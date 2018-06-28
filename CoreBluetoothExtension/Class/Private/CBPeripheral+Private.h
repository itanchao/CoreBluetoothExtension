//
//  CBPeripheral+Private.h
//  Pods
//
//  Created by 谈超 on 2018/6/13.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBPeripheral (Private)

@property (nonatomic, copy) void(^connectClosure)(CBPeripheral *peripheral,NSError *error);

@property (nonatomic, copy) void(^disconnectClosure)(CBPeripheral *peripheral,NSError *error);

@property (nonatomic, strong) NSMutableDictionary<NSString *,void(^)(CBService *service)> *discoverServiceClosures;

@property (nonatomic, weak) CBCentralManager *centralManager;
/**
 是否需要手动重连
 */
@property (nonatomic, assign) BOOL autoConnect;

@end
