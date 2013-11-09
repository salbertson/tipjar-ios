//
//  TPSendTipViewController.m
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "TPSendTipViewController.h"
#import "TPUser.h"
#import "TPTipjarSessionManager.h"

@interface TPSendTipViewController ()

@property (weak, nonatomic) IBOutlet UILabel *tipReceiverNameLabel;

@end

@implementation TPSendTipViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tipReceiverNameLabel.text = self.tipReceiver.name;
}

- (IBAction)sendOneDollar:(UIButton *)sender
{
    [self sendTipAmount:1];
}

- (IBAction)sendFiveDollars:(UIButton *)sender
{
    [self sendTipAmount:5];
}

- (void)sendTipAmount:(NSUInteger)amount
{
    [[TPTipjarSessionManager sharedManager] createTipWithAmount:amount forUserWithID:self.tipReceiver.identifier completionBlock:[self completionBlockForTipAmount:amount]];
}

- (TPTipjarSessionCompletionBlock)completionBlockForTipAmount:(NSUInteger)amount
{
    return ^(NSDictionary *response, NSError *error) {
        if (!response) {
            NSLog(@"Error creating tip. %@, %@", error, error.userInfo);
        }

        NSLog(@"Successfully sent tip with amount: %u", amount);
    };
}

@end
