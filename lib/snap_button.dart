import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'main.dart';

class SnapButton extends StatefulWidget {
  final CameraController cameraController;
  final Mode mode;

  SnapButton(this.cameraController, this.mode);

  @override
  _SnapButtonState createState() => _SnapButtonState();
}

class _SnapButtonState extends State<SnapButton>
    with SingleTickerProviderStateMixin {
  bool _isRecording = false;
  AnimationController _controller;
  Animation<Color> colorAnimation;

  @override
  initState() {
    super.initState();
    // Because this class has now mixed in a TickerProvider
    // It can be its own vsync. This is what you need almost always
    _controller = new AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    // The chained 'animate' function is required
    colorAnimation = new ColorTween(
      begin: Colors.red.shade400,
      end: Colors.red.shade900,
    ).animate(_controller)
      // This is a another chained method for Animations.
      // It will call the callback passed to it everytime the
      // value of the tween changes. Call setState within it
      // to repaint the widget with the new value
      ..addListener(() {
        setState(() {});
      });
    _controller.stop();
  }

  _getFilePath() async {
    final extension = widget.mode == Mode.photo ? '.png' : '.mp4';
    return join(
        (await getTemporaryDirectory()).path, '${DateTime.now()}$extension');
  }

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () async {
        try {
          if (!widget.cameraController.value.isInitialized) {
            print('Not initialized');
          }

          final path = await _getFilePath();
          if (widget.mode == Mode.photo) {
            await widget.cameraController.takePicture(path);
          } else {
            if (_isRecording) {
              _controller.stop();
              widget.cameraController.stopVideoRecording();
              setState(() {
                _isRecording = false;
              });
            } else {
              _controller.repeat(reverse: true);
              widget.cameraController.startVideoRecording(path);
              setState(() {
                _isRecording = true;
              });
            }
          }
        } catch (e) {
          print(e);
        }
      },
      child: widget.mode == Mode.photo
          ? Icon(
              Icons.camera,
              color: Colors.blue,
              size: 50.0,
            )
          : Container(
              decoration: new BoxDecoration(
                color: colorAnimation.status == AnimationStatus.dismissed
                    ? Colors.red
                    : colorAnimation.value,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(0),
              width: 50.0,
              height: 50.0,
            ),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: EdgeInsets.all(15.0),
      splashColor: Colors.blue,
    );
  }
}
