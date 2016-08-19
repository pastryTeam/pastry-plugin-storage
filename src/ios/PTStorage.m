//
//  PTStorage.m
//  HelloCordova
//
//  Created by gengych on 16/1/26.
//
//

#import "PTStorage.h"

@implementation PTStorage

- (void)getValue:(CDVInvokedUrlCommand*)command {
    
    NSString *key = [command.arguments[0] valueForKey:@"key"];
    
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:value];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

- (void)setValue:(CDVInvokedUrlCommand*)command {
    
    NSString *key = [command.arguments[0] valueForKey:@"key"];
    
    NSString *value = [command.arguments[0] valueForKey:@"value"];
    
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    CDVPluginResult *pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:YES];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}

@end
