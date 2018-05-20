//
//  ffFavouriteItemModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "gt_Modelizable.h"
#import "ffImageModel.h"

@interface ffFavouriteItemModel : gt_Modelizable

@property (nonatomic, copy) NSNumber *cid;
@property (nonatomic, strong) ffImageModel *avatar;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *descField;
@property (nonatomic, copy) NSString *referenceUri;

@end
