//
//  CBPeripheral+Private.m
//  Pods
//
//  Created by 谈超 on 2018/6/13.
//

#import "CBPeripheral+Private.h"
#import <objc/runtime.h>
#import "WeakObject.h"
@implementation CBPeripheral (Private)
- (NSMutableDictionary<NSString *,void (^)(CBService *)> *)discoverServiceClosures{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    if (dic == nil) {
        dic = [@{} mutableCopy];
        [self setDiscoverServiceClosures:dic];
    }
    return dic;
}
- (void)setDiscoverServiceClosures:(NSMutableDictionary<NSString *,void (^)(CBService *)> *)discoverServiceClosures{
    objc_setAssociatedObject(self, @selector(discoverServiceClosures), discoverServiceClosures, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setConnectClosure:(void (^)(CBPeripheral *, NSError *))connectClosure{
    objc_setAssociatedObject(self, @selector(connectClosure), connectClosure, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(CBPeripheral *, NSError *))connectClosure{
    return objc_getAssociatedObject(self, _cmd);
}
- (void (^)(CBPeripheral *, NSError *))disconnectClosure{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setDisconnectClosure:(void (^)(CBPeripheral *, NSError *))disconnectClosure{
    objc_setAssociatedObject(self, @selector(disconnectClosure), disconnectClosure, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void)setCentralManager:(CBCentralManager *)centralManager{
    WeakObject *ob = [[WeakObject alloc] initWithDeallocBlock:^{
        objc_setAssociatedObject(self, @selector(centralManager), nil, OBJC_ASSOCIATION_ASSIGN);
    }];
    // 这里关联的key必须唯一，如果使用_cmd，对一个对象多次关联的时候，前面的对象关联会失效。
    objc_setAssociatedObject(centralManager, (__bridge const void *)(ob.deallocBlock), ob, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, @selector(centralManager), centralManager, OBJC_ASSOCIATION_ASSIGN);
}
- (CBCentralManager *)centralManager{
    return objc_getAssociatedObject(self, _cmd);
}
- (BOOL)autoConnect{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (void)setAutoConnect:(BOOL)autoConnect{
    objc_setAssociatedObject(self, @selector(autoConnect), @(autoConnect), OBJC_ASSOCIATION_ASSIGN);
}
@end
