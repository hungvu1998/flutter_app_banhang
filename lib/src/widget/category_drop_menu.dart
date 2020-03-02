import 'package:flutter/material.dart';
import 'package:flutter_app_banhang/src/bloc/type_product_bloc.dart';
import 'package:flutter_app_banhang/src/data/type_product_model.dart';

class CategoryDropMenu extends StatefulWidget {
  final List<TypeProduct> listTypeProduct;

  const CategoryDropMenu({Key key, this.listTypeProduct}) : super(key: key);
  @override
  _CategoryDropMenu createState() => new _CategoryDropMenu();
}

class _CategoryDropMenu extends State<CategoryDropMenu> {

  String dropdownValue = "Pasta & Noodles";
  var typeProductCurrent;
  @override
  void initState() {
    typeProductCurrent=widget.listTypeProduct[0];
    super.initState();
  }




  @override
  Widget build(BuildContext context){

    return new DropdownButtonHideUnderline(child:
    new DropdownButton<TypeProduct>(
      value: typeProductCurrent,
      onChanged: (TypeProduct newValue) {
        setState(() {
          typeProductBloc.feedTypeProductVal(newValue);
          typeProductCurrent = newValue;
        });
      },
      items: widget.listTypeProduct.map<DropdownMenuItem<TypeProduct>>((TypeProduct value) {
        return DropdownMenuItem<TypeProduct>(
          value: value,
          child: Text(value.name, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        );
      }).toList(),
    ));
  }

}