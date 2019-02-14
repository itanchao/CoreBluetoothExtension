//
//  CBService+Private.h
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import <CoreBluetooth/CoreBluetooth.h>

@interface CBService (Private)
@property (nonatomic, strong) NSMutableDictionary<NSString *,void(^)(CBCharacteristic *characteristic)> *discoverCharacteristicClosures;

@end
