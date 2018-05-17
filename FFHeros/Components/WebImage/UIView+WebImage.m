//
//  UIView+WebImage.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "UIView+WebImage.h"
#import "ffWebImageCache.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>       // MD5

static char kffImageCacheKey;

@interface UIView () <NSURLSessionDownloadDelegate>
@end

@implementation UIView (WebImage)

- (void)ff_setImageWithUrl:(NSString *)url afterComplete:(void (^)(UIImage *image))complete {
    [self ff_setImageWithUrl:url placeHolderImage:nil afterComplete:complete];
}

- (void)ff_setImageWithUrl:(NSString *)url placeHolderImage:(UIImage *)placeHolder afterComplete:(void (^)(UIImage *image))complete
{
    @autoreleasepool {
        __block UIImage *img = nil;
        __block NSData *imgData = nil;

        __weak typeof(self) __weak_self = self;

        /// the block to handle final job and call the outsider callback
        void (^postFinishFetchImageHandler)(UIImage * __nonnull) = ^(UIImage * __nonnull finalImage) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [__weak_self _ff_setImage:finalImage animated:YES];
                if (complete) {
                    complete(finalImage);
                }
            });
        };

        /// to cache the image with digested url as the key
        void (^cacheFinalImage)(NSString * __nonnull, UIImage * __nonnull) = ^(NSString * __nonnull imgUrl, UIImage * __nonnull finalImage) {
            [__weak_self.imageCache setObject:finalImage forKey:[__weak_self keyForImage:url]];
        };


        /// set placeholder image as a tmp display
        if (placeHolder) {
            [self _ff_setImage:placeHolder animated:NO];
        }

        /// 1) try to get a cached image instance from local cache.
        UIImage *cachedImage_ = [self.imageCache objectForKey:[self keyForImage:url]];
        if (cachedImage_) {
            postFinishFetchImageHandler(cachedImage_);
            return;
        }

        /// 2) if failed in load cached image with key(MD5), try fetch the image data from the remote server
        NSURL *imgUrl = [NSURL URLWithString:url];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];

        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[session downloadTaskWithURL:imgUrl completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if ([location.filePathURL.absoluteString length] > 0 && (error == nil)) {
                imgData = [NSData dataWithContentsOfURL:location.filePathURL];
                if (imgData == nil) return;
                img = [UIImage imageWithData:imgData];
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];

        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        /// 3) cache fetched image
        cacheFinalImage(url, img);

        /// 4) calling the callback handler.
        postFinishFetchImageHandler(img);
    }
}


#pragma mark - private helpers
- (void)_ff_setImage:(UIImage *)image animated:(BOOL)animated
{
    if (image == nil) return;

    typedef void (^FFSetImageHandler)(UIImage *);
    FFSetImageHandler imageSetter;

    if ([self isKindOfClass:[UIImageView class]]) {
        imageSetter = ^(UIImage *image) {
            UIImageView *iv = (UIImageView *)self;
            [iv setImage:image];
        };
    } else if ([self isKindOfClass:[UIButton class]]) {
        imageSetter = ^(UIImage *image) {
            UIButton *btn = (UIButton *)self;
            [btn setImage:image forState:UIControlStateNormal];
        };
    } else {
        return;
    }

    if (animated == NO) {
        imageSetter(image);
    } else {
        self.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
            imageSetter(image);
            self.alpha = 1.0;
        } completion:nil];
    }
}

- (NSString *)keyForImage:(NSString *)url {
    return [self _MD5:url];
}

// -------------------------------------------------------------------------------
- (NSString *) _MD5:(NSString *)origin {
    return [self _MD5WithData:[origin dataUsingEncoding:(NSUTF8StringEncoding)]];
}

- (NSString *) _MD5WithData:(NSData *)data
{
    @autoreleasepool {
        const char*cStr = [data bytes];
        unsigned char result[CC_MD5_DIGEST_LENGTH];

        CC_MD5(cStr, (CC_LONG)data.length, result);
        return [[NSString stringWithFormat:
                @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
        ] lowercaseString];
    }
}

// -------------------------------------------------------------------------------
- (ffWebImageCache *)imageCache {
    ffWebImageCache * cache_ = objc_getAssociatedObject(self, &kffImageCacheKey);
    if (cache_ == nil) {
        cache_ = [[ffWebImageCache alloc] init];
        cache_.totalCostLimit = 10 * 1024 * 1024;
        [self setImageCache:cache_];
    }
    return cache_;
}

- (void)setImageCache:(ffWebImageCache *)newImageCache {
    objc_setAssociatedObject(self, &kffImageCacheKey, newImageCache, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
