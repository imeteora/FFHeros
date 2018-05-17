//
//  ffRefreshScrollView.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (FFRefresh)

- (nullable UIView *)headerView;
- (void)setHeaderView:(UIView * _Nonnull)header;

- (nullable UIView *)footerView;
- (void)setFooterView:(UIView * _Nonnull)footer;

@end
