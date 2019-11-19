import 'package:flutter/material.dart';
import 'package:flutter_camera/gallery.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class GalleryButton extends StatelessWidget {
  Future<String> _getPreviewImage() async {
    final path = (await getTemporaryDirectory()).path;
    Directory galleryDir = Directory(path);
    final List<String> files = galleryDir
        .listSync()
        .where((entity) => entity.path.split('.').last == 'png')
        .map((entity) => entity.path)
        .toList();
    if (files.length == 0) {
      return 'Gallery';
    }
    return files[0];
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GalleryPage()),
            ),
        child: Container(
          child: Center(
            child: FutureBuilder(
              future: _getPreviewImage(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Text('Gallery');
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                    return Text('Gallery');
                  case ConnectionState.done:
                    if (snapshot.hasError) return Text('Gallery');
                    return Image.file(File(snapshot.data));
                }
                return Text('Gallery');
              },
            ),
          ),
          color: Colors.white70,
          height: 50,
          width: 50,
        ));
  }
}
