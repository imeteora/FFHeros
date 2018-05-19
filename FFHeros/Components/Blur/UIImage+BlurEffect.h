//
//  UIImage+BlurEffect.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (BlurEffect)

- (UIImage *)ff_blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end
