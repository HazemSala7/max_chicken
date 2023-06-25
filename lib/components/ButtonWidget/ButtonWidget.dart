import 'package:flutter/material.dart';

class ButtonWidget extends StatefulWidget {
  Function OnTapButton;
  final name;
  ButtonWidget({super.key, this.name, required this.OnTapButton});

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 25, left: 25, top: 35),
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        height: 50,
        minWidth: double.infinity,
        color: Color(0xff800080),
        textColor: Colors.white,
        child: Text(
          widget.name,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          widget.OnTapButton();
        },
      ),
    );
  }
}
