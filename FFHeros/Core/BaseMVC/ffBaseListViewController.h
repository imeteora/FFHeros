//
//  ffBaseListViewController.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseViewController.h"
#import "ffBaseViewModel.h"

@interface ffBaseListViewController : ffBaseViewController
@property (nonatomic, strong) ffBaseViewModel *viewModel;
@property (nonatomic, assign) BOOL disableAutoLoadData;
@end
