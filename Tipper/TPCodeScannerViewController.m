//
//  TPCodeScannerViewController.m
//  Tipper
//
//  Created by Mark Adams on 11/8/13.
//  Copyright (c) 2013 Mark Adams. All rights reserved.
//

#import "TPCodeScannerViewController.h"
@import AVFoundation;

@interface TPCodeScannerViewController ()

@property (strong, nonatomic) AVCaptureSession *captureSession;

@end

@implementation TPCodeScannerViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];

    if (!self)
        return nil;

    _captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];

    if (!deviceInput)
        NSLog(@"Erro creating input device: %@, %@", error, error.userInfo);

    [_captureSession addInput:deviceInput];


    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    AVCaptureVideoPreviewLayer *previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.captureSession];
    previewLayer.frame = self.view.bounds;

    [self.view.layer addSublayer:previewLayer];
    [self.captureSession startRunning];
}

@end
