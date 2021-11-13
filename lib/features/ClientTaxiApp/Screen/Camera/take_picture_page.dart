import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePicturePage extends StatefulWidget {
  final List<CameraDescription> cameras;
  TakePicturePage({@required this.cameras});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  CameraController _cameraController;
  Future<void> _initializeCameraControllerFuture;
  bool loading = true;
  bool switching = false;
  
  @override
  void initState() {
    super.initState();
    _cameraController =
        CameraController(widget.cameras.first, ResolutionPreset.high);

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

  void _toggleCameraLens() async {
    setState(() {
      switching = true;
    });
    // get current lens direction (front / rear)
    final lensDirection =  _cameraController.description.lensDirection;
    CameraDescription newDescription;
    if(lensDirection == CameraLensDirection.front){
      newDescription = widget.cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.back);
    }else{
      newDescription = widget.cameras.firstWhere((description) => description.lensDirection == CameraLensDirection.front);
    }
    if(newDescription != null){
      _cameraController = CameraController(newDescription, ResolutionPreset.medium);
      _initializeCameraControllerFuture = _cameraController.initialize();
    }
    else{
      print('Asked camera not available');
    }
    setState(() {
      switching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            loading = false;
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 40,
              height: 40,
              margin: EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                heroTag: 'btn2',
                backgroundColor: Colors.white,
                onPressed: (){
                  if(!switching){
                    _toggleCameraLens();
                  }
                },
                child: Icon(Icons.switch_camera_outlined),
              ),
            ),
            FloatingActionButton(
              backgroundColor: Colors.white,
              heroTag: 'btn1',
              onPressed: (){
                if(loading) return; 
                _takePicture(context);
              },
              child: Icon(Icons.camera),
            ),
          ],
        ),
      ),

      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: Icon(Icons.camera),
        onPressed: () {
          if(loading) return; 
          _takePicture(context);
        },
      ) */
    );
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }
}
