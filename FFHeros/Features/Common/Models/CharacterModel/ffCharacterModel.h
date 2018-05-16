//
//	ffCharacterModelResult.h
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
//

// 

#import <UIKit/UIKit.h>
#import "gtModelizable.h"
#import "ffCategoryListModel.h"
#import "ffImageModel.h"
#import "ffUrlModel.h"

@interface ffCharacterModel : gtModelizable

@property (nonatomic, copy) NSString *idField;      // -> id
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descField;    // -> description
@property (nonatomic, copy) NSString * modified;
@property (nonatomic, copy) NSString * resourceURI;
@property (nonatomic, strong) NSArray<ffUrlModel *> * urls;
@property (nonatomic, strong) ffImageModel * thumbnail;
@property (nonatomic, strong) ffCategoryListModel * comics;
@property (nonatomic, strong) ffCategoryListModel * events;
@property (nonatomic, strong) ffCategoryListModel * series;
@property (nonatomic, strong) ffCategoryListModel * stories;

@end
