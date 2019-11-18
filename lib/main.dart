import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:flutter_camera/camera_window.dart';
import 'package:flutter_camera/gallery_preview.dart';
import 'package:flutter_camera/settings.dart';
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
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
  CameraController controller;
  int _selectedCamera = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() {
    controller =
        CameraController(cameras[_selectedCamera], ResolutionPreset.high);
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

  _switchCamera() {
    if (_selectedCamera + 1 >= cameras.length) {
      setState(() {
        _selectedCamera = 0;
        controller?.dispose()?.then((_) {
          _initCamera();
        });
      });
    } else {
      setState(() {
        _selectedCamera = _selectedCamera + 1;
        controller?.dispose()?.then((_) {
          _initCamera();
        });
      });
    }
  }

  _buildTopButtons() {
    return Text('buttons');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage(cameras)),
              );
            },
          ),
          onPressed: () => {},
        ),
        title: Text('Flutter Camera Demo'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            child: _buildTopButtons(),
            color: Colors.black,
            alignment: Alignment.center,
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Center(
              child: CameraWindow(controller),
            ),
          ),
          Container(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SwitchCameraButton(_switchCamera),
                SnapButton(controller),
                GalleryButton()
              ],
            ),
            color: Colors.black,
          )
        ],
      ),
    );
  }
}
