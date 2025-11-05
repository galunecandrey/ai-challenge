import 'dart:math';

import 'package:flutter/material.dart';

enum FitMode {
  cover, //fill frame
  fill,
  contain, //fit to frame
}

class VideoTexture extends StatelessWidget {
  final int textureId;
  final Size size;
  final FitMode fitMode;

  VideoTexture({
    required this.textureId,
    required this.size,
    required this.fitMode,
  }) : super(
          key: ValueKey(textureId),
        );

  @override
  Widget build(BuildContext context) => LayoutBuilder(
      builder: (context, constraints) => Center(
        child: constraints.maxWidth > 0 &&
                constraints.maxHeight > 0 &&
                size.width > 0 &&
                size.height > 0
            ? Transform.scale(
                scale: fitMode == FitMode.cover
                    ? _getScale(
                        width: size.width.toInt(),
                        height: size.height.toInt(),
                        maxWidth: constraints.maxWidth,
                        maxHeight: constraints.maxHeight,
                      )
                    : 1,
                child: AspectRatio(
                  aspectRatio: fitMode == FitMode.fill
                      ? constraints.maxWidth / constraints.maxHeight
                      : size.width / size.height,
                  child: Texture(
                    key: ValueKey(textureId),
                    textureId: textureId,
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );

  double _getScale({
    required int width,
    required int height,
    required double maxWidth,
    required double maxHeight,
  }) {
    final aspectRatio = width / height;
    final parentAspectRatio = maxWidth / maxHeight;
    final minSize = aspectRatio <= parentAspectRatio ? width : height;
    final maxSize = aspectRatio <= parentAspectRatio ? height : width;
    final minConstraint =
        aspectRatio <= parentAspectRatio ? maxWidth : maxHeight;
    final maxConstraint =
        aspectRatio <= parentAspectRatio ? maxHeight : maxWidth;
    final scaleOfMinSize = maxConstraint / maxSize;
    final scale = minConstraint / (minSize * scaleOfMinSize);
    return max(scale, 1);
  }
}
