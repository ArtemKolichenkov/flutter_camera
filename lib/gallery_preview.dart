import 'package:flutter/material.dart';

class GalleryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => print('gallery'),
        child: Container(
          child: Center(
            child: Text('Gallery'),
          ),
          color: Colors.white70,
          height: 50,
          width: 50,
        ));
  }
}
