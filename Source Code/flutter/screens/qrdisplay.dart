import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRdisplay extends StatelessWidget {
  String data;
  String name;
  QRdisplay({required this.data, required this.name});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            QrImage(
              data: data,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 15),
            Text(name),
          ],
        ),
      ),
    );
  }
}
