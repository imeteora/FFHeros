//
//  ffApiSignHelper.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffApiSignHelper : NSObject

+ (NSString *_Nullable)signQueryFrom:(nonnull NSDictionary<NSString *,NSString *> *)param withOrder:(nonnull NSArray<NSString *> *)order;
+ (NSString *_Nullable)signQueryFrom:(nonnull NSArray<NSString *> *)param withCombineComponent:(NSString *_Nullable)component;

@end
