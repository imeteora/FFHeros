//
// Created by ZhuDelun on 2018/5/17.
// Copyright (c) 2018 ZhuDelun. All rights reserved.
//

#import "ffWebImageCache.h"
@import UIKit;

@implementation ffWebImageCache {

}

+ (ffWebImageCache *)shared {
    static ffWebImageCache *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffWebImageCache alloc] init];
        _instance.totalCostLimit = 10 * 1024 * 1024;
    });
    return _instance;
}

- (void)setObject:(id)obj forKey:(id)key {
    [self setObject:obj forKey:key cost:[self _costOf:obj]];
}

#pragma mark - private helper
- (int64_t)_costOf:(id)object {
    if ([object isKindOfClass:[UIImage class]]) {
        UIImage *img = (UIImage *)object;
        return ((int64_t)(img.size.width * img.size.height) << 3);
    }
    return 0;
}

@end
