//
//  UIScrollView+ffExt.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "UIScrollView+ffExt.h"

@implementation UIScrollView (ffExt)

@dynamic contentInsetTop;
@dynamic contentInsetBottom;
@dynamic contentInsetLeft;
@dynamic contentInsetRight;
@dynamic contentOffsetX;
@dynamic contentOffsetY;
@dynamic contentSizeWidth;
@dynamic contentSizeHeight;


- (void)setContentInsetTop:(CGFloat)top {
    UIEdgeInsets inset = self.contentInset;
    inset.top = top;
    self.contentInset = inset;
}
- (CGFloat)contentInsetTop {
    return self.contentInset.top;
}
- (void)setContentInsetBottom:(CGFloat)bottom {
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = bottom;
    self.contentInset = inset;
}
- (CGFloat)contentInsetBottom {
    return self.contentInset.bottom;
}

- (void)setContentInsetLeft:(CGFloat)left {
    UIEdgeInsets inset = self.contentInset;
    inset.left = left;
    self.contentInset = inset;
}
- (CGFloat)contentInsetLeft {
    return self.contentInset.left;
}
- (void)setContentInsetRight:(CGFloat)Right {
    UIEdgeInsets inset = self.contentInset;
    inset.right = Right;
    self.contentInset = inset;
}
- (CGFloat)contentInsetRight {
    return self.contentInset.right;
}

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    CGPoint offset = self.contentOffset;
    offset.x = contentOffsetX;
    self.contentOffset = offset;
}
- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    CGPoint offset = self.contentOffset;
    offset.y = contentOffsetY;
    self.contentOffset = offset;
}
- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}

- (void)setContentSizeWidth:(CGFloat)contentSizeWidth {
    CGSize size = self.contentSize;
    size.width = contentSizeWidth;
    self.contentSize = size;
}
- (CGFloat)contentSizeWidth {
    return self.contentSize.width;
}

- (void)setContentSizeHeight:(CGFloat)contentSizeHeight {
    CGSize size = self.contentSize;
    size.height = contentSizeHeight;
    self.contentSize = size;
}
- (CGFloat)contentSizeHeight {
    return self.contentSize.height;
}

@end
