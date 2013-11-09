//
//  TPTipjarSessionManager.m
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "TPTipjarSessionManager.h"

@interface TPTipjarSessionManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

@implementation TPTipjarSessionManager

#pragma mark - Initialization

+ (instancetype)sharedManager
{
    static TPTipjarSessionManager *manager;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [self new];
    });

    return manager;
}

- (id)init
{
    self = [super init];

    if (!self)
        return nil;

    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[self baseURL]];
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];

    return self;
}

#pragma mark - API

#pragma mark Endpoints

- (void)GETTipCodeWithIdentifier:(NSString *)identifier completionBlock:(TPTipjarSessionCompletionBlock)block
{
    NSString *path = [[NSString stringWithFormat:@"tip_codes/%@", identifier] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Path: %@", path);

    [self.sessionManager GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

- (void)createTipWithAmount:(NSUInteger)amount forUserWithID:(NSUInteger)userID completionBlock:(TPTipjarSessionCompletionBlock)block
{
    NSString *path = [NSString stringWithFormat:@"users/%u/tips", userID];
    NSDictionary *parameters = (@{
                                  @"amount": @(amount)
                                  });

    [self.sessionManager POST:path parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if (block) {
            block(responseObject, nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
    }];
}

#pragma mark Initialization Helpers

- (NSURL *)baseURL;
{
    return [NSURL URLWithString:@"http://192.168.4.158:3000/api/"];
}

@end
