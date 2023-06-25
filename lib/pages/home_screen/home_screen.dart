import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:fluid_bottom_nav_bar/fluid_bottom_nav_bar.dart';
import 'package:flutter/material.dart';

import 'package:trendyol/constants/constants.dart';

import 'package:trendyol/pages/home_screen/tabs/main_screen/main_screen.dart';
import 'package:trendyol/pages/home_screen/tabs/profile/profile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'tabs/cart/cart.dart';
import 'tabs/categories/categories.dart';
import 'tabs/favourite/favourite.dart';

class HomeScreen extends StatefulWidget {
  var currentIndex;
  HomeScreen({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              height: 50,
              backgroundColor: MAIN_COLOR,
              // buttonBackgroundColor: MAIN_COLOR,
              items: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.home, size: 20),
                      Text(
                        "الرئيسيه",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/heart.png",
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        "المفضله",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Image.asset(
                        "assets/add_cart.png",
                        width: 20,
                        height: 20,
                      ),
                      Text(
                        "السله",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(Icons.person, size: 20),
                      Text(
                        "حسابي",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  widget.currentIndex = index;
                });
              },
            ),
            body: DoubleBackToCloseApp(
              snackBar:
                  SnackBar(content: Text('اضغط مره اخرى للخروج من التطبيق')),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _widgetOptions.elementAt(widget.currentIndex),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  List<Widget> _widgetOptions = <Widget>[
    MainScreen(),
    Favourite(),
    Cart(),
    Profile(),
  ];

  void onTabTapped(int index) {
    setState(() {
      widget.currentIndex = index;
    });
  }
}
