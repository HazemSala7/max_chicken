import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendyol/server/server.dart';

import '../../pages/home_screen/home_screen.dart';

var headers = {'ContentType': 'application/json', "Connection": "Keep-Alive"};
getHome() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('user_id');
  var response =
      await http.get(Uri.parse("$URL_HOME/${id.toString()}"), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

getShops() async {
  var url = "http://10.0.2.2:8000/api/shops";
  var response = await http.get(Uri.parse(url), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

getCategories() async {
  var response = await http.get(Uri.parse(URL_CATEGORIES), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

getShopScreen(id) async {
  var url = "$URL_SHOP_SCREEN/$id";
  var response = await http.get(Uri.parse(url), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

getSingleProduct(id, category_id) async {
  var response =
      await http.get(Uri.parse('$URL_SINGLE_PRODUCT/$id/$category_id'));
  var res = jsonDecode(response.body);
  return res;
}

getProductsCategories(category_id) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? id = prefs.getInt('user_id');
  var response =
      await http.get(Uri.parse('$URL_PRODUCT/$category_id/${id.toString()}'));
  var res = jsonDecode(response.body);
  return res;
}

getSingleCompany(id) async {
  var response = await http.get(Uri.parse('$URL_SINGLE_COMPANY/$id'));
  var res = jsonDecode(response.body);
  return res;
}

addCart(product_id, qty, price, context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  int? id = prefs.getInt('user_id');
  var headers = {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json'
  };
  var response = await http.post(
    Uri.parse(URL_ADD_CART),
    headers: headers,
    body: {
      'product_id': product_id.toString(),
      'user_id': id.toString(),
      'qty': qty.toString(),
      'price': price.toString(),
    },
  );
  var data = jsonDecode(response.body);

  if (data['status'] == 'true') {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(msg: 'تم اضافتها الى السله بنجاح');
  } else {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(msg: 'فشلت عمليه اضافتها للسله');
  }
}

getCarts() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  var headers = {
    'Authorization': 'Bearer $token',
    'ContentType': 'application/json'
  };
  var response = await http.get(Uri.parse(URL_CARTS), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

getFavourites() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  var headers = {
    'Authorization': 'Bearer $token',
    'ContentType': 'application/json'
  };
  var response = await http.get(Uri.parse(URL_FAVOURITES), headers: headers);
  var res = jsonDecode(response.body);
  return res;
}

addFavourite(product_id, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  int? user_id = prefs.getInt('user_id');
  var headers1 = {
    'Authorization': 'Bearer $token',
    'ContentType': 'application/json'
  };
  var response = await http.post(Uri.parse(URL_ADD_FAVOURITE),
      body: {
        'user_id': user_id.toString(),
        'product_id': product_id.toString(),
      },
      headers: headers1);
  var data = json.decode(response.body);
  if (data['status'] == 'true') {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "تمت الاضافه الى المفضله بنجاح",
    );
  } else {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "محذوف مسبقا",
    );
  }
}

removeFavourite(product_id, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  int? user_id = prefs.getInt('user_id');
  var headers1 = {
    'Authorization': 'Bearer $token',
    'ContentType': 'application/json'
  };
  var response = await http.post(Uri.parse(URL_REMOVE_FAVOURITE),
      body: {
        'user_id': user_id.toString(),
        'product_id': product_id.toString(),
      },
      headers: headers1);
  var data = json.decode(response.body);
  if (data['status'] == 'true') {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "تمت ازالتها من المفضله بنجاح",
    );
  } else {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "محذوف مسبقا",
    );
  }
}

removeCart(id, BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString('access_token');
  var headers = {
    'Authorization': 'Bearer $token',
    'ContentType': 'application/json'
  };
  var response = await http.post(Uri.parse(URL_REMOVE_CART),
      body: {"id": id.toString()}, headers: headers);
  var data = json.decode(response.body);

  if (data['status'] == 'true') {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "تم حذف هذا المنتج من السله بنجاح",
    );
  } else {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "محذوف مسبقا",
    );
  }
}

removeUser(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('access_token');
  int? id = prefs.getInt('user_id');
  var headers = {
    'Authorization': 'Bearer $token',
    'ContentType': 'application/json'
  };
  var response = await http.post(Uri.parse(URL_REMOVE_USER),
      body: {
        'id': id.toString(),
      },
      headers: headers);
  var data = jsonDecode(response.body);
  if (data['status'] == 'true') {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "تم حذف حسابك بنجاح",
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(
          currentIndex: 0,
        ),
      ),
      (route) => false,
    );
  } else {
    Navigator.of(context, rootNavigator: true).pop();
    Fluttertoast.showToast(
      msg: "فشلت عليه حذف حسابك , الرجاء المحاوله فيما بعد",
    );
  }
}
