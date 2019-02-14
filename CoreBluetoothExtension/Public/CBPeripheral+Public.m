//
//  CBPeripheral+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/11.
//

#import "CBPeripheral+Public.h"
#import "CBPeripheral+Private.h"
#import "CBCentralManager+Public.h"
#import <ReactiveObjC/ReactiveObjC.h>
@import ObjectiveC;
#define CallBlockIfNotNil(__MBK_Block__, ...) { if (__MBK_Block__) __MBK_Block__(__VA_ARGS__); }
@implementation CBPeripheral (Public)
- (void)disConnectionWithResulte:(void (^)(CBPeripheral *, NSError *))result{
    [self.centralManager cancelPeripheralConnection:self resulte:result];
}
- (instancetype)disCovery:(CBUUID *)serviceUUID duration:(NSTimeInterval)duration complete:(void (^)(CBService *))complete{
    // serviceUUID 为nil，则不进行搜索
    if (serviceUUID == nil) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(complete,nil);
        });
        return self;
    }
    
    @weakify(self)
    RACDisposable *timeOut = [RACScheduler.mainThreadScheduler afterDelay:duration schedule:^{
        @strongify(self)
        CallBlockIfNotNil(self.discoverServiceClosures[serviceUUID.UUIDString],nil);
    }];
    [self.discoverServiceClosures setObject:^void(CBService *ser) {
        @strongify(self)
        [[self discoverServiceClosures] removeObjectForKey:serviceUUID.UUIDString];
        [timeOut dispose];
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(complete,ser);
        });
    } forKey:serviceUUID.UUIDString];
    
    for (CBService *ser in self.services) {
        if ([ser.UUID.UUIDString isEqualToString:serviceUUID.UUIDString]) {
            CallBlockIfNotNil(self.discoverServiceClosures[ser.UUID.UUIDString],ser);
            return self;
        }
    }
    [self discoverServices:@[serviceUUID]];
    return self;
}
- (BOOL)autoConnect{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setAutoConnect:(BOOL)autoConnect{
    objc_setAssociatedObject(self, @selector(autoConnect), @(autoConnect), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
@end
