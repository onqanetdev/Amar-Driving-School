import 'package:flutter/material.dart';

import 'app_color.dart';
import 'convert_color.dart';

class CustomToast extends StatelessWidget {
  final String message;

  const CustomToast({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: HexColor("${AppColor.colorInputBorder}"),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        message,
        style: TextStyle(
            fontFamily: 'OpenSauceBold',fontSize: 14,fontWeight: FontWeight.w300,color: HexColor("${AppColor.colorWhite}")
        ),
      ),
    );
  }

  void showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context)!;
    OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        //bottom: 100,
        //left: MediaQuery.of(context).size.width / 4,
        top: MediaQuery.of(context).size.height -90,
        bottom: 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Center(child: CustomToast(message: message)),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}