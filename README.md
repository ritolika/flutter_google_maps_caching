# flutter_google_maps_caching

Made as a workaround for this issue https://github.com/flutter/flutter/issues/41731

Usage:

Add this in your dependencies in pubspec.yaml instead of google_maps_flutter

```
google_maps_caching_flutter:
  git:
    url: git://github.com/ritolika/flutter_google_maps_caching.git
    path: google_maps_caching_flutter
```

Then you use this plugins as you would use the normal google_maps_flutter except for an addition; caching.

How to cache:

index -> byte array from image file (recommend PNG as it keeps transparency)
The index you assign the byte arrays is important and will be used to fetch the cached byte array.

So for example you read an image to a byte array and give it the index 0.
Then you save it in a map along with any other byte arrays and indexes and call this static method with the map at the beginning of your application.
The native code will then cache your byte arrays under respective index for the underlying platform (iOS/Android).

`GoogleMapsCache.setCachedBitmaps(Map<int index, Uint8List byteArray> bitmapByIndex);`

Then to use the cached byte arrays in your markers:

Instead of `BitmapDescriptor.fromByteArray()`
You simply use `BitmapDescriptor.fromCacheIndex(int index)`
So for our example you would put `BitmapDescriptor.fromCacheIndex(0)` to give the marker the cached byte array.

And that's it. Now the system won't have to transfer and load a byte array each time you change a marker bitmap making switching between cached byte arrays very fast.

;)
