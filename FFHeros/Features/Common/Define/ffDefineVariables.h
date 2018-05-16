//
//  ffDefineVariables.h
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/17.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ffDefineVariables : NSObject

+ (nonnull NSString *)marver_key_pub;
+ (nonnull NSString *)marver_key_pri;

+ (nonnull NSString *)marver_base_url;
+ (nonnull NSString *)marvel_base_security_url;

@end

#define MARVEL_BASE_URL(xxx)        [NSString stringWithFormat:@"%@%@", [ffDefineVariables marver_base_url], xxx]
#define MARVEL_BASE_HTTPS_URL(xxx)  [NSString stringWithFormat:@"%@%@", [ffDefineVariables marvel_base_security_url], xxx]
