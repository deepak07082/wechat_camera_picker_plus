import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';

import '../../../../../drishya_picker/drishya_picker.dart';
// import 'package:drishya_picker/src/camera/src/widgets/ui_handler.dart';
import '../../../../../drishya_picker/src/editor/src/widgets/widgets.dart';

/// Drishya editing controller
class DrishyaEditingController extends ValueNotifier<EditorValue> {
  ///
  /// Drishya editing controller
  DrishyaEditingController()
    : _editorKey = GlobalKey(),
      _stickerController = StickerController(),
      _textController = TextEditingController(),
      _focusNode = FocusNode(),
      _currentAssetState = ValueNotifier(null),
      _currentAsset = ValueNotifier(null),
      super(const EditorValue()) {
    init();
  }

  ///
  late EditorSetting _setting;

  ///
  late ValueNotifier<Color> _colorNotifier;

  ///
  late ValueNotifier<EditorBackground> _backgroundNotifier;

  ///
  final GlobalKey _editorKey;

  ///
  final StickerController _stickerController;

  ///
  final TextEditingController _textController;

  /// Editor textfield focus node
  final FocusNode _focusNode;

  ///
  final ValueNotifier<DraggableResizableState?> _currentAssetState;

  ///
  final ValueNotifier<StickerAsset?> _currentAsset;

  /// Editor key
  GlobalKey get editorKey => _editorKey;

  /// Current color notifier
  ValueNotifier<Color> get colorNotifier => _colorNotifier;

  /// Current background notifier
  ValueNotifier<EditorBackground> get backgroundNotifier => _backgroundNotifier;

  /// Sticker controller
  StickerController get stickerController => _stickerController;

  /// Editor text field controller
  TextEditingController get textController => _textController;

  /// Editor text field focus node
  FocusNode get focusNode => _focusNode;

  /// Editor settings
  EditorSetting get setting => _setting;

  /// Initialize controller setting

  void init({EditorSetting? setting}) {
    _setting = setting ?? const EditorSetting();
    _colorNotifier = ValueNotifier(_setting.colors.first);
    _backgroundNotifier = ValueNotifier(_setting.backgrounds.first);
  }

  ///

  ValueNotifier<DraggableResizableState?> get currentAssetState =>
      _currentAssetState;

  ///

  ValueNotifier<StickerAsset?> get currentAsset => _currentAsset;

  bool _isDisposed = false;

  /// Update editor value

  void updateValue({
    bool? keyboardVisible,
    bool? fillTextfield,
    int? maxLines,
    TextAlign? textAlign,
    bool? hasFocus,
    bool? hasStickers,
    bool? isEditing,
    bool? isStickerPickerOpen,
    bool? isColorPickerOpen,
  }) {
    final EditorValue oldValue = value;
    if (oldValue.hasFocus && !(hasFocus ?? false)) {
      // UIHandler.hideStatusBar();
    }
    value = value.copyWith(
      keyboardVisible: keyboardVisible,
      fillTextfield: fillTextfield,
      maxLines: maxLines,
      textAlign: textAlign,
      hasFocus: hasFocus,
      hasStickers: hasStickers,
      isEditing: isEditing,
      isStickerPickerOpen: isStickerPickerOpen,
      isColorPickerOpen: isColorPickerOpen,
    );
  }

  /// Current color
  Color get currentColor => _colorNotifier.value;

  /// Current background
  EditorBackground get currentBackground => _backgroundNotifier.value;

  /// Computed text color as per the background
  Color get textColor => value.fillTextfield
      ? generateForegroundColor(currentColor)
      : currentColor;

  /// Generate foreground color from background color
  Color generateForegroundColor(Color background) =>
      background.computeLuminance() > 0.5 ? Colors.black : Colors.white;

  ///
  /// Clear editor
  ///
  void clear() {
    _stickerController.clearStickers();
    updateValue(hasStickers: false);
  }

  ///
  /// Change editor gradient background
  void changeBackground() {
    assert(_setting.backgrounds.isNotEmpty, 'Backgrounds cannot be empty');
    final int index = _setting.backgrounds.indexOf(currentBackground);
    final int nextIndex = index >= 0 && index + 1 < _setting.backgrounds.length
        ? index + 1
        : 0;
    final EditorBackground bg = _setting.backgrounds[nextIndex];
    _backgroundNotifier.value = bg;
  }

  ///
  /// Complete editing and generate image
  Future<DrishyaEntity?> completeEditing({
    ValueSetter<Exception>? onException,
  }) async {
    try {
      final EditorBackground bg = _backgroundNotifier.value;

      if (bg is DrishyaBackground && !value.hasStickers) {
        // If background is drishya background and user has not edit the image
        // return its enity
        return bg.entity;
      } else if (bg is MemoryAssetBackground && !value.hasStickers) {
        // If background is memory bytes background and user has not edited the
        // image, create entity and return it
        final uuid = const Uuid().v4();
        final AssetEntity entity = await PhotoManager.editor.saveImage(
          bg.bytes,
          filename: '$uuid.png',
          title: uuid,
        );
        return entity.toDrishya;
      } else {
        // If user has edited the background take screenshot
        final RenderRepaintBoundary? boundary =
            _editorKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary?;
        final ui.Image image = await boundary!.toImage();
        final ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png,
        );
        final Uint8List data = byteData!.buffer.asUint8List();
        final uuid = const Uuid().v4();
        final AssetEntity entity = await PhotoManager.editor.saveImage(
          data,
          filename: '$uuid.png',
          title: uuid,
        );
        return entity.toDrishya;
      }
    } catch (e) {
      onException?.call(
        Exception('Exception occured while capturing picture : $e'),
      );
    }
    return null;
  }

  @override
  set value(EditorValue newValue) {
    if (_isDisposed) {
      return;
    }
    super.value = newValue;
  }

  @override
  void dispose() {
    _colorNotifier.dispose();
    _backgroundNotifier.dispose();
    _textController.dispose();
    _stickerController.dispose();
    _focusNode.dispose();
    _currentAssetState.dispose();
    _currentAsset.dispose();
    _isDisposed = true;
    super.dispose();
  }

  //
}
