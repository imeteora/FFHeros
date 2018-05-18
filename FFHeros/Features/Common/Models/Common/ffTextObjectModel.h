//
//  ffTextObjectModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "gt_Modelizable.h"

@interface ffTextObjectModel : gt_Modelizable

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *text;

@end
