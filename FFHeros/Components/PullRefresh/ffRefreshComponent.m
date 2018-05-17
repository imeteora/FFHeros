//
//  ffRefreshComponent.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRefreshComponent.h"
#import "UIView+ffExt.h"

@implementation ffRefreshComponent

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview && [newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];
    self.viewWidth = newSuperview.viewWidth;
    self.viewLeft = newSuperview.viewLeft;

    [self addObservers];
}

- (void)addObservers {

}

- (void)removeObservers {

}

@end
