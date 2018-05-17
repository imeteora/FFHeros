//
//  UIScrollView+ffExt.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (ffExt)
@property (nonatomic, assign) CGFloat contentInsetTop;
@property (nonatomic, assign) CGFloat contentInsetBottom;
@property (nonatomic, assign) CGFloat contentInsetLeft;
@property (nonatomic, assign) CGFloat contentInsetRight;

@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat contentOffsetY;

@property (nonatomic, assign) CGFloat contentSizeWidth;
@property (nonatomic, assign) CGFloat contentSizeHeight;

//- (void)setContentInsetTop:(CGFloat)top;
//- (CGFloat)contentInsetTop;
//- (void)setContentInsetBottom:(CGFloat)bottom;
//- (CGFloat)contentInsetBottom;
//
//- (void)setContentInsetLeft:(CGFloat)left;
//- (CGFloat)contentInsetLeft;
//- (void)setContentInsetRight:(CGFloat)Right;
//- (CGFloat)contentInsetRight;


@end
