import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import '../model/slider.dart';

class SlideImage extends StatefulWidget {
  List<Silder> slideimage;
  SlideImage({
    Key? key,
    required this.slideimage,
  }) : super(key: key);

  @override
  State<SlideImage> createState() => _SlideImageState();
}

class _SlideImageState extends State<SlideImage> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ImageSlideshow(
        width: double.infinity,
        height: 220,
        children: widget.slideimage
            .map(
              (e) => Image.network(e.image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                        "assets/logo.png",
                        fit: BoxFit.cover,
                      )),
            )
            .toList(),
        autoPlayInterval: 3000,
        isLoop: true,
      );
    });
  }
}
