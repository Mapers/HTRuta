import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;
  TakePicturePage({@required this.camera});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;
  bool loading = true;

  @override
  void initState() {
    super.initState();

    _cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);

    _initializeCameraControllerFuture = _cameraController.initialize();
  }

  void _takePicture(BuildContext context) async {
    try {
      await _initializeCameraControllerFuture;
      XFile file = await _cameraController.takePicture();
      Navigator.pop(context, file.path);

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            loading = false;
            /* return Center(
              child: Transform.scale(
                scale: _cameraController.value.aspectRatio/deviceRatio,
                child: AspectRatio(
                  aspectRatio: _cameraController.value.aspectRatio,
                  child: CameraPreview(_cameraController),
                ),
              ),
            ); */
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.camera),
        onPressed: () {
          if(loading) return; 
          _takePicture(context);
        },
      )
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
