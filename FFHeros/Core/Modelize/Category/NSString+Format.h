//
//  NSString+Format.h
//  VanBuren Plan
//
//  Created by Zhu Delun on 15-4-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSString (Format)

+ (NSString*)appendingMoneyComponent: (NSString*)price;

+ (NSString*)appendingDiscountComponent: (NSString*)discount;

/**
 *  去除空格
 *
 *  @return 返回去除空格后的字符串
 */
- (NSString*)trim;


/**
 *  是否是空字符串
 *
 *  @return 返回结果
 */
- (BOOL)isEmptyString;

/**
 * 返回一个空字符串常量
 *
 * @return 空字符串
 */
+ (NSString*) EmptyString;


/**
 *  生成MD5字符串
 *
 *  @return 返回MD5字符串
 */
- (NSString *)MD5Hash;

/**
 *  生成SHA1字符串
 *
 *  @return 返回SHA1散列字符串
 */
- (NSString *)SHA1Hash;

/**
 *  URL字符串编码处理
 *
 *  @return 返回编码后的字符串
 */
- (NSString *)URLEncode;

/**
 * 字符串DES加密
 *
 * @return 返回DES加密之后的字符串
 */
- (NSString*)DESEncode: (NSString*)key;


/**
 * 字符串DES解密
 *
 * @return 返回DES解密之后的字符串
 */
- (NSString*)DESDecode: (NSString*)key;


/**
 *  URL字符串解码
 *
 *  @return 返回URL
 */
- (NSString *)URLDecodedString;


/**
 *  计算字符串展示需要的size
 *
 *  @param font 文字大小
 *  @param size 区域限制
 *
 *  @return 返回宽度和高度
 */
- (CGSize)sizeWithFont:(UIFont*)font constainedToSize:(CGSize)size;


/**
 *  是否包含非法字符（<  >  /  \  %  &  (  )  #  ;  ,  '  "  *）
 *
 *  @return 是否包含非法字符
 */
- (BOOL)containInvalidChars;


/**
 *  JSON字符串转成NSDictionary
 *
 *  @return 返回字典
 */
- (NSDictionary *)JsonValue;

@end

