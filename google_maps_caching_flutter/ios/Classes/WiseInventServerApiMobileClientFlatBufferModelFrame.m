// automatically generated, do not modify !!!

#import "WiseInventServerApiMobileClientFlatBufferModelFrame.h"

@implementation WiseInventServerApiMobileClientFlatBufferModelFrame 

- (FBMutableArray<NSNumber *> *) Frame {

    _Frame = [self fb_getNumbers:4 origin:_Frame type:FBNumberUint8];

    return _Frame;

}

- (void) add_Frame {

    [self fb_addNumbers:_Frame voffset:4 offset:4 type:FBNumberUint8];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 12;

        origin_size = 8+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:6 offset:bb_pos];

        [bb setInt16:6 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:8 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
