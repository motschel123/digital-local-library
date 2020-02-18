/*import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScanBookScreen extends StatefulWidget {
  final CameraDescription camera;

  const ScanBookScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => ScanBookScreenState();
}

class ScanBookScreenState extends State<ScanBookScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    /*_controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    _initializeControllerFuture = _controller.initialize();*/
  }

  @override
  void dispose() {
    //_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: null/*FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),*/
    );
  }
}*/
