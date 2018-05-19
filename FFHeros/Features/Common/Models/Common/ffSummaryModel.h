//
//  ffSummaryModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "gt_Modelizable.h"

@interface ffSummaryModel : gt_Modelizable

@property (nonatomic, copy) NSString * resourceURI;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * type;
@property (nonatomic, copy) NSString * role;        // special for 'creator' segment

@end
