import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vitals_sdk_example/common/widgets/popup_menu/popup_button_widget.dart';

const double _kMenuHorizontalPadding = 5.0;
const double _kMenuVerticalPadding = 8.0;
const double _kMenuDividerHeight = 16.0;

typedef PopupMenuItemBuilder<T> = List<PopupMenuItem<T>> Function(BuildContext context);

class PopupMenuButton<T> extends StatelessWidget {
  final PopupMenuItemBuilder<T> itemBuilder;
  final T? initialValue;
  final PopupMenuItemSelected<T> onSelected;
  final double? elevation;
  final EdgeInsetsGeometry padding;

  // ignore: avoid_positional_boolean_parameters
  final Widget Function(bool) buttonBuilder;
  final Offset offset;
  final ShapeBorder? shape;
  final Color? color;
  final double? maxHeight;
  final bool fitButtonWidth;
  final PositionToShow positionToShow;

  const PopupMenuButton({
    required this.itemBuilder,
    required this.buttonBuilder,
    required this.onSelected,
    this.initialValue,
    this.elevation,
    this.padding = const EdgeInsets.all(8.0),
    this.offset = Offset.zero,
    this.shape,
    this.color,
    this.maxHeight,
    this.fitButtonWidth = false,
    this.positionToShow = PositionToShow.down,
    super.key,
  });

  @override
  Widget build(BuildContext context) => PopupButton(
        shape: shape,
        offset: offset,
        fitButtonWidth: fitButtonWidth,
        buttonBuilder: buttonBuilder,
        popup: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? double.infinity,
          ),
          child: _Menu<T>(
            initialValue: initialValue,
            onSelected: onSelected,
            children: itemBuilder(context),
          ),
        ),
        color: color,
        positionToShow: positionToShow,
      );
}

class _Menu<T> extends StatefulWidget {
  final List<PopupMenuItem<T>> children;
  final T? initialValue;
  final double? maxHeight;
  final PopupMenuItemSelected<T> onSelected;

  const _Menu({
    required this.onSelected,
    required this.children,
    this.initialValue,
    this.maxHeight,
    super.key,
  });

  @override
  State<_Menu<T>> createState() => _MenuState<T>();
}

class _MenuState<T> extends State<_Menu<T>> {
  final _scrollController = ScrollController();
  late final itemSizes = List<Size?>.filled(widget.children.length, null);
  int selectedIndex = 0;

  @override
  void initState() {
    if (widget.initialValue != null) {
      for (var index = 0; index < widget.children.length; index += 1) {
        if (widget.children[index].represents(widget.initialValue)) {
          selectedIndex = index;
        }
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.jumpTo(selectedIndex * (itemSizes.isNotEmpty ? itemSizes.first?.height ?? 0 : 0));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];

    for (var i = 0; i < widget.children.length; i += 1) {
      final item = widget.children[i];

      children.add(
        _MenuItem(
          onLayout: (size) => itemSizes[i] = size,
          child: InkWell(
            onTap: () {
              widget.onSelected(item.value as T);
              Navigator.pop<T>(context);
            },
            child: item,
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: _kMenuVerticalPadding,
        horizontal: _kMenuHorizontalPadding,
      ),
      child: IntrinsicWidth(
        child: Scrollbar(
          controller: _scrollController,
          radius: const Radius.circular(20),
          thickness: 4,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: ListBody(
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

abstract class PopupMenuEntry<T> extends StatefulWidget {
  double get height;

  const PopupMenuEntry({super.key});

  bool represents(T? value);
}

class PopupMenuDivider extends PopupMenuEntry<Never> {
  @override
  final double height;

  const PopupMenuDivider({super.key, this.height = _kMenuDividerHeight});

  @override
  bool represents(void value) => false;

  @override
  State<PopupMenuDivider> createState() => _PopupMenuDividerState();
}

class _PopupMenuDividerState extends State<PopupMenuDivider> {
  @override
  Widget build(BuildContext context) => Divider(height: widget.height);
}

class _MenuItem extends SingleChildRenderObjectWidget {
  const _MenuItem({
    required this.onLayout,
    required super.child,
    //ignore: unused_element_parameter
    super.key,
  });

  final ValueChanged<Size> onLayout;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMenuItem(onLayout);

  @override
  void updateRenderObject(BuildContext context, covariant _RenderMenuItem renderObject) {
    renderObject.onLayout = onLayout;
  }
}

class _RenderMenuItem extends RenderShiftedBox {
  ValueChanged<Size> onLayout;

  _RenderMenuItem(this.onLayout, [RenderBox? child]) : super(child);

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (child == null) {
      return Size.zero;
    }
    return child!.getDryLayout(constraints);
  }

  @override
  void performLayout() {
    if (child == null) {
      size = Size.zero;
    } else {
      child!.layout(constraints, parentUsesSize: true);
      size = constraints.constrain(child!.size);
      (child!.parentData! as BoxParentData).offset = Offset.zero;
    }
    onLayout(size);
  }
}

class PopupMenuItem<T> extends PopupMenuEntry<T> {
  final T? value;
  final bool enabled;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final MouseCursor? mouseCursor;
  final Widget? child;
  @override
  final double height;

  const PopupMenuItem({
    required this.child,
    this.value,
    this.enabled = true,
    this.height = kMinInteractiveDimension,
    this.padding,
    this.textStyle,
    this.mouseCursor,
    super.key,
  });

  @override
  bool represents(T? value) => value == this.value;

  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() => PopupMenuItemState<T, PopupMenuItem<T>>();
}

class PopupMenuItemState<T, W extends PopupMenuItem<T>> extends State<W> {
  @protected
  Widget? buildChild() => widget.child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final popupMenuTheme = PopupMenuTheme.of(context);
    var style = widget.textStyle ?? popupMenuTheme.textStyle ?? theme.textTheme.titleMedium!;

    if (!widget.enabled) {
      style = style.copyWith(color: theme.disabledColor);
    }

    Widget item = AnimatedDefaultTextStyle(
      style: style,
      duration: kThemeChangeDuration,
      child: Container(
        alignment: AlignmentDirectional.centerStart,
        constraints: BoxConstraints(minHeight: widget.height),
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: _kMenuHorizontalPadding),
        child: buildChild(),
      ),
    );

    if (!widget.enabled) {
      final isDark = theme.brightness == Brightness.dark;
      item = IconTheme.merge(
        data: IconThemeData(opacity: isDark ? 0.5 : 0.38),
        child: item,
      );
    }

    return MergeSemantics(
      child: Semantics(
        enabled: widget.enabled,
        button: true,
        child: item,
      ),
    );
  }
}

class CheckedPopupMenuItem<T> extends PopupMenuItem<T> {
  final bool checked;

  const CheckedPopupMenuItem({
    super.value,
    this.checked = false,
    super.enabled,
    super.padding,
    super.height,
    super.child,
    super.key,
  });

  @override
  PopupMenuItemState<T, CheckedPopupMenuItem<T>> createState() => _CheckedPopupMenuItemState<T>();
}

class _CheckedPopupMenuItemState<T> extends PopupMenuItemState<T, CheckedPopupMenuItem<T>>
    with SingleTickerProviderStateMixin {
  static const Duration _fadeDuration = Duration(milliseconds: 150);
  late AnimationController _controller;

  Animation<double> get _opacity => _controller.view;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _fadeDuration, vsync: this)..value = widget.checked ? 1.0 : 0.0;
  }

  @override
  Widget buildChild() => ListTile(
        enabled: widget.enabled,
        leading: FadeTransition(
          opacity: _opacity,
          child: Icon(_controller.isDismissed ? null : Icons.done),
        ),
        title: widget.child,
      );
}
