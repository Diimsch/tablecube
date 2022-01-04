import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/overview/overview_screen.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../qr_view_screen.dart';

class QrViewState extends State<QrViewScreen> {
  Barcode? result;
  QRViewController? controller;
  bool requestLoading = false;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: qrViewFrame(context)),
          Expanded(
            flex: 1,
            child: TextFieldContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Text('Scan QR-rcode'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          icon: FutureBuilder(
                              future: controller?.getFlashStatus(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData && snapshot.data == true) {
                                  return const Icon(Icons.flash_on);
                                } else if (snapshot.hasData &&
                                    snapshot.data == false) {
                                  return const Icon(Icons.flash_off);
                                } else {
                                  return const Icon(Icons.photo);
                                }
                              }),
                          onPressed: () async {
                            await controller?.toggleFlash();
                            setState(() {});
                          }),
                      IconButton(
                        icon: FutureBuilder(
                            future: controller?.getCameraInfo(),
                            builder: (context, snapshot) {
                              return const Icon(
                                  Icons.flip_camera_android_rounded);
                            }),
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget qrViewFrame(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? minQrFrameSize
        : defaultQrFrameSize;

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      setState(() {
        // only allow qr code and do not execute request multiple times
        if (!requestLoading && scanData.format == BarcodeFormat.qrcode) {
          // TODO: make request to login on table nad loading icon
          requestLoading = true;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return OverviewScreen(userType: UserType.NONE);
              },
            ),
          );
        }
      });
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }
}
