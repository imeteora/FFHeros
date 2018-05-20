//
//	ffImageModel.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffImageModel.h"

@implementation ffImageModel

- (NSString *)pathWithPortraitSize:(CGSize)size {
    return [NSString stringWithFormat:@"%@/portrait_xlarge.%@", _path, _extension];
}

- (NSString *)pathWithSquareSize:(CGSize)size {
    return [NSString stringWithFormat:@"%@/standard_large.%@", _path, _extension];
}

- (NSString *)pathWithLandscapeSize:(CGSize)size {
    return [NSString stringWithFormat:@"%@/landscape_large.%@", _path, _extension];
}


@end
