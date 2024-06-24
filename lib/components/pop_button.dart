import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PopButton extends StatelessWidget {
  final Widget? child;
  final void Function()? onTap;
  const PopButton({
    super.key,
    this.child,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(55),
      ),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {
          HapticFeedback.heavyImpact();
          onTap ?? Navigator.of(context).pop();
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(
            color: Colors.black.withOpacity(.50),
            child: Center(child: child ?? const Icon(Icons.chevron_left, color: Colors.white, size: 40)),
          ),
        ),
      ),
    );
  }
}
