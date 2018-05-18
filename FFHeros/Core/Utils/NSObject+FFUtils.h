//
//  NSObject+FFUtils.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FFUtils)

/**
 checking if object had been override the super class's some selector

 @return YES, if object had been override the super class's instance method.
 */
- (BOOL)ff_checkObject:(id __nonnull)object overrideSelector:(NSString * __nonnull)selectorStr;

@end
