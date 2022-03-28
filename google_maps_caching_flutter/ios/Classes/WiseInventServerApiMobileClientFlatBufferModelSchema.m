// automatically generated, do not modify !!!

#import "WiseInventServerApiMobileClientFlatBufferModelSchema.h"

@implementation WiseInventServerApiMobileClientFlatBufferModelSchema 

- (FBMutableArray<WiseInventServerApiMobileClientFlatBufferModelFrame *> *) Frames {

    _Frames = [self fb_getTables:4 origin:_Frames className:[WiseInventServerApiMobileClientFlatBufferModelFrame class]];

    return _Frames;

}

- (void) add_Frames {

    [self fb_addTables:_Frames voffset:4 offset:4];

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
