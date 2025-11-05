// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i3;
import 'package:vitals_sdk_example/features/home/messages_room_screen.dart'
    as _i1;
import 'package:vitals_sdk_example/features/splash/splash_screen.dart' as _i2;

abstract class $VitalsRouter extends _i3.RootStackRouter {
  $VitalsRouter({super.navigatorKey});

  @override
  final Map<String, _i3.PageFactory> pagesMap = {
    MessagesRoomScreenRoute.name: (routeData) {
      return _i3.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.MessagesRoomScreen(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return _i3.AutoRoutePage<void>(
        routeData: routeData,
        child: const _i2.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.MessagesRoomScreen]
class MessagesRoomScreenRoute extends _i3.PageRouteInfo<void> {
  const MessagesRoomScreenRoute({List<_i3.PageRouteInfo>? children})
      : super(
          MessagesRoomScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'MessagesRoomScreenRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}

/// generated route for
/// [_i2.SplashScreen]
class SplashScreenRoute extends _i3.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i3.PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const _i3.PageInfo<void> page = _i3.PageInfo<void>(name);
}
