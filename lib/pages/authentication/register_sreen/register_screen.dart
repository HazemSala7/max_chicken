import 'dart:convert';
import 'dart:io' show Platform;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trendyol/constants/constants.dart';
import 'package:trendyol/server/server.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../home_screen/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../login_screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String os = Platform.operatingSystem; //in your code

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController repasswordController = TextEditingController();
  registerFunction() async {
    if (emailController.text == '' ||
        passwordController.text == '' ||
        phoneController.text == '' ||
        nameController.text == '') {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("الرجاء تعبئه جمبع الفراغات"),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "حسنا",
                  style: TextStyle(color: Color(0xff800080)),
                ),
              ),
            ],
          );
        },
      );
    } else if (passwordController.text != repasswordController.text) {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text("كلمه المرور غير متطابقه"),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  "حسنا",
                  style: TextStyle(color: Color(0xff800080)),
                ),
              ),
            ],
          );
        },
      );
    } else {
      var headers = {'Accept': 'application/json'};

      final response =
          await http.post(Uri.parse(URL_REGISTER), headers: headers, body: {
        'email': emailController.text,
        'password': passwordController.text,
        'phone': phoneController.text,
        'name': nameController.text,
      });
      var data = jsonDecode(response.body.toString());
      if (data['status'] == 'true') {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: "تم تسجيل حسابك بنجاح");
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      currentIndex: 0,
                    )));
      } else if (data['message'] == 'The given data was invalid.') {
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: new Text("الرجاء التأكد من البيانات المدخله"),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: new Text(
                    "حسنا",
                    style: TextStyle(
                      color: Color(0xff800080),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print('nothing');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      //     PreferredSize(child: AppBar2(), preferredSize: Size.fromHeight(50)),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Container(
                  // height: 150,
                  width: 250,
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  AppLocalizations.of(context)!.signup,
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  // color: Colors.red,

                  child: TextField(
                    controller: nameController,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            'assets/name.jpeg',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fitWidth,
                            color: Color(0xffB1B1B1),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff800080), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: AppLocalizations.of(context)!.username,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  // color: Colors.red,

                  child: TextField(
                    controller: phoneController,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            'assets/phone.jpeg',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fitWidth,
                            color: Color(0xffB1B1B1),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff800080), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: AppLocalizations.of(context)!.phonecon,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  // color: Colors.red,

                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Container(
                            alignment: Alignment.center,
                            height: 50,
                            width: 50,
                            child: Icon(Icons.mail, size: 25)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff800080), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: AppLocalizations.of(context)!.mailcon,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  // color: Colors.red,

                  child: TextField(
                    controller: passwordController,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            'assets/padlock.jpeg',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fitWidth,
                            color: Color(0xffB1B1B1),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff800080), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: AppLocalizations.of(context)!.enterpassword,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  // color: Colors.red,

                  child: TextField(
                    controller: repasswordController,
                    obscureText: false,
                    decoration: InputDecoration(
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(left: 7),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            'assets/padlock.jpeg',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fitWidth,
                            color: Color(0xffB1B1B1),
                          ),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff800080), width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                      ),
                      hintText: AppLocalizations.of(context)!.confirmpassword,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 35),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  height: 50,
                  minWidth: double.infinity,
                  color: MAIN_COLOR,
                  textColor: Colors.white,
                  child: Text(
                    AppLocalizations.of(context)!.signup,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (repasswordController.text != passwordController.text) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: new Text(
                                AppLocalizations.of(context)!.notcorrectreg),
                            actions: <Widget>[
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ok"))
                            ],
                          );
                        },
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: SizedBox(
                                height: 100,
                                width: 100,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          );
                        },
                      );
                      registerFunction();
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25, left: 25, top: 25),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.doyouhaveaccount,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      child: Text(
                        AppLocalizations.of(context)!.youcansigninhere,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: MAIN_COLOR),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
