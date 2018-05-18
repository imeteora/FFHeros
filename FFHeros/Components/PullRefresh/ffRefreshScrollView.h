//
//  ffRefreshScrollView.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ffRefreshHeader.h"
#import "ffRefreshFooter.h"

@interface UIScrollView (FFRefresh)

@property (nonatomic, strong, readonly, nullable) ffRefreshHeader *ff_headerView;
@property (nonatomic, strong, readonly, nullable) ffRefreshFooter *ff_footerView;

- (void)ff_addHeaderWith:(ffRefreshBlock)headerRefreshHandler;
- (void)ff_addFooterWith:(ffRefreshBlock)footerRefreshHandler;

- (void)ff_endRefreshing;

@end
