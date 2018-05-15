//
//	ffCharacterModelData.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffCharacterModelData.h"

@implementation ffCharacterModelData

+ (Class)classForPropertyName:(NSString *)propertyName {
    return @{@"results": [ffCharacterModelResult class]}[propertyName];
}

@end
