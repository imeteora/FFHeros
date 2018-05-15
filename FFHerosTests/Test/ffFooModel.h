//
//  ffFooModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "gtModelizable.h"

@class ffFooModelItem;

@interface ffFooModel : gtModelizable

@property (nonatomic, copy) NSString *idField;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descriptionField;
@property (nonatomic, strong) NSArray<ffFooModelItem *> * items;
@property (nonatomic, strong) ffFooModelItem *selected;

@end

@interface ffFooModelItem : gtModelizable
@property (nonatomic, copy) NSString *name;
@end
