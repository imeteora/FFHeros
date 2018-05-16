//
//	ffCharacterModel.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffMarvelApiWrapperModel.h"

@implementation ffMarvelApiWrapperModel

+ (Class)classForPropertyName:(NSString *)propertyName {
    return @{@"data": [ffMarvalApiModelResult class]}[propertyName];
}

@end
