import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class Categories extends StatelessWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    bottom: TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.black,
                      labelStyle: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                      tabs: [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Women"),
                              Icon(
                                Icons.woman,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text("Men"),
                              Icon(
                                Icons.person,
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    FutureBuilder(
                      future: getCategories(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        } else if (snapshot.data != null) {
                          var myproduct = snapshot.data['categories'];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 10, left: 10, bottom: 150),
                            child: ListView.builder(
                                itemCount: myproduct.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return categoryCard(
                                      index: index,
                                      name: myproduct[index]["name"]);
                                })),
                          );
                        } else {
                          return Center(
                              child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator()));
                        }
                      },
                    ),
                    FutureBuilder(
                      future: getCategories(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                        } else if (snapshot.data != null) {
                          var myproduct = snapshot.data['categories'];
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 10, left: 10, bottom: 150),
                            child: ListView.builder(
                                itemCount: myproduct.length,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: ((context, index) {
                                  return categoryCard(
                                      index: index,
                                      name: myproduct[index]["name"]);
                                })),
                          );
                        } else {
                          return Center(
                              child: SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: CircularProgressIndicator()));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  getCategories() async {
    var headers = {'ContentType': 'application/json'};
    var url = "http://10.0.2.2:8000/api/categories";
    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body);
    return res;
  }

  Widget categoryCard({int index = 0, String name = ""}) {
    return Container(
      color: index % 2 == 0 ? Color(0xffF6F6F6) : Colors.white,
      width: double.infinity,
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: TextStyle(fontSize: 17),
            ),
            Icon(Icons.arrow_right_sharp)
          ],
        ),
      ),
    );
  }
}
