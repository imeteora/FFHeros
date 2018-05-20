//
//  ffPreference.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffPreference.h"

@interface ffPreference ()
{
    NSUserDefaults *_userDefaults;
}
@end

@implementation ffPreference

- (NSUserDefaults *)userDefaults {
    if (!_userDefaults) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:[self configName]];
    }
    return _userDefaults;
}

- (void)sync
{
    [[self userDefaults] synchronize];
}

- (NSString * __nullable)configName
{
    return nil;
}

- (NSDictionary * __nullable)defaultConfig
{
    return nil;
}

@end
