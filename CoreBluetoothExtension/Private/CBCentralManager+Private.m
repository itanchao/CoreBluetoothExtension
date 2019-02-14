//
//  CBCentralManager+Private.m
//  Pods
//
//  Created by 谈超 on 2018/6/13.
//

#import "CBCentralManager+Private.h"
#import <objc/runtime.h>

@implementation CBCentralManager (Private)
static const int *scanResultClosureKey = 0;
- (void)setScanResultClosure:(void (^)(CBPeripheral *, NSDictionary<NSString *,id> *, NSNumber *, NSError *))scanResultClosure{
    objc_setAssociatedObject(self, scanResultClosureKey, scanResultClosure, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(CBPeripheral *, NSDictionary<NSString *,id> *, NSNumber *, NSError *))scanResultClosure{
    return objc_getAssociatedObject(self, scanResultClosureKey);
}
@end
