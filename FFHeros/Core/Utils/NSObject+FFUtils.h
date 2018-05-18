//
//  NSObject+FFUtils.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FFUtils)

- (BOOL)ff_checkObject:(id __nonnull)object overrideSelector:(NSString * __nonnull)selectorStr;

@end
