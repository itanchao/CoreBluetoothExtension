//
//  CBCharacteristic+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import "CBCharacteristic+Public.h"
#import "CBCharacteristic+Private.h"
#import "NSTimer+Public.h"
#import "CBNSLog.h"
@import ReactiveObjC;
//static dispatch_semaphore_t match_sema;
@implementation CBCharacteristic (Public)
- (instancetype)notify:(void (^)(BOOL))sucess{
    if (self.isNotifying) {
        if (sucess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                sucess(YES);
            });
        }
        return self;
    }
    @weakify(self)
    [self setNotifyClosure:^(BOOL b) {
        @strongify(self)
        if (sucess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                sucess(b);
            });
        }
        if (self) {
            [self setNotifyClosure:nil];
        }
    }];
    [self.service.peripheral setNotifyValue:YES forCharacteristic:self];
    return self;
}

- (instancetype)sendMessage:(NSData *)message duration:(NSTimeInterval)duration retryTimes:(NSInteger)retryTimes result:(void (^)(BOOL))sucess{
    dispatch_async(self.writeQueue, ^{
        dispatch_semaphore_t match_sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_main_queue(), ^{
            @weakify(self)
            __block NSInteger retryTs = retryTimes;
            NSTimer *timer = [NSTimer after:duration block:^{
                @strongify(self)
                if (self) {
                    retryTs = 0;
                    void(^sucess)(BOOL) = self.sendMessageClosure;
                    if (sucess) {
                        sucess(false);
                    }
                }
            }];
            @weakify(timer)
            [self setSendMessageClosure:^(BOOL result) {
                CBNSLog(@"写入%@====%@",[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding],result?@"成功":@"失败");
                @strongify(self)
                if (--retryTs >= 0 && !result) {
                    CBNSLog(@"开始第%ld重写====%@",retryTimes - retryTs,[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]);
                    [self.service.peripheral writeValue:message forCharacteristic:self type:CBCharacteristicWriteWithResponse];
                }else{
                    @strongify(timer)
                    [timer invalidate];
                    if (sucess) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            sucess(result);
                        });
                    }
                    dispatch_semaphore_signal(match_sema);
                    @strongify(self)
                    if (self) {
                        [self setSendMessageClosure:nil];
                    }
                }
            }];
        });
        CBNSLog(@"开始写入==%@",[[NSString alloc] initWithData:message encoding:NSUTF8StringEncoding]);
        if (self.service.peripheral.state != CBPeripheralStateConnected) {
            self.sendMessageClosure(NO);
        }else if (self.properties & CBCharacteristicPropertyWriteWithoutResponse) {
            [self.service.peripheral writeValue:message forCharacteristic:self type:CBCharacteristicWriteWithoutResponse];
            self.sendMessageClosure(YES);
        }else if (self.properties & CBCharacteristicPropertyWrite){
            [self.service.peripheral writeValue:message forCharacteristic:self type:CBCharacteristicWriteWithResponse];
        }else{
            self.sendMessageClosure(NO);
        }
        dispatch_semaphore_wait(match_sema, DISPATCH_TIME_FOREVER);
    });
    return self;
}
- (instancetype)notifyValueDidUpdate:(void (^)(CBCharacteristic *, NSError *))valueDidUpdateBlock{
    [self setNotifyValueDidUpdate:^(CBCharacteristic *cha, NSError *error) {
        if (valueDidUpdateBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                valueDidUpdateBlock(cha,error);
            });
        }
    }];
    return self;
}
@end
