//
//  CBPeripheral+Public.h
//  Pods
//
//  Created by 谈超 on 2018/6/11.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Public)

/**
 取消连接

 @param result 回调
 */
- (void)disConnectionWithResulte:(nonnull void(^)(CBPeripheral *peripheral,NSError *error))result;

/*!
 *  @method discoverServices:duration:complete:
 *  @param serviceUUID A CBUUID of <code>CBUUID</code> object representing the service types to be discovered. If <i>nil</i>,
 *                        None services will be discovered
 *  @param duration timeOut
 *  @discussion            Discovers available service(s) on the peripheral by UUID.
 *  @see complete completeBlock service is nullable
 *  @return CBPeripheral
 */
- (nonnull instancetype)disCovery:(nullable CBUUID *)serviceUUID
                 duration:(NSTimeInterval)duration
                 complete:(nonnull void(^)(CBService *service))complete;
@end
