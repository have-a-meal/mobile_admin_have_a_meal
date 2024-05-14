import 'dart:io';

import 'package:admin_have_a_meal/features/account/sign_in_screen.dart';
import 'package:admin_have_a_meal/widget_tools/swag_platform_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class TicketQrAuthScreen extends StatefulWidget {
  static const routeName = "ticketQrAuth";
  static const routeURL = "/ticketQrAuth";
  const TicketQrAuthScreen({super.key});

  @override
  State<TicketQrAuthScreen> createState() => _TicketQrAuthScreenState();
}

class _TicketQrAuthScreenState extends State<TicketQrAuthScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? _qrViewController;
  bool _isAuthStart = false;
  bool _isLoading = false;

  @override
  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await _qrViewController?.pauseCamera();
    } else if (Platform.isIOS) {
      await _qrViewController?.resumeCamera();
    }
  }

  @override
  void dispose() {
    _qrViewController?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(BuildContext context, QRViewController controller) {
    _qrViewController = controller;
    controller.scannedDataStream.listen((scanData) async {
      await _qrViewController?.pauseCamera();

      if (context.mounted) {
        await _onQRAuth(context);
      }

      setState(() {
        result = scanData;
      });
    });
  }

  Future<void> _onQRAuth(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    if (context.mounted) {
      await swagPlatformDialog(
        context: context,
        title: "인증",
        message: "식권 인증이 완료 되었습니다!",
        actions: [
          ElevatedButton(
            onPressed: () async {
              await _qrViewController?.resumeCamera();
              setState(() {
                _isLoading = false;
              });
              if (context.mounted) {
                context.pop();
              }
            },
            child: const Text("확인"),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text("식권 인증"),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  context.goNamed(SignInScreen.routeName);
                },
              )
            ],
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: (p0) => _onQRViewCreated(context, p0),
                    ),
                    if (!_isAuthStart)
                      Stack(
                        children: [
                          Container(
                            color: Colors.black,
                          ),
                          const Center(
                            child: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                              size: 100,
                            ),
                          ),
                        ],
                      ),
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: ElevatedButton.icon(
                    onPressed: _isAuthStart
                        ? () async {
                            if (_qrViewController != null) {
                              await _qrViewController!
                                  .pauseCamera(); // null이 아님을 확신할 수 있으므로 ! 사용
                              _isAuthStart = false;
                              if (mounted) {
                                // 현재 위젯이 위젯 트리에 존재하는지 확인
                                setState(() {});
                              }
                            }
                          }
                        : () async {
                            if (_qrViewController != null) {
                              await _qrViewController!
                                  .resumeCamera(); // null이 아님을 확신할 수 있으므로 ! 사용
                              _isAuthStart = true;
                              if (mounted) {
                                // 현재 위젯이 위젯 트리에 존재하는지 확인
                                setState(() {});
                              }
                            }
                          },
                    icon: Icon(_isAuthStart ? Icons.stop : Icons.play_arrow),
                    label: _isAuthStart
                        ? const Text("인증 중지")
                        : const Text("인증 시작"),
                    style: const ButtonStyle(
                      padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 40,
                        ),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        if (_isLoading)
          ModalBarrier(
            onDismiss: () async {
              await _qrViewController?.resumeCamera();
              setState(() {
                _isLoading = false;
              });
            },
          )
      ],
    );
  }
}
