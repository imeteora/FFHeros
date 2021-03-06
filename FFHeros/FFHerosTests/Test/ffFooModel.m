//
//  ffFooModel.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/16.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffFooModel.h"

@implementation ffFooModel

+ (NSString *)gt_aliasPropertyName:(NSString *)propertyName {
    return @{@"id": @"idField",
             @"description": @"descriptionField"
             }[propertyName];
}

+ (Class)gt_classForPropertyName:(NSString *)propertyName {
    return @{@"items": [ffFooModelItem class],
             @"selected": [ffFooModelItem class],
             }[propertyName];
}

@end


@implementation ffFooModelItem

@end
