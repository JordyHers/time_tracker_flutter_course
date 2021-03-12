import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/models/job_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_exeption_alert.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditJobPage extends StatefulWidget {
  final Database database;
  final Job job;

  const EditJobPage({Key key, @required this.database, this.job})
      : assert(database != null),
        super(key: key);

  /// The [context]  here is the context pf the JobsPage
  ///
  /// as the result we can get the provider of Database
  static Future<void> show(BuildContext context , {Database database ,Job job} ) async {
    await Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => EditJobPage(database: database , job: job),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formkey = GlobalKey<FormState>();
  String _name;
  int _ratePerHour;


  @override
  void initState(){
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;

    }

  }
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

        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if(widget.job != null){
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)){
        await showAlertDialog(
            context,
            title: ' Name already used',
            content: 'Please choose a different job name',
            defaultActionText:'OK'
          );
        }

       else{

          ///--------------------------------------------------
          ///here we pass on the id as date of creation if uid is not available
          ///
          ///
         final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
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
        title: Text( widget.job == null ? 'New Job' : 'Edit Job'),
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
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : "Name can't be empty",
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        initialValue:  _ratePerHour != null ? '$_ratePerHour': null ,
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
