import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:trendyol/constants/constants.dart';
import 'package:trendyol/server/server.dart';
import '../../home_screen/home_screen.dart';
import '../register_sreen/register_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  refresh() {
    setState(() {});
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  loginFunction() async {
    if (phoneController.text == '' || passwordController.text == '') {
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('الرجاء تعبئه جميع الفراغات'),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'حسنا',
                  style: TextStyle(color: Color(0xff800080)),
                ),
              ),
            ],
          );
        },
      );
    } else {
      var response = await http.post(Uri.parse(URL_LOGIN), body: {
        "phone": phoneController.text,
        "password": passwordController.text,
      });
      var data = jsonDecode(response.body.toString());

      if (data['status'] == 'true') {
        Navigator.of(context, rootNavigator: true).pop();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = data['access_token'];
        int id = data["id"]['id'];
        await prefs.setString('access_token', token);
        await prefs.setInt('user_id', id);
        await prefs.setBool('login', true);
        Fluttertoast.showToast(
          msg: 'تم تسجيل الدخول بنجاح',
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => HomeScreen(
              currentIndex: 0,
            ),
          ),
          (route) => false,
        );
      } else if (data['message'] == 'Invalid login details') {
        Navigator.of(context, rootNavigator: true).pop();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text('الرجاء التأكد من البيانات المدخله'),
              actions: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'حسنا',
                    style: TextStyle(color: Color(0xff800080)),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print('sdfsd');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                AppLocalizations.of(context)!.login,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15, left: 15, top: 25),
              child: Container(
                height: 50,
                width: double.infinity,
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.number,
                  obscureText: false,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: Icon(Icons.phone, size: 25)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
                    ),
                    hintText: "رقم الهاتف",
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
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(left: 7),
                      child: InkWell(
                        onTap: () {
                          toggle();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 50,
                          width: 50,
                          child: Image.asset(
                            'assets/view.jpeg',
                            height: 25,
                            width: 25,
                            fit: BoxFit.fitWidth,
                            color: Color(0xffB1B1B1),
                          ),
                        ),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: MAIN_COLOR, width: 2.0),
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
              padding: const EdgeInsets.only(right: 25, left: 25, top: 35),
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4))),
                height: 50,
                minWidth: double.infinity,
                color: MAIN_COLOR,
                textColor: Colors.white,
                child: Text(
                  AppLocalizations.of(context)!.login,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SizedBox(
                            height: 100,
                            width: 100,
                            child: Center(child: CircularProgressIndicator())),
                      );
                    },
                  );

                  loginFunction();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 25, left: 25, top: 25),
              child: Row(
                children: [
                  Text(
                    AppLocalizations.of(context)!.donthaveaccount,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterScreen()));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.youcansignup,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: MAIN_COLOR),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
