//
//	ffImageModel.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffImageModel.h"

@implementation ffImageModel

- (NSString *)pathWithSize:(CGSize)size {
    return [NSString stringWithFormat:@"%@/portrait_xlarge.%@", _path, _extension];
}

@end
