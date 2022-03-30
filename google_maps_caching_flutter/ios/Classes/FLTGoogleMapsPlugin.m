// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTGoogleMapsPlugin.h"
#import "WiseInventServerApiMobileClientFlatBufferModelSchema.h"
#import <google_maps_caching_flutter/google_maps_caching_flutter-Swift.h>

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
        NSData* value = [bitmaps objectForKey:key];
        UIImage* cacheimage = [UIImage imageWithData:value scale:screenScale];
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

  NSLog(@"%@", [[SwiftTestClass new] description]);

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
        int index = 0;
        NSMutableDictionary* cacheDict = [NSMutableDictionary new];
        for(NSString* flatBufferPath in flatBufferPaths) {
          //NSError* error = nil;
          //NSData* data = [NSData dataWithContentsOfFile:flatBufferPath  options:0 error:&error];
            NSArray* arr = [UtilityMethods byteArraysWithPath: flatBufferPath];

          for(int i = 0; i < [arr count]; i++) {
            [cacheDict setObject:arr[i] forKey:[NSNumber numberWithInteger:index]];
              index = index + 1;
          }

          /*for(WiseInventServerApi_MobileClient_FlatBuffer_ModelFrame* frame in schema.Frames) {
            //FBMutableArray<NSNumber *> * image = frame.Image;
            //NSMutableData *data = [[NSMutableData alloc] initWithCapacity: [image count]];
            for(NSNumber *number in image) {
                char byte = [number charValue];
              [data appendBytes:&byte length:1];
            }
            //NSData* payload = [NSData dataWithBytes:&image length:image.count];
            [cacheDict setObject:[frame getByteBuffer] forKey:[NSNumber numberWithInteger:index]];
            index = index + 1;
          }*/
        }
        [FLTGoogleMapsCache setCache:cacheDict];
        NSLog(@"[GoogleMapsFlutterCaching] %lu bitmaps indexed.", FLTGoogleMapsCache.cache.count);
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
