import 'package:flutter/material.dart';
import 'package:shop_app/models/User.dart';

class UserData with ChangeNotifier{
  User ? _user;

  User ? get user => _user;

  void setUser(User value){
    _user = value;
    notifyListeners();
  }
}