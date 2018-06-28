//
//  NSTimer+Public.h
//  Pods
//
//  Created by 谈超 on 2018/6/11.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Public)

/**
  Create and schedule a timer that will call `block` once after the specified time.


 @param interval TimeInterval
 @param block block
 @return NSTimer
 */
+(instancetype)after:(NSTimeInterval)interval block:(void(^_Nullable)(void))block;

/**
 Create and schedule a timer that will call `block` repeatedly in specified time intervals.

 @param interval TimeInterval
 @param block block
 @return NSTimer
 */
+(instancetype)every:(NSTimeInterval)interval block:(void(^_Nullable)(NSTimer *timer))block;
@end
