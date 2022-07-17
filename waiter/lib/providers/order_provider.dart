import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waiter/models/order_model.dart';
import 'package:waiter/services/db_helper.dart';


class OrderProvider extends ChangeNotifier {

  DBHelper db = DBHelper() ;

  int _counter = 0;
  int get counter => _counter;
  
  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>> _cart ;
  Future<List<Cart>> get cart => _cart ;

  Future<List<Cart>> getData () async {
    _cart = db.getCartList();
    return _cart ;
  }

  void _setPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('order_items', _counter);
    preferences.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItems() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    _counter = preferences.getInt('order_items') ?? 0;
    _totalPrice = preferences.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addCounter(){
    _counter++;
    _setPrefItems();
    notifyListeners();
  }
  
  void removeCounter(){
    _counter--;
    _setPrefItems();
    notifyListeners();
  }
  
  int getCounter(){
    _getPrefItems();
    return _counter;
  }

  void addTotalPrice(double productPrice){
    _totalPrice += productPrice;
    _setPrefItems();
    notifyListeners();
  }
  
  void removeTotalPrice(double productPrice){
    _totalPrice -= productPrice;
    _setPrefItems();
    notifyListeners();
  }
  
  double getTotalPrice(){
    _getPrefItems();
    return _totalPrice;
  }
}