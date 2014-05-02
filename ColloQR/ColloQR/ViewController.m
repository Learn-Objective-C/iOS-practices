//
//  ViewController.m
//  ColloQR
//
//  Created by Long Vinh Nguyen on 5/2/14.
//  Copyright (c) 2014 Home Inc. All rights reserved.
//

#import "ViewController.h"
#import "BarCode.h"
@import AVFoundation;

@interface ViewController ()<AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) IBOutlet UIView *previewView;

@end

@implementation ViewController
{
    AVCaptureSession *_captureSession;
    AVCaptureDevice *_videoDevice;
    AVCaptureDeviceInput *_videoInput;
    AVCaptureVideoPreviewLayer *_previewLayer;
    AVCaptureMetadataOutput *_metadataOutput;
    AVSpeechSynthesizer *_speechSynthesizer;
    NSMutableDictionary *_barCodes;
    BOOL _running;
    CGFloat _initialPinchZoom;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupCaptureSessioin];
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
    _previewLayer.frame = _previewView.bounds;
    [_previewView.layer addSublayer:_previewLayer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    _barCodes = [NSMutableDictionary new];
    _speechSynthesizer = [[AVSpeechSynthesizer alloc] init];
    [_previewView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)]];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self stopRunning];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Initilization
- (void)setupCaptureSessioin
{
    if (_captureSession) {
        return;
    }
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No camera on this device.");
        return;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];
    
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t metadataQueue = dispatch_queue_create("com.longnv.ColloQR.metadata", DISPATCH_QUEUE_SERIAL);
    [_metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
    
    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
    
}

- (void)startRunning
{
    if (!_running) {
        _metadataOutput.metadataObjectTypes = _metadataOutput.availableMetadataObjectTypes;
        [_captureSession startRunning];
        _running = YES;
    }
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:0 error:nil];
}

- (void)stopRunning
{
    if (_running) {
        [_captureSession stopRunning];
        _running = NO;
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationWillEnterForeground:(NSNotification *)n
{
    [self startRunning];
}

- (void)applicationDidEnterBackground:(NSNotification *)n
{
    [self stopRunning];
}

- (BarCode*)processMetadataObject:(AVMetadataMachineReadableCodeObject *)code
{
    BarCode *barcode = _barCodes[code.stringValue];
    if (!barcode) {
        barcode = [BarCode new];
        _barCodes[code.stringValue] = barcode;
    }
    
    barcode.metadataObject = code;
    
    CGMutablePathRef cornersPath = CGPathCreateMutable();
    
    CGPoint point;
    CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)code.corners[0], &point);
    CGPathMoveToPoint(cornersPath, nil, point.x, point.y);
    
    for (int i = 1; i < code.corners.count; i++) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)code.corners[i], &point);
        CGPathAddLineToPoint(cornersPath, nil, point.x, point.y);
    }
    
    CGPathCloseSubpath(cornersPath);
    barcode.cornerPath = [UIBezierPath bezierPathWithCGPath:cornersPath];
    CGPathRelease(cornersPath);
    
    barcode.boundingBoxPath = [UIBezierPath bezierPathWithRect:code.bounds];
    
    return barcode;
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)gesture
{
    if (!_videoDevice) {
        return;
    }
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        _initialPinchZoom = _videoDevice.videoZoomFactor;
    }
    
    //
    NSError *error = nil;
    [_videoDevice lockForConfiguration:&error];
    
    if (!error) {
        CGFloat zoomFactor;
        CGFloat scale = gesture.scale;
        if (scale < 1.0f) {
            zoomFactor = _initialPinchZoom - pow(_videoDevice.activeFormat.videoMaxZoomFactor, 1.0f - gesture.scale);
        } else {
            zoomFactor = _initialPinchZoom + pow(_videoDevice.activeFormat.videoMaxZoomFactor, (gesture.scale - 1.0f) / 2.0);
        }
        
        zoomFactor = MIN(10.0, zoomFactor);
        zoomFactor = MAX(1.0, zoomFactor);
        
        _videoDevice.videoZoomFactor = zoomFactor;
        
        [_videoDevice unlockForConfiguration];
    }
}

#pragma mark - AVMetaDataOutput delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSSet *originalBarCodes = [NSSet setWithArray:_barCodes.allValues];
    
    
    NSMutableSet *foundBarCodes = [NSMutableSet new];
    [metadataObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Metadata: %@", obj);
        if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject *)[_previewLayer transformedMetadataObjectForMetadataObject:obj];
            BarCode *barCode = [self processMetadataObject:code];
            [foundBarCodes addObject:barCode];
        }
    }];
    
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSArray *subLayers = [_previewView.layer.sublayers copy];
        [subLayers enumerateObjectsUsingBlock:^(CALayer *layer, NSUInteger idx, BOOL *stop) {
            if (layer != _previewLayer) {
                [layer removeFromSuperlayer];
            }
        }];
        
        // Add new layers
        [foundBarCodes enumerateObjectsUsingBlock:^(BarCode *barcode, BOOL *stop) {
            CAShapeLayer *boundingBoxLayer = [CAShapeLayer new];
            boundingBoxLayer.path = barcode.boundingBoxPath.CGPath;
            boundingBoxLayer.lineWidth = 2.0f;
            boundingBoxLayer.strokeColor = [UIColor greenColor].CGColor;
            boundingBoxLayer.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.5].CGColor;
            [_previewView.layer addSublayer:boundingBoxLayer];
            
            CAShapeLayer *cornerLayer = [CAShapeLayer new];
            cornerLayer.path = barcode.cornerPath.CGPath;
            cornerLayer.lineWidth = 2.0f;
            cornerLayer.strokeColor = [UIColor blueColor].CGColor;
            cornerLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.5].CGColor;
            [_previewView.layer addSublayer:cornerLayer];
        }];
        
        NSMutableSet *newBarcodes = [foundBarCodes mutableCopy];
        [newBarcodes minusSet:originalBarCodes];
        
        NSMutableSet *oldBarcodes = [originalBarCodes mutableCopy];
        [oldBarcodes minusSet:foundBarCodes];
        [oldBarcodes enumerateObjectsUsingBlock:^(BarCode *barcode, BOOL *stop) {
            [_barCodes removeObjectForKey:barcode.metadataObject.stringValue];
        }];
        
        [newBarcodes enumerateObjectsUsingBlock:^(BarCode *barcode, BOOL *stop) {
            AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:barcode.metadataObject.stringValue];
            utterance.rate = AVSpeechUtteranceMinimumSpeechRate + ((AVSpeechUtteranceMaximumSpeechRate - AVSpeechUtteranceMinimumSpeechRate) * 0.5);
            utterance.volume = 1.0f;
            utterance.pitchMultiplier = 1.2f;
            [_speechSynthesizer speakUtterance:utterance];
        }];
    });
}

- (IBAction)zoomView:(UISlider *)slider
{
    CGFloat zoomFactor = zoomFactorCalculate(_videoDevice.activeFormat.videoMaxZoomFactor, slider.value);
    [_videoDevice lockForConfiguration:nil];
    _videoDevice.videoZoomFactor = zoomFactor;
    [_videoDevice unlockForConfiguration];
}

CGFloat zoomFactorCalculate(CGFloat maxZoomFactor, CGFloat sliderValue)
{
    CGFloat factor = pow(maxZoomFactor, sliderValue);
    return MIN(10.0f, factor);
}


@end
