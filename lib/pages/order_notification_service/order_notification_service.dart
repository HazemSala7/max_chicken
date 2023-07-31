// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:trendyol/constants/constants.dart';
import 'package:trendyol/server/function/functions.dart';

class OrderNotificationService extends StatefulWidget {
  bool ring;
  OrderNotificationService({
    Key? key,
    required this.ring,
  }) : super(key: key);

  @override
  State<OrderNotificationService> createState() =>
      OordeNnotificatioSserviceState();
}

class OordeNnotificatioSserviceState extends State<OrderNotificationService> {
  // final player = AudioPlayer();
  // static AudioPlayer advancedPlayer = AudioPlayer();
  // static AudioCache player = AudioCache();
  // void changeVolume(double value) {
  //   advancedPlayer.setVolume(value);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    widget.ring ? playAudio() : null;
  }

  playAudio() async {
    AssetsAudioPlayer.newPlayer().open(
      Audio("assets/order_ring.mp3"),
      showNotification: true,
      volume: 100.0,
    );
    // assetsAudioPlayer.setVolume(0.5);
    // await advancedPlayer.setVolume(100.0);
    // changeVolume(100.0);
    // player.setVolume(0.9);
    // advancedPlayer.play(AssetSource('order_ring.mp3'),
    //     mode: PlayerMode.mediaPlayer);
  }

  Widget build(BuildContext context) {
    return Container(
        color: MAIN_COLOR,
        child: SafeArea(
            child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FutureBuilder(
                    future: GetAllOrders(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.data != null) {
                        var products = snapshot.data['orders'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: products.length,
                              itemBuilder: (context, int index) {
                                return OrderWidget(
                                  products: products[index]["products"] ?? [],
                                  name: products[index]["user_name"] ??
                                      "حازم صلاح",
                                  phone: products[index]["phone"] ?? "",
                                  status: products[index]["status"] ?? "",
                                  id: products[index]["id"] ?? 1,
                                  total: products[index]["total"] ?? "",
                                );
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

                // InkWell(
                //   onTap: () {
                //     Fluttertoast.showToast(msg: "تم قبول الطلب بنجاح");
                //     player.stop();
                //   },
                //   child: Container(
                //     width: 250,
                //     height: 50,
                //     decoration: BoxDecoration(
                //         color: MAIN_COLOR,
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Center(
                //       child: Text(
                //         "قبول الطلب",
                //         style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             color: Colors.white,
                //             fontSize: 18),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        )));
  }

  Widget OrderWidget(
      {var products,
      String name = '',
      String status = '',
      String phone = '',
      var total,
      int id = 0}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: Container(
        width: double.infinity,
        // height: 50,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 5,
          ),
        ], borderRadius: BorderRadius.circular(10), color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 120,
                    child: Text(
                      "أسم المستخدم : ",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      child: Text(
                        "رقم الهاتف : ",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(
                      phone,
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Color.fromARGB(255, 157, 156, 156),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: Center(
                          child: Text(
                            "المنتج",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: MAIN_COLOR),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "الكميه",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: MAIN_COLOR),
                          ),
                        )),
                    Expanded(
                        flex: 1,
                        child: Center(
                          child: Text(
                            "السعر",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, color: MAIN_COLOR),
                          ),
                        )),
                  ],
                ),
              ),
              ListView.builder(
                  itemCount: products.length,
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  products[index]["name"] ?? "-",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  products[index]["qty"].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  "₪${products[index]["price"]}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              )),
                        ],
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 1,
                  color: Color.fromARGB(255, 157, 156, 156),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    // Container(
                    //   width: 120,
                    //   child: Text(
                    //     "ملاحظات : ",
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.w600, fontSize: 16),
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 5,
                    // ),
                    Expanded(
                      child: Text(
                        "ملاحظات ملاحظات ملاحظات ملاحظات ملاحظات ملاحظات ملاحظات ملاحظات ملاحظات ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () async {
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
                    await changeOrderStatus(id, context);
                    setState(() {});
                  },
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: status == "قيد التحضير"
                            ? MAIN_COLOR
                            : Colors.green),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          status == "قيد التحضير"
                              ? "قبول الطلب : "
                              : "مقبول : ",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        Text(
                          "₪${total}",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
