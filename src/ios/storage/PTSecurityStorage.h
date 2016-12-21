//
//  PTSecurityStorage.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "PTStorageDelegate.h"

/**
 @def PTSECURITYSTORAGE_NAME
 @brief 加密存储器类名
 */
#define PTSECURITYSTORAGE_NAME @"PTSecurityStorage"

/**
 @ingroup storageModuleClass
 该存储类只是实现数据的加密与解密，并不实现正真的存储，可以作为其他存储类的基类
 */
@interface PTSecurityStorage : NSObject <PTStorageDelegate>
/**
 * 采用系统保存的3DES密钥加密
 * @param  data  明文
 * @return
 *     nil     加密失败<br/>
 *    非nil    加密成功，返回加密后的字符串<br/>
 */
- (NSData *)encrypt:(NSData *)data;

/**
 * 采用系统保存的3DES密钥解密
 * @param  data  密文
 * @return
 *     nil     解密失败<br/>
 *    非nil    解密后的明文<br/>
 */
- (NSData *)decrypt:(NSData *)data;


@end
