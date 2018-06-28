#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CBCentralManager+Public.h"
#import "CBCharacteristic+Public.h"
#import "CBPeripheral+Public.h"
#import "CBService+Public.h"
#import "NSTimer+Public.h"

FOUNDATION_EXPORT double CoreBluetoothExtensionVersionNumber;
FOUNDATION_EXPORT const unsigned char CoreBluetoothExtensionVersionString[];

