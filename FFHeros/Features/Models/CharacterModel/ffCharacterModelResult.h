//
//	ffCharacterModelResult.h
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

// 

#import <UIKit/UIKit.h>
#import "gtModelizable.h"
#import "ffCharacterModelCategoryList.h"
#import "ffCharacterModelThumbnail.h"
#import "ffCharacterModelUrl.h"

@interface ffCharacterModelResult : gtModelizable

@property (nonatomic, copy) NSString *idField;      // -> id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descField;    // -> description
@property (nonatomic, copy) NSString * modified;
@property (nonatomic, copy) NSString * resourceURI;
@property (nonatomic, strong) NSArray<ffCharacterModelUrl *> * urls;
@property (nonatomic, strong) ffCharacterModelThumbnail * thumbnail;
@property (nonatomic, strong) ffCharacterModelCategoryList * comics;
@property (nonatomic, strong) ffCharacterModelCategoryList * events;
@property (nonatomic, strong) ffCharacterModelCategoryList * series;
@property (nonatomic, strong) ffCharacterModelCategoryList * stories;

@end
