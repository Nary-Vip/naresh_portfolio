import 'package:flutter/widgets.dart';

/// Rebuilds with whether this widget intersects the enclosing scroll viewport.
/// Children of a SingleChildScrollView stay mounted, so tickers never pause on their own.
class OnScreenBuilder extends StatefulWidget {
  final Widget Function(BuildContext context, bool onScreen) builder;

  /// Called on the first visibility check and on every change after it.
  final ValueChanged<bool>? onChanged;

  const OnScreenBuilder({super.key, required this.builder, this.onChanged});

  @override
  State<OnScreenBuilder> createState() => _OnScreenBuilderState();
}

class _OnScreenBuilderState extends State<OnScreenBuilder> {
  ScrollableState? _scrollable;
  // Null until first measured, so onChanged also fires when already visible at load.
  bool? _onScreen;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final scrollable = Scrollable.maybeOf(context);
    if (scrollable != _scrollable) {
      _scrollable?.position.removeListener(_update);
      _scrollable = scrollable;
      _scrollable?.position.addListener(_update);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _update());
  }

  void _update() {
    final scrollable = _scrollable;
    if (!mounted || scrollable == null) return;
    final box = context.findRenderObject() as RenderBox?;
    final viewport = scrollable.context.findRenderObject() as RenderBox?;
    if (box == null || viewport == null) return;
    if (!box.hasSize || !box.attached || !viewport.attached) return;

    final top = box.localToGlobal(Offset.zero, ancestor: viewport).dy;
    final visible = top < scrollable.position.viewportDimension &&
        top + box.size.height > 0;
    if (visible == _onScreen) return;
    setState(() => _onScreen = visible);
    widget.onChanged?.call(visible);
  }

  @override
  void dispose() {
    _scrollable?.position.removeListener(_update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, _onScreen ?? true);
}
