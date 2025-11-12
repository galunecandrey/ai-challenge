import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart' show BindableWidget, Binder;
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/features/chat/chat_room_screen.dart';
import 'package:vitals_sdk_example/features/home/vm/home_viewmodel.dart' show HomeViewModel;

const _kHuggingFaceModels = <AIAgentsOptions>[
  AIAgentsOptions.sao10K,
  AIAgentsOptions.miniMaxAI,
  AIAgentsOptions.qwen,
];

@RoutePage()
class HomeScreen extends Binder<HomeViewModel> {
  const HomeScreen({
    super.key,
  }) : super();

  @override
  BindableWidget<HomeViewModel> buildWidget(BuildContext context) => const _HomeWidget();
}

class _HomeWidget extends BindableWidget<HomeViewModel> {
  const _HomeWidget({
    //ignore: unused_element
    super.key,
  });

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: _kHuggingFaceModels.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Day 4. Different Reasoning Methods',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: TabBar(
              tabs: [
                for (final model in _kHuggingFaceModels)
                  Tab(
                    text: model.name,
                  ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              for (final model in _kHuggingFaceModels)
                ChatRoomScreen(
                  options: AIAgentOptions(
                    key: model.options.key,
                    name: model.options.name,
                    model: model.options.model,
                  ),
                  type: model.type,
                ),
            ],
          ),
        ),
      );
}
