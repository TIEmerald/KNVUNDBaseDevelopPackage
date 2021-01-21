//
//  KNVUNDScannerHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/1/18.
//

#import "KNVUNDScannerHelper.h"

#import <AVFoundation/AVFoundation.h>

@protocol KNVUNDSHScannerModelDelegate <NSObject>
- (void)didCaptureCodeString: (NSString *)codeString;
@end

@interface KNVUNDSHScannerModel : KNVUNDBaseModel <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, weak) id<KNVUNDSHScannerModelDelegate> delegate;
@property (nonatomic, weak) UIView *relatedPreviewView;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

#pragma mark - Initial
- (instancetype)initScannerOnView: (UIView *)view;

#pragma mark - General Methods
- (void)changeCameraPosition: (AVCaptureDevicePosition)position;
- (void)start;
- (void)stop;

@end

@implementation KNVUNDSHScannerModel

#pragma mark - KNVUNDBaseModel
//- (BOOL)shouldShowRelatedLog
//{
//    return YES;
//}

#pragma mark - Initial
- (instancetype)initScannerOnView: (UIView *)view
{
    if (self = [super init]) {
        self.relatedPreviewView = view;
    }
    
    return self;
}

#pragma mark - Memory
- (void)dealloc
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    self.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark - General Methods
- (void)setUpModelWithSuccessHandler:(void(^)(void))successHandler andTheErrorHandler:(void(^)(NSString *errorMessage))errorHandler
{
    __weak typeof(self) weakSelf = self;
    [self checkingCameraAccessWithSuccessfulHandler:^{
        __strong typeof(self) strongWeakSelf = weakSelf;
        if (strongWeakSelf == nil) {
            return;
        }
        [strongWeakSelf setUpAVCaptureSession];
        if (successHandler) {
            successHandler();
        }
    } andErrorHandler:errorHandler];
}

- (void)setUpOritationOfScannerView
{
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortraitUpsideDown];
    }else if (deviceOrientation == UIInterfaceOrientationPortrait) {
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    }else if (deviceOrientation == UIInterfaceOrientationLandscapeLeft) {
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeLeft];
    }else{
        [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationLandscapeRight];
    }
}

- (void)start
{
    [self.captureSession startRunning];
}

- (void)stop
{
    [self.captureSession stopRunning];
}

- (void)changeCameraPosition: (AVCaptureDevicePosition)position
{
    // Change camera source
    // Check if the there is a camera available
    if(self.captureSession && self.captureSession.inputs.count > 0) {
        //Get new input
        AVCaptureDevice *newCamera = [self cameraWithPosition:position];
        
        if (newCamera) {
            //Indicate that some changes will be made to the session
            [self.captureSession beginConfiguration];
            
            //Remove existing input
            AVCaptureInput* currentCameraInput = [_captureSession.inputs objectAtIndex:0];
            [_captureSession removeInput:currentCameraInput];
            
            // Add input to session (Bugfix: check if newVidInput is valid to avoid crash for 1st time running app in device)
            AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:newCamera error:nil];
            if(!newVideoInput)
                return;
            
            [_captureSession addInput:newVideoInput];
            
            //Commit all the configuration changes at once
            [_captureSession commitConfiguration];
        }
        
    }
}

// Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices)
    {
        if ([device position] == position) return device;
    }
    return nil;
}

#pragma mark Support Methods
- (void)checkingCameraAccessWithSuccessfulHandler:(void(^)(void))successfulHandler andErrorHandler:(void(^)(NSString *errorMessage))errorHandler
{
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
        case AVAuthorizationStatusAuthorized:{
            if (successfulHandler) {
                successfulHandler();
            }
            break;
        }
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                     completionHandler:^(BOOL granted) {
                                         if (granted && successfulHandler) {
                                             successfulHandler();
                                         } else if (!granted && errorHandler) {
                                             errorHandler(@"Camera permission denied");
                                         }
                                     }];
            break;
        }
        case AVAuthorizationStatusDenied:{
            if (errorHandler) {
                errorHandler(@"User has previously denied access.");
            }
            break;
        }
        case AVAuthorizationStatusRestricted:{
            if (errorHandler) {
                errorHandler(@"User can't grant access due to restrictions.");
            }
            break;
        }
    }
}

- (void)setUpAVCaptureSession
{
    self.captureSession = [[AVCaptureSession alloc] init];
    AVCaptureDevice *videoCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoCaptureDevice error:&error];
    
    if(videoInput){
        [self.captureSession addInput:videoInput];
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1280x720];
        
        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        [self.captureSession addOutput:metadataOutput];
        [metadataOutput setMetadataObjectsDelegate:self
                                             queue:dispatch_get_main_queue()];
        
        // Support QRCode and Code 128
        [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code]];
        
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        self.previewLayer.frame = self.relatedPreviewView.layer.bounds;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        [self.relatedPreviewView.layer addSublayer:self.previewLayer];
        [self setUpOritationOfScannerView];
        
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(setUpOritationOfScannerView)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
    }
}

#pragma mark - Delegates
#pragma mark AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"KNVUNDScannerHelper AVCaptureMetadataOutputObjectsDelegate has been triggered with count %@",
     @([metadataObjects count])];
    
    for(AVMetadataObject *metadataObject in metadataObjects)
    {
        AVMetadataMachineReadableCodeObject *readableObject = (AVMetadataMachineReadableCodeObject *)metadataObject;
        if([metadataObject.type isEqualToString:AVMetadataObjectTypeQRCode])
        {
            if ([self.delegate respondsToSelector:@selector(didCaptureCodeString:)]) {
                [self.delegate didCaptureCodeString:readableObject.stringValue];
            }
        }
        else if ([metadataObject.type isEqualToString:AVMetadataObjectTypeCode128Code])
        {
            if ([self.delegate respondsToSelector:@selector(didCaptureCodeString:)]) {
                [self.delegate didCaptureCodeString:readableObject.stringValue];
            }
        }
    }
}

@end

@interface KNVUNDScannerHelper(){
    KNVUNDSHResultHandlerBlock _storedResultHandlerBlock;
    KNVUNDSHScannerModel *_usingScanner;
    NSString *_storedScannedString;
}

@property (nonatomic) AVCaptureDevicePosition currentCaptureDevicePosition; // Default is Font

@end

@implementation KNVUNDScannerHelper

#pragma mark - KNVUNDBaseModel
//- (BOOL)shouldShowRelatedLog
//{
//    return YES;
//}

#pragma mark - Getters && Setters
#pragma mark - Getters
- (AVCaptureDevicePosition)currentCaptureDevicePosition
{
    if (_currentCaptureDevicePosition == AVCaptureDevicePositionUnspecified) {
        _currentCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    return _currentCaptureDevicePosition;
}

#pragma mark - Set Up
- (void)setUpCurrentHelperWithScanningDisplayingView:(UIView *_Nonnull)displayingView andScannedResultReceivedBlock:(KNVUNDSHResultHandlerBlock _Nonnull)handler
{
    [self setUpCurrentHelperWithScanningDisplayingView:displayingView
                         andScannedResultReceivedBlock:handler
                                           errorHandle:^(NSString * _Nullable errorString) { }];
}

- (void)setUpCurrentHelperWithScanningDisplayingView:(UIView *_Nonnull)displayingView andScannedResultReceivedBlock:(KNVUNDSHResultHandlerBlock _Nonnull)handler errorHandle:(KNVUNDSHErrorHandlerBlock _Nullable)errorHandler
{
    _usingScanner = [[KNVUNDSHScannerModel alloc] initScannerOnView:displayingView];
    __weak typeof(self) weakSelf = self;
    [_usingScanner setUpModelWithSuccessHandler:^{
        __strong typeof(self) strongWeakSelf = weakSelf;
        if (strongWeakSelf == nil) {
            return;
        }
        strongWeakSelf->_usingScanner.delegate = self;
        strongWeakSelf->_storedResultHandlerBlock = handler;
        [strongWeakSelf setUpCameraDevicePosition];
    } andTheErrorHandler:^(NSString *errorMessage) {
        __strong typeof(self) strongWeakSelf = weakSelf;
        if (strongWeakSelf == nil) {
            return;
        }
        strongWeakSelf->_usingScanner = nil;
        errorHandler (errorMessage);
    }];
}

#pragma mark - Public Methods
- (void)switchCameraDevicePosition
{
    switch (self.currentCaptureDevicePosition) {
        case AVCaptureDevicePositionFront:
            self.currentCaptureDevicePosition = AVCaptureDevicePositionBack;
            break;
        default:
            self.currentCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    [self setUpCameraDevicePosition];
}

#pragma mark - KNVUNDSHScannerModelDelegate
- (void)didCaptureCodeString:(NSString *)codeString
{
    [self performConsoleLogWithLogLevel:NSObject_LogLevel_Debug
                     andLogStringFormat:@"Did Read String from Code Scanner --- %@",
     codeString];
    // We will only sure the scanned string is correct when we have received the same String Twice...
    if([_storedScannedString isEqualToString:codeString]) {
        if (_storedResultHandlerBlock) {
            _storedResultHandlerBlock(codeString);
        }
        [_usingScanner stop];
        _storedScannedString = nil;
    } else {
        _storedScannedString = codeString;
    }
}

#pragma mark - Support Method
- (void)setUpCameraDevicePosition
{
    [_usingScanner stop];
    [_usingScanner changeCameraPosition:self.currentCaptureDevicePosition];
    [_usingScanner start];
}

@end
