import 'dart:typed_data';

import 'package:google_maps_caching_flutter_platform_interface/src/method_channel/method_channel_google_maps_cached_flutter.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../../google_maps_flutter_platform_interface.dart';

class GoogleMapsCachedFlutterPlatform extends GoogleMapsFlutterPlatform {
  static MethodChannelGoogleMapsCachedFlutter get instance => _instance;

  static final _token = Object();

  static MethodChannelGoogleMapsCachedFlutter _instance =
      MethodChannelGoogleMapsCachedFlutter();

  static set instance(MethodChannelGoogleMapsCachedFlutter instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }
}
