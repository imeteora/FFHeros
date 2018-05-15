//
//	ffCharacterModelData.h
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

// 

#import <UIKit/UIKit.h>
#import "gtModelizable.h"
#import "ffCharacterModelResult.h"

@interface ffCharacterModelData : gtModelizable

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSArray<ffCharacterModelResult *> * results;
@property (nonatomic, assign) NSInteger total;

@end
