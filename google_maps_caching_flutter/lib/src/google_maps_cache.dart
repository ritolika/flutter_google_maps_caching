part of google_maps_cached_flutter;

class GoogleMapsCache {
  static Future<void> setCachedBitmaps(Map<int, Uint8List> bitmapByIndex) {
    assert(bitmapByIndex != null);

    return GoogleMapsCachedFlutterPlatform.instance
        .setCachedBitmaps(bitmapByIndex);
  }
}
