//
//  NSObject+FFUtils.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "NSObject+FFUtils.h"

@implementation NSObject (FFUtils)

- (BOOL)ff_checkObject:(id __nonnull)object overrideSelector:(NSString * __nonnull)selectorStr
{
    IMP objectIMP = [object methodForSelector:NSSelectorFromString(selectorStr)];
    Class superClass = [[object class] superclass];
    IMP superClassIMP = [superClass instanceMethodForSelector:NSSelectorFromString(selectorStr)];

    return objectIMP != superClassIMP;
}

@end
