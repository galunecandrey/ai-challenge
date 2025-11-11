import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart';
import 'package:vitals_core/vitals_core.dart';

enum PositionToShow {
  down, //default
  up,
  left, //not implemented yet
  right,
}

const Duration _kPopupDuration = Duration(milliseconds: 300);
const double _kPopupCloseIntervalEnd = 2.0 / 3.0;
const double _kPopupMinWidth = 2.0 * _kPopupWidthStep;
const double _kPopupVerticalPadding = 8.0;
const double _kPopupWidthStep = 56.0;
const double _kPopupScreenPadding = 8.0;

class PopupButton extends StatefulWidget {
  //ignore: avoid_positional_boolean_parameters
  final Widget Function(bool) buttonBuilder;
  final Widget popup;
  final EdgeInsetsGeometry? padding;
  final Offset offset;
  final ShapeBorder? shape;
  final Color? color;
  final double? elevation;
  final bool fitButtonWidth;
  final PositionToShow positionToShow;

  //ignore: avoid_positional_boolean_parameters
  final Function(bool)? onButtonClicked;

  const PopupButton({
    required this.buttonBuilder,
    required this.popup,
    this.offset = Offset.zero,
    this.shape,
    this.color,
    this.elevation,
    this.padding,
    this.fitButtonWidth = false,
    this.positionToShow = PositionToShow.down,
    this.onButtonClicked,
    super.key,
  });

  @override
  PopupButtonState createState() => PopupButtonState();
}

class PopupButtonState extends State<PopupButton> {
  bool isMenuOpened = false;
  late final StreamSubscription<Size> _subscription;

  @override
  void initState() {
    super.initState();

    _subscription = context.read<PlatformProvider>().stream((p) => p.size).distinct().listen((event) {
      if (isMenuOpened) {
        isMenuOpened = false;
        //ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void showButtonPopup() {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final button = context.findRenderObject()! as RenderBox;
    final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(widget.offset + Offset(0, button.size.height), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero) + widget.offset, ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    widget.onButtonClicked?.call(isMenuOpened);
    setState(() => isMenuOpened = true);

    showPopup(
      context: context,
      elevation: widget.elevation ?? popupMenuTheme.elevation,
      child: widget.popup,
      position: position,
      shape: widget.shape ?? popupMenuTheme.shape,
      color: widget.color ?? popupMenuTheme.color,
      width: widget.fitButtonWidth ? button.size.width : null,
      positionToShow: widget.positionToShow,
    ).then((value) => setState(() => isMenuOpened = false));
  }

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: showButtonPopup,
        child: widget.buttonBuilder(isMenuOpened),
      );
}

class _Popup extends StatelessWidget {
  const _Popup({
    required this.route,
    //ignore: unused_element_parameter
    super.key,
  });

  final _PopupRoute route;

  @override
  Widget build(BuildContext context) {
    final theme = PopupMenuTheme.of(context);

    const start = 0.4;
    final end = (start + 1.5 * start).clamp(0.0, 1.0);

    final opacity = CurveTween(curve: const Interval(0.0, 1.0 / 3.0));
    final width = CurveTween(curve: const Interval(0.0, start / 2));
    final height = CurveTween(curve: const Interval(0.0, start * 1));

    return AnimatedBuilder(
      animation: route.animation!,
      builder: (context, child) => FadeTransition(
        opacity: opacity.animate(route.animation!),
        child: Material(
          shape: route.shape ?? theme.shape,
          color: route.color ?? theme.color,
          type: MaterialType.card,
          elevation: route.elevation ?? theme.elevation ?? 8.0,
          child: Align(
            widthFactor: width.evaluate(route.animation!),
            heightFactor: height.evaluate(route.animation!),
            child: child,
          ),
        ),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: _kPopupMinWidth),
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: route.animation!,
            curve: Interval(start, end),
          ),
          child: SizedBox(
            width: route.width,
            child: route.child,
          ),
        ),
      ),
    );
  }
}

class _PopupRouteLayout extends SingleChildLayoutDelegate {
  _PopupRouteLayout(
    this.position,
    this.itemSize,
    this.textDirection,
    this.padding, {
    this.positionToShow = PositionToShow.down,
  });

  final RelativeRect position;
  final TextDirection textDirection;
  final PositionToShow positionToShow;
  EdgeInsets padding;
  Size? itemSize;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(constraints.biggest).deflate(
        const EdgeInsets.all(_kPopupScreenPadding) + padding,
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final buttonHeight = size.height - position.top - position.bottom;

    var y = position.top;
    if (itemSize != null) {
      var selectedItemOffset = _kPopupVerticalPadding;
      selectedItemOffset += itemSize!.height;
      selectedItemOffset += itemSize!.height / 2;
      y = y + buttonHeight / 2.0 - selectedItemOffset;
    }

    double x;
    if (position.left > position.right) {
      x = size.width - position.right - childSize.width;
    } else if (position.left < position.right) {
      x = position.left;
    } else {
      switch (textDirection) {
        case TextDirection.rtl:
          x = size.width - position.right - childSize.width;
          break;
        case TextDirection.ltr:
          x = position.left;
          break;
      }
    }

    if (x < _kPopupScreenPadding + padding.left) {
      x = _kPopupScreenPadding + padding.left;
    } else if (x + childSize.width > size.width - _kPopupScreenPadding - padding.right) {
      x = size.width - childSize.width - _kPopupScreenPadding - padding.right;
    }
    if (y < _kPopupScreenPadding + padding.top) {
      y = _kPopupScreenPadding + padding.top;
    } else if (y + childSize.height > size.height - _kPopupScreenPadding - padding.bottom) {
      y = size.height - padding.bottom - _kPopupScreenPadding - childSize.height;
    }

    if (positionToShow == PositionToShow.up) {
      y = size.height - padding.bottom - _kPopupScreenPadding - childSize.height - position.bottom;
    }
    if (positionToShow == PositionToShow.right) {
      x = size.width - position.right;
    }

    return Offset(x, y);
  }

  @override
  bool shouldRelayout(_PopupRouteLayout oldDelegate) =>
      position != oldDelegate.position || textDirection != oldDelegate.textDirection || padding != oldDelegate.padding;
}

class _PopupRoute extends PopupRoute<void> {
  _PopupRoute({
    required this.position,
    required this.child,
    required this.barrierLabel,
    required this.capturedThemes,
    this.elevation,
    this.shape,
    this.color,
    this.width,
    this.positionToShow = PositionToShow.down,
  }) : itemSize = null;

  final RelativeRect position;
  final Widget child;

  Size? itemSize;

  final double? elevation;
  final ShapeBorder? shape;
  final Color? color;
  final CapturedThemes capturedThemes;
  final double? width;
  final PositionToShow positionToShow;

  @override
  Animation<double> createAnimation() => CurvedAnimation(
        parent: super.createAnimation(),
        curve: Curves.linear,
        reverseCurve: const Interval(0.0, _kPopupCloseIntervalEnd),
      );

  @override
  Duration get transitionDuration => _kPopupDuration;

  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => null;

  @override
  final String barrierLabel;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    final popup = _Popup(route: this);
    final mediaQuery = MediaQuery.of(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Builder(
        builder: (context) => CustomSingleChildLayout(
          delegate: _PopupRouteLayout(
            position,
            itemSize,
            Directionality.of(context),
            mediaQuery.padding,
            positionToShow: positionToShow,
          ),
          child: capturedThemes.wrap(popup),
        ),
      ),
    );
  }
}

Future<void> showPopup({
  required BuildContext context,
  required RelativeRect position,
  required Widget child,
  double? width,
  double? elevation,
  ShapeBorder? shape,
  Color? color,
  bool useRootNavigator = false,
  PositionToShow positionToShow = PositionToShow.down,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);

  return navigator.push(
    _PopupRoute(
      position: position,
      child: child,
      elevation: elevation,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      shape: shape,
      color: color,
      capturedThemes: InheritedTheme.capture(from: context, to: navigator.context),
      width: width,
      positionToShow: positionToShow,
    ),
  );
}
