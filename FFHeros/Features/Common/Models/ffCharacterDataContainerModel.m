//
//	ffCharacterDataContainerModel.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 

#import "ffCharacterDataContainerModel.h"

@implementation ffCharacterDataContainerModel

+ (Class)gt_classForPropertyName:(NSString *)propertyName {
    return @{@"results": [ffCharacterModel class]}[propertyName];
}

@end
