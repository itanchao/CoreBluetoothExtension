//
//  CBService+Private.m
//  Pods
//
//  Created by 谈超 on 2018/6/19.
//

#import "CBService+Private.h"
#import <objc/runtime.h>
@implementation CBService (Private)
- (NSMutableDictionary<NSString *,void (^)(CBCharacteristic *)> *)discoverCharacteristicClosures{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, _cmd);
    if (dic == nil) {
        dic = [@{} mutableCopy];
        [self setDiscoverCharacteristicClosures:dic];
    }
    return dic;
}
- (void)setDiscoverCharacteristicClosures:(NSMutableDictionary<NSString *,void (^)(CBCharacteristic *)> *)discoverCharacteristicClosures{
    objc_setAssociatedObject(self, @selector(discoverCharacteristicClosures), discoverCharacteristicClosures, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
