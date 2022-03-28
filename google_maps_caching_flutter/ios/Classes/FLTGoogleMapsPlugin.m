// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTGoogleMapsPlugin.h"
#import "WiseInventServerApiMobileClientFlatBufferModelSchema.h"

#pragma mark - GoogleMaps plugin implementation



@implementation FLTGoogleMapsCache 
  static NSMutableDictionary* cache;
  + (NSMutableDictionary*) cache
  { @synchronized(self) { return cache; } }
  + (void) setCache:(NSDictionary*)bitmaps
  { @synchronized(self) 
    { 

      cache = [[NSMutableDictionary alloc] init];
      CGFloat screenScale = [[UIScreen mainScreen] scale];
      for (id key in bitmaps) {
        FlutterStandardTypedData* value = [bitmaps objectForKey:key];
        UIImage* cacheimage = [UIImage imageWithData:[value data] scale:screenScale];
        [cache setObject:cacheimage forKey:key]; 
      }
    } 
  }
@end

@implementation FLTGoogleMapsPlugin {
  NSObject<FlutterPluginRegistrar>* _registrar;
  FlutterMethodChannel* _channel;
  NSMutableDictionary* _mapControllers;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FLTGoogleMapFactory* googleMapFactory = [[FLTGoogleMapFactory alloc] initWithRegistrar:registrar];
  [registrar registerViewFactory:googleMapFactory
                                withId:@"plugins.flutter.io/google_maps"
      gestureRecognizersBlockingPolicy:
          FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];

  NSString* channelName =
        @"plugins.flutter.io/google_maps_static";
  FlutterMethodChannel* staticChannel = [FlutterMethodChannel methodChannelWithName:channelName
                                           binaryMessenger:registrar.messenger];
  [staticChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
      if([call.method isEqualToString:@"map#setCachedBitmaps"]) {

        NSDictionary* bitmaps = call.arguments[@"bitmapByIndex"];
        [FLTGoogleMapsCache setCache:bitmaps];
        NSLog(@"[GoogleMapsFlutterCaching] %lu bitmaps indexed.", FLTGoogleMapsCache.cache.count);
        result(@[ @(YES) ]);
      } else if([call.method isEqualToString:@"map#setCachedBitmapsFromFlatBufferPaths"]) {
        NSArray* flatBufferPaths = call.arguments[@"flatBufferPaths"];
        for(NSString* flatBufferPath in flatBufferPaths) {
          NSError* error = nil;
          NSData* data = [NSData dataWithContentsOfFile:flatBufferPath  options:0 error:&error];
          WiseInventServerApiMobileClientFlatBufferModelSchema* schema = [WiseInventServerApiMobileClientFlatBufferModelSchema getRootAs:data];
          NSLog(@"[GoogleMapsFlutterCaching] %lu bitmaps found in FlatBuffer table.", [schema.Frames count]);
        }
        result(@[ @(YES) ]);
      } else {
        result(FlutterMethodNotImplemented);
      }
    }
  ];
}

- (FLTGoogleMapController*)mapFromCall:(FlutterMethodCall*)call error:(FlutterError**)error {
  id mapId = call.arguments[@"map"];
  FLTGoogleMapController* controller = _mapControllers[mapId];
  if (!controller && error) {
    *error = [FlutterError errorWithCode:@"unknown_map" message:nil details:mapId];
  }
  return controller;
}
@end
