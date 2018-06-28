//
//  WeakObject.h
//  Pods
//
//  Created by 谈超 on 2018/6/15.
//

#import <Foundation/Foundation.h>
@interface WeakObject : NSObject
@property (nonatomic, copy) void (^deallocBlock)(void);
- (instancetype)initWithDeallocBlock:(void(^)(void))block;
@end
