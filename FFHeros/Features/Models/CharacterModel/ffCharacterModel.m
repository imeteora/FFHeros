//
//	ffCharacterModel.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffCharacterModel.h"

@implementation ffCharacterModel

+ (Class)classForPropertyName:(NSString *)propertyName {
    return @{@"data": [ffCharacterModelData class]}[propertyName];
}

@end
