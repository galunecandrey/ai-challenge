import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:vitals_arch/src/view_model.dart';

class Preloader<VM extends ViewModel> extends StatelessWidget {
  const Preloader({
    required this.child,
    this.customPreLoader,
    super.key,
  });

  final Widget child;
  final Widget? customPreLoader;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          child,
          StreamBuilder<PreloaderState>(
            initialData: context.read<VM>().state,
            stream: context.read<VM>().stateStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.requireData == PreloaderState.loading) {
                return customPreLoader ??
                    Container(
                      color: const Color(0x61000000),
                      alignment: Alignment.center,
                      child: const CupertinoActivityIndicator(
                        radius: 30,
                      ),
                    );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ],
      );
}
