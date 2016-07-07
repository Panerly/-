//
//  PkeyChain.h
//  first
//
//  Created by HS on 16/6/13.
//  Copyright © 2016年 HS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PkeyChain : NSObject


+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;

@end
