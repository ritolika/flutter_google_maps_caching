// automatically generated by the FlatBuffers compiler, do not modify

package io.flutter.plugins.googlemaps;

import java.nio.*;
import java.lang.*;
import java.util.*;
import com.google.flatbuffers.*;

@SuppressWarnings("unused")
public final class ModelFrame extends Table {
  public static void ValidateVersion() { Constants.FLATBUFFERS_2_0_0(); }
  public static ModelFrame getRootAsModelFrame(ByteBuffer _bb) { return getRootAsModelFrame(_bb, new ModelFrame()); }
  public static ModelFrame getRootAsModelFrame(ByteBuffer _bb, ModelFrame obj) { _bb.order(ByteOrder.LITTLE_ENDIAN); return (obj.__assign(_bb.getInt(_bb.position()) + _bb.position(), _bb)); }
  public void __init(int _i, ByteBuffer _bb) { __reset(_i, _bb); }
  public ModelFrame __assign(int _i, ByteBuffer _bb) { __init(_i, _bb); return this; }

  public byte Frame(int j) { int o = __offset(4); return o != 0 ? bb.get(__vector(o) + j * 1) : 0; }
  public int FrameLength() { int o = __offset(4); return o != 0 ? __vector_len(o) : 0; }
  public ByteVector FrameVector() { return FrameVector(new ByteVector()); }
  public ByteVector FrameVector(ByteVector obj) { int o = __offset(4); return o != 0 ? obj.__assign(__vector(o), bb) : null; }
  public ByteBuffer FrameAsByteBuffer() { return __vector_as_bytebuffer(4, 1); }
  public ByteBuffer FrameInByteBuffer(ByteBuffer _bb) { return __vector_in_bytebuffer(_bb, 4, 1); }

  public static int createModelFrame(FlatBufferBuilder builder,
      int FrameOffset) {
    builder.startTable(1);
    ModelFrame.addFrame(builder, FrameOffset);
    return ModelFrame.endModelFrame(builder);
  }

  public static void startModelFrame(FlatBufferBuilder builder) { builder.startTable(1); }
  public static void addFrame(FlatBufferBuilder builder, int FrameOffset) { builder.addOffset(0, FrameOffset, 0); }
  public static int createFrameVector(FlatBufferBuilder builder, byte[] data) { return builder.createByteVector(data); }
  public static int createFrameVector(FlatBufferBuilder builder, ByteBuffer data) { return builder.createByteVector(data); }
  public static void startFrameVector(FlatBufferBuilder builder, int numElems) { builder.startVector(1, numElems, 1); }
  public static int endModelFrame(FlatBufferBuilder builder) {
    int o = builder.endTable();
    return o;
  }

  public static final class Vector extends BaseVector {
    public Vector __assign(int _vector, int _element_size, ByteBuffer _bb) { __reset(_vector, _element_size, _bb); return this; }

    public ModelFrame get(int j) { return get(new ModelFrame(), j); }
    public ModelFrame get(ModelFrame obj, int j) {  return obj.__assign(__indirect(__element(j), bb), bb); }
  }
}
