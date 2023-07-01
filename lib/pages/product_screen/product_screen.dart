import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/constants.dart';
import '../../model/slider.dart';
import '../../server/function/functions.dart';
import '../../services/prodcut_widget/product_widget.dart';
import '../authentication/login_screen/login_screen.dart';
import 'dialog_add.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SingleProduct extends StatefulWidget {
  final name, id, price, image, description, category_id;
  var favourite;
  SingleProduct({
    Key? key,
    this.id,
    this.name,
    required this.favourite,
    this.image,
    this.price,
    this.category_id,
    this.description,
  }) : super(key: key);

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          // appBar: PreferredSize(
          //     child: AppBar2(), preferredSize: Size.fromHeight(50)),
          body: SingleChildScrollView(
            child: Container(
              // color: Colors.white,
              child: Column(
                children: [
                  FutureBuilder(
                      future: getSingleProduct(
                          widget.id.toString(), widget.category_id.toString()),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.data != null) {
                          var nameof = snapshot.data['product'];
                          return image_product(
                              image: widget.image,
                              name: nameof['name'],
                              id: nameof['id'],
                              price: nameof['price'],
                              refresh: () {
                                Future.delayed(Duration(seconds: 1))
                                    .then((value) {
                                  getSingleProduct(widget.id.toString(),
                                      widget.category_id.toString());
                                  setState(() {});
                                });
                              },
                              products: snapshot.data['products'],
                              desc: nameof["description"] ?? "");
                        } else {
                          return image_product(
                              refresh: () {
                                Future.delayed(Duration(seconds: 1))
                                    .then((value) {
                                  getSingleProduct(widget.id.toString(),
                                      widget.category_id.toString());
                                  setState(() {});
                                });
                              },
                              image: widget.image,
                              name: widget.name.toString(),
                              desc: widget.description.toString(),
                              products: [],
                              price: widget.price.toString());
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget products(
      {String image = '', String name = '', String price = "", int id = 0}) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SingleProduct(
                      price: price,
                      favourite: widget.favourite,
                      id: id,
                      name: name,
                    )));
      },
      child: Container(
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

        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
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
                    child: Image.network(image,
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
                              child: Text("not found"),
                            )),
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
                          name.length > 15
                              ? name.substring(0, 15) + '...'
                              : name,
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₪$price',
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
                Container(
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
                      "طلب المتج",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget image_product(
      {String image = "",
      String name = '',
      int id = 0,
      String price = "",
      Function? refresh,
      String desc = "",
      var products}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 400,
              width: double.infinity,
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_circle_right,
                      size: 35,
                      color: MAIN_COLOR,
                    )),
                Padding(
                  padding: const EdgeInsets.only(top: 10, right: 20, left: 20),
                  child: Row(
                    children: [
                      InkWell(
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
                          widget.favourite == false
                              ? addFavourite(widget.id, context)
                              : removeFavourite(widget.id, context);
                          setState(() {
                            widget.favourite = !widget.favourite;
                          });
                        },
                        child: ImageIcon(
                          AssetImage(widget.favourite == false
                              ? "assets/like.jpeg"
                              : "assets/heart.png"),
                          color: MAIN_COLOR,
                          size: 30,
                        ),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          bool? login = prefs.getBool('login');
                          if (login == true) {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  actions: <Widget>[
                                    Dialog1(
                                      id: widget.id,
                                      name: widget.name,
                                      price: "${widget.price}",
                                    )
                                  ],
                                );
                              },
                            );
                          } else {
                            return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Text(
                                      AppLocalizations.of(context)!.dialogl1),
                                  actions: <Widget>[
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  LoginScreen()),
                                        );
                                      },
                                      child: Center(
                                        child: Text(
                                          AppLocalizations.of(context)!.login,
                                          style: TextStyle(color: MAIN_COLOR),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: ImageIcon(
                          AssetImage("assets/add_cart.png"),
                          color: MAIN_COLOR,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 60, left: 60, top: 10),
              child: Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 7,
                        blurRadius: 5,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                        left: 10,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name.length > 15
                                ? name.substring(0, 15) + '...'
                                : name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                '₪$price',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: MAIN_COLOR),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              bool? login = prefs.getBool('login');
                              if (login == true) {
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      actions: <Widget>[
                                        Dialog1(
                                          id: widget.id,
                                          name: widget.name,
                                          price: widget.price.toString(),
                                        )
                                      ],
                                    );
                                  },
                                );
                              } else {
                                return showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                          AppLocalizations.of(context)!
                                              .dialogl1),
                                      actions: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LoginScreen()),
                                            );
                                          },
                                          child: Center(
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .login,
                                              style:
                                                  TextStyle(color: MAIN_COLOR),
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
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white),
                                color: MAIN_COLOR,
                              ),
                              height: 35,
                              child: Center(
                                child: Text(
                                  "اضافه الى السله",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
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
                              widget.favourite == false
                                  ? addFavourite(widget.id, context)
                                  : removeFavourite(widget.id, context);
                              setState(() {
                                widget.favourite = !widget.favourite;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white),
                                color: MAIN_COLOR,
                              ),
                              height: 35,
                              child: Center(
                                child: Text(
                                  widget.favourite == false
                                      ? "اضافه الى المفضله"
                                      : "ازاله من المفضله",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffEBEBEB),
                      border: Border.all(color: Color(0xffD6D3D3))),
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      desc,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "منتجات أخرى",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "المزيد",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: MAIN_COLOR),
                ),
              ),
            ],
          ),
        ),
        products.length == 0
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: GridView.builder(
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.7),
                    itemBuilder: (context, int index) {
                      return ProductWidget(
                          image: products[index]["image"],
                          favourite: products[index]["favourite"],
                          category_id: products[index]["category_id"],
                          name: products[index]["name"] ?? "",
                          desc: products[index]["description"] ?? "",
                          price: products[index]["price"] ?? "",
                          id: products[index]["id"] ?? 1);
                    }),
              ),
      ],
    );
  }

  InkWell Slideimage(List<Silder> slideimages) {
    return InkWell(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ImageProduct(
        //             slideimages: slideimages,
        //           )),
        // );
      },
      child: ImageSlideshow(
        width: double.infinity,
        height: 400,
        children: slideimages
            .map((e) => Image.network(
                  e.image,
                  alignment: Alignment.center,
                  // height: MediaQuery.of(context).size.height,
                  // width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ))
            .toList(),
        onPageChanged: (value) {},
        autoPlayInterval: 3000,
        isLoop: true,
      ),
    );
  }
}
