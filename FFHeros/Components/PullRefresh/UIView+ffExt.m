//
//  UIView+ffExt.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "UIView+ffExt.h"

@implementation UIView (ffExt)

- (void)setViewLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)viewLeft {
    return self.frame.origin.x;
}

- (void)setViewTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)viewTop {
    return self.frame.origin.y;
}

- (CGFloat)viewRight {
    return self.viewLeft + self.viewWidth;
}

- (CGFloat)viewBottom {
    return self.viewTop + self.viewHeight;
}

- (void)setViewWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)viewWidth {
    return self.frame.size.width;
}

- (void)setViewHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)viewHeight {
    return self.frame.size.height;
}

@end
