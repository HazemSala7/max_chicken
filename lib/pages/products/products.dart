import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../constants/constants.dart';
import '../../server/function/functions.dart';
import '../../services/prodcut_widget/product_widget.dart';

class Products extends StatefulWidget {
  final category_id;
  const Products({super.key, this.category_id});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            color: MAIN_COLOR,
                            size: 30,
                          ))
                    ],
                  ),
                ),
                FutureBuilder(
                    future:
                        getProductsCategories(widget.category_id.toString()),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null) {
                        var products = snapshot.data['products'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
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
                        );
                      } else {
                        return Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.4,
                          child: SpinKitPulse(
                            color: MAIN_COLOR,
                            size: 60,
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
