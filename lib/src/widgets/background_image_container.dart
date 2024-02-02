import 'package:flutter/material.dart';

class BackgroundImageContainer extends StatelessWidget {
  final Widget child;
  final String src;

  const BackgroundImageContainer(
      {super.key, required this.child, required this.src});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image:
              DecorationImage(image: AssetImage(src), fit: BoxFit.fitHeight)),
      child: child,
    );
  }
}
