import 'dart:convert';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:path/path.dart' as Path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:trendyol/constants/constants.dart';
import 'package:trendyol/pages/home_screen/home_screen.dart';

enum SingingCharacter { male, female }

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool im = false;
  File? imageFile;
  final picker = ImagePicker();

  chooseImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);
    setState(() {
      imageFile = File(pickedFile!.path);
    });
  }

  // bool loading = false;
  SingingCharacter? _character = SingingCharacter.female;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController dateinput = TextEditingController();
  @override
  void initState() {
    super.initState();

    getData();
  }

  editthisprofile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? id = prefs.getInt('id');
    var headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    };
    var url = 'http://qadrs.com/ayesh_dent/api/edit_data';

    var request = new http.MultipartRequest("POST", Uri.parse(url));

    request.fields['name'] = nameController.text.toString();
    request.fields['email'] = emailController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['notes'] = notesController.text;
    request.fields['id'] = id.toString();

    request.headers.addAll(headers);

    if (imageFile != null) {
      var stream =
          new http.ByteStream(DelegatingStream.typed(imageFile!.openRead()));
      var length = await imageFile!.length();

      var multipartFile = new http.MultipartFile("avatar", stream, length,
          filename: Path.basename(imageFile!.path));

      request.files.add(multipartFile);
    }
    var response = await request.send();

    response.stream.transform(utf8.decoder).listen((value) async {
      Map valueMap = json.decode(value);
      print("valueMap");
      print(valueMap);
      if (valueMap['status'].toString() == 'true') {
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      currentIndex: 3,
                    )));
        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.editsuccess);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.editfailed);
      }
    });
  }

  _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(
            2000), //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      // print(pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      // print(
      //     formattedDate); //formatted date output using intl package =>  2021-03-16
      //you can implement different kind of Date Format here according to your requirement

      setState(() {
        dateinput.text = formattedDate; //set output date to TextField value.
      });
    } else {
      // print("Date is not selected");
    }
  }

  getmyimage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? id = prefs.getInt('id');
    var headers = {
      'Authorization': 'Bearer $token',
      'ContentType': 'application/json'
    };

    var url = 'http://qadrs.com/ayesh_dent/api/profile_data/$id';

    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body)["data"][0];
    return res;
  }

  getData() async {
    setState(() {
      im = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');
    int? id = prefs.getInt('id');
    var headers = {
      'Authorization': 'Bearer $token',
      'Aceept': 'application/json'
    };

    var url = 'http://qadrs.com/ayesh_dent/api/profile_data/$id';

    var response = await http.get(Uri.parse(url), headers: headers);
    var res = jsonDecode(response.body)["data"][0];

    var name = res['name'] ?? "";
    var notes = res['notes'] ?? "-";
    var email = res['email'] ?? "-";
    var phone = res['phone'] ?? "-";
    var created_at = res['created_at'] ?? "-";

    setState(() {
      nameController.text = name;
      notesController.text = notes;
      emailController.text = email;
      phoneController.text = phone;
      dateinput.text = created_at.toString().substring(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: imageoftheuser(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "أسم المستخدم ",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Container(
                      child: Center(
                        child: TextFormField(
                          controller: nameController,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      // color: Colors.black,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Color(0xffD6D3D3)),
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "البريد الالكتروني",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Container(
                      child: Center(
                        child: TextFormField(
                          controller: emailController,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      // color: Colors.black,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Color(0xffD6D3D3)),
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "رقم الهاتف",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Container(
                      child: Center(
                        child: TextFormField(
                          controller: phoneController,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      // color: Colors.black,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Color(0xffD6D3D3)),
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "ملاحظات",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Container(
                      child: Center(
                        child: TextFormField(
                          controller: notesController,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      // color: Colors.black,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Color(0xffD6D3D3)),
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "تاريخ الميلاد",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
                    child: Container(
                      child: Center(
                        child: TextFormField(
                          readOnly: true,
                          onTap: _pickDate,
                          controller: dateinput,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      // color: Colors.black,
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Color(0xffD6D3D3)),
                        borderRadius: BorderRadius.circular(4),
                        color: Color(0xffEBEBEB),
                      ),
                    ),
                  ),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     SizedBox(
                  //       height: 50,
                  //       width: 150,
                  //       child: RadioListTile(
                  //           title: Text(AppLocalizations.of(context)!.male),
                  //           value: SingingCharacter.male,
                  //           groupValue: _character,
                  //           selected: _character == SingingCharacter.male,
                  //           onChanged: (SingingCharacter? value) {
                  //             setState(() {
                  //               _character = value;
                  //             });
                  //           }),
                  //     ),
                  //     SizedBox(
                  //       height: 50,
                  //       width: 150,
                  //       child: Center(
                  //         child: RadioListTile(
                  //             title: Text(AppLocalizations.of(context)!.female),
                  //             value: SingingCharacter.female,
                  //             groupValue: _character,
                  //             selected: _character == SingingCharacter.female,
                  //             onChanged: (SingingCharacter? value) {
                  //               setState(() {
                  //                 _character = value;
                  //               });
                  //             }),
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, top: 25, right: 25),
                    child: Container(
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: Center(
                                          child: CircularProgressIndicator())),
                                );
                              },
                            );
                            editthisprofile();
                          },
                          child: Text(
                            AppLocalizations.of(context)!.editsave,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0xff800080)),
                          ),
                        ),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xff800080),
                        )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget imageoftheuser() {
    return Container(
      child: im
          ? FutureBuilder(
              future: getmyimage(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.data != null) {
                  var myim = snapshot.data['avatar'];
                  return withoutedit(myim);
                } else {
                  return SizedBox(
                    height: 120,
                    width: 120,
                  );
                }
              },
            )
          : Stack(
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                      // color: Colors.blue,
                      shape: BoxShape.circle),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                actions: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xff800080),
                                      ),
                                      width: double.infinity,
                                      child: InkWell(
                                        onTap: () {
                                          chooseImage(ImageSource.gallery);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .takegallery,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xff800080),
                                      ),
                                      width: double.infinity,
                                      child: InkWell(
                                        onTap: () {
                                          chooseImage(ImageSource.gallery);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .takegallery,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color(0xff800080),
                                      ),
                                      width: double.infinity,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)!.ok,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.add_a_photo)))
              ],
            ),
    );
  }

  InkWell withoutedit(String image) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xff800080),
                    ),
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        chooseImage(ImageSource.gallery);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.takegallery,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xff800080),
                    ),
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        chooseImage(ImageSource.camera);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.takecamera,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Color(0xff800080),
                    ),
                    width: double.infinity,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.ok,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        height: 120,
        // color: Colors.blueGrey,
        width: 120,
        decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
          border: Border.all(color: Color(0xff800080), width: 2),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
