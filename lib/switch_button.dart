import 'package:flutter/material.dart';

class SwitchCameraButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      iconSize: 50,
      icon: Icon(Icons.switch_camera),
      onPressed: () => print('Camera switched'),
    );
  }
}
