//
//  ffBaseViewModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffBaseViewModel : NSObject
@property (nonatomic, assign) BOOL isLoading;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, assign) BOOL tryLoaded;
@property (nonatomic, strong) NSError *error;

- (void)loadData;
- (void)loadMoreData;
- (void)tryLoadData;

@end
