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
- (void)disConnectionWithResulte:(void(^)(CBPeripheral *peripheral,NSError *error))result;

/*!
 *  @method discoverServices:duration:complete:
 *  @param serviceUUID A CBUUID of <code>CBUUID</code> object representing the service types to be discovered. If <i>nil</i>,
 *                        None services will be discovered
 *  @param duration timeOut
 *  @discussion            Discovers available service(s) on the peripheral by UUID.
 *  @see complete completeBlock service is nullable
 *  @return CBPeripheral
 */
- (instancetype)disCovery:(CBUUID *)serviceUUID
                 duration:(NSTimeInterval)duration
                 complete:(void(^)(CBService *service))complete;
@end
