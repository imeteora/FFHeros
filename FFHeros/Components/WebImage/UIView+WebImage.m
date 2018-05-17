//
//  UIView+WebImage.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "UIView+WebImage.h"

@interface UIView () <NSURLSessionDownloadDelegate>
@end

@implementation UIView (WebImage)

- (void)ff_setImageWithUrl:(NSString *)url afterComplete:(void (^)(UIImage *image))complete
{
    @autoreleasepool {
        __block UIImage *img = nil;
        __block NSData *imgData = nil;

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

        dispatch_async(dispatch_get_main_queue(), ^{
            [self _ff_setImage:img];
            if (complete) {
                complete(img);
            }
        });
    }
}


#pragma mark - private helpers
- (void)_ff_setImage:(UIImage *)image
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

    self.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        imageSetter(image);
        self.alpha = 1.0;
    } completion:nil];
}

@end
