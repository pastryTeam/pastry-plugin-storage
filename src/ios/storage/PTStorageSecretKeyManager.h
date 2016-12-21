//
//  PTStorageSecretKeyManager.h
//  testPastry
//
//  Created by 耿远超 on 16/12/21.
//
//

#import <Foundation/Foundation.h>

@interface PTStorageSecretKeyManager : NSObject

#pragma mark - 方法
/**
 * 以懒惰方式实现的单例模式
 * @return 返回PTSessionManager对象
 */
+ (id)getInstance;

/**
 保存设备识别号key <br/>
 获取由服务器下发的设备绑定key <br/>
 */
- (void)setBindKey:(NSString *)key;

/**
 保存设备识别号key <br/>
 获取由服务器下发的设备绑定key <br/>
 */
- (NSString *)getBindKey;

@end
