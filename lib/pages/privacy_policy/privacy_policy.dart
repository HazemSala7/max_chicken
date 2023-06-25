import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:trendyol/constants/constants.dart';

class Privacy extends StatefulWidget {
  const Privacy({Key? key}) : super(key: key);

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
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
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "",
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Html text1(String privacy) {
  //   return Html(data: _htmlContent);
  // }

  final _htmlContent = """
  <div>
    <p>سياسة الخصوصية </p>
    <p>عزيزي المستخدم، عزيزتي  المستدمه ..</p>
    <p>أهلا بكم في أفضل و أحدث تطبيق للتسوق في عالم   
يرجى من حضرتكم الإحاطة بالأمور التالية:</p>
    <p>-نقاط مجانية، تحصلون عليها عند كل عملية شراء من متجر Pal-Dent يمكنكم استبدالها في أي وقت بمنتجات قيّمة من المتجر 
</p>
    <p>-يمكنكم متابعة حالة الطلبيات من خلال التطبيق </p>
    <p>التطبيق يشمل التوصيل لكافة مناطق الضفة الغربية والقدس و الداخل</p>
    <p>التوصيل مجاني من خلال مندوبي rOVAN في المدن التالية:
جنين، نابلس، طولكرم و قلقيلية</p>
    <p>تكلفة التوصيل تضاف للطلبية بقيمة 20 شيقل للمناطق الأخرى داخل الضفة</p>
    <p>-طريقة الدفع المعتمدة لدى المتجر هي الدفع نقدا عند الاستلام</p>
    <p>تكلفة التوصيل تضاف للطلبية بقيمة 20 شيقل للمناطق الأخرى داخل الضفة</p>
    <p>مع كل المودة لحضراتكم .. استمتعوا بالتسوق لدى متجركم Pal-Dent الأفضل في فلسطين</p>
  </div>
  """;
}
