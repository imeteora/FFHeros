//
//  ffNavigationHelper.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffNavigationHelper.h"
#import "ffNavigationController.h"
#import "ffHeroDetailViewController.h"
#import "ffSearchViewController.h"
#import "ffFavTableViewController.h"
#import "ffWebViewController.h"
#import <FFRouter/FFRouter.h>

@implementation ffNavigationHelper

+ (instancetype)shared {
    static ffNavigationHelper *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[ffNavigationHelper alloc] init];
    });
    return _instance;
}

- (void)showHeroInfoViewController:(int64_t)cid {
    ffHeroDetailViewController *detailVC = [[ffHeroDetailViewController alloc] initWithCharacterId:cid];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)showFavouriteListViewController {
    ffFavTableViewController *vc = [[ffFavTableViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showSearchViewController {
    ffSearchViewController *vc = [[ffSearchViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showWebControllerWithUrl:(NSString *)url {
    [[ffRouterTransfer shared] processUrl:url animated:YES];
//    ffWebViewController *webVC = [[ffWebViewController alloc] init];
//    webVC.url = url;
//    [self.navigationController pushViewController:webVC animated:YES];
}

@end
