//
//  PTSystemStorage.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTSystemStorage.h"
#import "SSKeychain.h"

@implementation PTSystemStorage
{
    NSString *systemKey;
    NSMutableDictionary *systemDict;
}

- (id)init
{
    self = [super init];
    if (self) {
        systemKey = [NSString stringWithFormat:@"%@", @"system"];
        NSString *base64Str = [SSKeychain passwordForService:systemKey account:systemKey];
        if (base64Str != nil && base64Str.length != 0) {
            NSData *data = [PTConverter base64ToBytes:base64Str];
            NSData *decryptData = [self decrypt:data];
            systemDict = [NSMutableDictionary dictionaryWithDictionary:[decryptData objectFromJSONData]];
        } else {
            systemDict = [NSMutableDictionary dictionary];
        }
    }
    
    return self;
}

- (NSString *)getString:(NSString *)key
{
    if (key == nil) {
        return nil;
    }
    
    PTLogDebug(@"-----system getString key = %@ ----", key);
    PTLogDebug(@"-----systemDict = %@", systemDict);
    
    return [systemDict objectForKey:key];
}

- (BOOL)put:(NSString *)key value:(NSString *)value
{
    if (key == nil || value == nil) {
        return NO;
    }
    
    [systemDict setObject:value forKey:key];
    
    return YES;
}

- (void)remove:(NSString *)key
{
    if (key != nil) {
        [systemDict removeObjectForKey:key];
    }
}

- (BOOL)commit
{
    PTLogDebug(@"-----commit systemDict = %@ ----", [systemDict JSONData]);
    
    NSData *data = [systemDict JSONData];
    if (data != nil) {
        NSData *encryptData = [self encrypt:data];
        if (encryptData != nil) {
            return [SSKeychain setPassword:[PTConverter bytesToBase64:encryptData] forService:systemKey account:systemKey];
        }
    }
    
    return NO;
}

- (NSString *)getName
{
    return PTSYSTEMSTORAGE_NAME;
}

@end
