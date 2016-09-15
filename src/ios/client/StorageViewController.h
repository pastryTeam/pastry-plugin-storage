//
//  StorageViewController.h
//  CBCordova
//
//  Created by gengych on 16/5/16.
//
//

#import <UIKit/UIKit.h>

@interface StorageViewController : PTViewControllerBase<PTFrameworkDelegate, PTComponentInterface>

- (IBAction)returnBeforePage:(id)sender;

/**
 * 系统方式 加密
 */
- (IBAction)systemEncryptAction:(id)sender;

/**
 * 系统方式 解密
 */
- (IBAction)systemDecrypt:(id)sender;

/**
 * 框架内实现的 加密 继承于 PTSecurityStorage 类
 */
- (IBAction)frameCustomEncrypt:(id)sender;

/**
 * 框架内实现的 解密 继承于 PTSecurityStorage 类
 */
- (IBAction)frameCustomDecrypt:(id)sender;

/**
 * 客户端实现的 加密 继承于 PTSecurityStorage 类
 */
- (IBAction)clientCustomEncrypt:(id)sender;

/**
 * 客户端实现的 解密 继承于 PTSecurityStorage 类
 */
- (IBAction)clientCustomDecrypt:(id)sender;

@end
