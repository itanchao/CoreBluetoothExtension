//
//  CBCharacteristic+Public.h
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBCharacteristic (Public)

/**
 订阅

 @param sucess 订阅回调
 @return CBCharacteristic
 */
- (nonnull instancetype)notify:(nonnull void(^)(BOOL sucess))sucess;

/**
 发送

 @param message 消息
 @param duration 耗时
 @param retryTimes 重试
 @param sucess 回调
 @return CBCharacteristic
 */
- (nonnull instancetype)sendMessage:(nonnull NSData *)message duration:(NSTimeInterval)duration retryTimes:(NSInteger)retryTimes result:(nonnull void (^)(BOOL))sucess;

/**
 监听外设返回消息

 @param valueDidUpdateBlock 回调闭包
 @return CBCharacteristic
 */
- (nonnull instancetype)notifyValueDidUpdate:(nullable void(^)(CBCharacteristic *characteristic,NSError * error)) valueDidUpdateBlock;
@end
