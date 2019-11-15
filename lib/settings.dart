import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:device_info/device_info.dart';

class SettingsPage extends StatefulWidget {
  final List<CameraDescription> cameras;

  SettingsPage(this.cameras);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo _androidInfo;
  // TODO: add iOS info

  initState() {
    super.initState();
    _getDeviceInfo();
  }

  _buildHeading(text) {
    return Container(
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.cyan,
            width: 1.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(bottom: 5, top: 15),
      margin: EdgeInsets.only(bottom: 8),
    );
  }

  _getDeviceInfo() async {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    setState(() {
      _androidInfo = androidInfo;
    });
  }

  _buildAboutPhone() {
    return Table(
      children: [
        TableRow(
          children: [
            Text('Device model'),
            Text(_androidInfo?.product ?? 'loading..')
          ],
        ),
        TableRow(
          children: [
            Text('Android version'),
            Text(_androidInfo?.version?.release ?? 'loading..')
          ],
        ),
      ],
    );
  }

  _buildCameraSpecs(index) {
    return Table(
      children: [
        TableRow(
          children: [
            Text('Sensor orientation'),
            Text(widget.cameras[index].sensorOrientation.toString())
          ],
        ),
        TableRow(children: [
          Text('Lens direction'),
          Text(widget.cameras[index].lensDirection.toString().split('.').last)
        ])
      ],
    );
  }

  List<Widget> _buildCameras() {
    return widget.cameras
        .asMap()
        .keys
        .map<List<Widget>>((index) {
          return [_buildHeading('Camera ${index+1}'), _buildCameraSpecs(index)];
        })
        .expand((i) => i) // flatten the list
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildHeading('About phone'),
            _buildAboutPhone(),
            ..._buildCameras()
          ],
        ),
      ),
    );
  }
}
