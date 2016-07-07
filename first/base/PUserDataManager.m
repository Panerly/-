//
//  PUserDataManager.m
//  first
//
//  Created by HS on 16/6/13.
//  Copyright © 2016年 HS. All rights reserved.
//

#import "PUserDataManager.h"
#import "PkeyChain.h"

@implementation PUserDataManager

static NSString * const KEY_IN_KEYCHAIN = @"com.wuqian.app.allinfo";
static NSString * const KEY_PASSWORD = @"com.wuqian.app.password";

+(void)savePassWord:(NSString *)password
{
    NSMutableDictionary *usernamepasswordKVPairs = [NSMutableDictionary dictionary];
    [usernamepasswordKVPairs setObject:password forKey:KEY_PASSWORD];
    [PkeyChain save:KEY_IN_KEYCHAIN data:usernamepasswordKVPairs];
}

+(id)readPassWord
{
    NSMutableDictionary *usernamepasswordKVPair = (NSMutableDictionary *)[PkeyChain load:KEY_IN_KEYCHAIN];
    return [usernamepasswordKVPair objectForKey:KEY_PASSWORD];
}

+(void)deletePassWord
{
    [PkeyChain delete:KEY_IN_KEYCHAIN];
}

@end
