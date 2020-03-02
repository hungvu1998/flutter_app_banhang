import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_banhang/src/bloc/type_product_bloc.dart';
import 'package:flutter_app_banhang/src/data/product.dart';
import 'package:flutter_app_banhang/src/data/type_product_model.dart';
import 'package:flutter_app_banhang/src/repositories/ProductsRepository.dart';
import 'package:flutter_app_banhang/src/widget/item_product.dart';

import 'category_drop_menu.dart';
import 'minimal_cart.dart';

class GridShop extends StatefulWidget {
  @override
  _GridShopState createState() => _GridShopState();
}

class _GridShopState extends State<GridShop> {
  List<TypeProduct> _listTypeProduct;
  final Firestore nodeRoot = Firestore.instance;
  @override
  void initState() {
    typeProductBloc.getListTypeProduct();
    super.initState();
  }

  List<Product> _products = new ProductsRepository().fetchAllProducts();

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _products.clear();
      _products = new ProductsRepository().fetchAllProducts();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    double _gridSize = MediaQuery.of(context).size.height*0.88; //88% of screen
    double childAspectRatio =  MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.0);



    return Column(
      children: <Widget>[
        new Container(
            height: _gridSize,
            decoration: BoxDecoration(
                color: const Color(0xFFeeeeee),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(_gridSize/10),
                    bottomRight: Radius.circular(_gridSize/10))),
            padding: EdgeInsets.only(left: 10, right: 10),
            child:  StreamBuilder(
              stream: typeProductBloc.typeProductStream,
              builder: (context,snapShotTypeProduct){
                if(!snapShotTypeProduct.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                else{

                  return  new Container(
                      margin: EdgeInsets.only(top: 40),
                      child: new Column(
                          children: <Widget>[
                            new Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new CategoryDropMenu(listTypeProduct: snapShotTypeProduct.data,),
                                  new FlatButton.icon(
                                      onPressed: (){

                                      },
                                      icon: new Icon(Icons.filter_list),
                                      label: new Text(""))
                                ]),
                            new Container(
                                height: _gridSize - 88,
                                margin: EdgeInsets.only(top: 0),
                                child: new PhysicalModel(
                                    color: Colors.transparent,
                                    borderRadius:  BorderRadius.only(
                                        bottomLeft: Radius.circular(_gridSize/10 - 10),
                                        bottomRight: Radius.circular(_gridSize/10 - 10)),
                                    clipBehavior: Clip.antiAlias,
                                    child: StreamBuilder(
                                      stream: typeProductBloc.recieveTypeProductVal,
                                      builder: (context,snapshotValueType){
                                        if(!snapshotValueType.hasData)
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        else{
                                          return RefreshIndicator(
                                            onRefresh: refreshList,
                                            child: StreamBuilder(
                                              stream:nodeRoot
                                                .collection('products/'+snapshotValueType.data.slug+'/list_product')
                                                .orderBy('name',descending: true)
                                                .snapshots(),
                                              builder: (context,snapShotProduct){
                                                if(!snapShotProduct.hasData)
                                                  return Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                else{
                                                  return new GridView.builder(
                                                      //itemCount: snapShotProduct.data.documents.length,
                                                    itemCount: _products.length,
                                                      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          childAspectRatio: childAspectRatio),
                                                      itemBuilder: (BuildContext context, int index) {
                                                        return new Padding(
                                                            padding: EdgeInsets.only(top: index%2==0 ? 20 : 0, right: index%2==0 ? 5 : 0, left: index%2==1 ? 5 : 0, bottom: index%2==1 ? 20 : 0),
                                                            child: ProductWidget(product: _products[index]));
                                                      });
                                                }
                                              },

                                            ),
                                          );
                                        }
                                      },

                                    )
                                )
                            )
                          ])
                  );
                }

              }
            )
        ),
        new MinimalCart(_gridSize)
      ],
    );
  }
}
