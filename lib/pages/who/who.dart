import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:trendyol/constants/constants.dart';

class WhoWeAre extends StatelessWidget {
  const WhoWeAre({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10, left: 20, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_sharp,
                                color: MAIN_COLOR,
                                size: 30,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              AppLocalizations.of(context)!.who,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container()
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: text(),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Html text() {
    return Html(data: _htmlContent);
  }

  final _htmlContent = """
  <div>
    <p>من نحن</p>
    <p>عزيزي المستخدم، عزيزتي  المستدمه ..</p>
    <p>أهلا بكم في أفضل و أحدث تطبيق للتسوق في عالم   
يرجى من حضرتكم الإحاطة بالأمور التالية:</p>
    <p>-نقاط مجانية، تحصلون عليها عند كل عملية شراء من متجر Pal-Dent يمكنكم استبدالها في أي وقت بمنتجات قيّمة من المتجر 
</p>
    <p>-يمكنكم متابعة حالة الطلبيات من خلال التطبيق </p>
    <p>التطبيق يشمل التوصيل لكافة مناطق الضفة الغربية والقدس و الداخل</p>
    <p>التوصيل مجاني من خلال مندوبي Kliamr في المدن التالية:
جنين، نابلس، طولكرم و قلقيلية</p>
    <p>تكلفة التوصيل تضاف للطلبية بقيمة 20 شيقل للمناطق الأخرى داخل الضفة</p>
    <p>-طريقة الدفع المعتمدة لدى المتجر هي الدفع نقدا عند الاستلام</p>
    <p>تكلفة التوصيل تضاف للطلبية بقيمة 20 شيقل للمناطق الأخرى داخل الضفة</p>
    <p>مع كل المودة لحضراتكم .. استمتعوا بالتسوق لدى متجركم Kliamr الأفضل في فلسطين</p>
  </div>
  """;
}
