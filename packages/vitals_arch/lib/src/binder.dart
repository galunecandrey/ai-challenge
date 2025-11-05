import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals_arch/src/bindable_widget.dart';
import 'package:vitals_arch/src/preloader_widget.dart';
import 'package:vitals_arch/src/view_model.dart';
import 'package:vitals_arch/src/vitals_di.dart';

abstract class Binder<VM extends ViewModel> extends StatelessWidget {
  const Binder({
    required super.key,
    this.instanceName,
    this.param1,
    this.param2,
    this.lazy,
    this.preLoader,
    this.enablePreLoader = true,
  }) : _vm = null;

  const Binder.vm({
    required super.key,
    required VM vm,
    this.preLoader,
    this.enablePreLoader = true,
  })  : _vm = vm,
        instanceName = null,
        param1 = null,
        param2 = null,
        lazy = null;

  final String? instanceName;
  final dynamic param1;
  final dynamic param2;
  final bool? lazy;
  final VM? _vm;
  final Widget? preLoader;
  final bool enablePreLoader;

  @override
  Widget build(BuildContext context) => _vm != null
      ? Provider<VM>.value(
          value: _vm,
          child: enablePreLoader
              ? Preloader<VM>(customPreLoader: preLoader, child: buildWidget(context))
              : buildWidget(context),
        )
      : Provider<VM>(
          create: (_) => getIt<VM>(
            instanceName: instanceName,
            param1: param1,
            param2: param2,
          ),
          dispose: (context, value) => value.dispose(),
          lazy: lazy,
          child: enablePreLoader
              ? Preloader<VM>(customPreLoader: preLoader, child: buildWidget(context))
              : buildWidget(context),
        );

  BaseBindableWidget<VM> buildWidget(BuildContext context);
}
