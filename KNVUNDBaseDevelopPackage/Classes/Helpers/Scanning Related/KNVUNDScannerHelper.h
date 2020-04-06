//
//  KNVUNDScannerHelper.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/1/18.
//

#import "KNVUNDBaseModel.h"

typedef void(^KNVUNDSHResultHandlerBlock)(NSString *_Nonnull scannedString);
typedef void(^KNVUNDSHErrorHandlerBlock)(NSString *_Nullable errorString);

@interface KNVUNDScannerHelper : KNVUNDBaseModel

/// Currently, We only support QRCode and 128 Bar Code in this Helper

#pragma mark - Set Up
- (void)setUpCurrentHelperWithScanningDisplayingView:(UIView *_Nonnull)displayingView andScannedResultReceivedBlock:(KNVUNDSHResultHandlerBlock _Nonnull)handler;
- (void)setUpCurrentHelperWithScanningDisplayingView:(UIView *_Nonnull)displayingView andScannedResultReceivedBlock:(KNVUNDSHResultHandlerBlock _Nonnull)handler errorHandle:(KNVUNDSHErrorHandlerBlock _Nullable)errorHandler;

#pragma mark - Public Methods
- (void)switchCameraDevicePosition;

@end
