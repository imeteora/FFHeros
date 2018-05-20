//
//  ffSearchViewModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseViewModel.h"


@interface ffSearchViewModel : ffBaseViewModel
@property (nonatomic, copy) NSString *keyword;

- (void)loadData;

@end
