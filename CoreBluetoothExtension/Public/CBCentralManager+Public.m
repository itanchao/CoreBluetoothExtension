//
//  CBCentralManager+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/8.
//

#import "CBCentralManager+Public.h"
#import "CBCentralManagerDelegate.h"
#import "CBCentralManager+Private.h"
#import "CBPeripheral+Private.h"
#import "CBNSLog.h"
#import "CBPeripheral+Public.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <ReactiveObjC/NSObject+RACSelectorSignal.h>
#define CallBlockIfNotNil(__MBK_Block__, ...) { if (__MBK_Block__) __MBK_Block__(__VA_ARGS__); }
@implementation CBCentralManager (Public)
+ (instancetype)manager{
    return [[self alloc] initWithDelegate:CBCentralManagerDelegate.sharedDelegate queue:dispatch_queue_create("com.ble.queue.ble", DISPATCH_QUEUE_SERIAL) options:@{CBCentralManagerOptionShowPowerAlertKey:@0,CBConnectPeripheralOptionNotifyOnDisconnectionKey:@0}];
}
- (void)centralManagerDidUpdateState:(void (^)(CBCentralManager *))block{
    @weakify(self)
    NSAssert(self.delegate == CBCentralManagerDelegate.sharedDelegate, @"please use [CBCentralManager manager] initialize");
    [[[CBCentralManagerDelegate.sharedDelegate rac_signalForSelector:@selector(centralManagerDidUpdateState:)] takeUntil:self.rac_willDeallocSignal].deliverOnMainThread subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        if ([x.first isEqual:self]) {
            CallBlockIfNotNil(block,self);
        }
    }];
    // 手动触发一下
    [self.delegate centralManagerDidUpdateState:self];
}
- (CBCentralManager *)scanForPeripheralsWithServices:(NSArray<CBUUID *> *)serviceUUIDs options:(NSDictionary<NSString *,id> *)options duration:(NSTimeInterval)duration responseBlock:(void (^)(CBPeripheral *, NSDictionary<NSString *,id> *, NSNumber *, NSError *))responseBlock complete:(void (^)(void))complete{
    // 设置代理
    NSAssert(self.delegate == CBCentralManagerDelegate.sharedDelegate, @"please use [CBCentralManager manager] initialize");
    // 设置回调
    [self setScanResultClosure:^(CBPeripheral *peripheral, NSDictionary<NSString *,id> *advertisementData, NSNumber *RSSI, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(responseBlock,peripheral,advertisementData,RSSI,error)
        });
    }];
    // 当蓝牙状态为打开的时候开始扫描
    @weakify(self)
    RACDisposable *disposable = [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        RACDisposable *inner_disposer = [[[CBCentralManagerDelegate.sharedDelegate rac_signalForSelector:@selector(centralManagerDidUpdateState:)] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(RACTuple * _Nullable x) {
            @strongify(self)
            if ([x.first isEqual:self] && self.state == CBCentralManagerStatePoweredOn) {
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
    RACDisposable *timeOutdisposable = [RACScheduler.mainThreadScheduler afterDelay:duration  schedule:^{
        @strongify(self);
        [self stopScan];
        [disposable dispose];
    }];
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
    }].deliverOnMainThread subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self setScanResultClosure:nil];
        [timeOutdisposable dispose];
        CallBlockIfNotNil(complete);
    }];
    return self;
}
- (void)connectPeripheral:(CBPeripheral *)peripheral options:(NSDictionary<NSString *,id> *)options duration:(NSTimeInterval)duration complete:(void (^)(CBPeripheral *, NSError *))complete{
    NSAssert(self.delegate == CBCentralManagerDelegate.sharedDelegate, @"please use [CBCentralManager manager] initialize");
    if (peripheral.state == CBPeripheralStateConnected ) {
        CallBlockIfNotNil(complete,peripheral,nil)
        return;
    }
    @weakify(self)
    RACDisposable *timeOut = [RACScheduler.mainThreadScheduler afterDelay:duration schedule:^{
        @strongify(self)
        [self cancelPeripheralConnection:peripheral resulte:^(CBPeripheral *peripheral, NSError *error) {}];
        void (^connectClosure)(CBPeripheral *, NSError *) = [peripheral connectClosure];
        if (connectClosure) {
            connectClosure(peripheral,[NSError errorWithDomain:@"801" code:801 userInfo:@{@"message":@"time out"}]);
        }
    }];
    [peripheral setConnectClosure:^(CBPeripheral *peripheral, NSError *error) {
        [timeOut dispose];
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(complete,peripheral,error);
        });
    }];
    [self connectPeripheral:peripheral options:options];
}
- (void)cancelPeripheralConnection:(CBPeripheral *)peripheral resulte:(void (^)(CBPeripheral *, NSError *))result{
    CBNSLog(@"开始断开链接***");
    peripheral.autoConnect = NO;
    if (peripheral.state == CBPeripheralStateDisconnected) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(result,peripheral,nil);
        });
        return;
    }
    [peripheral setDisconnectClosure:^(CBPeripheral *peripheral, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CallBlockIfNotNil(result,peripheral,error);
        });
    }];
    [self cancelPeripheralConnection:peripheral];
}
@end
