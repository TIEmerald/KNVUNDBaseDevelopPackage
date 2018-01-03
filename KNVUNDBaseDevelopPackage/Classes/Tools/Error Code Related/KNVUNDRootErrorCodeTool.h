//
//  KNVUNDRootErrorCodeTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDRootErrorCodeTool : KNVUNDBaseModel

#pragma mark - Override Methods
+ (NSString *_Nonnull)errorDomain;
+ (NSString *_Nonnull)getErrorMessageErrorCode:(NSString *_Nonnull)errorCode;

#pragma mark - Support Methods
+ (NSError *_Nonnull)generateErrorWithMessage:(NSString *_Nonnull)errorMessage;
+ (NSError *_Nonnull)generateErrorWithErrorCodeIdentifier:(NSString * _Nonnull)errorCodeIdentifier failureReason:(NSString * _Nullable)failureReason recoverySuggestion:(NSString * _Nullable)recoverySuggestion;

@end
