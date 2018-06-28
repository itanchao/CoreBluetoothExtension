//
//  CBService+Public.h
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBService (Public)
- (instancetype)disCovery:(CBUUID *)characteristicUUID
                 duration:(NSTimeInterval)duration
                 complete:(void(^)(CBCharacteristic *service))complete;
@end
