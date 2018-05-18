//
//  ffRefreshFooter.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRefreshFooter.h"
#import "UIView+ffExt.h"
#import "UIScrollView+ffExt.h"


static int32_t const kFFRefreshFooterHeight = 30;

@implementation ffRefreshFooter

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.refreshState = ffRefreshStateNone;
        self.autoRefreshRate = 1.0;
        self.needAutoRefresh = YES;
#if DEBUG
        self.backgroundColor = [UIColor purpleColor];
#endif  // DEBUG
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.viewWidth = self.superview.viewWidth;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self removeObserver];

    if (newSuperview) {
        [self addObserver:newSuperview];

        self.viewHeight = kFFRefreshFooterHeight;
        self.scrollView.contentInsetBottom += self.viewHeight;

        [self updateFrameWithContentSize];
    } else {
        self.scrollView.contentInsetBottom -= self.viewHeight;
    }
}

- (void)addObserver:(UIView *)newSuperView {
    [newSuperView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [newSuperView addObserver:self forKeyPath:@"pan.state" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    if (self.superview) {
        [self.superview removeObserver:self forKeyPath:@"contentSize"];
        [self.superview removeObserver:self forKeyPath:@"pan.state"];
    }
}

- (void)setRefreshState:(ffRefreshState)refreshState {
    if (_refreshState == refreshState) return;
    _refreshState = refreshState;

    if (_refreshState == ffRefreshStateNone) {

    } else if (_refreshState == ffRefreshStateRefreshing) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self.refreshHandler) {
                self.refreshHandler();
            }
            if (self.refreshTarget && self.refreshAction && [self.refreshTarget respondsToSelector:self.refreshAction]) {
                [self.refreshTarget performSelector:self.refreshAction];
            }
        });
    } else if (_refreshState == ffRefreshStateNoMoreData) {

    }
}

#pragma mark - KVO delegate
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.hidden) return;
    [self updateRefreshStateWithKeyPath:keyPath];
}

#pragma mark - public helper
- (void)startRefreshing {
    if ([self isRefreshing]) return;
    self.refreshState = ffRefreshStateRefreshing;
}

- (void)endRefreshing {
    self.refreshState = ffRefreshStateNone;
}

- (BOOL)isRefreshing {
    return (self.refreshState == ffRefreshStateRefreshing);
}

- (void)enableNoMoreDataState {
    self.refreshState = ffRefreshStateNoMoreData;
}

- (void)resetRefreshState {
    self.refreshState = ffRefreshStateNone;
}

#pragma mark - private helper
- (void)updateRefreshStateWithKeyPath:(NSString *)keyPath {
    if (self.hidden) return;
    if (self.refreshState == ffRefreshStateNone) {
        if ([keyPath isEqualToString:@"pan.state"]) {
            if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
                if (self.scrollView.contentInsetTop + self.scrollView.contentSizeHeight <= self.scrollView.viewHeight) {
                    [self startRefreshing];
                } else if (self.scrollView.contentOffsetY > self.scrollView.contentSizeHeight + self.scrollView.contentInsetBottom - self.scrollView.viewHeight) {
                    [self startRefreshing];
                }
            }
        } else if ([keyPath isEqualToString:@"contentOffset"]) {
            if (self.refreshState != ffRefreshStateRefreshing && self.needAutoRefresh) {
                [self updateStateWithContentOffset];
            }
        }
    }

    if ([keyPath isEqualToString:@"contentSize"]) {
        [self updateFrameWithContentSize];
    }
}

- (void)updateStateWithContentOffset {
    if (self.viewTop == 0) return;
    if (self.scrollView.contentInsetTop + self.scrollView.contentSizeHeight > self.scrollView.viewHeight) {
        if (self.scrollView.contentOffsetY > self.scrollView.contentSizeHeight - self.scrollView.viewHeight + self.viewHeight * self.autoRefreshRate + self.scrollView.contentInsetBottom - self.viewHeight) {
            [self startRefreshing];
        }
    }
}

- (void)updateFrameWithContentSize {
    self.viewTop = self.scrollView.contentSizeHeight;
}

@end
