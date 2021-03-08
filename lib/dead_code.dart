/// Future<void> _createJob(BuildContext context) async {
//   try {
//     final database = Provider.of<Database>(context, listen: false);
//     await database.createJob(Job(name: 'Blogging', ratePerHour: 10));
//   } on FirebaseException catch (e) {
//     // if( e.code == 'permission-denied'){}
//     showExceptionAlertDialog(context,
//         title: 'Operation Failed', exception: e);
//   }
// }