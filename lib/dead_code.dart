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

///Used in jobs_page  Widget _buildContents(BuildContext context)
// if (snapshot.hasData) {
//   ///jobs represents the list of documents in the collection
//   final jobs = snapshot.data;
//
//   if(jobs.isNotEmpty){
//   final children = jobs
//       .map((job) => JobListTile(
//           job: job, onTap: () => EditJobPage.show(context, job: job)))
//       .toList();
//   return ListView(children: children);}
//   return EmptyContent();
// }
// if (snapshot.hasError) {
//   return Center(child: Text('Some Error Occured'));
// }
// return Center(
//   child: CircularProgressIndicator(),
// );