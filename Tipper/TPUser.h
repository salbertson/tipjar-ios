//
//  TPUser.h
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

@interface TPUser : NSObject

@property (assign, nonatomic) NSUInteger identifier;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *email;

- (instancetype)initWithJSON:(NSDictionary *)JSON;

@end
