//
//  ffRefreshScrollView.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ffRefreshHeader.h"

@interface UIScrollView (FFRefresh)

@property (nonatomic, strong, readonly, nullable) ffRefreshHeader *headerView;

- (void)ff_addHeaderWith:(ffRefreshBlock)headerRefreshHandler;


- (nullable UIView *)footerView;
- (void)setFooterView:(UIView * _Nonnull)footer;

@end
