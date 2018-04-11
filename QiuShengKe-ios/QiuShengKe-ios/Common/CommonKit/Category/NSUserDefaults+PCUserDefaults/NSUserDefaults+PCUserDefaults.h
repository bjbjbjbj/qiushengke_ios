//
//  NSUserDefaults+UserDefaults.h
//  PCCoreKit
//
//  Created by Mao Zhijun on 12-8-7.
//  Copyright (c) 2012年 PConline.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (PCUserDefaults)

//访问NSUserDefaults的公共数据
+ (id) getObjectFromNSUserDefaultsWithKeyPC:(NSString *)key;
+ (void) setObjectToNSUserDefaultsPC:(id)object withKey:(NSString *)key;
+ (void) removeObjectFromNSUserDefaultsWithKeyPC:(NSString *)key;
@end
