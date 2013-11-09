//
//  TPTipjarSessionManager.h
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

typedef void (^TPTipjarSessionCompletionBlock)(NSDictionary *response, NSError *error);

#import "AFHTTPSessionManager.h"

@interface TPTipjarSessionManager : NSObject

+ (instancetype)sharedManager;
- (void)GETTipCodeWithIdentifier:(NSString *)identifier completionBlock:(TPTipjarSessionCompletionBlock)block;
- (void)createTipWithAmount:(NSUInteger)amount forUserWithID:(NSUInteger)userID completionBlock:(TPTipjarSessionCompletionBlock)block;

@end
