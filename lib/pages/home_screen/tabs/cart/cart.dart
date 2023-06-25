import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
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
    return FutureBuilder(
        future: getCarts(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: SpinKitPulse(
                  color: MAIN_COLOR,
                  size: 60,
                ),
              ),
            );
          } else if (snapshot.data != null) {
            var album1 = snapshot.data["carts"];
            return CartScreen(
                CartsArray: album1, SUM_ALL: snapshot.data["result"]);
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: double.infinity,
              child: Center(
                child: Text('Cart is empty'),
              ),
            );
          }
        });
  }

  Widget CartScreen({var CartsArray, int SUM_ALL = 0}) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Text(
                  "سله المشتريات",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: CartsArray.length,
                    itemBuilder: (context, int index) {
                      return SalaCart(
                          image: CartsArray[index]["image"],
                          name: CartsArray[index]["name"],
                          qty: CartsArray[index]["qty"] ?? 0,
                          price: CartsArray[index]["price"] ?? "",
                          sum: CartsArray[index]["sum"] ?? 0,
                          id: CartsArray[index]["id"],
                          cart2id: CartsArray[index]["id"],
                          ondelete: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: MAIN_COLOR,
                                      ))),
                                );
                              },
                            );
                            removeCart(CartsArray[index]["id"], context);
                            setState(() {
                              getCarts();
                            });
                          },
                          onupdate: () {
                            setState(() {
                              getCarts();
                            });
                          },
                          onedit: () {
                            setState(() {});
                          },
                          onQuantityChanged: (newAmount, newPrice) {
                            CartsArray[index]["qty"] = newAmount;
                            CartsArray[index]["sum"] = newPrice;
                          });
                    }),
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: cartnav(SUM_ALL: SUM_ALL, CartsArray: CartsArray),
        )
      ],
    );
  }

  Widget cartnav({int SUM_ALL = 0, var CartsArray}) {
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
  Function? ondelete;
  Function? onedit;
  String image = "";
  String name = "";
  int qty = 0;
  Function? onQuantityChanged;
  var price;
  // String details;
  var sum;
  var id;
  var cart2id;
  Function onupdate;

  // Function onQuantityChanged;
  SalaCart({
    Key? key,
    required this.ondelete,
    required this.onupdate,
    this.onQuantityChanged,
    required this.image,
    required this.name,
    required this.qty,
    this.price,
    this.sum,
    this.id,
    this.cart2id,
    // required this.onQuantityChanged,
    // required this.details,
    required this.onedit,
  }) : super(key: key);

  @override
  _SalaCartState createState() => _SalaCartState();
}

class _SalaCartState extends State<SalaCart> {
  @override
  editcart(id, qty) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };
    var response = await http.post(Uri.parse(URL_EDIT_CART),
        body: {
          'id': id.toString(),
          'qty': qty.toString(),
        },
        headers: headers);
    var data = json.decode(response.body);

    if (data['status'] == 'true') {
      print("success");
      return data;
    } else {
      print("failed");
      return null;
    }
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25, right: 15, left: 15),
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
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
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
                    ),
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
                            onTap: () async {
                              setState(() {
                                widget.qty++;
                                // widget.onQuantityChanged(
                                //     widget.qty, widget.sum);
                              });
                              var response =
                                  await editcart(widget.id, widget.qty);
                              if (response['status'] != 'true') {
                                widget.qty--;
                                // widget.onQuantityChanged(
                                //     widget.qty, widget.sum);
                              } else {
                                print("Increased successfully");
                                widget.onupdate();
                              }
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
                            onTap: () async {
                              // ---

                              // int qt = widget.qty;
                              var id1 = widget.id;
                              // var qt = qty;
                              // if (widget.qty > 1) {
                              // minus();
                              // setState(() {
                              //   widget.qty--;
                              //   widget.onQuantityChanged(
                              //       widget.qty, widget.sum);
                              // });
                              // var response = await editcart();
                              // editcart(widget.id, widget.qty);
                              // widget.onedit();
                              setState(() {
                                if (widget.qty != 1) widget.qty--;
                              });
                              var response =
                                  await editcart(widget.id, widget.qty);

                              if (response['status'] != 'true') {
                                print("Error decreasing");
                                widget.qty++;

                                // widget.onQuantityChanged(
                                //     widget.qty, widget.sum);
                              } else {
                                print("Decreased successfully");
                                widget.onupdate();
                              }

                              // }
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
                  widget.ondelete!();
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
