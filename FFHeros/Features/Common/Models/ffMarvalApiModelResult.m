//
//	ffMarvalApiModelResult.m
//
//	Create by 德伦 朱 on 16/5/2018
//	Copyright © 2018. All rights reserved.
// 



#import "ffMarvalApiModelResult.h"

@implementation ffMarvalApiModelResult

+ (Class)classForPropertyName:(NSString *)propertyName {
    return @{@"results": [ffCharacterModelInfo class]}[propertyName];
}

@end
