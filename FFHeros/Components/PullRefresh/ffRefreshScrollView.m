//
//  ffRefreshScrollView.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRefreshScrollView.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

static char FFRefreshHeaderViewKey;
static char FFRefreshFooterViewKey;

static NSString * const kFFRefreshHeaderViewKVOKey = @"com.farfetch.heros.refreshHeaderKVO";
static NSString * const kFFRefreshFooterViewKVOKey = @"com.farfetch.heros.refreshFooterKVO";


@implementation UIScrollView (FFRefresh)

- (UIView *)headerView {
    return objc_getAssociatedObject(self, &FFRefreshHeaderViewKey);
}

- (void)setHeaderView:(UIView *)header {
    if (self.headerView != header) {
        if (self.headerView) {
            [self.headerView removeFromSuperview];
        }

        [self willChangeValueForKey:kFFRefreshHeaderViewKVOKey];
        objc_setAssociatedObject(self, &FFRefreshHeaderViewKey, header, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:kFFRefreshHeaderViewKVOKey];

        [self addSubview:header];
    }
}

- (UIView *)footerView {
    return objc_getAssociatedObject(self, &FFRefreshFooterViewKey);
}

- (void)setFooterView:(UIView *)footer {
    if (self.footerView != footer) {
        if (self.footerView) {
            [self.footerView removeFromSuperview];
        }

        [self willChangeValueForKey:kFFRefreshFooterViewKVOKey];
        objc_setAssociatedObject(self, &FFRefreshFooterViewKey, footer, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:kFFRefreshFooterViewKVOKey];

        [self addSubview:footer];
    }
}



@end
