import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

class TabWidget extends StatefulWidget {
  final name;
  int index;
  List<bool> checkColor;
  TabWidget({
    Key? key,
    required this.name,
    required this.index,
    required this.checkColor,
  }) : super(key: key);

  @override
  State<TabWidget> createState() => _TabWidgetState();
}

class _TabWidgetState extends State<TabWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, left: 5),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.checkColor[widget.index] = !widget.checkColor[widget.index];
          });
        },
        child: Container(
          height: 25,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 20,
              left: 20,
            ),
            child: Center(
                child: Text(
              widget.name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: widget.checkColor[widget.index]
                      ? Colors.white
                      : Colors.black),
            )),
          ),
          decoration: BoxDecoration(
              color:
                  widget.checkColor[widget.index] ? MAIN_COLOR : Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                  color: widget.checkColor[widget.index]
                      ? Colors.white
                      : Color(0xffDFDFDF))),
        ),
      ),
    );
  }
}
