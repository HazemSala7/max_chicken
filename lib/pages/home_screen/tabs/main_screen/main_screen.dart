import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trendyol/constants/constants.dart';
import 'package:trendyol/pages/products/products.dart';
import 'package:trendyol/server/function/functions.dart';
import 'package:trendyol/services/company_widget/company_widget.dart';
import 'package:trendyol/services/prodcut_widget/product_widget.dart';
import 'package:trendyol/services/slide_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../main.dart';
import '../../../../model/slider.dart';
import '../../../product_screen/product_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

List<bool> checkColor = [true, false, false, false, false, false, false];

ScrollController scrollController = ScrollController();
@override
void initState() {
  scrollController.addListener(() async {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {}
  });
}

Widget MainCategoryWidget({int i = 2}) {
  return FutureBuilder(
    future: getShopScreen(i),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.4,
          child: SpinKitPulse(
            color: MAIN_COLOR,
            size: 60,
          ),
        );
      } else if (snapshot.data != null) {
        var companies = snapshot.data['companies'];
        var sub_categories = snapshot.data['sub_categories'];
        var products = snapshot.data['products'];

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 15, top: 15, bottom: 15, left: 15),
              child: Row(
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )
                ],
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: 5,
                childAspectRatio: 0.9,
                mainAxisSpacing: 5,
                crossAxisCount: 4,
              ),
              itemCount: sub_categories.length,
              itemBuilder: (BuildContext context, int index) {
                return cateWidget(
                    image: sub_categories[index]["image"],
                    name: sub_categories[index]["name"],
                    id: sub_categories[index]["id"]);
              },
            ),
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: companies.length,
                itemBuilder: ((context, index) {
                  return CompanyWidget(
                    id: companies[index]["id"],
                    image: companies[index]["logo_image"],
                    name: companies[index]["name"],
                    background_image: companies[index]["background_image"],
                    address: companies[index]["address"] ?? " - ",
                    description: " - ",
                  );
                })),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                height: 20,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10, left: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Products",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => Products(
                          //             id: widget.id,
                          //             name: widget.name,
                          //           )),
                          // );
                        },
                        child: Text(
                          "More Products",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: MAIN_COLOR),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: GridView.builder(
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
      } else {
        return Center(
            child: SizedBox(
                height: 40, width: 40, child: CircularProgressIndicator()));
      }
    },
  );
}

Widget cateWidget({String name = "", String image = "", int id = 0}) {
  return Column(
    children: [
      Container(
        height: 60,
        width: 70,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
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
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
            ),
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(10), topLeft: Radius.circular(10)),
        ),
      ),
      Container(
          // height: 30,
          width: 70,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          child: Center(child: Text(name)))
    ],
  );
}

Widget TabWidget({String name = "", String image = ""}) {
  return Padding(
    padding: const EdgeInsets.only(right: 10, left: 10),
    child: Column(
      children: [
        Container(
          height: 60,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100)),
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
                        child: Image.asset(
                      "assets/logo.jpeg",
                      fit: BoxFit.fitHeight,
                    ))),
          ),
          decoration: BoxDecoration(
              border: Border.all(color: MAIN_COLOR, width: 2),
              shape: BoxShape.circle),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Text(name),
        )
      ],
    ),
  );
}

int current = 0;

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TopBar(),
          Column(
            children: [
              Container(
                child: current == 0
                    ? FutureBuilder(
                        future: getHome(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: SpinKitPulse(
                                color: MAIN_COLOR,
                                size: 60,
                              ),
                            );
                          } else {
                            List<Silder>? album = [];
                            if (snapshot.data != null) {
                              List mysslide = snapshot.data['sliders'];
                              var companies = snapshot.data['companies'];
                              var products = snapshot.data['products'];
                              var categories = snapshot.data['categories'];
                              List<Silder> album1 = mysslide.map((s) {
                                Silder c = Silder.fromJson(s);
                                return c;
                              }).toList();
                              album = album1;
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 220,
                                    child: SlideImage(
                                      slideimage: album,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 20,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20, left: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "الأقسام",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Text(
                                                "المزيد",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: MAIN_COLOR),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 20),
                                    child: Container(
                                      height: 140,
                                      width: double.infinity,
                                      child: GridView.builder(
                                          scrollDirection: Axis.horizontal,
                                          // physics:
                                          //     NeverScrollableScrollPhysics(),
                                          // shrinkWrap: true,
                                          itemCount: products.length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 2,
                                                  // mainAxisSpacing: 10,
                                                  crossAxisSpacing: 10,
                                                  childAspectRatio: 0.32),
                                          itemBuilder: (context, int index) {
                                            return CategoryWidget(
                                                name: categories[index]["name"],
                                                id: categories[index]["id"],
                                                image: categories[index]
                                                    ["image"]);
                                          }),
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    width: double.infinity,
                                    color: MAIN_COLOR,
                                    child: Center(
                                      child: Text(
                                        "أهلا وسهلا بكم في تطبيق  كليمار",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Container(
                                      height: 20,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 20, left: 25),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "منتجات",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            InkWell(
                                              onTap: () {},
                                              child: Text(
                                                "المزيد",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                    color: MAIN_COLOR),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: GridView.builder(
                                        scrollDirection: Axis.vertical,
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: products.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.7),
                                        itemBuilder: (context, int index) {
                                          return ProductWidget(
                                              image: products[index]["image"],
                                              favourite: products[index]
                                                  ["favourite"],
                                              category_id: products[index]
                                                  ["category_id"],
                                              name:
                                                  products[index]["name"] ?? "",
                                              desc: products[index]
                                                      ["description"] ??
                                                  "",
                                              price: products[index]["price"] ??
                                                  "",
                                              id: products[index]["id"] ?? 1);
                                        }),
                                  ),
                                ],
                              );
                            } else {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.25,
                                width: double.infinity,
                                color: Colors.white,
                              );
                            }
                          }
                        })
                    : MainCategoryWidget(i: 2),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget CategoryWidget({String name = "", String image = "", int id = 0}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Products(
                        category_id: id.toString(),
                      )));
        },
        child: Container(
          height: 80,
          // width: 150,
          child: Padding(
            padding:
                const EdgeInsets.only(right: 20, left: 10, top: 5, bottom: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  image,
                  height: 70,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 40,
                  child: Text(
                    name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: MAIN_COLOR),
        ),
      ),
    );
  }

  Color first = Colors.black;

  Widget row1(String name, int id) {
    return Tab(
      child: InkWell(
        onTap: () {
          // setState(() {
          //   far(i = id);
          // });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: Colors.redAccent, width: 1)),
          height: 35,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),
            child: Center(
                child: Tab(
              child: Text(name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 17, color: first, fontWeight: FontWeight.w500)),
            )),
          ),
        ),
      ),
    );
  }

  Container TopBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          color: Colors.white, border: Border.all(width: 2, color: MAIN_COLOR)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 55,
                  child: TextField(
                    style: TextStyle(color: Color(0xffF6F6F6)),
                    onChanged: (value) {
                      // searchData(st = value.trim().toLowerCase());
                      // Method For Searching
                    },
                    textAlign: TextAlign.start,
                    decoration: const InputDecoration(
                      hintText: "بحث عن منتج",
                      hintStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Color(0xff996C31),
                      ),
                      contentPadding: EdgeInsets.only(top: 12, right: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(flex: 2, child: Image.asset("assets/logo.png")),
          ],
        ),
      ),
    );
  }
}
