import 'dart:typed_data';
import 'dart:ui' as ui;

import '../../../../../drishya_picker/drishya_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Widget to display [DrishyaEntity] thumbnail
class EntityThumbnail extends StatelessWidget {
  ///
  const EntityThumbnail({Key? key, required this.entity, this.onBytesGenerated})
    : super(key: key);

  ///
  final DrishyaEntity entity;

  /// Callback function triggered when image bytes is generated
  final ValueSetter<Uint8List?>? onBytesGenerated;

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();

    //
    if (entity.type == AssetType.image || entity.type == AssetType.video) {
      if (entity.pickedThumbData != null) {
        child = Image.memory(entity.pickedThumbData!, fit: BoxFit.cover);
      } else {
        child = Image(
          image: _MediaThumbnailProvider(
            entity: entity,
            onBytesLoaded: onBytesGenerated,
          ),
          fit: BoxFit.cover,
        );
      }
    }

    if (entity.type == AssetType.audio) {
      child = const Center(child: Icon(Icons.audiotrack, color: Colors.white));
    }

    if (entity.type == AssetType.other) {
      child = const Center(child: Icon(Icons.file_copy, color: Colors.white));
    }

    if (entity.type == AssetType.video || entity.type == AssetType.audio) {
      child = Stack(
        fit: StackFit.expand,
        children: <Widget>[
          child,
          Align(
            alignment: Alignment.bottomRight,
            child: _DurationView(duration: entity.duration),
          ),
        ],
      );
    }

    return AspectRatio(aspectRatio: 1, child: child);
  }
}

/// ImageProvider implementation
@immutable
class _MediaThumbnailProvider extends ImageProvider<_MediaThumbnailProvider> {
  /// Constructor for creating a [_MediaThumbnailProvider]
  const _MediaThumbnailProvider({required this.entity, this.onBytesLoaded});

  ///
  final DrishyaEntity entity;
  final ValueSetter<Uint8List?>? onBytesLoaded;

  @override
  ImageStreamCompleter load(
    _MediaThumbnailProvider key,
    Future<ui.Codec> Function(Uint8List, {bool? allowUpscaling}) decode,
  ) => MultiFrameImageStreamCompleter(
    codec: _loadAsync(key, decode),
    scale: 1,
    informationCollector: () sync* {
      yield ErrorDescription('Id: ${entity.id}');
    },
  );

  Future<ui.Codec> _loadAsync(
    _MediaThumbnailProvider key,
    Future<ui.Codec> Function(Uint8List, {bool? allowUpscaling}) decode,
  ) async {
    assert(key == this, 'Checks _MediaThumbnailProvider');
    final Uint8List? bytes = await entity.thumbnailData;
    onBytesLoaded?.call(bytes);
    return decode(bytes!);
  }

  @override
  Future<_MediaThumbnailProvider> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<_MediaThumbnailProvider>(this);

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    // ignore: test_types_in_equals
    final _MediaThumbnailProvider typedOther = other as _MediaThumbnailProvider;
    return entity.id == typedOther.entity.id;
  }

  @override
  int get hashCode => entity.id.hashCode;

  @override
  String toString() => '$_MediaThumbnailProvider("${entity.id}")';
}

class _DurationView extends StatelessWidget {
  const _DurationView({Key? key, required this.duration}) : super(key: key);

  final int duration;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withValues(alpha: 0.7),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          duration.formatedDuration,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

extension on int {
  String get formatedDuration {
    final Duration duration = Duration(seconds: this);
    final String min = duration.inMinutes
        .remainder(60)
        .toString()
        .padRight(2, '0');
    final String sec = duration.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$min:$sec';
  }
}
