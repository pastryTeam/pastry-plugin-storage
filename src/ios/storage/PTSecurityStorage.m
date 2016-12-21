//
//  PTSecurityStorage.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTSecurityStorage.h"
#import "SSKeychain.h"
#import "PTStorageSecretKeyManager.h"

@implementation PTSecurityStorage
{
    NSString *key;
}

- (id)init
{
    self = [super init];
    if (self) {
        key = nil;
    }
    
    return self;
}

- (NSData *)encrypt:(NSData *)data
{
    NSString *desKey = [self getStorageSecretKey];
    if (desKey == nil) {
        return nil;
    }
    
    return [PT3Des encrypt:data key1:[desKey substringWithRange:NSMakeRange(0, 8)] key2:[desKey substringWithRange:NSMakeRange(8, 8)] key3:[desKey substringWithRange:NSMakeRange(16, 8)]];
}

- (NSData *)decrypt:(NSData *)data
{
    NSString *desKey = [self getStorageSecretKey];
    if (desKey == nil) {
        return nil;
    }
    
    return [PT3Des decrypt:data key1:[desKey substringWithRange:NSMakeRange(0, 8)] key2:[desKey substringWithRange:NSMakeRange(8, 8)] key3:[desKey substringWithRange:NSMakeRange(16, 8)]];
}

#pragma mark -- delegate implementation
- (NSString *)getName
{
    return PTSECURITYSTORAGE_NAME;
}

/**
 * 默认使用服务器下发的UUIDKEY作为 加解密 客户端明文UUID 的3DES密钥 混淆前字符串
 */
- (NSString *)getUUIDClearKey {
    return [[PTStorageSecretKeyManager getInstance] getBindKey];
}

- (NSString *)getString:(NSString *)key
{
    return nil;
}

- (BOOL)put:(NSString *)key value:(NSString *)value
{
    return NO;
}

- (void)remove:(NSString *)key
{
    return;
}

- (BOOL)commit
{
    return NO;
}

#pragma mark -- private method
/**
 * 获取最终为本地存储加解密使用的3DES密钥字符串
 * @return 3DES密钥字符串
 */
- (NSString *)getStorageSecretKey
{
    if (key == nil) {
        int config[] = {77, 22, 88, 44, 55, 66};
        NSString *plainUUIDKey = [self getPlainUUID];
        if (plainUUIDKey != nil) {
            NSMutableString *buffer = [NSMutableString string];
            [buffer setString:@""];
            
            int start = 0;
            int end = 0;
            for (int i = 0; i < 3; i++) {
                start = config[i * 2] % plainUUIDKey.length;
                end = config[i * 2 + 1] % plainUUIDKey.length;
                if (start > end) {
                    start ^= end;
                    end ^= start;
                    start ^= end;
                }
                
                [buffer appendString:[plainUUIDKey substringWithRange:NSMakeRange(start, end - start)]];
            }
            
            while (buffer.length < 24) {
                [buffer appendString:@"0"];
            }
            
            key = [NSString stringWithFormat:@"%@", buffer];
        }
    }
    
    return key;
}

/**
 * 获取设备绑定值对应的UUID<br/>
 * 备注：UUID每次都不一样，为了确保每次都是用同一个UUID.<br/>
 * 是将第一次获取的UUID进行了3DES加密保存。这个3DES密钥是由服务器下发的)<br/>
 * @return 客户端明文UUID值
 */
- (NSString *)getPlainUUID
{
    // 客户端明文UUID
    NSString *plainUUID = nil;
    
    // 加解密 客户端明文UUID 用的3DES密钥混淆前字符串
    NSString *clearKey = [self getUUIDClearKey];
    
    if (clearKey != nil && clearKey.length != 0) {
        
        // 加解密 客户端明文UUID 用的3DES密钥
        NSString *desKey = [self getConfuseKey:clearKey];
        
        // 客户端密文UUID
        NSString *cipherUUID = [SSKeychain passwordForService:clearKey account:clearKey];
        if (cipherUUID == nil || cipherUUID.length == 0) {
    
            CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
            NSString *plainUUIDTemp = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidRef));
            // 去掉UUID中的横线
            NSString *simpleUUID = [plainUUIDTemp stringByReplacingOccurrencesOfString:@"-" withString:@""];
            NSData *encryptUUID = [PT3Des encrypt:[simpleUUID dataUsingEncoding:NSUTF8StringEncoding] key1:[desKey substringWithRange:NSMakeRange(0, 8)] key2:[desKey substringWithRange:NSMakeRange(8, 8)] key3:[desKey substringWithRange:NSMakeRange(16, 8)]];
            
            [SSKeychain setPassword:[PTConverter bytesToHex:encryptUUID] forService:clearKey account:clearKey];
            CFRelease(uuidRef);
            
            plainUUID = [NSString stringWithFormat:@"%@", simpleUUID];
        } else {
            NSData *encryptUUID = [PTConverter hexToBytes:cipherUUID];
            NSData *decryptUUID = [PT3Des decrypt:encryptUUID key1:[desKey substringWithRange:NSMakeRange(0, 8)] key2:[desKey substringWithRange:NSMakeRange(8, 8)] key3:[desKey substringWithRange:NSMakeRange(16, 8)]];
            
            plainUUID = [[NSString alloc] initWithData:decryptUUID encoding:NSUTF8StringEncoding];
        }
    }
    
    return plainUUID;
}

/**
 * 混淆 加解密客户端明文UUID的3DES密钥
 */
- (NSString *)getConfuseKey:(NSString *)plainKey
{
    int config[] = {77, 22, 88, 44, 55, 66};
    NSMutableString *buffer = [NSMutableString string];
    int start = 0;
    int end = 0;
    
    for (int i = 0; i < 3; i++) {
        start = config[i * 2] % plainKey.length;
        end = config[i * 2 + 1] % plainKey.length;
        if (start > end) {
            start ^= end;
            end ^= start;
            start ^= end;
        }
        [buffer appendString:[plainKey substringWithRange:NSMakeRange(start, end - start)]];
    }
    
    while (buffer.length < 24) {
        [buffer appendString:@"0"];
    }
    
    return buffer;
}

@end
