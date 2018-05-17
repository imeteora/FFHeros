//
//  UIView+WebImage.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WebImage)

- (void)ff_setImageWithUrl:(NSString *)url afterComplete:(void (^)(UIImage *image))complete;
- (void)ff_setImageWithUrl:(NSString *)url placeHolderImage:(UIImage *)placeHolder afterComplete:(void (^)(UIImage *image))complete;

@end
