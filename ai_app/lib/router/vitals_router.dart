import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart' as flutter;
import 'package:vitals_sdk_example/common/widgets/bottom_sheet/vis_bottom_sheet_widget.dart';
import 'package:vitals_sdk_example/router/context_provider.dart';
import 'package:vitals_sdk_example/router/router.dart';
import 'package:vitals_sdk_example/theme/colors.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Screen,ScreenRoute',
)
class VitalsRouter extends $VitalsRouter {
  @override
  RouteType get defaultRouteType => const RouteType.adaptive();

  @override
  final List<AutoRoute> routes = [
    AutoRoute(
      page: SplashScreenRoute.page,
      path: '/',
    ),
    AutoRoute(
      page: MessagesRoomScreenRoute.page,
      path: '/home',
    ),
  ];
}

extension VitalsRouterX on VitalsRouter {
  flutter.BuildContext get currentContext => navigatorKey.currentContext ?? globalContext!;

  bool hasRouteInStack(String routeName) => stackData.any((e) => e.name == routeName);

  void removeIfInStackByName(String routeName) {
    if (hasRouteInStack(routeName)) {
      removeWhere((route) => route.name == routeName);
    }
  }

  Future<T?> pushSingleInStack<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    removeIfInStackByName(route.routeName);
    return push<T>(route, onFailure: onFailure);
  }

  Future<T?> replaceSingleInStack<T extends Object?>(
    PageRouteInfo route, {
    OnNavigationFailure? onFailure,
  }) {
    if (current.name == route.routeName) {
      return pushSingleInStack(route);
    }
    removeIfInStackByName(route.routeName);
    return replace<T>(route, onFailure: onFailure);
  }

  Future<T?> showDialog<T>({
    required flutter.WidgetBuilder builder,
    bool barrierDismissible = true,
    flutter.Color? barrierColor = flutter.Colors.black54,
    String? barrierLabel,
    bool useSafeArea = true,
    bool useRootNavigator = true,
    flutter.RouteSettings? routeSettings,
  }) =>
      flutter.showDialog(
        context: currentContext,
        builder: builder,
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        barrierLabel: barrierLabel,
        useSafeArea: useSafeArea,
        useRootNavigator: useRootNavigator,
        routeSettings: routeSettings,
      );

  void hideCurrentSnackBar() => flutter.ScaffoldMessenger.of(currentContext).hideCurrentSnackBar();

  flutter.ScaffoldFeatureController<flutter.SnackBar, flutter.SnackBarClosedReason> showSnackBar({
    required flutter.SnackBar snackBar,
  }) {
    final scaffoldMessenger = flutter.ScaffoldMessenger.of(currentContext)..removeCurrentSnackBar();
    return scaffoldMessenger.showSnackBar(snackBar);
  }

  flutter.PersistentBottomSheetController showBottomSheet<T>({
    required flutter.WidgetBuilder builder,
    flutter.Color? backgroundColor,
    double? elevation,
    flutter.ShapeBorder? shape,
    flutter.Clip? clipBehavior,
    flutter.BoxConstraints? constraints,
    flutter.AnimationController? transitionAnimationController,
  }) =>
      flutter.showBottomSheet(
        context: currentContext,
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        transitionAnimationController: transitionAnimationController,
      );

  Future<T?> showModalBottomSheet<T>({
    required flutter.WidgetBuilder builder,
    flutter.Color? backgroundColor,
    double? elevation,
    flutter.ShapeBorder? shape,
    flutter.Clip? clipBehavior,
    flutter.BoxConstraints? constraints,
    flutter.AnimationController? transitionAnimationController,
    bool isScrollControlled = false,
  }) =>
      flutter.showModalBottomSheet<T>(
        context: currentContext,
        builder: builder,
        backgroundColor: backgroundColor,
        elevation: elevation,
        shape: shape,
        clipBehavior: clipBehavior,
        constraints: constraints,
        transitionAnimationController: transitionAnimationController,
        isScrollControlled: isScrollControlled,
      );

  Future<T?> showVisModalBottomSheet<T>({
    required flutter.WidgetBuilder builder,
    String? headerText,
    flutter.BoxConstraints? constraints,
    flutter.AnimationController? transitionAnimationController,
    flutter.Color? backgroundColor,
    flutter.BorderRadius? shapeRadius,
    bool? shrinkWrap,
    bool enableShadedBackground = false,
  }) =>
      flutter.showModalBottomSheet<T>(
        context: currentContext,
        builder: (_) => VisBottomSheet(
          headerText: headerText,
          shrinkWrap: shrinkWrap ?? false,
          builder: builder,
          backgroundColor: backgroundColor ?? AppColors.white,
          shapeRadius: shapeRadius,
        ),
        backgroundColor: flutter.Colors.transparent,
        barrierColor: enableShadedBackground ? null : flutter.Colors.transparent,
        constraints: constraints,
        isScrollControlled: true,
        transitionAnimationController: transitionAnimationController,
      );
}
