import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppSvgIcon extends StatelessWidget {
  const AppSvgIcon({
    required this.assetPath,
    this.width,
    this.height,
    super.key,
  });

  final String assetPath;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      colorFilter: ColorFilter.mode(
        Theme.of(context).colorScheme.primary,
        BlendMode.srcIn,
      ),
    );
  }
}
