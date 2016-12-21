//
//  PTStorageSecretKeyManager.m
//  testPastry
//
//  Created by 耿远超 on 16/12/21.
//
//

#import "PTStorageSecretKeyManager.h"

static PTStorageSecretKeyManager *instance = nil;

@implementation PTStorageSecretKeyManager
{
    NSString *_bindKey;
}

+ (id)getInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[PTStorageSecretKeyManager alloc] init];
        }
    });
    return instance;
}

- (void)setBindKey:(NSString *)key
{
    if (key == nil || key.length == 0) {
        return;
    }
    
    if (_bindKey != nil) {
        _bindKey = nil;
    }
    
    PTLogDebug(@"---- set bindkey = %@  -------", key);
    
    _bindKey = [NSString stringWithFormat:@"%@", key];
}

- (NSString *)getBindKey
{
    return _bindKey;
}

@end
