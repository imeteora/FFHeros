//
//  ffRefreshHeader.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffRefreshComponent.h"

@interface ffRefreshHeader : ffRefreshComponent
@property (nonatomic, assign) ffRefreshState refreshState;

- (void)startRefreshing;
- (void)endRefreshing;
- (BOOL)isRefreshing;

@end
