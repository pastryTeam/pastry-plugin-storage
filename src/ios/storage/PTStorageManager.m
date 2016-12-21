//
//  PTStorageManager.m
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import "PTStorageManager.h"
#import "PTSystemStorage.h"
#import "PTPrivateStorage.h"

static PTStorageManager *instance = nil;

@implementation PTStorageManager
{
    NSMutableDictionary *storageDict;
}

+ (id)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[PTStorageManager alloc] init];
        }
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        
        NSNotificationCenter *nsCenter = [NSNotificationCenter defaultCenter];
        [nsCenter addObserver:self selector:@selector(handleHandShake:) name:[PTNotificationNameManager getNotificationName:PTNotification_CONSULT_NAME] object:nil];
    }
    
    return self;
}

- (void)dealloc{
    NSNotificationCenter *nsCenter = [NSNotificationCenter defaultCenter];
    [nsCenter removeObserver:self name:[PTNotificationNameManager getNotificationName:PTNotification_CONSULT_NAME] object:nil];
}

- (void)initialization{
    // 默认 加密存储 不可用
    _storageState = NO;
    storageDict = nil;
    storageDict = [NSMutableDictionary dictionary];
}

- (void)registStorage:(id<PTStorageDelegate>)storage
{
    NSString *name = [storage getName];
    if (![storageDict objectForKey:name] || !([PTSYSTEMSTORAGE_NAME isEqualToString:name] || [PTPRIVATESTORAGE_NAME isEqualToString:name])) {
        [storageDict setObject:storage forKey:name];
    }
}

- (void)unRegistStorage:(NSString *)storageName {
    if ([storageDict objectForKey:storageName] != nil) {
        [storageDict removeObjectForKey:storageName];
    }
}

- (NSString *)getString:(NSString *)key formStorageName:(NSString *)storageName
{
    id<PTStorageDelegate> storage = [storageDict objectForKey:storageName];
    if (storage != nil) {
        return [storage getString:key];
    }
    
    return nil;
}

- (BOOL)put:(NSString *)key value:(NSString *)value formStorageName:(NSString *)storageName
{
    if (key == nil || value == nil) {
        return NO;
    }
    
    id<PTStorageDelegate> storage = [storageDict objectForKey:storageName];
    if (storage != nil) {
        return [storage put:key value:value];
    }
    
    return NO;
}

- (void)remove:(NSString *)key formStorageName:(NSString *)storageName
{
    if (key == nil) {
        return;
    }
    
    id<PTStorageDelegate> storage = [storageDict objectForKey:storageName];
    if (storage != nil) {
        [storage remove:key];
    }
}

- (BOOL)commit:(NSString *)storageName
{
    id<PTStorageDelegate> storage = [storageDict objectForKey:storageName];
    if (storage != nil) {
        return [storage commit];
    }
    
    return NO;
}

- (void)handleHandShake:(NSNotification *)notification
{
    BOOL result = [[[notification userInfo] objectForKey:@"result"] boolValue];
    
    // 1 根据握手结果 设置 加密存储的Manager 的状态
    if (result) {
        _storageState = YES;
    } else {
        _storageState = NO;
    }
    
    // 2 握手成功，注册 系统加密类 和 框架自定义加密类
    if (result) {
        
        PTSystemStorage *systemStorage = [[PTSystemStorage alloc] init];
        [self registStorage:systemStorage];
        
        PTPrivateStorage *privateStorage = [[PTPrivateStorage alloc] init];
        [self registStorage:privateStorage];
    }
}

@end