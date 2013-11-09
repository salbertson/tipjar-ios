//
//  TPUser.m
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "TPUser.h"

@implementation TPUser

- (instancetype)initWithJSON:(NSDictionary *)JSON
{
    self = [super init];

    if (!self)
        return nil;

    _identifier = [JSON[@"user"][@"id"] integerValue];
    _name = JSON[@"user"][@"name"];
    _email = JSON[@"user"][@"email"];

    return self;
}

@end
