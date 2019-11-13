import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera/camera_window.dart';
import 'package:flutter_camera/gallery_preview.dart';
import 'package:flutter_camera/snap_button.dart';
import 'package:flutter_camera/switch_button.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

List<CameraDescription> cameras;

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Camera Demo',
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          splashColor: Colors.orangeAccent),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.settings),
          onPressed: () => {},
        ),
        title: Text('AppBar'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            child: Text('Buttons'),
            color: Colors.black,
            alignment: Alignment.center,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Center(
              child: CameraWindow(cameras),
            ),
          ),
          Container(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [SwitchCameraButton(), SnapButton(), GalleryButton()],
            ),
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
