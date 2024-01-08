import 'package:flutter/material.dart';

class Cart with ChangeNotifier{
  // declare
  int  _quantity = 1;
  List _cartItem = [];


// get element
   int? get quantity => _quantity;
   List get cartItem => _cartItem;



  //  modify function
  void changeQuantiry(int value){
    _quantity = value;
    notifyListeners();
  }

  void addCartItem(item){
    _cartItem.add(item);
    notifyListeners();
  }
  void clearCartItem(){
    _cartItem.clear();
    notifyListeners();
  }
}