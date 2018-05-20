//
//  ffSearchBarView.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ffSearchBarView;

@protocol ffSearchBarViewDelegate <NSObject>
@optional
- (void)searchBarBackButtonClicked:(ffSearchBarView *)searchBar;
- (void)searchBarFindButtonClicked:(ffSearchBarView *)searchBar;
- (void)searchBar:(ffSearchBarView *)searchBar didChangeText:(NSString *)text;
- (void)searchBarBeginEditSearchText:(ffSearchBarView *)searchBar;
@end

@interface ffSearchBarView : UIView
@property (nonatomic, weak) id<ffSearchBarViewDelegate> delegate;
@end
