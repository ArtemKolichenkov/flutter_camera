import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWindow extends StatefulWidget {
  final CameraController cameraController;

  CameraWindow(this.cameraController);

  @override
  _CameraWindowState createState() => new _CameraWindowState();
}

class _CameraWindowState extends State<CameraWindow> {

  @override
  Widget build(BuildContext context) {
    if (!widget.cameraController.value.isInitialized) {
      return Container();
    }
    print('aspect ration');
    print(widget.cameraController.value.aspectRatio);
    print(widget.cameraController.value.previewSize.height);
    print(widget.cameraController.value.previewSize.width);
    return AspectRatio(
        aspectRatio: widget.cameraController.value.aspectRatio,
        child: CameraPreview(widget.cameraController));
  }
}
