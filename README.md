# Flutter WeChat Camera Picker

[![MIT License](https://img.shields.io/badge/License-MIT-green.svg)](https://pub.dev/packages/wechat_camera_picker_plus)
[![pub](https://img.shields.io/pub/v/wechat_camera_picker_plus)](https://pub.dev/packages/wechat_camera_picker_plus)
[![dart](https://img.shields.io/badge/dart-pure%20dart-success)](https://pub.dev/packages/wechat_camera_picker_plus)

A **camera picker** based on WeChat's UI which is a separate runnable extension to
[wechat_assets_picker_plus](https://pub.dev/packages/wechat_camera_picker_plus).
The package based on `camera` for camera functions
and `photo_manager` for asset implementation.

## 📷 Screenshots


| ![](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggtt6yrdqej30u01t017w.jpg) | ![](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggtt6yh3x4j30u01t0wuo.jpg) |
|-------------------------------------------------------------------------|-------------------------------------------------------------------------|
| ![](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggtt6z1h7xj30u01t01kx.jpg) | ![](https://tva1.sinaimg.cn/large/007S8ZIlgy1ggtt6zarvhj30u01t0x5f.jpg) |


## Features ✨

- ♻️ Fully implementable with `State`s override
- 💚 99% similar to WeChat style
- 📷 Picture taking support
- 🎥 Video recording support
  - ⏱ Duration limitation support
  - 🔍 Scale when recording support
- ☀️ Exposure adjust support
- 🔍️ Scale with pinch support
- 💱 i18n support
  - ⏪ RTL language support
- 🎏 Fully customizable theme
- 🖾 Foreground custom widget builder support
- 🕹️ Intercept saving with custom process

## 📦 Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  wechat_camera_picker_plus: ^latest_version
```

```sh
dependencies:
  flutter pub get
```

### Setup

- [wechat_assets_picker#preparing-for-use](https://github.com/deepak07082/wechat_assets_picker_plus#preparing-for-use-)
- [camera#installation](https://pub.dev/packages/camera#installation)

#### Android 13 (API 33) permissions

If you don't need to take photos or videos,
consider removing relevant permission in your apps, more specifically:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    package="com.your.app">
    <!-- Add this if you need to take photos. -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
    <!-- Add this if you need to take videos. -->
    <uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
</manifest>
```


## 🚀 Usage
Import the package:
```dart
import 'package:wechat_camera_picker_plus/wechat_camera_picker_plus.dart';
```

### Usage 📖

#### Record Video:
```dart
  final entity = await CameraPicker.pickFromCamera(
      Get.context!,
      pickerConfig: CameraPickerConfig(
        enableRecording: true,
        onlyEnableRecording: true,
        resolutionPreset: ResolutionPreset.high,
        maximumRecordingDuration: const Duration(seconds: 60),
        minimumRecordingDuration: const Duration(seconds: 7),
        enableTapRecording: true,
        permissionRequestOption: PermissionRequestOption(
          androidPermission:
              AndroidPermission(type: RequestType.all, mediaLocation: true),
        ),
        textDelegate: EnglishCameraPickerTextDelegate(),
        onMinimumRecordDurationNotMet: () {
          'Minimum recording duration is 7 seconds'.errorToast();
        },
      ),
    );

  final file = await entity?.file;
```

#### Take Picture:
```dart
  final entity = await CameraPicker.pickFromCamera(
      Get.context!,
      pickerConfig: CameraPickerConfig(
        enableRecording: false,
        resolutionPreset: ResolutionPreset.high,
        permissionRequestOption: PermissionRequestOption(
          androidPermission:
              AndroidPermission(type: RequestType.all, mediaLocation: true),
        ),
        textDelegate: EnglishCameraPickerTextDelegate(),
      ),
    );

  final file = await entity?.file;
```

## 💭 Frequently asked question
Why the orientation behavior is strange on iOS? 
Currently, the preview is not correctly synced on the iOS. You can find more details in this issue: https://github.com/flutter/flutter/issues/89216 . Other than that, please submit issues to describe your question.


## 📄 License
This project is licensed under the MIT License. See the [LICENSE](https://github.com/deepak07082/wechat_camera_picker_plus/blob/main/LICENSE) file for details.


## Contributors ✨

Thank goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):
<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://blog.alexv525.com"><img src="https://avatars1.githubusercontent.com/u/15884415?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Alex Li</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/commits?author=AlexV525" title="Code">💻</a> <a href="#design-AlexV525" title="Design">🎨</a> <a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/commits?author=AlexV525" title="Documentation">📖</a> <a href="#example-AlexV525" title="Examples">💡</a> <a href="#ideas-AlexV525" title="Ideas, Planning, & Feedback">🤔</a> <a href="#maintenance-AlexV525" title="Maintenance">🚧</a> <a href="#question-AlexV525" title="Answering Questions">💬</a> <a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/pulls?q=is%3Apr+reviewed-by%3AAlexV525" title="Reviewed Pull Requests">👀</a></td>
    <td align="center"><a href="https://www.kikt.top"><img src="https://avatars0.githubusercontent.com/u/14145407?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Caijinglong</b></sub></a><br /><a href="#example-CaiJingLong" title="Examples">💡</a> <a href="#ideas-CaiJingLong" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/LaelLuo"><img src="https://avatars3.githubusercontent.com/u/26056971?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Lael</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/commits?author=LaelLuo" title="Documentation">📖</a></td>
    <td align="center"><a href="https://github.com/mjl0602"><img src="https://avatars1.githubusercontent.com/u/32868496?v=4?s=50" width="50px;" alt=""/><br /><sub><b>mjl0602</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/commits?author=mjl0602" title="Code">💻</a> <a href="#ideas-mjl0602" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/siyukok"><img src="https://avatars0.githubusercontent.com/u/21030561?v=4?s=50" width="50px;" alt=""/><br /><sub><b>AliasWang</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/commits?author=siyukok" title="Code">💻</a> <a href="#ideas-siyukok" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/leftcoding"><img src="https://avatars.githubusercontent.com/u/7122926?v=4?s=50" width="50px;" alt=""/><br /><sub><b>leftcoding</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/issues?q=author%3Aleftcoding" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/TheVinhLuong"><img src="https://avatars.githubusercontent.com/u/20371879?v=4?s=50" width="50px;" alt=""/><br /><sub><b>Luong The Vinh</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/commits?author=TheVinhLuong" title="Code">💻</a></td>
  </tr>
  <tr>
    <td align="center"><a href="https://github.com/luomo-pro"><img src="https://avatars.githubusercontent.com/u/41097395?v=4?s=50" width="50px;" alt=""/><br /><sub><b>luomo-pro</b></sub></a><br /><a href="#a11y-luomo-pro" title="Accessibility">️️️️♿️</a> <a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/issues?q=author%3Aluomo-pro" title="Bug reports">🐛</a></td>
    <td align="center"><a href="https://github.com/ZhuBoao"><img src="https://avatars.githubusercontent.com/u/17305573?v=4?s=50" width="50px;" alt=""/><br /><sub><b>LeonardoZhu</b></sub></a><br /><a href="https://github.com/fluttercandies/flutter_wechat_camera_picker/commits?author=ZhuBoao" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification. Contributions of any kind welcome!

## 🌐 Author
Made with ❤️ by Deepak.