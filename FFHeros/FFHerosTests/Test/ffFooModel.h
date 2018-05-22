//
//  ffFooModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "gt_Modelizable.h"

@class ffFooModelItem;

@interface ffFooModel : gt_Modelizable

@property (nonatomic, copy) NSString *idField;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descriptionField;
@property (nonatomic, strong) NSArray<ffFooModelItem *> * items;
@property (nonatomic, strong) ffFooModelItem *selected;

@end

@interface ffFooModelItem : gt_Modelizable
@property (nonatomic, copy) NSString *name;
@end
