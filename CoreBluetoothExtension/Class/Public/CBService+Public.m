//
//  CBService+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import "CBService+Public.h"
#import "NSTimer+Public.h"
#import "CBService+Private.h"
@import ReactiveObjC;
@implementation CBService (Public)
- (instancetype)disCovery:(CBUUID *)characteristicUUID duration:(NSTimeInterval)duration complete:(void (^)(CBCharacteristic *))complete{
    if (characteristicUUID == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(nil);
        });
        return self;
    }
    
    @weakify(self)
    NSTimer *timer = [NSTimer after:duration block:^{
        @strongify(self)
        void(^discoveryClosure)(CBCharacteristic *service) = self.discoverCharacteristicClosures[characteristicUUID.UUIDString];
        if (discoveryClosure) {
            discoveryClosure(nil);
        }
    }];
    
    @weakify(timer)
    [self.discoverCharacteristicClosures setObject:^void(CBCharacteristic *characteristic) {
        @strongify(timer)
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        @strongify(self)
        [self.discoverCharacteristicClosures removeObjectForKey:characteristicUUID.UUIDString];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(characteristic);
        });
    } forKey:characteristicUUID.UUIDString];
    
    for (CBCharacteristic *characteristic in self.characteristics) {
        if ([characteristic.UUID.UUIDString isEqualToString:characteristicUUID.UUIDString]) {
            void(^discoveryClosure)(CBCharacteristic *service) = self.discoverCharacteristicClosures[characteristicUUID.UUIDString];
            if (discoveryClosure) {
                discoveryClosure(characteristic);
            }
            return self;
        }
    }
    [self.peripheral discoverCharacteristics:@[characteristicUUID] forService:self];
    return self;
}
@end
