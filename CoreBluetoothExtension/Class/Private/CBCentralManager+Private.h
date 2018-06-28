//
//  CBCentralManager+Private.h
//  Pods
//
//  Created by 谈超 on 2018/6/13.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBCentralManager (Private)
@property (nonatomic, copy) void(^scanResultClosure)(CBPeripheral *peripheral,NSDictionary<NSString *, id> * advertisementData,NSNumber *RSSI,NSError *error);
@end
