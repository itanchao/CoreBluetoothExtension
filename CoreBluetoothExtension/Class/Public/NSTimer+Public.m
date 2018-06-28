//
//  NSTimer+Public.m
//  Pods
//
//  Created by 谈超 on 2018/6/11.
//

#import "NSTimer+Public.h"

@implementation NSTimer (Public)
+ (instancetype)every:(NSTimeInterval)interval block:(void (^)(NSTimer *))block{
    return [[self timerWithInterval:interval repeat:YES block:block] _startRunloop];
}
+(instancetype)after:(NSTimeInterval)interval block:(void(^_Nullable)(void))block{
    return [[self timerWithInterval:interval repeat:NO block:^(NSTimer *t) {
        block();
        [t invalidate];
    }] _startRunloop];
}
+(instancetype)timerWithInterval:(NSTimeInterval)interval repeat:(BOOL)repeat block:(void (^)(NSTimer *))block{
    return CFBridgingRelease(CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + interval, repeat?interval:0, 0, 0, ^(CFRunLoopTimerRef timer) {
        block((__bridge NSTimer *)(timer));
    }));
}
- (instancetype)_startRunloop{
    [[NSRunLoop currentRunLoop] addTimer:self forMode: NSDefaultRunLoopMode];
    return self;
}
@end
