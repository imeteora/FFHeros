//
//  DESUtils.h
//  VanBuren Plan
//
//  Created by Zhu Delun on 11-23-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DESUtils : NSObject

+ (NSString *) doCipher:(NSString *)sTextIn key:(NSString *)sKey context:(uint32_t)encryptOrDecrypt;
+ (NSString *) encryptStr:(NSString *) str usingKey: (NSString*)key;
+ (NSString *) decryptStr:(NSString *) str usingKey: (NSString*)key;

+ (NSString *) MD5:(NSString *)origin;

@end
