import '../delegates/camera_picker_text_delegate.dart';

export 'package:photo_manager/photo_manager.dart';

final class Singleton {
  const Singleton._();

  static CameraPickerTextDelegate textDelegate =
      const CameraPickerTextDelegate();
}
