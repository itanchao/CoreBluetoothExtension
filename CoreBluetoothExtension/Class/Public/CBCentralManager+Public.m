//
//  CBCentralManager+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/8.
//

#import "CBCentralManager+Public.h"
#import "CBCentralManagerDelegate.h"
#import "NSTimer+Public.h"
#import "CBCentralManager+Private.h"
#import "CBPeripheral+Private.h"
@import ReactiveObjC;
#import <ReactiveObjC/NSObject+RACSelectorSignal.h>
@implementation CBCentralManager (Public)
+ (instancetype)newCentral{
     return [[self alloc] initWithDelegate:CBCentralManagerDelegate.sharedDelegate queue:dispatch_queue_create("com.MobikeCoreBluetooth.queue.ble", DISPATCH_QUEUE_SERIAL)];
}
- (CBCentralManager *)scanForPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary<NSString *,id> *)options duration:(NSTimeInterval)duration responseBlock:(void (^)(CBPeripheral *, NSDictionary<NSString *,id> *, NSNumber *, NSError *))responseBlock complete:(void (^)(void))complete{
    // 设置代理
    self.delegate = CBCentralManagerDelegate.sharedDelegate;
    // 设置回调
    [self setScanResultClosure:^(CBPeripheral *peripheral, NSDictionary<NSString *,id> *advertisementData, NSNumber *RSSI, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseBlock) {
                responseBlock(peripheral,advertisementData,RSSI,error);
            }
        });
    }];
    // 当蓝牙状态为打开的时候开始扫描
    @weakify(self)
    RACDisposable *disposable = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        RACDisposable *inner_disposer = [[CBCentralManagerDelegate.sharedDelegate rac_signalForSelector:@selector(centralManagerDidUpdateState:)] subscribeNext:^(id  _Nullable x) {
            if (self.state == CBCentralManagerStatePoweredOn) {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return [RACDisposable disposableWithBlock:^{
            [inner_disposer dispose];
        }];
    }] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self scanForPeripheralsWithServices:serviceUUIDs options:options];
    }];
    // 手动调用一下触发扫描
    [self.delegate centralManagerDidUpdateState:self];
    // 超时定时器
    NSTimer *durationTimer = [NSTimer after:duration block:^{
        @strongify(self);
        [self stopScan];
        [disposable dispose];
    }];
    @weakify(durationTimer)
    // 监听stopScan方法，停止扫描定时器以及回调闭包
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        RACDisposable *inner_disposer = [[self rac_signalForSelector:@selector(stopScan)] subscribeNext:^(RACTuple * _Nullable x) {
            [subscriber sendNext:nil];
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
            [inner_disposer dispose];
        }];
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(durationTimer)
        @strongify(self)
        [self setScanResultClosure:nil];
        if (durationTimer) {
            [durationTimer invalidate];
            durationTimer = nil;
        }
        if (complete) {
            dispatch_async(dispatch_get_main_queue(), ^{
                complete();
            });
        }
    }];
    return self;
}
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary<NSString *,id> *)options duration:(NSTimeInterval)duration complete:(void (^)(CBPeripheral *, NSError *))complete{
    self.delegate = CBCentralManagerDelegate.sharedDelegate;
    @weakify(self)
    NSTimer *timer = [NSTimer after:duration block:^{
        @strongify(self)
        [self cancelPeripheralConnection:peripheral resulte:^(CBPeripheral *peripheral, NSError *error) {}];
        void (^connectClosure)(CBPeripheral *, NSError *) = [peripheral connectClosure];
        if (connectClosure) {
            connectClosure(peripheral,[NSError errorWithDomain:@"801" code:801 userInfo:@{@"message":@"time out"}]);
        }
    }];
    
    @weakify(timer)
    [peripheral setConnectClosure:^(CBPeripheral *peripheral, NSError *error) {
        @strongify(timer)
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [peripheral setAutoConnect:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (complete) {
                complete(peripheral,error);
            }
        });
    }];
    [self connectPeripheral:peripheral options:options];
}
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral resulte:(void (^)(CBPeripheral *, NSError *))result{
    peripheral.autoConnect = NO;
    if (peripheral.state == CBPeripheralStateDisconnected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(peripheral,nil);
            }
        });
        return;
    }
    [peripheral setDisconnectClosure:^(CBPeripheral *peripheral, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (result) {
                result(peripheral,error);
            }
        });
    }];
    self.delegate = CBCentralManagerDelegate.sharedDelegate;
    [self cancelPeripheralConnection:peripheral];
}
@end
