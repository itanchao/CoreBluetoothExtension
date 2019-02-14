//
//  CBCentralManagerDelegate.h
//  Pods
//
//  Created by 谈超 on 2018/6/8.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@interface CBCentralManagerDelegate : NSObject<CBCentralManagerDelegate>
+ (nonnull instancetype)sharedDelegate NS_SWIFT_NAME(shared());
@end
