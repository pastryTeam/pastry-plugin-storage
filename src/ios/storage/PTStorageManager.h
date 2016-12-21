//
//  PTStorageManager.h
//  PT
//
//  Created by gengych on 16/3/14.
//  Copyright © 2016年 中信网络科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTStorageDelegate.h"

typedef enum : NSUInteger {
    PTStorage_Privte,
    PTStorage_System,
} PTStorageType;
/**
 @ingroup storageModuleClass
 @class PTStorageManager
 @brief PTStorageManager类
 */
@interface PTStorageManager : NSObject

#pragma mark - 属性
@property (nonatomic)        BOOL    storageState;

#pragma mark - 方法
/**
 * 以懒惰方式实现的初始化
 * @return PTStorageManager对象
 */
+ (id)getInstance;

/**
 * 初始化 加密存储模块
 */
- (void)initialization;

/**
 * 注册存储器
 * @param  storage  实现了PTStorageDelegate协议的对象
 */
- (void)registStorage:(id<PTStorageDelegate>)storage;

/**
 * 注销存储器
 * @param  storageName  实现了PTStorageDelegate协议的存储器的名称
 */
- (void)unRegistStorage:(NSString *)storageName;

/**
 * 读取字符串
 * @parma key               键
 * @param storageName       存储器名称
 * @return
 *     nil    未找到对应值<br/>
 *    非nil   找到对应值<br/>
 */
- (NSString *)getString:(NSString *)key formStorageName:(NSString *)storageName;

/**
 * 存储字符串
 * @param   key     键
 * @param   value   值
 * @param   storageName       存储器名称
 * @return
 *     YES    存储成功<br/>
 *      NO    存储失败<br/>
 */
- (BOOL)put:(NSString *)key value:(NSString *)value formStorageName:(NSString *)storageName;

/**
 * 删除字符串
 * @param   key     键
 * @param   storageName       存储器名称
 */
- (void)remove:(NSString *)key formStorageName:(NSString *)storageName;

/**
 * 提交修改
 * @return
 *     YES   提交成功<br/>
 *      NO   提交失败<br/>
 */
- (BOOL)commit:(NSString *)storageName;

@end
