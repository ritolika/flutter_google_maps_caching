// automatically generated, do not modify !!!

#import "WiseInventServerApiMobileClientFlatBufferModelSchema.h"

@implementation WiseInventServerApiMobileClientFlatBufferModelSchema 

- (FBMutableArray<NSString *> *) Names {

    _Names = [self fb_getStrings:4 origin:_Names];

    return _Names;

}

- (void) add_Names {

    [self fb_addStrings:_Names voffset:4 offset:4];

    return ;

}

- (FBMutableArray<WiseInventServerApiMobileClientFlatBufferModelFrame *> *) Frames {

    _Frames = [self fb_getTables:6 origin:_Frames className:[WiseInventServerApiMobileClientFlatBufferModelFrame class]];

    return _Frames;

}

- (void) add_Frames {

    [self fb_addTables:_Frames voffset:6 offset:8];

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
