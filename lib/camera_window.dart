import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWindow extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraWindow(this.cameras);

  @override
  _CameraWindowState createState() => new _CameraWindowState();
}

class _CameraWindowState extends State<CameraWindow> {
  CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    print('aspect ration');
    print(controller.value.aspectRatio);
    print(controller.value.previewSize.height);
    print(controller.value.previewSize.width);
    return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller));
  }
}
