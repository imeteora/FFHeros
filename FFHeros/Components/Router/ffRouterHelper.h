//
//  ffRouterHelper.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

DEPRECATED_MSG_ATTRIBUTE("标准RESTful链接翻译成短连接的帮助类，未完成，禁止使用")
@interface ffRouterHelper : NSObject

/**
 将标准的RESTful链接转译成为应用内的软连接

 @param url 外部调用链接
 @return 内部使用的短连接
 */
+ (NSString *)routerFromURL:(NSString *)url DEPRECATED_ATTRIBUTE;

@end
