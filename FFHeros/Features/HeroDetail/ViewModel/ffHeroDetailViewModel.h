//
//  ffHeroDetailViewModel.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffBaseViewModel.h"
#import "ffCharacterModel.h"

@interface ffHeroDetailViewModel : ffBaseViewModel
@property (nonatomic, assign) int64_t cid;      // hero's id
@property (nonatomic, strong, readonly) ffCharacterModel *heroData;

- (instancetype)initWithCharacterId:(int64_t)cid;

@end
