//
//  ffRefreshComponent.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(int32_t, ffRefreshState) {
    ffRefreshStateNone = 0,
    ffRefreshStatePulling,
    ffRefreshStateRefreshing,
    ffRefreshStateNoMoreData,       // just for footer 
};

static NSString * const kFFContentOffset = @"contentOffset";

typedef void(^ffRefreshBlock)(void);

@interface ffRefreshComponent : UIView
@property (nonatomic, weak, readonly) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets scrollViewOriginalInset;
@property (nonatomic, weak, readonly)     id refreshTarget;
@property (nonatomic, assign, readonly)   SEL refreshAction;

@property (nonatomic, copy) ffRefreshBlock  refreshHandler;     // for data load trigger
- (void)setTarget:(id __nonnull)target action:(SEL __nonnull)action;    // for data load trigger

- (void)startRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

@end
