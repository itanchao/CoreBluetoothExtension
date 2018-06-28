//
//  CBPeripheral+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/11.
//

#import "CBPeripheral+Public.h"
#import "CBPeripheral+Private.h"
#import "CBCentralManager+Public.h"
#import "NSTimer+Public.h"
@import ReactiveObjC;
@implementation CBPeripheral (Public)
- (void)disConnectionWithResulte:(void (^)(CBPeripheral *, NSError *))result{
    [self.centralManager cancelPeripheralConnection:self resulte:result];
}
- (instancetype)disCovery:(CBUUID *)serviceUUID duration:(NSTimeInterval)duration complete:(void (^)(CBService *))complete{
    // serviceUUID 为nil，则不进行搜索
    if (serviceUUID == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(nil);
        });
        return self;
    }
    
    @weakify(self)
    NSTimer *timer = [NSTimer after:duration block:^{
        @strongify(self)
        void(^discoveryClosure)(CBService *service) = self.discoverServiceClosures[serviceUUID.UUIDString];
        if (discoveryClosure) {
            discoveryClosure(nil);
        }
    }];
    @weakify(timer)
    [self.discoverServiceClosures setObject:^void(CBService *ser) {
        @strongify(self)
        [[self discoverServiceClosures] removeObjectForKey:serviceUUID.UUIDString];
        @strongify(timer)
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(ser);
        });
    } forKey:serviceUUID.UUIDString];
    
    for (CBService *ser in self.services) {
        if ([ser.UUID.UUIDString isEqualToString:serviceUUID.UUIDString]) {
            void(^discoveryClosure)(CBService *service) = self.discoverServiceClosures[ser.UUID.UUIDString];
            if (discoveryClosure) {
                discoveryClosure(ser);
            }
            return self;
        }
    }
    [self discoverServices:@[serviceUUID]];
    return self;
}
@end
