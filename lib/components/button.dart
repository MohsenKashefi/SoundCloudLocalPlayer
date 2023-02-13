import 'package:flutter/material.dart';

class button extends StatelessWidget {
  Widget? icon;
  Function()? pressing;

  button({
    this.icon,
    this.pressing,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      width: 70,
      height: 70,
      child: Center(
        child: IconButton(
          color: Colors.white,
          onPressed: pressing!,
          icon: icon!,
        ),
      ),
      decoration: BoxDecoration(color: Colors.black, shape: BoxShape.circle),
    ));
  }
}
