import 'package:flutter/material.dart';
import 'package:flutter_app_banhang/src/bloc/cart_bloc.dart';
import 'package:flutter_app_banhang/src/widget/cart_manager.dart';
import 'package:flutter_app_banhang/src/widget/grid_shop.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _showCart = false;
  CartBloc _cartBloc;
  ScrollController _scrollController;
  @override
  void initState() {
    _cartBloc= new CartBloc();
    _scrollController =  new ScrollController();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body:Stack(
          children: <Widget>[
            CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              slivers: <Widget>[
              SliverToBoxAdapter(
                  child: GridShop(),
                ),
                SliverToBoxAdapter(
                  child: CartManager(),
                )
              ],

            ),
            Align(alignment: Alignment.bottomRight, child:
            new Container(margin: EdgeInsets.only(right: 10, bottom: 10),child:
            new FloatingActionButton(onPressed: (){
              if(_showCart)
                _scrollController.animateTo(_scrollController.position.minScrollExtent, curve: Curves.fastOutSlowIn, duration: Duration(seconds: 2));
              else
                _scrollController.animateTo(_scrollController.position.maxScrollExtent, curve: Curves.fastOutSlowIn, duration: Duration(seconds: 2));

              setState(() {
                _showCart = !_showCart;
              });

            }, backgroundColor: Colors.amber, child: new Icon(_showCart ? Icons.close : Icons.shopping_cart))
            )
            )

          ],
        )
    );
  }
}
