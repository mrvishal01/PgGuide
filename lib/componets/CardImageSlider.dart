import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CardImageSlider extends StatelessWidget {
  final List<String> images;
  const CardImageSlider({Key? key,required this.images,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: images.length,
      options: CarouselOptions(
        height: 250.0,

        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        final imageUrl = images[index];
        debugPrint(imageUrl);
        return Card(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
            ),
            margin: const EdgeInsets.all(8.0),
              child:Padding(
                padding: const EdgeInsets.all(0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22.0),
                  child: Image.asset(
                      imageUrl,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover
                  ),
                ),
              ),
            );
      },
    );
  }
}