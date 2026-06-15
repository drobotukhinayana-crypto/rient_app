import 'package:flutter/material.dart';

/// Прокручивает [controller] горизонтальным свайпом поверх вертикального скролла
/// (Syncfusion calendar перехватывает жесты и не даёт родительскому скроллу двигаться).
class ScheduleDayHorizontalDragScroll extends StatefulWidget {
  const ScheduleDayHorizontalDragScroll({
    super.key,
    required this.controller,
    required this.child,
  });

  final ScrollController controller;
  final Widget child;

  @override
  State<ScheduleDayHorizontalDragScroll> createState() =>
      _ScheduleDayHorizontalDragScrollState();
}

class _ScheduleDayHorizontalDragScrollState
    extends State<ScheduleDayHorizontalDragScroll> {
  int? _pointer;
  Offset? _origin;
  bool _resolvedAxis = false;
  bool _isHorizontalDrag = false;

  static const _slop = 12.0;

  bool get _canScroll =>
      widget.controller.hasClients &&
      widget.controller.position.maxScrollExtent > 0;

  void _resetPointer() {
    if (!_resolvedAxis && !_isHorizontalDrag) {
      _pointer = null;
      _origin = null;
      return;
    }
    setState(() {
      _pointer = null;
      _origin = null;
      _resolvedAxis = false;
      _isHorizontalDrag = false;
    });
  }

  void _onPointerDown(PointerDownEvent event) {
    if (!_canScroll) return;
    _pointer = event.pointer;
    _origin = event.position;
    _resolvedAxis = false;
    _isHorizontalDrag = false;
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_pointer != event.pointer || _origin == null || !_canScroll) return;

    final totalDelta = event.position - _origin!;
    if (!_resolvedAxis) {
      if (totalDelta.distance < _slop) return;
      final horizontal = totalDelta.dx.abs() >= totalDelta.dy.abs();
      _resolvedAxis = true;
      if (!horizontal) {
        _resetPointer();
        return;
      }
      setState(() => _isHorizontalDrag = true);
    }

    if (!_isHorizontalDrag) return;

    final position = widget.controller.position;
    final next = (position.pixels - event.delta.dx).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if ((position.pixels - next).abs() > 0.01) {
      widget.controller.jumpTo(next);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: (_) => _resetPointer(),
      onPointerCancel: (_) => _resetPointer(),
      child: IgnorePointer(
        ignoring: _isHorizontalDrag,
        child: widget.child,
      ),
    );
  }
}
