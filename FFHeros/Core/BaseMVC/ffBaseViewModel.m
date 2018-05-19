//
//  ffBaseViewModel.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseViewModel.h"

@implementation ffBaseViewModel

- (void)loadData {
    // EMPTY
}

- (void)loadMoreData {
    // EMPTY
}

- (void)tryLoadData {
    if (self.isLoading) {
        return;
    }
    self.isLoading = YES;
    [self loadData];
}

@end
