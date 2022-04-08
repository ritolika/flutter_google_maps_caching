// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.googlemaps;

import android.app.Activity;
import android.app.Application.ActivityLifecycleCallbacks;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.Lifecycle.Event;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleRegistry;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.HashMap;
import java.util.ArrayList;
import java.util.List;
import java.util.Map.Entry;

import java.io.*;

import com.google.flatbuffers.*;

import java.nio.ByteBuffer;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.ByteOrder;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.BitmapDescriptorFactory;

import com.google.flatbuffers.FlatBufferBuilder;

/**
 * Plugin for controlling a set of GoogleMap views to be shown as overlays on
 * top of the Flutter view. The overlay should be hidden during transformations
 * or while Flutter is rendering on top of the map. A Texture drawn using
 * GoogleMap bitmap snapshots can then be shown instead of the overlay.
 */
public class GoogleMapsPlugin implements FlutterPlugin, ActivityAware {

  @Nullable
  private Lifecycle lifecycle;

  private static final String VIEW_TYPE = "plugins.flutter.io/google_maps";

  public static final HashMap<Integer, BitmapDescriptor> CACHED_BITMAPS = new HashMap<Integer, BitmapDescriptor>();

  @SuppressWarnings("deprecation")
  public static void registerWith(final io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    final Activity activity = registrar.activity();
    if (activity == null) {
      // When a background flutter view tries to register the plugin, the registrar
      // has no activity.
      // We stop the registration process as this plugin is foreground only.
      return;
    }
    if (activity instanceof LifecycleOwner) {
      registrar.platformViewRegistry().registerViewFactory(VIEW_TYPE,
          new GoogleMapFactory(registrar.messenger(), new LifecycleProvider() {
            @Override
            public Lifecycle getLifecycle() {
              return ((LifecycleOwner) activity).getLifecycle();
            }
          }));
    } else {
      registrar.platformViewRegistry().registerViewFactory(VIEW_TYPE,
          new GoogleMapFactory(registrar.messenger(), new ProxyLifecycleProvider(activity)));
    }

  }

  public GoogleMapsPlugin() {
  }

  // FlutterPlugin

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    binding.getPlatformViewRegistry().registerViewFactory(VIEW_TYPE,
        new GoogleMapFactory(binding.getBinaryMessenger(), new LifecycleProvider() {
          @Nullable
          @Override
          public Lifecycle getLifecycle() {
            return lifecycle;
          }
        }));

    

    final MethodChannel staticChannel = new MethodChannel(binding.getBinaryMessenger(),
        "plugins.flutter.io/google_maps_static");

    staticChannel.setMethodCallHandler(new MethodCallHandler() {

      @Override
      public void onMethodCall(MethodCall methodCall, Result result) {
        if (methodCall.method.equals("map#setCachedBitmaps")) {
          HashMap<Integer, byte[]> bitmaps = methodCall.argument("bitmapByIndex");

          CACHED_BITMAPS.clear();

          new Thread(() -> {
            Bitmap bitmap;
            for (Entry<Integer, byte[]> entry : bitmaps.entrySet()) {
              bitmap = BitmapFactory.decodeByteArray(entry.getValue(), 0, entry.getValue().length);
              CACHED_BITMAPS.put(entry.getKey(), BitmapDescriptorFactory.fromBitmap(bitmap));
            }
            Log.i("GoogleMapsFlutterCaching", CACHED_BITMAPS.size() + " bitmaps indexed.");
            result.success(null);
          }).start();

          
        } else if(methodCall.method.equals("map#setCachedBitmapsFromFlatBufferPaths")) {
          List<String> paths = methodCall.argument("flatBufferPaths");
          int index = 0;

          for(String path : paths) {

            try {
              Log.i("GoogleMapsFlutterCaching", "Reading file " + path);

              File flatBufferFile = new File(path);

              //read all bytes from file
              /*byte[] flatBufferBytes = Files.readAllBytes(Paths.get(path));

              ByteBuffer byteBuffer = ByteBuffer.wrap(flatBufferBytes);
              byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
              int i = 0;
              int nextSize;
              Bitmap nextBitmap;
              while(i < flatBufferBytes.length) {
                nextSize = byteBuffer.getInt(i);
                i += 4;
                nextBitmap = BitmapFactory.decodeByteArray(flatBufferBytes, i, nextSize);
                CACHED_BITMAPS.put(index, BitmapDescriptorFactory.fromBitmap(nextBitmap));
                index++;
                i += nextSize;
              }*/

              RandomAccessFile file = new RandomAccessFile(flatBufferFile, "r");
              Log.i("GoogleMapsFlutterCaching", "Reading file " + path);
              byte[] data = new byte[(int)file.length()];
              file.readFully(data);
              file.close();
              Log.i("GoogleMapsFlutterCaching", "Read file " + path);

              ByteBuffer bb = ByteBuffer.wrap(data);
              Log.i("GoogleMapsFlutterCaching", "ByteBuffer created for " + path);
              ModelSchema schema = ModelSchema.getRootAsModelSchema(bb);
              Log.i("GoogleMapsFlutterCaching", "ModelSchema created for " + path);
              ModelFrame frame;
              ByteBuffer byteBuffer;
              byte[] byteArray;

              for(int i = 0; i < schema.FramesLength(); i++) {
                frame = schema.Frames(i);
                byteBuffer = frame.FrameAsByteBuffer();
                byteArray = byteBuffer.array();
                Bitmap bitmap = BitmapFactory.decodeByteArray(byteArray, byteBuffer.position(), byteBuffer.limit() - byteBuffer.position());
                CACHED_BITMAPS.put(index, BitmapDescriptorFactory.fromBitmap(bitmap));
                index++;
              }
            } catch(IOException e) {
              e.printStackTrace();
              Log.e("GoogleMapsFlutterCaching", "Error reading file: " + path);
            }
            
          }
          Log.i("GoogleMapsFlutterCaching", CACHED_BITMAPS.size() + " bitmaps indexed.");
          result.success(null);
        }
      }

    });

  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
  }

  // ActivityAware

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    lifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    lifecycle = null;
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  /**
   * This class provides a {@link LifecycleOwner} for the activity driven by
   * {@link ActivityLifecycleCallbacks}.
   *
   * <p>
   * This is used in the case where a direct Lifecycle/Owner is not available.
   */
  private static final class ProxyLifecycleProvider
      implements ActivityLifecycleCallbacks, LifecycleOwner, LifecycleProvider {

    private final LifecycleRegistry lifecycle = new LifecycleRegistry(this);
    private final int registrarActivityHashCode;

    private ProxyLifecycleProvider(Activity activity) {
      this.registrarActivityHashCode = activity.hashCode();
      activity.getApplication().registerActivityLifecycleCallbacks(this);
    }

    @Override
    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
      if (activity.hashCode() != registrarActivityHashCode) {
        return;
      }
      lifecycle.handleLifecycleEvent(Event.ON_CREATE);
    }

    @Override
    public void onActivityStarted(Activity activity) {
      if (activity.hashCode() != registrarActivityHashCode) {
        return;
      }
      lifecycle.handleLifecycleEvent(Event.ON_START);
    }

    @Override
    public void onActivityResumed(Activity activity) {
      if (activity.hashCode() != registrarActivityHashCode) {
        return;
      }
      lifecycle.handleLifecycleEvent(Event.ON_RESUME);
    }

    @Override
    public void onActivityPaused(Activity activity) {
      if (activity.hashCode() != registrarActivityHashCode) {
        return;
      }
      lifecycle.handleLifecycleEvent(Event.ON_PAUSE);
    }

    @Override
    public void onActivityStopped(Activity activity) {
      if (activity.hashCode() != registrarActivityHashCode) {
        return;
      }
      lifecycle.handleLifecycleEvent(Event.ON_STOP);
    }

    @Override
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
    }

    @Override
    public void onActivityDestroyed(Activity activity) {
      if (activity.hashCode() != registrarActivityHashCode) {
        return;
      }
      activity.getApplication().unregisterActivityLifecycleCallbacks(this);
      lifecycle.handleLifecycleEvent(Event.ON_DESTROY);
    }

    @NonNull
    @Override
    public Lifecycle getLifecycle() {
      return lifecycle;
    }
  }
}
