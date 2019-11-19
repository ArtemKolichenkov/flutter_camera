import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:math';

class PhotoViewPage extends StatelessWidget {
  final String path;
  PhotoViewPage(this.path);

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  Future<Map<String, dynamic>> _getStats(path) async {
    File file = File(path);
    int size = file.statSync().size;
    var decodedImage = await decodeImageFromList(file.readAsBytesSync());
    Map<String, dynamic> stats = {
      'size': formatBytes(size, 2).toString(),
      'resolution': '${decodedImage.width} x ${decodedImage.height}'
    };
    return stats;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path.split('/').last),
      ),
      body: Column(children: [
        Flexible(
          flex: 3,
          child: Center(
            child: Image.file(
              File(path),
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: FutureBuilder(
            future: _getStats(path),
            initialData: {'size': 'loading...', 'resolution': 'loading...'},
            builder: (context, snapshot) {
              return Column(
                children: [
                  Text('Size: ${snapshot.data['size']}'),
                  Text('Resolution: ${snapshot.data['resolution']}')
                ],
              );
            },
          ),
        ),
      ]),
    );
  }
}
