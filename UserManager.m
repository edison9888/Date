//
//  UserManager.m
//  Date
//
//  Created by maoyu on 12-11-12.
//  Copyright (c) 2012年 Liu&Mao. All rights reserved.
//

#import "UserManager.h"

static UserManager * sUserManager;

@implementation UserManager {
    NSDictionary *_userAuthData;
    NSDictionary *_userData;
}

@synthesize userID = _userID;
@synthesize screenName = _screenName;
@synthesize imageUrl = _imageUrl;
@synthesize accessToken = _accessToken;
@synthesize expirationDate = _expirationDate;
@synthesize refreshToken = _refreshToken;

#pragma 私有函数
- (BOOL)checkJsonValue:(id)value{
    return [value isKindOfClass:[NSString class]];
}

#pragma 类成员函数
+ (UserManager *)defaultManager {
    if (nil == sUserManager) {
        sUserManager = [[UserManager alloc] init];
    }
    
    return sUserManager;
}

- (id)init {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _userAuthData = [defaults objectForKey:@"SinaWeiboAuthData"];
        _userData = [defaults objectForKey:@"UserData"];
    }
    
    return self;
}


- (void)storeUserAuthData:(NSString *)userID withAccessToken:(NSString *)accessToken withExpirationDate:(NSDate *)expirationDate {
    
    if (userID == nil ||
   accessToken == nil ||
expirationDate == nil) {
        return;
    }
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              accessToken, @"AccessTokenKey",
                              expirationDate, @"ExpirationDateKey",
                              userID, @"UserIDKey",
                              nil, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

- (void)removeUserAuthData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (NSString *)userID {
    return [_userAuthData objectForKey:@"UserIDKey"];
}

- (NSString *)accessToken {
    return [_userAuthData objectForKey:@"AccessTokenKey"];
}

- (NSDate *)expirationDate {
    return [_userAuthData objectForKey:@"ExpirationDateKey"];
}

- (void)storeUserData:(NSString *)screenName withImageUrl:(NSString *)imageUrl {
    if (nil == screenName ||
        nil == imageUrl) {
        return;
    }
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              screenName, @"ScreenNameKey",
                              imageUrl, @"ImageUrlKey", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"UserData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeUserData {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserData"];
}

- (NSString *)screenName {
    return [_userData objectForKey:@"ScreenNameKey"];
}

- (NSString *)imageUrl {
    return [_userData objectForKey:@"ImageUrlKey"];
}

- (BOOL)analyzeData:(NSDictionary *)wrapped {
    id screenName = [wrapped objectForKey:kSinaWeiboScreenNameKey];
    if (! [self checkJsonValue:screenName]) {
        return NO;
    }
    
    id imageUrl = [wrapped objectForKey:kSinaWeiboProfileImageUrlKey];
    if (![self checkJsonValue:imageUrl]) {
        return NO;
    }
    
    [self storeUserData:screenName withImageUrl:imageUrl];
    
    return YES;
}

@end