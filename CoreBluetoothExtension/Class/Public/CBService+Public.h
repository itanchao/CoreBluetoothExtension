//
//  CBService+Public.h
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBService (Public)
- (nonnull instancetype)disCovery:(CBUUID *)characteristicUUID
                 duration:(NSTimeInterval)duration
                 complete:(nonnull void(^)(CBCharacteristic *service))complete;
@end
