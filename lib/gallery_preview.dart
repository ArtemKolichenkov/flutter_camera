import 'package:flutter/material.dart';
import 'package:flutter_camera/gallery.dart';

class GalleryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => GalleryPage()),
          ),
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
