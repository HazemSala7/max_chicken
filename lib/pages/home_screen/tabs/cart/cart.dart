import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../LocalDB/Models/CartModel.dart';
import '../../../../LocalDB/Provider/CartProvider.dart';
import '../../../../constants/constants.dart';
import '../../../../server/function/functions.dart';
import '../../../../server/server.dart';
import '../../../buy_now/buy_now.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    return CartScreen();
  }

  Widget CartScreen() {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        List<CartItem> cartItems = cartProvider.cartItems;
        double total = 0;
        for (CartItem item in cartItems) {
          total += item.price * item.quantity;
        }
        return Stack(
          alignment: Alignment.topCenter,
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 15, right: 15),
                    child: Text(
                      "سله المشتريات",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  cartItems.length != 0
                      ? ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: cartItems.length,
                          itemBuilder: (context, index) {
                            CartItem item = cartItems[index];
                            double total = item.price * item.quantity;
                            return SalaCart(
                              cartProvider: cartProvider,
                              id: 2,
                              price: item.price,
                              name: item.name,
                              qty: item.quantity,
                              sum: total,
                              removeProduct: () {
                                cartProvider.removeFromCart(item);
                                setState(() {});
                              },
                              image: item.image,
                              item: item,
                            );
                          },
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "لا يوجد منتجات بالسله",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 17),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Icon(Icons.no_accounts_sharp)
                            ],
                          ),
                        ),
                  SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80),
              child: cartnav(SUM_ALL: total, CartsArray: cartItems),
            )
          ],
        );
      },
    );
  }

  Widget cartnav({var SUM_ALL, var CartsArray}) {
    return Container(
      height: 50,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // textDirection: TextDirection.ltr,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'المجموع : $SUM_ALL₪',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              height: 35,
              minWidth: 100,
              color: MAIN_COLOR,
              textColor: Colors.white,
              child: Text(
                "شراء الأن",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                if (CartsArray.length == 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Text('الرجاء اضافه منتجات الى السله'),
                        actions: <Widget>[
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'حسنا',
                              style: TextStyle(color: MAIN_COLOR),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BuyNow(
                              total: SUM_ALL,
                            )),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SalaCart extends StatefulWidget {
  String image = "";
  String name = "";
  int qty = 0;
  Function removeProduct;
  CartProvider cartProvider;
  CartItem item;
  var price;
  var sum;
  var id;
  var cart2id;
  SalaCart({
    Key? key,
    required this.removeProduct,
    required this.cartProvider,
    required this.item,
    required this.image,
    required this.name,
    required this.qty,
    this.price,
    this.sum,
    this.id,
    this.cart2id,
  }) : super(key: key);

  @override
  _SalaCartState createState() => _SalaCartState();
}

class _SalaCartState extends State<SalaCart> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: Container(
          height: 140,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ],
              color: Color(0xffF6F6F6)),
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => SingleProduct(
                  //             price: widget.price,
                  //             id: int.parse(widget.id),
                  //             name: widget.name,
                  //             // name: name,
                  //             isfavourate: false,
                  //           )),
                  // );
                },
                child: SizedBox(
                  height: 130,
                  width: 100,
                  child: Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    height: 130,
                    width: 100,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      widget.name.length > 20
                          ? widget.name.substring(0, 20) + '...'
                          : widget.name,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "الكميه",
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          InkWell(
                            onTap: () {
                              int quantity = int.parse(widget.qty.toString());
                              // Call the updateCartItem function in CartProvider
                              widget.cartProvider.updateCartItem(
                                widget.item.copyWith(
                                  quantity: quantity + 1,
                                ),
                              );
                              setState(() {});
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Center(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      color: MAIN_COLOR,
                                      image: const DecorationImage(
                                          image:
                                              AssetImage('assets/plus.jpeg'))),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: MAIN_COLOR, width: 1)),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                child: Text(
                                  '${widget.qty}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,

                                    fontWeight: FontWeight.bold,
                                    // color: Color(0xffB23634),
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (widget.qty > 1) {
                                int quantity = int.parse(widget.qty.toString());
                                // Call the updateCartItem function in CartProvider
                                widget.cartProvider.updateCartItem(
                                  widget.item.copyWith(
                                    quantity: quantity - 1,
                                  ),
                                );
                                setState(() {});
                              }
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                    color: MAIN_COLOR,
                                    image: DecorationImage(
                                        image: const AssetImage(
                                            'assets/minus.jpeg'))),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'السعر : ',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₪${widget.price}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'المجموع : ',
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₪${widget.sum}',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content:
                            Text("هل تريد بالتأكيد حذف هذا المنتج من الطلبيه؟"),
                        actions: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  widget.removeProduct();
                                  Fluttertoast.showToast(
                                      msg: "تم حذف المنتج بنجاح");
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: MAIN_COLOR),
                                  child: Center(
                                    child: Text(
                                      "نعم",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 50,
                                width: 100,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: MAIN_COLOR),
                                child: Center(
                                  child: Text(
                                    "لا",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.delete),
                color: MAIN_COLOR,
                iconSize: 30,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
          )),
    );
  }

  int _countController = 1;
  void add() {
    setState(() {
      widget.qty++;
    });
  }

  void minus() {
    setState(() {
      if (widget.qty != 1) widget.qty--;
    });
  }
}
