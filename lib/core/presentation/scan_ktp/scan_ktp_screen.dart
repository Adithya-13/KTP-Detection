import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ktp_detection/constants/colors.dart';

class CustomCamera extends StatefulWidget {
  const CustomCamera({super.key});

  @override
  State<CustomCamera> createState() => _CustomCameraState();
}

class _CustomCameraState extends State<CustomCamera> {
  late List<CameraDescription> _cameras;

  CameraController? controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await initializeCamera();
    });
  }

  Future<void> initializeCamera() async {
    _cameras = await availableCameras();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !(controller?.value.isInitialized ?? false)) {
      return Container();
    }
    return Scaffold(
      body: Stack(
        children: [
          CameraPreview(
            controller!,
            child: Center(
              child: _FocusRectangle(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.045),
                child: Text(
                  "Place your ID Card within the box",
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.04,
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () async {
                final xFile = await controller!.takePicture();

                Navigator.pop(context, File(xFile.path));
              },
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: appColorAccent1Pink,
                ),
                height: 72,
                width: 72,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FocusRectangle extends StatelessWidget {
  final Color color;

  const _FocusRectangle({
    Key? key,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AspectRatio(
          aspectRatio: 720 / 1280,
          child: Column(
            children: [
              Flexible(
                flex: 8,
                child: Container(),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: AspectRatio(
                  aspectRatio: (1.56 / 1),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
              ),
              Flexible(
                flex: 8,
                child: Container(),
              )
            ],
          ),
        )
      ],
    );
  }
}
