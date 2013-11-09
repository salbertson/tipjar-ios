//
//  TPCodeScannerViewController.m
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "TPCodeScannerViewController.h"
@import AVFoundation;
#import "TPUser.h"
#import "TPSendTipViewController.h"
#import "TPTipjarSessionManager.h"

static NSString *const TPSendTipViewControllerStoryboardIdentifier = @"TPSendTipViewController";

@interface TPCodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;

@end

@implementation TPCodeScannerViewController

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (!self)
        return nil;

    [self addVideoCaptureDeviceInput];
    [self addMetadataCaptureDeviceOutput];

    return self;
}

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    previewLayer.frame = self.view.bounds;

    [self.view.layer addSublayer:previewLayer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.captureSession startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ([metadataObjects count] == 0)
        return;

    [self.captureSession stopRunning];
    [self validateCapturedObject:[metadataObjects firstObject]];
}

#pragma mark - API

#pragma mark Properties

- (AVCaptureSession *)captureSession
{
    if (!_captureSession)
        _captureSession = [AVCaptureSession new];

    return _captureSession;
}

#pragma mark Configuring the Capture Session

- (void)addVideoCaptureDeviceInput
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];

    if (!deviceInput)
        NSLog(@"Error creating input device: %@, %@", error, error.userInfo);

    [self.captureSession addInput:deviceInput];
}

- (void)addMetadataCaptureDeviceOutput
{
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.captureSession addOutput:output];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
}

#pragma mark Validating Codes

- (void)validateCapturedObject:(AVMetadataMachineReadableCodeObject *)capturedObject
{
    [[TPTipjarSessionManager sharedManager] GETTipCodeWithIdentifier:[capturedObject stringValue] completionBlock:^(NSDictionary *response, NSError *error) {
        if (!response) {
            NSLog(@"Error getting tip code with identifier: %@.\n%@, %@", [capturedObject stringValue], error, error.userInfo);
            return;
        }

        TPUser *user = [[TPUser alloc] initWithJSON:response];
        [self pushSendTipViewControllerForUser:user];
    }];
}

#pragma mark Pushing the Send Tip View Controller

- (void)pushSendTipViewControllerForUser:(TPUser *)user
{
    TPSendTipViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:TPSendTipViewControllerStoryboardIdentifier];
    viewController.tipReceiver = user;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
