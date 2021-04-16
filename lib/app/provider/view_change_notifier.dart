import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/provider/model_change_notifier.dart';
import 'package:time_tracker_flutter_course/app/provider/model_products.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class ViewChangeNotifier extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(auth.currentUser.displayName),
      ),
      body: Consumer<UserProvider>(
        builder: (context, user, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Spacer(
              flex: 1,
            ),
            Text(
              'List of products',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            ...user.products
                .map((e) => ListTile(
                      title: Text(e.name),
                      subtitle: Text(e.brand),
                      trailing: Text(e.size.toString()),
                    ))
                .toList()
          ],
        ),
      ),
      floatingActionButton: Consumer<UserProvider>(
        builder: (context, user, child) => FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            var newProduct = ProductsModel('Watch', 'Dolce&Gabbana', 21);
            user.addModel(newProduct);
          },
        ),
      ),
    );
  }
}
