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

- (void)ff_endRefreshing {
    [self.ff_headerView endRefreshing];
}


@end
