//
//  ffRouter.h
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/19.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

DEPRECATED_MSG_ATTRIBUTE("并没有完全时限完成，暂时无法适配short url")
@interface ffRouter : NSObject

+ (nonnull ffRouter *)shared;


/**
 用短链接注册目标对象，短连接格式 "/abc/def/:param1/ghi/:param2 ..."

 @code
 [[ffRouter shared] map:@"/hero/:cid/comics"
                toClass:[ffHeroDetailViewController class]];
 @endcode
 @param router 短连接 例如：/abc/def/:param1/ghi/:param2 ...
 @param vcClass 需要被注册是类型
 */
- (void)map:(NSString *)router toClass:(Class __nonnull)vcClass;

/**
 证据给定的短连接，查找对应的对象类型

 @param router 短连接
 @return 被注册好的类型，如果未被注册，则返回空类型
 */
- (id _Nullable)classMatchRouter:(NSString *)router;


@end
