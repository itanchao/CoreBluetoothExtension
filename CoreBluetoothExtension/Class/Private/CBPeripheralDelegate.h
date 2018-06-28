//
//  CBPeripheralDelegate.h
//  Pods
//
//  Created by 谈超 on 2018/6/13.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;
@interface CBPeripheralDelegate : NSObject<CBPeripheralDelegate>
+(nonnull instancetype)sharedDelegate;
@end
