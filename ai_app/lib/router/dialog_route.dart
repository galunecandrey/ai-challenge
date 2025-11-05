import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class DialogScreenRoute extends CustomRoute {
  DialogScreenRoute({
    required super.page,
    super.path,
    super.initial = false,
    super.children,
  }) : super(
          barrierDismissible: true,
          opaque: false,
          barrierColor: const Color(0x4D000000),
        );
}
