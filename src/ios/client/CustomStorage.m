//
//  CustomStorage.m
//  CBCordova
//
//  Created by gengych on 16/5/16.
//
//

#import "CustomStorage.h"

@implementation CustomStorage
{
    NSString *filename;
    
    NSMutableDictionary *privateDict;
}

- (id)init
{
    self = [super init];
    if (self) {
        filename = [NSString stringWithFormat:@"%@/Documents/customStorage.json", NSHomeDirectory()];
        
        NSData *data = [NSData dataWithContentsOfFile:filename];
        if (data != nil && data.length != 0) {
            NSData *decryptData = [self decrypt:data];
            privateDict = [NSMutableDictionary dictionaryWithDictionary:[decryptData objectFromJSONData]];
        } else {
            privateDict = [NSMutableDictionary dictionary];
        }
    }
    
    return self;
}

- (NSString *)getString:(NSString *)key
{
    if (key == nil || key.length == 0) {
        return nil;
    }
    
    return [privateDict objectForKey:key];
}

- (BOOL)put:(NSString *)key value:(NSString *)value
{
    if (key == nil || value == nil) {
        return NO;
    }
    
    [privateDict setObject:value forKey:key];
    
    return YES;
}

- (void)remove:(NSString *)key
{
    if (key != nil) {
        [privateDict removeObjectForKey:key];
    }
}

- (BOOL)commit
{
    NSData *data = [privateDict JSONData];
    if (data != nil) {
        NSData *encryptData = [self encrypt:data];
        if (encryptData != nil) {
            NSError *error = nil;
            [encryptData writeToFile:filename options:NSDataWritingAtomic error:&error];
            if (error == nil) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (NSString *)getName
{
    return @"CustomStorage";
}

@end
