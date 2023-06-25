import 'package:flutter/material.dart';

import 'package:trendyol/pages/single_store/single_store.dart';

class CompanyWidget extends StatefulWidget {
  var name, image, id, address, description, background_image;
  CompanyWidget({
    Key? key,
    required this.id,
    required this.image,
    required this.name,
    required this.address,
    required this.description,
    required this.background_image,
  }) : super(key: key);

  @override
  State<CompanyWidget> createState() => _CompanyWidgetState();
}

class _CompanyWidgetState extends State<CompanyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SingleStore(
                      id: widget.id,
                      name: widget.name,
                      image: widget.image,
                      background_image: widget.background_image)));
        },
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            Container(
              width: double.infinity,
              height: 170,
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                Container(
                  width: 100,
                  height: 60,
                  child: Center(
                    child: Text(
                      widget.name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 20),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(10)),
                  ),
                ),
                Container(
                  width: 100,
                  height: 20,
                  child: Center(
                    child: Text(
                      widget.name,
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(10)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
