//
//  WeakObject.m
//  Pods
//
//  Created by 谈超 on 2018/6/15.
//

#import "WeakObject.h"
@implementation WeakObject
- (instancetype)initWithDeallocBlock:(void (^)(void))block{
    self = [super init];
    if (self) {
        self.deallocBlock = block;
    }
    return self;
}
- (void)dealloc {
    self.deallocBlock ? self.deallocBlock() : nil;
}
@end
