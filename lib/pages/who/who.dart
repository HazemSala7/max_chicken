import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
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
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.who,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Text("Here we put content of who we are page"),
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

  // Html text(String privacy) {
  //   return Html(data: privacy);
  // }
}
