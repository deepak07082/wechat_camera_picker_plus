// ignore_for_file: unused_field
import 'package:flutter/material.dart';

/// {@template drag_update}
/// Drag update model which includes the position and size.
/// {@endtemplate}
class DragUpdate {
  /// {@macro drag_update}
  const DragUpdate({
    required this.angle,
    required this.position,
    required this.size,
    required this.constraints,
    required this.scale,
  });

  /// The angle of the draggable asset.
  final double angle;

  /// The position of the draggable asset.
  final Offset position;

  /// The size of the draggable asset.
  final Size size;

  /// The constraints of the parent view.
  final Size constraints;

  ///
  final double scale;
}

/// {@template draggable_resizable}
/// A widget which allows a user to drag and resize the provided [child].
/// {@endtemplate}
class DraggableResizable extends StatefulWidget {
  /// {@macro draggable_resizable}
  DraggableResizable({
    Key? key,
    required this.child,
    required this.size,
    this.onTap,
    BoxConstraints? constraints,
    this.initialPosition,
    this.initialAngle,
    this.initialScale,
    this.onUpdate,
    this.onScaleUpdate,
    this.onStart,
    this.onEnd,
    this.canTransform = false,
  })  : constraints = constraints ?? BoxConstraints.loose(Size.infinite),
        super(key: key);

  /// The child which will be draggable/resizable.
  final Widget child;

  /// Drag/Resize end callback
  final ValueSetter<DraggableResizableState>? onTap;

  /// Drag/Resize start callback
  final VoidCallback? onStart;

  /// Drag/Resize value setter.
  final void Function(DragUpdate, GlobalKey)? onUpdate;

  ///
  final ValueSetter<ScaleUpdateDetails>? onScaleUpdate;

  /// Drag/Resize end callback
  final VoidCallback? onEnd;

  /// Whether or not the asset can be dragged or resized.
  /// Defaults to false.
  final bool canTransform;

  /// Initial position of widget
  final Offset? initialPosition;

  /// Initial angle of the widget
  final double? initialAngle;

  /// Initial scale of the widget
  final double? initialScale;

  /// The child's original size.
  final Size size;

  /// The child's constraints.
  /// Defaults to [BoxConstraints.loose(Size.infinite)].
  final BoxConstraints constraints;

  @override
  State<DraggableResizable> createState() => DraggableResizableState();
}

///
class DraggableResizableState extends State<DraggableResizable>
    with SingleTickerProviderStateMixin {
  late Size _size;
  late BoxConstraints _constraints;
  late double _angle;
  late double _scale;
  late double _angleDelta;
  late double _baseAngle;
  double? _aspectRatio;
  // bool get _isTouchInputSupported => true;
  late Offset _position;
  final GlobalKey<State<StatefulWidget>> _key = GlobalKey();
  double _centerDX = 0.0;
  double _centerDY = 0.0;
  Size _initialSize = Size.zero;

  @override
  void initState() {
    super.initState();
    _position = widget.initialPosition ?? Offset.zero;
    if (widget.size != Size.zero) {
      _size = Size(
        widget.size.width * (widget.initialScale ?? 1),
        widget.size.height * (widget.initialScale ?? 1),
      );
      _aspectRatio = _size.width / _size.height;
    } else {
      _size = widget.size;
    }
    _constraints = widget.constraints;
    _angle = widget.initialAngle ?? 0;
    _scale = widget.initialScale ?? 1;
    _baseAngle = 0;
    _angleDelta = 0;
    _initialSize = _size;
  }

  void _onUpdate(double normalizedLeft, double normalizedTop) {
    WidgetsBinding.instance.addPostFrameCallback((Duration timeStamp) {
      final Offset normalizedPosition = Offset(normalizedLeft, normalizedTop);
      widget.onUpdate?.call(
        DragUpdate(
          position: normalizedPosition,
          size: _size,
          constraints: Size(_constraints.maxWidth, _constraints.maxHeight),
          angle: _angle,
          scale: _scale,
        ),
        _key,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // final aspectRatio = widget.size.width / widget.size.height;
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double aspectRatio =
            _aspectRatio ?? constraints.maxWidth / constraints.maxHeight;

        if (widget.size == Size.zero) {
          _size = constraints.smallest;
        }

        _centerDX = (constraints.maxWidth - _size.width) / 2;
        _centerDY = (constraints.maxHeight - _size.height) / 2;

        _position =
            _position == Offset.zero ? Offset(_centerDX, _centerDY) : _position;

        final double normalizedWidth = _size.width;
        final double normalizedHeight = normalizedWidth / aspectRatio;
        final Size newSize = Size(normalizedWidth, normalizedHeight);

        if (widget.constraints.isSatisfiedBy(newSize)) {
          _size = newSize;
        }

        final double normalizedLeft = _position.dx;
        final double normalizedTop = _position.dy;

        final SizedBox decoratedChild = SizedBox(
          height: normalizedHeight,
          width: normalizedWidth,
          key: _key,
          child: widget.child,
        );

        if (_constraints != constraints) {
          _constraints = constraints;
          _onUpdate(normalizedLeft, normalizedTop);
        }

        return Stack(
          children: <Widget>[
            Positioned(
              top: normalizedTop,
              left: normalizedLeft,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..scale(1.0)
                  ..rotateZ(_angle),
                child: _DraggablePoint(
                  key: const Key('draggableResizable_child_draggablePoint'),
                  onScaleUpdate: widget.onScaleUpdate,
                  onTap: () {
                    widget.onTap?.call(this);
                    _onUpdate(normalizedLeft, normalizedTop);
                  },
                  onStart: widget.onStart,
                  onEnd: widget.onEnd,
                  onDrag: (Offset d) {
                    setState(() {
                      _position =
                          Offset(_position.dx + d.dx, _position.dy + d.dy);
                    });
                    _onUpdate(normalizedLeft, normalizedTop);
                  },
                  onScale: (double s) {
                    final Size updatedSize = Size(
                      widget.size.width * s,
                      widget.size.height * s,
                    );

                    if (!widget.constraints.isSatisfiedBy(updatedSize)) return;

                    final double midX = _position.dx + (_size.width / 2);
                    final double midY = _position.dy + (_size.height / 2);
                    final Offset updatedPosition = Offset(
                      midX - (updatedSize.width / 2),
                      midY - (updatedSize.height / 2),
                    );

                    setState(() {
                      _size = updatedSize;
                      _position = updatedPosition;
                      _scale = s;
                    });
                    _onUpdate(normalizedLeft, normalizedTop);
                  },
                  onRotate: (double a) {
                    setState(() => _angle = a);
                    _onUpdate(normalizedLeft, normalizedTop);
                  },
                  child: decoratedChild,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum _PositionMode { local, global }

class _DraggablePoint extends StatefulWidget {
  const _DraggablePoint({
    Key? key,
    required this.child,
    this.onDrag,
    this.onScale,
    this.onRotate,
    this.onScaleUpdate,
    this.onTap,
    this.onStart,
    this.onEnd,
    // ignore: unused_element
    this.mode = _PositionMode.global,
  }) : super(key: key);

  final Widget child;
  final _PositionMode mode;
  final ValueSetter<Offset>? onDrag;
  final ValueSetter<double>? onScale;
  final ValueSetter<double>? onRotate;
  final ValueSetter<ScaleUpdateDetails>? onScaleUpdate;
  final VoidCallback? onTap;
  final VoidCallback? onStart;
  final VoidCallback? onEnd;

  @override
  _DraggablePointState createState() => _DraggablePointState();
}

class _DraggablePointState extends State<_DraggablePoint> {
  late Offset initPoint;
  double _baseScaleFactor = 1.0;
  double _scaleFactor = 1.0;
  double _baseAngle = 0.0;
  double _angle = 0.0;

  // var _isStartTriggered = false;
  // var _isEndTriggered = false;
  // var _isUpdating = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: widget.onTap,
      onScaleStart: (ScaleStartDetails details) {
        widget.onStart?.call();
        switch (widget.mode) {
          case _PositionMode.global:
            initPoint = details.focalPoint;
            break;
          case _PositionMode.local:
            initPoint = details.localFocalPoint;
            break;
        }
        if (details.pointerCount > 1) {
          _baseAngle = _angle;
          _baseScaleFactor = _scaleFactor;
          widget.onRotate?.call(_baseAngle);
          widget.onScale?.call(_baseScaleFactor);
        }
      },
      onScaleUpdate: (ScaleUpdateDetails details) {
        widget.onScaleUpdate?.call(details);
        // _isEndTriggered = false;
        // _isStartTriggered = false;
        switch (widget.mode) {
          case _PositionMode.global:
            final double dx = details.focalPoint.dx - initPoint.dx;
            final double dy = details.focalPoint.dy - initPoint.dy;
            initPoint = details.focalPoint;
            widget.onDrag?.call(Offset(dx, dy));
            break;
          case _PositionMode.local:
            final double dx = details.localFocalPoint.dx - initPoint.dx;
            final double dy = details.localFocalPoint.dy - initPoint.dy;
            initPoint = details.localFocalPoint;
            widget.onDrag?.call(Offset(dx, dy));
            break;
        }
        if (details.pointerCount > 1) {
          _scaleFactor = _baseScaleFactor * details.scale;
          widget.onScale?.call(_scaleFactor);
          _angle = _baseAngle + details.rotation;
          widget.onRotate?.call(_angle);
        }
      },
      onScaleEnd: (ScaleEndDetails detail) {
        widget.onEnd?.call();
      },
      child: widget.child,
    );
  }
}
