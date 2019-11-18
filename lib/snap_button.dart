import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class SnapButton extends StatelessWidget {
  final CameraController cameraController;

  SnapButton(this.cameraController);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () async {
        try {
          // Ensure that the camera is initialized.
          if (!cameraController.value.isInitialized) {
            print('Not initialized');
          }

          // Construct the path where the image should be saved using the path
          // package.
          final path = join(
            // Store the picture in the temp directory.
            // Find the temp directory using the `path_provider` plugin.
            (await getTemporaryDirectory()).path,
            '${DateTime.now()}.png',
          );

          // Attempt to take a picture and log where it's been saved.
          await cameraController.takePicture(path);
          print('Picture saved');
          print(path);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => GalleryPage(path)),
          // );
        } catch (e) {
          print(e);
        }
      },
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
