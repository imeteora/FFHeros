//
//	ffCharacterDataContainerModel.h
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

// 

#import <UIKit/UIKit.h>
#import "gt_Modelizable.h"
#import "ffCharacterModel.h"

@interface ffCharacterDataContainerModel : gt_Modelizable

@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, strong) NSArray<ffCharacterModel *> * results;
@property (nonatomic, assign) NSInteger total;

@end
