import 'package:flutter/widgets.dart';
import 'package:vitals_sdk_example/theme/colors.dart' show AppColors;

const kDotsAnimationDuration = Duration(milliseconds: 1200);

class WaitingCallLabel extends StatefulWidget {
  final double dotSize;
  final TextStyle? textStyle;
  final Color? color;

  const WaitingCallLabel({
    super.key,
    this.dotSize = 4.0,
    this.textStyle,
    this.color,
  });

  @override
  State<StatefulWidget> createState() => _WaitingCallLabelState();
}

class _WaitingCallLabelState extends State<WaitingCallLabel> with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: kDotsAnimationDuration);
    _animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
        parent: _animationController,
      ),
    )..addListener(() {
        setState(() {});
      });
    _animationController.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (var i = 0; i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: JumpingDot(
                height: 4 + _getCoefficient(_animation.value, i),
                dotSize: widget.dotSize,
                color: widget.color,
              ),
            ),
        ],
      );

  double _getCoefficient(double value, int index) {
    if (index == 0) {
      if (value < 0.3) {
        return value * 10;
      } else if (value >= 0.3 && value < 0.6) {
        final height = 0.6 - value;
        return (height.isNegative ? 0 : height) * 10;
      } else {
        return 0;
      }
    } else if (index == 1) {
      if (value < 0.3) {
        return 0;
      } else if (value > 0.3 && value < 0.6) {
        return (value - 0.3) * 10;
      } else {
        final height = 0.6 - (value - 0.3);
        return (height.isNegative ? 0 : height) * 10;
      }
    } else if (index == 2) {
      if (value < 0.3) {
        return 0;
      } else if (value > 0.3 && value < 0.6) {
        return 0;
      } else if (value >= 0.6 && value < 0.8) {
        return (value - 0.6) * 10;
      } else {
        final height = 0.6 - (value - 0.4);
        return (height.isNegative ? 0 : height) * 10;
      }
    }

    return 0;
  }
}

class JumpingDot extends StatelessWidget {
  final double dotSize;
  final double height;
  final Color? color;

  const JumpingDot({
    required this.height,
    this.dotSize = 4.0,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Container(
          height: height,
          width: dotSize,
          decoration: BoxDecoration(
            color: color ?? AppColors.visionableDarkBlue,
            shape: BoxShape.circle,
          ),
        ),
      );
}
