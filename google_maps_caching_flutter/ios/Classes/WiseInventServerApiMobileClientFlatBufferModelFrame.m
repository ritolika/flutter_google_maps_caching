// automatically generated, do not modify !!!

#import "WiseInventServerApiMobileClientFlatBufferModelFrame.h"

@implementation WiseInventServerApiMobileClientFlatBufferModelFrame 

- (NSString *) Name {

    _Name = [self fb_getString:4 origin:_Name];

    return _Name;

}

- (void) add_Name {

    [self fb_addString:_Name voffset:4 offset:4];

    return ;

}

- (FBMutableArray<NSNumber *> *) Image {

    _Image = [self fb_getNumbers:6 origin:_Image type:FBNumberInt8];

    return _Image;

}

- (void) add_Image {

    [self fb_addNumbers:_Image voffset:6 offset:8 type:FBNumberInt8];

    return ;

}

- (instancetype)init{

    if (self = [super init]) {

        bb_pos = 14;

        origin_size = 12+bb_pos;

        bb = [[FBMutableData alloc]initWithLength:origin_size];

        [bb setInt32:bb_pos offset:0];

        [bb setInt32:8 offset:bb_pos];

        [bb setInt16:8 offset:bb_pos-[bb getInt32:bb_pos]];

        [bb setInt16:12 offset:bb_pos-[bb getInt32:bb_pos]+2];

    }

    return self;

}

@end
