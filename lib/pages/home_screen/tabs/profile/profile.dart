import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trendyol/constants/constants.dart';
import 'package:trendyol/pages/authentication/login_screen/login_screen.dart';
import 'package:trendyol/pages/home_screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trendyol/pages/order_notification_service/order_notification_service.dart';
import 'package:trendyol/pages/privacy_policy/privacy_policy.dart';
import 'package:trendyol/pages/who/who.dart';

import '../../../../server/function/functions.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  bool Login = false;
  setControllers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? login = prefs.getBool('login');
    if (login == true) {
      setState(() {
        Login = true;
      });
    } else {
      setState(() {
        Login = false;
      });
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    setControllers();
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: SizedBox(
                              height: 70,
                              width: 155,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "هل تريد بالتأكيد حذف حسابك بشكل نهائي ؟ ",
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                content: SizedBox(
                                                    height: 100,
                                                    width: 100,
                                                    child: Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                      color: MAIN_COLOR,
                                                    ))),
                                              );
                                            },
                                          );

                                          await removeUser(context);
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 40,
                                          child: Center(
                                            child: Text(
                                              "نعم",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: MAIN_COLOR),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                          width: 70,
                                          height: 40,
                                          child: Center(
                                            child: Text(
                                              "لا",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: MAIN_COLOR),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 130,
                    height: 40,
                    child: Center(
                      child: Text(
                        "حذف حسابي",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: MAIN_COLOR),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ], borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: Column(
                children: [
                  addressMethod(name: "الملخص"),
                  // lineMethod(),
                  // profileCard(
                  //     name: "الطلبيات",
                  //     iconornot: false,
                  //     image: "assets/checkout.png"),
                  lineMethod(),
                  profileCard(
                      name: "السله",
                      image: "assets/shopping-cart.png",
                      iconornot: false,
                      NavigatorFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      currentIndex: 2,
                                    )));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "المفضله",
                      iconornot: false,
                      image: "assets/heart.png",
                      icon: Icons.request_quote,
                      NavigatorFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen(
                                      currentIndex: 1,
                                    )));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "الطلبيات",
                      iconornot: true,
                      image: "assets/heart.png",
                      icon: Icons.request_quote,
                      NavigatorFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OrderNotificationService(
                                      ring: false,
                                    )));
                      }),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ], borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: Column(
                children: [
                  addressMethod(name: "حسابي"),
                  // lineMethod(),
                  // profileCard(
                  //   name: "المعلومات الشخصيه",
                  //   icon: Icons.person,
                  //   iconornot: true,
                  // ),
                  lineMethod(),
                  Login
                      ? profileCard(
                          name: "تسجيل خروج",
                          icon: Icons.logout,
                          iconornot: true,
                          NavigatorFunction: () async {
                            SharedPreferences preferences =
                                await SharedPreferences.getInstance();
                            await preferences.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                          currentIndex: 0,
                                        )));
                          })
                      : profileCard(
                          name: "تسجيل دخول",
                          icon: Icons.login,
                          iconornot: true,
                          NavigatorFunction: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          }),
                  lineMethod(),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 15, left: 15, bottom: 30),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 7,
                  blurRadius: 5,
                ),
              ], borderRadius: BorderRadius.circular(4), color: Colors.white),
              child: Column(
                children: [
                  addressMethod(name: "المزيد"),
                  // lineMethod(),
                  // profileCard(
                  //   name: "للمساعده & التواصل",
                  //   icon: Icons.person,
                  //   iconornot: true,
                  // ),
                  lineMethod(),
                  profileCard(
                      name: "معلومات عنا",
                      icon: Icons.info,
                      iconornot: true,
                      NavigatorFunction: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WhoWeAre()));
                      }),
                  lineMethod(),
                  profileCard(
                      name: "سياسه الخصوصيه",
                      icon: Icons.privacy_tip,
                      iconornot: true,
                      NavigatorFunction: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Privacy()));
                      }),
                  lineMethod(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget addressMethod({String name = ""}) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(right: 20, left: 20),
        child: Row(
          children: [
            Row(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget lineMethod() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Color(0xffD6D3D3),
    );
  }

  Widget profileCard(
      {String name = "",
      IconData? icon,
      Function? NavigatorFunction,
      bool iconornot = false,
      String image = ""}) {
    return InkWell(
      onTap: () {
        NavigatorFunction!();
      },
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: 45,
        child: Padding(
          padding: const EdgeInsets.only(right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  iconornot
                      ? Icon(icon)
                      : Image.asset(
                          image,
                          height: 25,
                          width: 25,
                        ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Icon(Icons.arrow_right_sharp)
            ],
          ),
        ),
      ),
    );
  }
}
