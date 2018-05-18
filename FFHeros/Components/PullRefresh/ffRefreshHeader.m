//
//  ffRefreshHeader.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRefreshHeader.h"
#import "UIView+ffExt.h"
#import "UIScrollView+ffExt.h"

static int32_t const kFFRefreshHeaderHeight = 44;

@implementation ffRefreshHeader

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.refreshState = ffRefreshStateNone;
#if DEBUG
        self.backgroundColor = [UIColor purpleColor];
#endif  // DEBUG
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];

    if (newSuperview) {
        self.viewHeight = kFFRefreshHeaderHeight;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.viewTop = -self.viewHeight;
}

#pragma mark - public helper
- (void)startRefreshing {
    self.refreshState = ffRefreshStateRefreshing;
}

- (void)endRefreshing {
    dispatch_after(dispatch_time(1, 0), dispatch_get_main_queue(), ^{
        self.refreshState = ffRefreshStateNone;
    });
}

- (BOOL)isRefreshing {
    return self.refreshState == ffRefreshStateRefreshing;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (self.hidden || self.refreshState == ffRefreshStateRefreshing) return;
    if ([keyPath isEqualToString:kFFContentOffset]) {
        [self updateRefreshStateWithContentOffset];
    }
}

#pragma mark - private helpers
- (void)updateRefreshStateWithContentOffset {
    if (self.refreshState != ffRefreshStateRefreshing) {
        self.scrollViewOriginalInset = self.scrollView.contentInset;
    }

    if (self.refreshState == ffRefreshStateRefreshing) {
        if (self.scrollView.contentOffset.y >= -self.scrollViewOriginalInset.top) {
            self.scrollView.contentInsetTop = self.scrollViewOriginalInset.top;
        } else {
            self.scrollView.contentInsetTop = MIN(self.scrollViewOriginalInset.top + self.viewHeight, self.scrollViewOriginalInset.top - self.scrollView.contentOffset.y);
        }
        return;
    }

    CGFloat offsetY = self.scrollView.contentOffsetY;
    CGFloat triggerOffsetY = self.scrollViewOriginalInset.top;

    if (offsetY >= triggerOffsetY) return;  // skip drag up
    CGFloat pullOffsetY = triggerOffsetY - self.viewHeight;
    if (self.scrollView.isDragging) {
        if (self.refreshState == ffRefreshStateNone && offsetY < pullOffsetY) {
            self.refreshState = ffRefreshStatePulling;
        } else if (self.refreshState == ffRefreshStatePulling && offsetY >= pullOffsetY) {
            self.refreshState = ffRefreshStateNone;
        }
    } else if (self.refreshState == ffRefreshStatePulling) {
        self.refreshState = ffRefreshStateRefreshing;
    } else {

    }
}

- (void)setRefreshState:(ffRefreshState)state
{
    if (_refreshState == state) return;
    static const CGFloat kAnimeDuring = 0.45;

    ffRefreshState oldState = _refreshState;
    _refreshState = state;

    switch (state) {
        case ffRefreshStateNone: {
            if (oldState == ffRefreshStateRefreshing) {
                [UIView animateWithDuration:kAnimeDuring delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
                    self.scrollView.contentInsetTop -= self.viewHeight;
                } completion:nil];
            }
            break;
        }

        case ffRefreshStateRefreshing: {
            [UIView animateWithDuration:kAnimeDuring delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState animations:^{
                // 增加滚动区域
                CGFloat top = self.scrollViewOriginalInset.top + self.viewHeight;
                self.scrollView.contentInsetTop = top;
                self.scrollView.contentOffsetY = - top;
            } completion:^(BOOL finished) {
                if (self.refreshHandler) {
                    self.refreshHandler();
                }
                if ([self.refreshTarget respondsToSelector:self.refreshAction]) {
                    [self.refreshTarget performSelector:self.refreshAction];
                }
            }];
            break;
        }

        default:
            break;
    }
}

@end
