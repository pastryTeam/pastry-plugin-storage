//
//  PTStorageDelegate.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 @ingroup storageModuleProtocol
 @protocol PTStorageDelegate
 @brief PTStorageDelegate 协议
 */
@protocol PTStorageDelegate <NSObject>
@required
/**
 * 获取存储器名称
 * @return 名称
 */
- (NSString *)getName;

/**
 * 设置为 UUID 加密的密钥字符串<br/>
 * 场景1->本地存储需要联网才能使用：子类不要重写此方法。默认使用 握手完成后服务器下发的UUIDKEY<br/>
 *          框架内：PTPrivateStorage、PTSystemStorage 适用此场景
 * 场景2->本地存储不需要联网也能使用：子类要重写此方法。设置 密钥字符串<br/>
 *          pastry-plugin-storage插件的 CustomStorage 适用此场景
 * @return 自定义的密钥混淆字符串
 */
- (NSString *)getUUIDClearKey;

/**
 * 获取存储器中的字符串
 * @param  key   存储变量的key
 * @return       key对应的值
 *     nil       未找到对应值<br/>
 *    非nil      找到对应值<br/>
 */
- (NSString *)getString:(NSString *)key;

/**
 * 向存储器中写入字符串
 * @param  key    存储变量的key
 * @param  value  存储的字符串
 * @return
 *     YES        保存成功<br/>
 *      NO        保存失败<br/>
 */
- (BOOL)put:(NSString *)key value:(NSString *)value;

/**
 * 从存储器中删除字符串
 * @param  key   存储变量的key
 */
- (void)remove:(NSString *)key;

/**
 * 提交修改
 * @return 提交结果
 */
- (BOOL)commit;

@end
