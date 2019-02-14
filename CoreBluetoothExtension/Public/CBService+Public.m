//
//  CBService+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import "CBService+Public.h"
#import "CBService+Private.h"
#import <ReactiveObjC/ReactiveObjC.h>
#define CallBlockIfNotNil(__MBK_Block__, ...) { if (__MBK_Block__) __MBK_Block__(__VA_ARGS__); }
@implementation CBService (Public)
- (instancetype)disCovery:(CBUUID *)characteristicUUID duration:(NSTimeInterval)duration complete:(void (^)(CBCharacteristic *))complete{
    if (characteristicUUID == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(complete,nil);
        });
        return self;
    }
    
    @weakify(self)
    RACDisposable *timeOut = [RACScheduler.mainThreadScheduler afterDelay:duration schedule:^{
        @strongify(self)
        CallBlockIfNotNil(self.discoverCharacteristicClosures[characteristicUUID.UUIDString],nil);
    }];
    [self.discoverCharacteristicClosures setObject:^void(CBCharacteristic *characteristic) {
        [timeOut dispose];
        @strongify(self)
        [self.discoverCharacteristicClosures removeObjectForKey:characteristicUUID.UUIDString];
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(complete,characteristic);
        });
    } forKey:characteristicUUID.UUIDString];
    
    for (CBCharacteristic *characteristic in self.characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:characteristicUUID.UUIDString]) {
            CallBlockIfNotNil(self.discoverCharacteristicClosures[characteristicUUID.UUIDString],characteristic);
            return self;
        }
    }
    [self.peripheral discoverCharacteristics:@[characteristicUUID] forService:self];
    return self;
}
@end
