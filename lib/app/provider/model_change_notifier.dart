import 'package:flutter/cupertino.dart';
import 'package:time_tracker_flutter_course/app/provider/model_products.dart';

class UserProvider with ChangeNotifier{
   String name ;
   List<ProductsModel> _products = [
     ProductsModel('HandBag','Gucci',34),
     ProductsModel('Lovely','Dior',16),
     ProductsModel('Perfume','Pierre Cardin',34),

   ];

   Future<void> addModel(ProductsModel model){
     _products.add(model);
     notifyListeners();

   }

   List<ProductsModel> get products => _products;

}