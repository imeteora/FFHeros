//
//  ffRefreshComponent.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRefreshComponent.h"
#import "UIView+ffExt.h"

@interface ffRefreshComponent ()
@property (nonatomic, weak, readwrite) UIScrollView *scrollView;
@property (nonatomic, weak, readwrite)     id refreshTarget;
@property (nonatomic, assign, readwrite)   SEL refreshAction;
@end

@implementation ffRefreshComponent

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil && ![newSuperview isKindOfClass:[UIScrollView class]]) return;
    
    [self removeObservers];

    self.viewWidth = newSuperview.viewWidth;
    self.viewLeft = newSuperview.viewLeft;
    self.scrollView = (UIScrollView *)newSuperview;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollViewOriginalInset = self.scrollView.contentInset;

    [self addObservers:newSuperview];
}

- (void)addObservers:(UIView *)newSuperView {
    [newSuperView addObserver:self forKeyPath:kFFContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:kFFContentOffset context:nil];
    }
}

- (void)setTarget:(id)target action:(SEL)action {
    self.refreshTarget = target;
    self.refreshAction = action;
}

- (void)startRefreshing {
    // EMPTY
}

- (void)endRefreshing {
    // EMPTY
}

- (BOOL)isRefreshing {
    return NO;
}

@end
