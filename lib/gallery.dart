import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  String _galleryPath;
  String _selectedImage;

  @override
  void initState() {
    super.initState();
    _initGalleryPath();
  }

  _initGalleryPath() async {
    final path = (await getTemporaryDirectory()).path;
    setState(() {
      _galleryPath = path;
    });
  }

  List<String> _getFiles(dir) {
    Directory galleryDir = Directory(dir);
    return galleryDir.listSync().map((entity) => entity.path).toList();
  }

  Widget _buildImageCard(path) {
    return InkWell(
      onTap: () {
        print('selected $path');
        setState(() {
          _selectedImage = path;
        });
      },
      child: Container(
        child: Column(children: [
          Expanded(child: Image.file(File(path))),
          Text(path.split('/').last)
        ]),
        decoration: BoxDecoration(border: Border.all(color: Colors.cyan)),
        padding: EdgeInsets.all(10),
      ),
    );
  }

  _buildGrid() {
    final imgPaths = _getFiles(_galleryPath);
    final imgCount = imgPaths.length;
    return GridView.count(
      // Create a grid with 2 columns. If you change the scrollDirection to
      // horizontal, this produces 2 rows.
      crossAxisCount: 2,
      // Generate 100 widgets that display their index in the List.
      children: List.generate(imgCount, (index) {
        return Center(child: _buildImageCard(imgPaths[index]));
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Column(
        children: [
          Text('Gallery path is'),
          Text(_galleryPath),
          Expanded(child: _buildGrid()),
        ],
      ),
    );
  }
}
