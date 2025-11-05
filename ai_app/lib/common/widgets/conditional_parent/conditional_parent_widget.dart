import 'package:flutter/material.dart';

class ConditionalParent extends StatelessWidget {
  final Widget child;
  final bool condition;
  final Widget Function(Widget child) parentBuilder;
  final Widget Function(Widget child)? elseBuilder;

  const ConditionalParent({
    required this.condition,
    required this.child,
    required this.parentBuilder,
    this.elseBuilder,
    super.key,
  });

  @override
  Widget build(BuildContext context) => condition ? parentBuilder(child) : elseBuilder?.call(child) ?? child;
}
