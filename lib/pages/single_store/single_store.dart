import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trendyol/server/function/functions.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/constants.dart';
import '../../services/prodcut_widget/product_widget.dart';

class SingleStore extends StatefulWidget {
  final name, image, id, address, desc, background_image;
  var stores_images;
  SingleStore({
    Key? key,
    this.name,
    this.stores_images,
    this.desc,
    this.address,
    this.image,
    this.background_image,
    this.id,
  }) : super(key: key);

  @override
  State<SingleStore> createState() => _SingleStoreState();
}

class _SingleStoreState extends State<SingleStore> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: FutureBuilder(
                future: getSingleCompany(widget.id.toString()),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data != null) {
                    var STORE = snapshot.data["company"];
                    var PRODUCTS = snapshot.data["products"];
                    return StoreWidget(
                      image_logo: widget.image,
                      image_background: STORE["background_image"],
                      store_name: STORE["name"],
                      desc:
                          "الخليل-مجمع الرشاد-ط1 الفرع الثاني مجمع الهيبرون سنتر ط3 بيت لحم السعادة مول ط2, Hebron, Palestine",
                      productsArray: PRODUCTS,
                      address: STORE["address"] ?? "",
                      whatsapp: "",
                      snapchat: "",
                      facebook: "",
                      instagram: "",
                      messenger: "",
                      latt: "",
                      long: "",
                    );
                  } else {
                    return StoreWidget(
                      image_logo: widget.image,
                      image_background: widget.background_image,
                      store_name: widget.name,
                      desc:
                          "الخليل-مجمع الرشاد-ط1 الفرع الثاني مجمع الهيبرون سنتر ط3 بيت لحم السعادة مول ط2, Hebron, Palestine",
                      productsArray: [],
                      address: "",
                      whatsapp: "",
                      snapchat: "",
                      facebook: "",
                      instagram: "",
                      messenger: "",
                      latt: "",
                      long: "",
                    );
                  }
                }),
          ),
        ),
      ),
    );
  }

  int current = 0;

  Widget StoreWidget(
      {String image_logo = "",
      String image_background = "",
      String store_name = "",
      String desc = "",
      String address = "",
      String whatsapp = "",
      String facebook = "",
      String instagram = "",
      String messenger = "",
      String snapchat = "",
      String latt = "",
      String long = "",
      var productsArray}) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              height: 320,
              width: double.infinity,
              child: Image.network(image_background,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/logo.jpeg",
                        fit: BoxFit.cover,
                      )),
            ),
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_circle_right,
                  size: 35,
                  color: MAIN_COLOR,
                ))
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Container(
            width: double.infinity,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(color: MAIN_COLOR, width: 4)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.network(image_logo,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                                "assets/logo.png",
                                fit: BoxFit.cover,
                              )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        store_name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        address,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 20),
        //   child: socail(
        //       insta: instagram,
        //       facebook: facebook,
        //       messanger: messenger,
        //       phone: whatsapp,
        //       wahtapp: whatsapp),
        // ),
        Padding(
          padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
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
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          child: Container(
            height: 20,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(right: 10, left: 15),
              child: Row(
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 40,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: Items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      current = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(5),
                    // width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                      color: current == index ? Colors.red : Colors.white,
                      borderRadius: current == index
                          ? BorderRadius.circular(10)
                          : BorderRadius.circular(10),
                      border: current == index
                          ? Border.all(color: Colors.red, width: 2)
                          : Border.all(color: MAIN_COLOR, width: 2),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 5, right: 5, left: 5, top: 5),
                      child: Center(
                        child: Text(
                          Items[index],
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: current == index
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
        MainCategoryWidget(i: 2)
      ],
    );
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
          var products = snapshot.data['products'];

          return Padding(
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
          );
        } else {
          return Center(
              child: SizedBox(
                  height: 40, width: 40, child: CircularProgressIndicator()));
        }
      },
    );
  }
}
