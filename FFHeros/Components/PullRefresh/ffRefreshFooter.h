//
//  ffRefreshFooter.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRefreshComponent.h"

@interface ffRefreshFooter : ffRefreshComponent
@property (nonatomic, assign) ffRefreshState refreshState;

/**
 auto trigger load more data callback if scroll view almost touch down. default is YES;
 */
@property (nonatomic, assign) BOOL needAutoRefresh;

/**
 the ratio of the scroll view height for automatical refresh op. default is 1.0. (1.0 is about touching bottom to autorefresh)
 */
@property (nonatomic, assign) CGFloat autoRefreshRate;

- (void)startRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;
- (void)enableNoMoreDataState;
- (void)resetRefreshState;

@end
