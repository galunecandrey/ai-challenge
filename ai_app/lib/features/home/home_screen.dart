import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:vitals_arch/vitals_arch.dart' show BindableWidget, Binder;
import 'package:vitals_core/vitals_core.dart';
import 'package:vitals_sdk_example/features/chat/chat_room_screen.dart';
import 'package:vitals_sdk_example/features/home/vm/home_viewmodel.dart' show HomeViewModel;

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
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Day 13',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: const TabBar(
              tabs: [
                //for (final model in _kHuggingFaceModels)
                Tab(
                  text: 'Day 14. Orchestration',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              //for (final model in _kHuggingFaceModels)
              ChatRoomScreen(
                options: AISession(
                  key: 'key_2025_11_24_03_57',
                  name: 'Assistant',
                  model: 'gpt-5-mini',
                ),
                type: AIAgentTypes.deff,
              ),
            ],
          ),
        ),
      );
}
