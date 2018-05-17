//
//  DESUtils.m
//  VanBuren Plan
//
//  Created by Zhu Delun on 11-23-17.
//  Copyright (c) 2015年 Gamebable Studio. All rights reserved.
//

#import "DESUtils.h"
#import <CommonCrypto/CommonDigest.h>       // MD5
#import <CommonCrypto/CommonCryptor.h>      // Base64 etc.

@implementation DESUtils

+ (NSString *) encryptStr:(NSString *) str usingKey: (NSString*)key
{
    return[DESUtils doCipher:str key:key context:kCCEncrypt];
}

+ (NSString *) decryptStr:(NSString *) str usingKey: (NSString*)key
{
    return[DESUtils doCipher:str key:key context:kCCDecrypt];
}

+ (NSString *)doCipher:(NSString *)sTextIn
                   key:(NSString *)sKey
               context:(CCOperation)encryptOrDecrypt
{
    @autoreleasepool {
        NSStringEncoding EnC = NSUTF8StringEncoding;

        NSMutableData * dTextIn;
        if (encryptOrDecrypt == kCCDecrypt) {
            dTextIn = [[DESUtils decodeBase64WithString:sTextIn] mutableCopy];
        }
        else{
            dTextIn = [[sTextIn dataUsingEncoding: EnC] mutableCopy];
        }
        NSMutableData * dKey = [[sKey dataUsingEncoding:EnC] mutableCopy];
        [dKey setLength:kCCBlockSizeDES];
        uint8_t *bufferPtr1 = NULL;
        size_t bufferPtrSize1 = 0;
        size_t movedBytes1 = 0;
        //uint8_t iv[kCCBlockSizeDES];
        //memset((void *) iv, 0x0, (size_t) sizeof(iv));
        Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
        bufferPtrSize1 = ([sTextIn length] + kCCKeySizeDES) & ~(kCCKeySizeDES -1);
        bufferPtr1 = malloc(bufferPtrSize1 * sizeof(uint8_t));
        memset((void *)bufferPtr1, 0x00, bufferPtrSize1);
        CCCrypt(encryptOrDecrypt, // CCOperation op
                kCCAlgorithmDES, // CCAlgorithm alg
                kCCOptionPKCS7Padding | kCCOptionECBMode, // CCOptions options
                [dKey bytes], // const void *key
                [dKey length], // size_t keyLength
                iv, // const void *iv
                [dTextIn bytes], // const void *dataIn
                [dTextIn length], // size_t dataInLength
                (void*)bufferPtr1, // void *dataOut
                bufferPtrSize1, // size_t dataOutAvailable
                &movedBytes1); // size_t *dataOutMoved


        NSString * sResult;
        if (encryptOrDecrypt == kCCDecrypt){
            sResult = [[NSString alloc] initWithData:[NSData dataWithBytes:bufferPtr1
                                                                    length:movedBytes1] encoding:EnC];
        }
        else {
            NSData *dResult = [NSData dataWithBytes:bufferPtr1 length:movedBytes1];
            sResult = [DESUtils encodeBase64WithData:dResult];
        }
        return sResult;
    }
}

+ (NSString *)encodeBase64WithString:(NSString *)strData {
    return[DESUtils encodeBase64WithData:[strData dataUsingEncoding:NSUTF8StringEncoding]];
}

+ (NSString *)encodeBase64WithData:(NSData *)objData {
    return  [objData base64EncodedStringWithOptions:0];
}


+ (NSData *)decodeBase64WithString:(NSString *)strBase64 {
    return [[NSData alloc] initWithBase64EncodedString:strBase64 options:0];
}


+ (NSString *) MD5:(NSString *)origin {
    return [self MD5WithData:[origin dataUsingEncoding:(NSUTF8StringEncoding)]];
}

+ (NSString *) MD5WithData:(NSData *)data
{
    @autoreleasepool {
        const char*cStr = [data bytes];
        unsigned char result[CC_MD5_DIGEST_LENGTH];

        CC_MD5(cStr, (CC_LONG)data.length, result);
        return [[NSString stringWithFormat:
                @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                result[0], result[1], result[2], result[3],
                result[4], result[5], result[6], result[7],
                result[8], result[9], result[10], result[11],
                result[12], result[13], result[14], result[15]
        ] lowercaseString];
    }
}

@end


