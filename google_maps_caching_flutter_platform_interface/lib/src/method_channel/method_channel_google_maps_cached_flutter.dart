import 'dart:typed_data';

import 'package:flutter/services.dart';

import '../../google_maps_flutter_platform_interface.dart';
import 'method_channel_google_maps_flutter.dart';

class MethodChannelGoogleMapsCachedFlutter
    extends MethodChannelGoogleMapsFlutter {
  final MethodChannel staticChannel =
      MethodChannel("plugins.flutter.io/google_maps_static");

  Future<void> setCachedBitmaps(Map<int, Uint8List> bitmapByIndex) {
    return staticChannel.invokeMethod<void>('map#setCachedBitmaps',
        <String, Object>{"bitmapByIndex": bitmapByIndex});
  }

  Future<void> setCachedBitmapsFromFlatBufferPaths(
      List<String> flatBufferPaths) {
    return staticChannel.invokeMethod<void>(
        'map#setCachedBitmapsFromFlatBufferPaths',
        <String, Object>{"flatBufferPaths": flatBufferPaths});
  }
}
