//
//  ffNavigationHelper.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/21.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffNavigationHelper.h"
#import "ffNavigationController.h"
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
    NSString *router = [NSString stringWithFormat:@"/character/%lld", cid];
    [[ffRouter shared] processUrl:router animated:YES];
//    ffHeroDetailViewController *detailVC = [[ffHeroDetailViewController alloc] initWithCharacterId:cid];
//    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)showFavouriteListViewController {
    [[ffRouter shared] processUrl:@"/favourite" animated:YES];
}

- (void)showSearchViewController {
    [[ffRouter shared] processUrl:@"/search" animated:YES];
}

- (void)showWebControllerWithUrl:(NSString *)url {
    [[ffRouter shared] processUrl:url animated:YES];
}

@end
