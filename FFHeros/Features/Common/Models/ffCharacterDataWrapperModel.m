//
//	ffCharacterModel.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffCharacterDataWrapperModel.h"

@implementation ffCharacterDataWrapperModel

+ (Class)gt_classForPropertyName:(NSString *)propertyName {
    return @{@"data": [ffCharacterDataContainerModel class]}[propertyName];
}

@end
