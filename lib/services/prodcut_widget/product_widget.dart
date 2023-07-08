import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendyol/server/function/functions.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/constants.dart';
import '../../pages/authentication/login_screen/login_screen.dart';
import '../../pages/product_screen/product_screen.dart';

class ProductWidget extends StatefulWidget {
  var price, id, name, desc, image, category_id, favourite;
  ProductWidget({
    Key? key,
    required this.image,
    required this.category_id,
    required this.favourite,
    required this.id,
    required this.price,
    required this.desc,
    required this.name,
  }) : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleProduct(
                      favourite: widget.favourite,
                      price: widget.price,
                      id: widget.id,
                      name: widget.name,
                      description: widget.desc,
                      image: widget.image,
                      category_id: widget.category_id,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 15, left: 10),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 300,
              width: 150,
              // margin: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.0),
                    blurRadius: 5,
                  ),
                ],
              ),
              // color: Colors.brown,

              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10)),
                      child: Image.network(widget.image,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;

                            return Center(
                                child: CircularProgressIndicator(
                              backgroundColor: MAIN_COLOR,
                            ));
                            // You can use LinearProgressIndicator or CircularProgressIndicator instead
                          },
                          errorBuilder: (context, error, stackTrace) => Center(
                                  child: Image.asset(
                                "assets/logo.jpeg",
                                fit: BoxFit.fitHeight,
                              ))),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    height: 30,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5, left: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name.length > 13
                                ? widget.name.substring(0, 13) + '...'
                                : widget.name,
                            style: TextStyle(
                                fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₪${widget.price}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: MAIN_COLOR,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      bool? login = prefs.getBool('login');
                      if (login == true) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: Center(
                                      child: CircularProgressIndicator())),
                            );
                          },
                        );
                        await addCart(widget.id, 1, widget.price, context);
                      } else {
                        return showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              content:
                                  Text(AppLocalizations.of(context)!.dialogl1),
                              actions: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()),
                                    );
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        color: MAIN_COLOR,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        AppLocalizations.of(context)!.login,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: MAIN_COLOR,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                      ),
                      width: double.infinity,
                      height: 30,
                      child: Center(
                        child: Text(
                          "اضافه الى السله",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
              child: InkWell(
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  bool? login = prefs.getBool('login');
                  if (login == true) {
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

                    widget.favourite == false
                        ? addFavourite(widget.id, context)
                        : removeFavourite(widget.id, context);
                    setState(() {
                      widget.favourite = !widget.favourite;
                    });
                  } else {
                    return showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(AppLocalizations.of(context)!.dialogl1),
                          actions: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()),
                                );
                              },
                              child: Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: MAIN_COLOR,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  child: Center(
                      child: ImageIcon(
                    AssetImage(widget.favourite == false
                        ? "assets/like.jpeg"
                        : "assets/heart.png"),
                    color: MAIN_COLOR,
                  )),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
