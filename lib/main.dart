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
import 'package:carousel_slider/carousel_slider.dart';

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

enum Mode { photo, video }
const availableQualities = [
  'low',
  'medium',
  'high',
  'very high',
  'ultra high',
  'max'
];
const qualityMap = {
  'low': ResolutionPreset.low,
  'medium': ResolutionPreset.medium,
  'high': ResolutionPreset.high,
  'very high': ResolutionPreset.veryHigh,
  'ultra high': ResolutionPreset.ultraHigh,
  'max': ResolutionPreset.max
};

const qualityDescriptionMap = {
  'low': '352x288 on iOS, 240p (320x240) on Android',
  'medium': '480p (640x480 on iOS, 720x480 on Android)',
  'high': '720p (1280x720)',
  'very high': '1080p (1920x1080)',
  'ultra high': '2160p (3840x2160)',
  'max': 'The highest resolution available on the device.'
};

class _MyHomePageState extends State<MyHomePage> {
  CameraController controller;
  int _selectedCamera = 0;
  Mode _mode = Mode.photo;
  String _selectedQuality = 'medium';

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  _initCamera() {
    controller = CameraController(
        cameras[_selectedCamera], qualityMap[_selectedQuality]);
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
    return CarouselSlider(
      height: 70,
      initialPage: 1,
      enableInfiniteScroll: false,
      viewportFraction: 0.3,
      onPageChanged: (index) {
        setState(() {
          _selectedQuality = availableQualities[index];
          controller?.dispose()?.then((_) {
            _initCamera();
          });
        });
      },
      items: availableQualities.map((i) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              alignment: Alignment(0.0, 0.0),
              child: Text(
                i,
                style: TextStyle(fontSize: 16.0),
              ),
            );
          },
        );
      }).toList(),
    );
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
            height: 110,
            child: Column(
              children: [
                Text('Quality'),
                Text(
                  qualityDescriptionMap[_selectedQuality],
                  style: TextStyle(fontSize: 11.0),
                ),
                _buildTopButtons(),
              ],
            ),
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
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _mode = Mode.photo;
                    });
                  },
                  color: _mode == Mode.photo ? Colors.orange : Colors.black,
                  child: Text('Photo'),
                ),
                FlatButton(
                  onPressed: () {
                    setState(() {
                      _mode = Mode.video;
                    });
                  },
                  color: _mode == Mode.video ? Colors.orange : Colors.black,
                  child: Text('Video'),
                ),
              ],
            ),
            color: Colors.black,
          ),
          Container(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SwitchCameraButton(_switchCamera),
                SnapButton(controller, _mode),
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
