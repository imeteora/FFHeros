//
//	ffCharacterModelComic.h
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "gtModelizable.h"
#import "ffCharacterSummaryModel.h"

@interface ffCharacterModelCategoryList : gtModelizable

@property (nonatomic, assign) NSInteger available;
@property (nonatomic, copy) NSString * collectionURI;
@property (nonatomic, strong) NSArray<ffCharacterSummaryModel *> * items;
@property (nonatomic, assign) NSInteger returned;
@end
