//
//  ffRouter.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ffRouter : NSObject

+ (nonnull ffRouter *)shared;

- (void)map:(NSString *)router toClass:(Class __nonnull)vcClass;
- (id _Nullable)classMatchRouter:(NSString *)router;


@end
