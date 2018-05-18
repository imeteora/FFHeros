//
//  ffBaseListViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseListViewController.h"

@interface ffBaseListViewController ()

@end

@implementation ffBaseListViewController

- (void)ff_viewWillFirstAppear
{
    [super ff_viewWillFirstAppear];
    if (!self.disableAutoLoadData) {
        [self.viewModel tryLoadData];
    }
}

@end
