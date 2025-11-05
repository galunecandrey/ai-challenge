import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vitals_arch/src/view_model.dart';

abstract class BaseBindableWidget<VM extends ViewModel> extends Widget {
  const BaseBindableWidget({required super.key});

  VM getViewModel(BuildContext context);
}

abstract class BindableWidget<VM extends ViewModel> extends StatelessWidget implements BaseBindableWidget<VM> {
  const BindableWidget({required super.key});

  @override
  VM getViewModel(BuildContext context) => context.read<VM>();
}

abstract class StatefulBindableWidget<VM extends ViewModel> extends StatefulWidget implements BaseBindableWidget<VM> {
  const StatefulBindableWidget({required super.key});

  @override
  VM getViewModel(BuildContext context) => context.read<VM>();
}
