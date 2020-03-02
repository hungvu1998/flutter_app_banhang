import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_banhang/src/data/type_product_model.dart';
import 'package:rxdart/rxdart.dart';
final typeProductBloc = new TypeProductBloc();

class TypeProductBloc{
  final db = Firestore.instance;
  var _typeProductValController = BehaviorSubject<TypeProduct>();
  Function(TypeProduct) get feedTypeProductVal => _typeProductValController.sink.add;
  Stream<TypeProduct> get recieveTypeProductVal => _typeProductValController.stream;


  var _typeProductController = StreamController<List<TypeProduct>>.broadcast();
  Stream get typeProductStream => _typeProductController.stream;

  Future<List<TypeProduct>> getListTypeProduct() async{
    List<TypeProduct> listTypeProduct = new List();

    await db.collection('type_product').orderBy('name',descending: true).getDocuments().then((value){
      if(listTypeProduct.length < value.documents.length){
        listTypeProduct.clear();
        for(var item in value.documents){
          var typeProduct = new TypeProduct(
            name: item['name'],
            slug: item['slug']
          );
          listTypeProduct.add(typeProduct);
        }
        _typeProductController.add(listTypeProduct);
        Future.delayed(Duration(
            seconds: 3),
              (){
                feedTypeProductVal(listTypeProduct[0]);
            //Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => HomeScreen()),ModalRoute.withName("/Home"));
          },
        );


      }
    });
    return listTypeProduct;

  }

  dispose() {
    //_storiesController?.close();
    _typeProductValController?.close();
    _typeProductController?.close();
  }
}