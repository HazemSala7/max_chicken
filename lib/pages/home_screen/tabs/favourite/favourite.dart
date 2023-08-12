import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:trendyol/LocalDB/Models/FavoriteItem.dart';
import 'package:trendyol/LocalDB/Provider/FavouriteProvider.dart';
import '../../../../constants/constants.dart';
import '../../../../server/function/functions.dart';

class Favourite extends StatefulWidget {
  const Favourite({Key? key}) : super(key: key);

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FavouriteProvider>(builder: (context, favoriteProvider, _) {
      List<FavoriteItem> favoritesItems = favoriteProvider.favoriteItems;
      return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
              child: Row(
                children: [
                  Text(
                    "المفضله",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            favoritesItems.length != 0
                ? ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: favoritesItems.length,
                    itemBuilder: (context, index) {
                      FavoriteItem item = favoritesItems[index];
                      return favoriteCard(
                        id: 2,
                        price: item.price.toString(),
                        name: item.name,
                        removeProduct: () {
                          favoriteProvider.removeFromFavorite(item.productId);
                          setState(() {});
                        },
                        image: item.image,
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
      );
    });
  }

  Widget favoriteCard(
      {String image = "",
      String price = "",
      String name = "",
      int fav_id = 0,
      Function? removeProduct,
      int id = 0,
      String categry = ""}) {
    return Padding(
      padding: const EdgeInsets.only(right: 15, left: 15, top: 20),
      child: Stack(
        alignment: Alignment.topLeft,
        children: [
          Container(
            height: 150,
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
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Container(
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      height: 180,
                      width: 120,
                    ),
                    height: 180,
                    width: 120,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(name.length > 18 ? name.substring(0, 12) : name),
                        Text(categry),
                        Text("${price} NIS"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () async {
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
                                removeProduct!();
                                Fluttertoast.showToast(
                                    msg: "تم حذف المنتج من المفضله بنجاح");
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
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
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
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
              icon: Icon(
                Icons.delete,
                color: MAIN_COLOR,
              ))
        ],
      ),
    );
  }
}
