//
//  UIView+WebImage.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WebImage)

/**
 load image from remote server with the URI.

 @param url image's URI
 @param complete callback handler when image data was loaded.
 */
- (void)ff_setImageWithUrl:(NSString *)url afterComplete:(void (^)(UIImage *image))complete;

/**
 load image from remote server with the URI.

 @param url image's URI
 @param placeHolder placeholder image for current view as temporary replacement image before a remote image downloaded.
 @param complete callback handler when image data was loaded.
 */
- (void)ff_setImageWithUrl:(NSString *)url placeHolderImage:(UIImage *)placeHolder afterComplete:(void (^)(UIImage *image))complete;

@end
