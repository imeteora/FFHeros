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


- (void)ff_addHeaderWith:(ffRefreshBlock)headerRefreshHandler {
    ffRefreshHeader *header = [[ffRefreshHeader alloc] init];
    self.ff_headerView = header;
    [self.ff_headerView setRefreshHandler:headerRefreshHandler];
}

- (void)ff_addFooterWith:(ffRefreshBlock)footerRefreshHandler {
    ffRefreshFooter *footer = [[ffRefreshFooter alloc] init];
    self.ff_footerView = footer;
    [self.ff_footerView setRefreshHandler:footerRefreshHandler];
}

- (ffRefreshHeader *)ff_headerView {
    return objc_getAssociatedObject(self, &FFRefreshHeaderViewKey);
}

- (void)setFf_headerView:(ffRefreshHeader * _Nullable)ff_headerView {
    if (self.ff_headerView != ff_headerView) {
        if (self.ff_headerView) {
            [self.ff_headerView removeFromSuperview];
        }

        [self willChangeValueForKey:kFFRefreshHeaderViewKVOKey];
        objc_setAssociatedObject(self, &FFRefreshHeaderViewKey, ff_headerView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:kFFRefreshHeaderViewKVOKey];

        [self addSubview:ff_headerView];
    }
}

- (UIView *)ff_footerView {
    return objc_getAssociatedObject(self, &FFRefreshFooterViewKey);
}

- (void)setFf_footerView:(UIView *)ff_footerView {
    if (self.ff_footerView != ff_footerView) {
        if (self.ff_footerView) {
            [self.ff_footerView removeFromSuperview];
        }

        [self willChangeValueForKey:kFFRefreshFooterViewKVOKey];
        objc_setAssociatedObject(self, &FFRefreshFooterViewKey, ff_footerView, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:kFFRefreshFooterViewKVOKey];

        [self addSubview:ff_footerView];
    }
}

- (void)ff_endRefreshing
{
    if ([self.ff_headerView isRefreshing]) {
        [self.ff_headerView endRefreshing];
    }

    if ([self.ff_footerView isRefreshing]) {
        [self.ff_footerView endRefreshing];
    }
}


@end