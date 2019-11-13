import 'package:flutter/material.dart';

class SnapButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () => print('snap'),
      child: Icon(
        Icons.camera,
        color: Colors.blue,
        size: 50.0,
      ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: EdgeInsets.all(15.0),
      splashColor: Colors.blue,
    );
  }
}
