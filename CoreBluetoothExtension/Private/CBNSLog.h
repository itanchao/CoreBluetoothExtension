//
//  CBNSLog.h
//  Pods
//
//  Created by 谈超 on 2018/7/19.
//

#ifndef CBNSLog_h
#define CBNSLog_h


#endif /* CBNSLog_h */
#ifdef DEBUG
#define CBNSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define CBNSLog(...)
#endif

