//
//  TPCodeScannerViewController.m
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "TPCodeScannerViewController.h"
@import AVFoundation;

@interface TPCodeScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (strong, nonatomic) AVCaptureSession *captureSession;
@property (strong, nonatomic) AVMetadataMachineReadableCodeObject *capturedObject;

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
    [self.captureSession startRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if (self.capturedObject)
        return;

    if ([metadataObjects count] == 0)
        return;

    self.capturedObject = [metadataObjects firstObject];

    NSLog(@"%@", [self.capturedObject stringValue]);
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

    [_captureSession addInput:deviceInput];
}

- (void)addMetadataCaptureDeviceOutput
{
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_captureSession addOutput:output];
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
}

@end
