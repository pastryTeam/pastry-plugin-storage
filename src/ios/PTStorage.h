//
//  PTStorage.h
//  HelloCordova
//
//  Created by gengych on 16/1/26.
//
//

//#import <Cordova/Cordova.h>
#import <Cordova/CDV.h>

/**
 * JS端利用原生进行数据存储
 */
@interface PTStorage : CDVPlugin

/**
 * 获取指定 key 的 Value 值
 */
- (void)getValue:(CDVInvokedUrlCommand*)command;

/**
 * 设置指定 key 的 Value 值
 */
- (void)setValue:(CDVInvokedUrlCommand*)command;

@end
