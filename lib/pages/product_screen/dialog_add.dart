import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendyol/constants/constants.dart';

import '../../server/function/functions.dart';
import '../../server/server.dart';

class Dialog1 extends StatefulWidget {
  final id;
  String name;
  String price;
  Dialog1({
    Key? key,
    required this.id,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  State<Dialog1> createState() => _DialogState();
}

class _DialogState extends State<Dialog1> {
  late var new_price = int.parse(widget.price);
  late var new_total = int.parse(widget.price);

  int index = 0;
  var myid;

  int _countController = 1;
  int? myvalue;
  void add() {
    setState(() {
      _countController++;
    });
  }

  var pp;

  void minus() {
    setState(() {
      if (_countController != 1) _countController--;
    });
  }

  int? newss;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          AppLocalizations.of(context)!.sin_cart,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: Row(
            children: [
              Text(
                  '${AppLocalizations.of(context)!.sin_product} :  ${widget.name}'),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.qty} : ',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            InkWell(
              onTap: () {
                add();
                new_total = new_price * _countController;
              },
              child: Container(
                decoration: BoxDecoration(
                    color: MAIN_COLOR,
                    border: Border.all(color: MAIN_COLOR, width: 2)),
                height: 30,
                width: 30,
                child: Center(
                  child: Image.asset(
                    'assets/plus.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              height: 30,
              width: 30,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: MAIN_COLOR, width: 1)),
              child: Center(
                child: Text(
                  '$_countController',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: MAIN_COLOR),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                minus();
                setState(() {
                  new_total = new_price * _countController;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: MAIN_COLOR,
                    border: Border.all(color: MAIN_COLOR, width: 2)),
                height: 30,
                width: 30,
                child: Center(
                  child: Image.asset(
                    'assets/minus.jpeg',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('${AppLocalizations.of(context)!.price} : '),
            Text(
              '$new_price ₪',
              style: TextStyle(
                  color: MAIN_COLOR, fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        ),
        Row(
          children: [
            Text('${AppLocalizations.of(context)!.total} : '),
            Text(
              '$new_total ₪',
              style: TextStyle(
                  color: MAIN_COLOR, fontWeight: FontWeight.bold, fontSize: 15),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
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
                  addCart(widget.id, _countController, widget.price, context);
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: MAIN_COLOR,
                      borderRadius: BorderRadius.circular(4)),
                  height: 30,
                  // width:
                  //     MediaQuery.of(context).size.width /
                  //         2,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.sin_cart,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
