import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exeption_alert.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class AddJobPage extends StatefulWidget {
  final Database database;

  const AddJobPage({Key key, @required this.database})
      : assert(database != null),
        super(key: key);

  /// The [context]  here is the context pf the JobsPage
  ///
  /// as the resukt we can get the provider of Database
  static Future<void> show(BuildContext context) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => AddJobPage(database: database),
      fullscreenDialog: true,
    ));
  }

  @override
  _AddJobPageState createState() => _AddJobPageState();
}

class _AddJobPageState extends State<AddJobPage> {
  final _formkey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;

  bool _validateAndSaveForm() {
    final form = _formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        /// this section makes sure the jobs name entered does not already exist
        /// in the stream
        /// Stream.first is a getter that get the most up-to-date value

        final jobs = await widget.database.JobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (allNames.contains(_name)){
        await showAlertDialog(
            context,
            title: ' Name already used',
            content: 'Please choose a different job name',
            defaultActionText:'OK'
          );
        }
        ///--------------------------
       else{
          final job = Job(name: _name, ratePerHour: _ratePerHour);
          await widget.database.createJob(job);
          print('form Saved : $_name and Rate per hour : $_ratePerHour');
          Navigator.of(context).pop();
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(context,
            title: 'Operation failed', exception: e);
      }
      //TODO: Submit data to Firestore
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2.0,
        title: Text('New Job'),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: _submit,
            child: Text(
              'Save',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          )
        ],
      ),
      body: _buildContents(),
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _buildFormChildren(),
        ));
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Job Name'),
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        validator: (value) =>
            value.isNotEmpty ? null : "Rate per hour can't be empty",
        decoration: InputDecoration(labelText: 'Rate per hour'),
        keyboardType:
            TextInputType.numberWithOptions(signed: false, decimal: false),

        /// By using tryParse a null value will be entered instead of just using [int.Parse]
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
      ),
    ];
  }
}
