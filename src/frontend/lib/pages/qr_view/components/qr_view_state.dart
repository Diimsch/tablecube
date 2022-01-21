import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/api.dart';
import 'package:frontend/bottom_nav_bar/account_bubble.dart';
import 'package:frontend/common_components/text_field_container.dart';
import 'package:frontend/constants.dart';
import 'package:frontend/pages/qr_view/components/qr_information.dart';
import 'package:frontend/utils.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../qr_view_screen.dart';

class QrViewState extends State<QrViewScreen> {
  QrInformation? information;
  QRViewController? controller;
  bool requestLoading = false;
  late OverviewArguments args;
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
    args = getOverviewArguments(context);

    return Scaffold(
      appBar: getAppBar("Scan table Code"),
      body: Column(
        children: <Widget>[
          Expanded(flex: 5, child: qrViewFrame(context)),
          Expanded(
            child: TextFieldContainer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
    debugPrint('hello');
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      // only allow qr code and do not execute request multiple times

      if (!requestLoading && scanData.format == BarcodeFormat.qrcode) {
        requestLoading = true;
        if (scanData.code == null) {
          showErrorMessage("QR-Code has no content.");
          sleep(const Duration(seconds: 2));
          requestLoading = false;
          return;
        } else {
          setState(() {
            information = QrInformation.fromJson(jsonDecode(scanData.code!));
          });

          if (information!.tableId.isEmpty) {
            showErrorMessage("QR-Code is not corrrect.");
            sleep(const Duration(seconds: 2));
            requestLoading = false;
            return;
          } else {
            //TODO: check if booked an then join instead
            createBooking(args.restaurantId, information!.tableId);
            Navigator.pushNamed(context, '/color',
                arguments: OverviewArguments(
                    args.restaurantId, information!.tableId, 'null'));
          }
        }
      }
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
