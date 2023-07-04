import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as LocationManager;
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:trendyol/constants/constants.dart';
import 'package:trendyol/server/server.dart';

import '../home_screen/home_screen.dart';

var del = 20;

class BuyNow extends StatefulWidget {
  var total;
  BuyNow({
    Key? key,
    required this.total,
  }) : super(key: key);

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  TextEditingController noteController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController nearofController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  List<Marker> _markers = [];
  var lati, longi;
  _handleTap(LatLng point) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
      lati = point.latitude;
      longi = point.longitude;
    });
  }

  var mycur = LatLng(31.952162, 35.233154);
  static const LatLng _center = const LatLng(31.952162, 35.233154);
  LatLng _lastMapPosition = _center;
  String _title = "";
  String _detail = "";

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  AddMarker() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(title: _title, snippet: _detail),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  _onAddMarkerButtonPressed() {
    _markers.clear();
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_lastMapPosition.toString()),
          position: _lastMapPosition,
          infoWindow: InfoWindow(title: _title, snippet: _detail),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  Completer<GoogleMapController> _controller = Completer();

  currentLocation() async {
    final GoogleMapController controller = await _controller.future;
    LocationData? currentLocation;
    var location = new Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }

    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(currentLocation!.latitude!, currentLocation.longitude!),
        zoom: 17.0,
      ),
    ));

    setState(() {
      _markers.clear();
      _markers.add(Marker(
          markerId: MarkerId(
              LatLng(currentLocation!.latitude!, currentLocation.longitude!)
                  .toString()),
          position:
              LatLng(currentLocation.latitude!, currentLocation.longitude!),
          infoWindow: InfoWindow(title: _title, snippet: _detail),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(31.952162, 35.233154),
    zoom: 14.4746,
  );
  static CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(31.952162, 35.233154),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  static final now = new DateTime.now();
  static final formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  String iniitem = 'firstone';

  double tt = 0;
  String dropdownValue = "Encajes";
  String firstDropDownData = "";
  bool drop = false;
  int index = 0;

  send() async {
    if (cityController.text == '' ||
        areaController.text == '' ||
        phoneController.text == '' ||
        nearofController.text == '') {
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');
      var headers = {
        'Authorization': 'Bearer $token',
        'ContentType': 'application/json'
      };
      final response = await http.post(Uri.parse(URL_ADD_ORDER),
          body: {
            'note': noteController.text,
            'phone': phoneController.text,
            'status': "قيد التحضير",
            'area': areaController.text,
            'city': cityController.text,
            'near': nearofController.text,
            'sum': widget.total.toString(),
          },
          headers: headers);

      var data = json.decode(response.body.toString());
      print("data");
      print(data);
      if (data['status'] == 'true') {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(msg: AppLocalizations.of(context)!.req_suc);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      currentIndex: 0,
                    )));

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('city', cityController.text);
        await prefs.setString('phone', phoneController.text);
        await prefs.setString('area', areaController.text);
        await prefs.setString('near', nearofController.text);
        await prefs.setString('notes', noteController.text);
        await prefs.setString('phone', phoneController.text);
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        print('fsdsdfs');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // createMarker(context);
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 25, right: 25, left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "رقم الهاتف",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 25, left: 25, top: 5),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        // color: Colors.red,

                        child: TextField(
                          controller: phoneController,
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff800080), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD6D3D3)),
                            ),
                            hintText: "رقم الهاتف",
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 25, left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "المدينه",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 25, left: 25, top: 5),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        // color: Colors.red,

                        child: TextField(
                          controller: cityController,
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff800080), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD6D3D3)),
                            ),
                            hintText: "المدينه",
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 25, left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "المنطقه",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 25, left: 25, top: 5),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        // color: Colors.red,

                        child: TextField(
                          controller: areaController,
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff800080), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD6D3D3)),
                            ),
                            hintText: "المنطقه",
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 25, left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "بالقرب من",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 25, left: 25, top: 5),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        // color: Colors.red,

                        child: TextField(
                          controller: nearofController,
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff800080), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD6D3D3)),
                            ),
                            hintText: "بالقرب من",
                          ),
                        ),
                      ),
                    );
                  }),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, right: 25, left: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "ملاحظات",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter setState) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(right: 25, left: 25, top: 5),
                      child: Container(
                        height: 80,
                        width: double.infinity,
                        // color: Colors.red,

                        child: TextField(
                          controller: noteController,
                          obscureText: false,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xff800080), width: 2.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2.0, color: Color(0xffD6D3D3)),
                            ),
                            hintText: "ملاحظات",
                          ),
                        ),
                      ),
                    );
                  }),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 25, right: 25, top: 10),
                  //   child: Container(
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: Color(0xffD6D3D3))),
                  //     height: 300,
                  //     width: double.infinity,
                  //     child: Stack(
                  //       alignment: Alignment.topLeft,
                  //       children: [
                  //         GoogleMap(
                  //           markers: Set<Marker>.of(_markers),
                  //           onTap: _handleTap,
                  //           gestureRecognizers:
                  //               <Factory<OneSequenceGestureRecognizer>>[
                  //             new Factory<OneSequenceGestureRecognizer>(
                  //               () => new EagerGestureRecognizer(),
                  //             ),
                  //           ].toSet(),

                  //           // padding: EdgeInsets.all(100),
                  //           scrollGesturesEnabled: true,
                  //           // myLocationButtonEnabled: true,
                  //           // myLocationEnabled: true,
                  //           zoomControlsEnabled: true,
                  //           mapType: MapType.terrain,
                  //           initialCameraPosition: _kGooglePlex,
                  //           onMapCreated: (GoogleMapController controller) {
                  //             _controller.complete(controller);
                  //           },
                  //         ),
                  //         // IconButton(
                  //         //     icon: Icon(Icons.battery_charging_full),
                  //         //     onPressed: () async {
                  //         //       currentLocation();
                  //         //     }),
                  //         InkWell(
                  //           onTap: () {
                  //             currentLocation();
                  //           },
                  //           child: Container(
                  //             height: 50,
                  //             width: 50,
                  //             color: Colors.white,
                  //             child: Column(
                  //               children: [
                  //                 Container(
                  //                     height: 30,
                  //                     width: 30,
                  //                     child:
                  //                         Image.asset('assets/location.jpeg')),
                  //                 Text(
                  //                   'موقعي',
                  //                   style: TextStyle(
                  //                       fontSize: 10,
                  //                       fontWeight: FontWeight.bold),
                  //                 )
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 5,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),

                      height: 50,
                      width: double.infinity,
                      // color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.totally,
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "التوصيل",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "المطلوب للدفع",
                              style: TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 25, top: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.4),
                              blurRadius: 5,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4)),

                      height: 55,
                      width: double.infinity,
                      // color: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  // "f",
                                  "₪${double.parse(widget.total.toString())}",
                                  style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "₪${int.parse(del.toString())}",
                                  style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  // "g,",
                                  "₪${double.parse(widget.total.toString()) + int.parse(del.toString())}",
                                  style: GoogleFonts.cairo(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "الدفع نقدا عند الاستلام",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 25, left: 25, top: 40),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      height: 50,
                      minWidth: double.infinity,
                      color: MAIN_COLOR,
                      textColor: Colors.white,
                      child: new Text(
                        AppLocalizations.of(context)!.confirmbuy,
                        style: GoogleFonts.cairo(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
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
                        send();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding code() {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25, top: 10),
      child: Container(
        height: 50,
        width: double.infinity,
        // color: Colors.red,

        child: TextField(
          controller: codeController,
          obscureText: false,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff800080), width: 2.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2.0, color: Color(0xffD6D3D3)),
            ),
            hintText: AppLocalizations.of(context)!.codeoffer,
          ),
        ),
      ),
    );
  }

  // DropdownSearch<Country> test1_drop(List<Country> areas) {
  //   return DropdownSearch<Country>(
  //       mode: Mode.MENU,
  //       showSelectedItems: true,
  //       items: areas.map((Country value) {
  //         return DropdownMenuItem<Country>(
  //           value: value,
  //           child: Padding(
  //             padding: const EdgeInsets.only(right: 8.0),
  //             child: Text(
  //               value.area,
  //               style: TextStyle(fontSize: 12),
  //             ),
  //           ),
  //         );
  //       }).toList(),
  //       label: "Menu mode",
  //       hint: "country in menu mode",
  //       popupItemDisabled: (String s) => s.startsWith('I'),
  //       onChanged: (Country? changedValue) {
  //         // if (index != 0) {
  //         setState(() {
  //           index = areas.indexOf(changedValue!);
  //           newss = areas[index].id;
  //           aar1 = newss;
  //         });
  //         Fluttertoast.showToast(msg: '$aar1');
  //         // } else {
  //         //   print('sdsd');
  //         // }
  //       },
  //       selectedItem: "Brazil");
  // }

  Padding listofreq({
    String name = '',
    String price = '',
    String qty = '',
    String details = '',
    int total = 0,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5,
          ),
        ], color: Colors.white, borderRadius: BorderRadius.circular(4)),

        height: 50,
        width: double.infinity,
        // color: Colors.black,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  name.length > 7 ? name.substring(0, 7) + '...' : name,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  '₪$price',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  '$qty',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                Text(
                  '₪$total',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                )
              ],
            ),
            details_row(detail: details)
          ],
        ),
      ),
    );
  }

  Row details_row({String detail = ''}) {
    return Row(
      children: [
        SizedBox(
          width: 25,
        ),
        Text(
          '${AppLocalizations.of(context)!.details} ',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        Text(
          detail,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

// var _value = itemList.isEmpty
//     ? value
//     : itemList.firstWhere((item) => item.value == value.value);
  // int? newss;
  // int? mynull;

  // DropdownButtonFormField<String> area1(List<Area> areas1) {
  //   return DropdownButtonFormField<String>(
  //     decoration: InputDecoration(),
  //     hint: Padding(
  //       padding: const EdgeInsets.only(right: 8.0),
  //       child: Text(
  //         AppLocalizations.of(context)!.getarea,
  //         style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
  //       ),
  //     ),
  //     items: areas1.map((Area value) {
  //       return DropdownMenuItem(
  //         value: aar2 = value.id.toString(),
  //         child: Padding(
  //           padding: const EdgeInsets.only(right: 8.0),
  //           child: Text(
  //             value.area,
  //             style: TextStyle(fontSize: 12),
  //           ),
  //         ),
  //       );
  //     }).toList(),
  //     onChanged: (newid1) {
  //       setState(() {
  //         aar2 = newid1;
  //       });
  //       changeText(areas1[0].price);

  //       // changeid(areas[0].id);
  //     },
  //   );
  // }

  // InkWell dialog_drop({String name = ''}) {
  //   return InkWell(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Container(
  //           child: Row(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [Text(name)],
  //       )),
  //     ),
  //   );
  // }
}

class DropDown extends StatefulWidget {
  const DropDown({Key? key}) : super(key: key);

  @override
  _DropDownState createState() => _DropDownState();
}

class _DropDownState extends State<DropDown> {
  String _dropDownValue = '';
  var aar;
  double tt = 0;
  changeText(double price5) {
    // setState(() {
    tt = price5;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        //   child: Container(
        //     decoration: BoxDecoration(
        //         border: const Border(
        //             top: BorderSide(color: Color(0xffD6D3D3), width: 1),
        //             right: BorderSide(color: Color(0xffD6D3D3), width: 1),
        //             left: BorderSide(color: Color(0xffD6D3D3), width: 1),
        //             bottom: BorderSide(color: Color(0xffD6D3D3), width: 1)),
        //         borderRadius: BorderRadius.circular(4)),
        //     width: double.infinity,
        //     height: 50,
        //     child: DropdownButton<String>(
        //       hint: _dropDownValue == ''
        //           ? const Text(
        //               'اختيار المنطقه الجغرافيه',
        //               style:
        //                   TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        //             )
        //           : Text(
        //               _dropDownValue,
        //               style: TextStyle(color: Colors.blue),
        //             ),
        //       isExpanded: true,
        //       iconSize: 30.0,
        //       style: const TextStyle(color: Colors.blue),
        //       items: ['One', 'Two', 'Three'].map(
        //         (val) {
        //           return DropdownMenuItem<String>(
        //             value: val,
        //             child: Text(val),
        //           );
        //         },
        //       ).toList(),
        //       onChanged: (val) {
        //         setState(
        //           () {
        //             _dropDownValue = val!;
        //           },
        //         );
        //       },
        //     ),
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
          child: Container(
            decoration: BoxDecoration(
                border: const Border(
                    top: BorderSide(color: Color(0xffD6D3D3), width: 1),
                    right: BorderSide(color: Color(0xffD6D3D3), width: 1),
                    left: BorderSide(color: Color(0xffD6D3D3), width: 1),
                    bottom: BorderSide(color: Color(0xffD6D3D3), width: 1)),
                borderRadius: BorderRadius.circular(4)),
            width: double.infinity,
            height: 50,
            child: DropdownButton<String>(
              hint: _dropDownValue == ''
                  ? const Text(
                      'اختيار المدينه',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    )
                  : Text(
                      _dropDownValue,
                      style: const TextStyle(color: Colors.blue),
                    ),
              isExpanded: true,
              iconSize: 30.0,
              style: const TextStyle(color: Colors.blue),
              items: ['One', 'Two', 'Three'].map(
                (val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val),
                  );
                },
              ).toList(),
              onChanged: (val) {
                // setState(
                // () {
                _dropDownValue = val!;
                // },
                // );
              },
            ),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
        //   child: Container(
        //     decoration: BoxDecoration(
        //         border: const Border(
        //             top: BorderSide(color: Color(0xffD6D3D3), width: 1),
        //             right: BorderSide(color: Color(0xffD6D3D3), width: 1),
        //             left: BorderSide(color: Color(0xffD6D3D3), width: 1),
        //             bottom: BorderSide(color: Color(0xffD6D3D3), width: 1)),
        //         borderRadius: BorderRadius.circular(4)),
        //     width: double.infinity,
        //     height: 50,
        //     child: DropdownButton<String>(
        //       hint: _dropDownValue == ''
        //           ? const Text(
        //               'اختيار المنطقه ',
        //               style:
        //                   TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        //             )
        //           : Text(
        //               _dropDownValue,
        //               style: const TextStyle(color: Colors.blue),
        //             ),
        //       isExpanded: true,
        //       iconSize: 30.0,
        //       style: const TextStyle(color: Colors.blue),
        //       items: ['One', 'Two', 'Three'].map(
        //         (val) {
        //           return DropdownMenuItem<String>(
        //             value: val,
        //             child: Text(val),
        //           );
        //         },
        //       ).toList(),
        //       onChanged: (val) {
        //         setState(
        //           () {
        //             _dropDownValue = val!;
        //           },
        //         );
        //       },
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
