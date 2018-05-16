//
//  ffTextObjectModel.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "gtModelizable.h"

@interface ffTextObjectModel : gtModelizable

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *language;
@property (nonatomic, copy) NSString *text;

@end
