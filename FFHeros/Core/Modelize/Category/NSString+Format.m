//
//  NSString+Format.m
//  VanBuren Plan
//
//  Created by Zhu Delun on 15-4-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import "NSString+Format.h"
#import "DESUtils.h"
#import <CommonCrypto/CommonDigest.h>


@implementation NSString (Format)

+ (NSString *)appendingMoneyComponent:(NSString *)price {
    return [NSString stringWithFormat:@"￥%@", price];
}

+ (NSString *)appendingDiscountComponent:(NSString *)discount {
    return [NSString stringWithFormat:@"%@折", discount];
}

- (NSString*)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (BOOL)isEmptyString
{
    return ([[self trim] isEqualToString:@""]);
}

+ (NSString *)EmptyString {
    return @"";
}

- (NSString *)MD5Hash
{
    if(self == nil || [self length] == 0){
        return nil;
    }

    const char *value = [self UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    return outputString;
}

- (NSString *)SHA1Hash {
    
    //  将字符串转换成 C字符串
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    //  C字符串转换成二进制数据
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint32_t)data.length, digest);
    
    NSMutableString *encryptionString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [encryptionString appendFormat:@"%02x", digest[i]];
    }
    
    return encryptionString;
}

- (NSString *)URLEncode {
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!*'();:@&=+$,/?%#[]"]];
}

- (NSString *)URLDecodedString {
    return [self stringByRemovingPercentEncoding];
}


- (NSString *)DESEncode: (NSString*)key {
    return [DESUtils encryptStr:self usingKey:key];
}

- (NSString *)DESDecode:(NSString *)key {
    return [DESUtils decryptStr:self usingKey:key];
}

- (CGSize)sizeWithFont:(UIFont *)font constainedToSize:(CGSize)size
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing              = 0;
    paragraphStyle.paragraphSpacing         = 0;
    paragraphStyle.lineBreakMode            = NSLineBreakByWordWrapping;
    
    NSDictionary *attribute = @{NSFontAttributeName : font
                                , NSParagraphStyleAttributeName : paragraphStyle
                                };
    CGSize _retSize = [self boundingRectWithSize: size
                                         options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes: attribute
                                         context: nil].size;
    CGFloat _width = ceilf(_retSize.width);
    CGFloat _height = ceilf(_retSize.height);
    
    return CGSizeMake(_width, _height);
}

- (BOOL)containInvalidChars
{
    if ([self rangeOfString:@"\\"].location != NSNotFound) {
         return YES;
    }
         
    NSString *invalidStr = @"[<>/%&()#;,'\"*]+";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:invalidStr
                                                                           options:0
                                                                             error:nil];
    NSTextCheckingResult *isMatch = [regex firstMatchInString:self
                                                          options:0
                                                            range:NSMakeRange(0, [self length])];
    
    BOOL match = (isMatch) ? YES : NO;
    return match;
}

- (NSDictionary *)JsonValue{
    
    if (self == nil || self.isEmptyString) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return nil;
    }
    
    return dict;
}

@end
