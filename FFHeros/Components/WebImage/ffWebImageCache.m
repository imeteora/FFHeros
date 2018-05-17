//
// Created by ZhuDelun on 2018/5/17.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

#import "ffWebImageCache.h"
@import UIKit;

@implementation ffWebImageCache {

}

- (void)setObject:(id)obj forKey:(id)key {
    [self setObject:obj forKey:key cost:[self costOf:obj]];
}

#pragma mark - private helper
- (int64_t)costOf:(id)object {
    if ([object isKindOfClass:[UIImage class]]) {
        UIImage *img = (UIImage *)object;
        return ((int64_t)(img.size.width * img.size.height) << 3);
    }
    return 0;
}

@end