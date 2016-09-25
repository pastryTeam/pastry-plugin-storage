//
//  StorageViewController.h
//  CBCordova
//
//  Created by gengych on 16/5/16.
//
//

#import <UIKit/UIKit.h>

@interface StorageViewController : PTViewControllerBase<PTComponentInterface>

- (IBAction)returnBeforePage:(id)sender;

#pragma mark - 需要联网，握手成功后才能使用
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

#pragma mark - 不需要联网，正常使用
/**
 * 客户端实现的 加密 继承于 PTSecurityStorage 类
 */
- (IBAction)clientCustomEncrypt:(id)sender;

/**
 * 客户端实现的 解密 继承于 PTSecurityStorage 类
 */
- (IBAction)clientCustomDecrypt:(id)sender;

@end
