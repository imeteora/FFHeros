//
//  ffNavigationHelper.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ffNavigationController;

@interface ffNavigationHelper : NSObject
@property (nonatomic, weak) ffNavigationController *navigationController;

+ (instancetype)shared;

- (void)showHeroInfoViewController:(int64_t)cid;
- (void)showFavouriteListViewController;
- (void)showSearchViewController;
- (void)showWebControllerWithUrl:(NSString *)url;

@end
