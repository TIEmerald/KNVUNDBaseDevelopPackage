//
//  KNVUNDRootErrorCodeTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "KNVUNDRootErrorCodeTool.h"

@implementation KNVUNDRootErrorCodeTool
#pragma mark - Constant
// Format
NSString *const KNVUNDRootErrorCodeTool_Format_ErrorWithCode = @"Oops, something wrong happened. (ErrorCode: %@)";

// NSError
NSInteger const KNVUNDRootErrorCodeTool_Error_Code_Customize = -1;

#pragma mark - Override Methods
+ (NSString *)errorDomain
{
    return @"";
}

+ (NSString *)getErrorMessageErrorCode:(NSString *)errorCode
{
    NSString *fullErrorMessage = [[self errorDomain] stringByAppendingString:errorCode];
    
    return [NSString stringWithFormat:KNVUNDRootErrorCodeTool_Format_ErrorWithCode, fullErrorMessage];
}


#pragma mark - Support Methods
+ (NSError *)generateErrorWithMessage:(NSString *)errorMessage
{
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: errorMessage
                               };
    NSError *returnError = [NSError errorWithDomain:[self errorDomain]
                                               code:KNVUNDRootErrorCodeTool_Error_Code_Customize
                                           userInfo:userInfo] ;
    
    return returnError;
}

+ (NSError * _Nonnull)generateErrorWithErrorCodeIdentifier:(NSString * _Nonnull)errorCodeIdentifier failureReason:(NSString * _Nullable)failureReason recoverySuggestion:(NSString * _Nullable)recoverySuggestion
{
    NSString *localizedDescription = [self getErrorMessageErrorCode:errorCodeIdentifier];
    NSDictionary *userInfo;
    
    if (failureReason && recoverySuggestion) {
        userInfo = @{
                     NSLocalizedDescriptionKey:localizedDescription,
                     NSLocalizedFailureReasonErrorKey: failureReason,
                     NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion
                     };
    } else if (failureReason) {
        userInfo = @{
                     NSLocalizedDescriptionKey:localizedDescription,
                     NSLocalizedFailureReasonErrorKey: failureReason
                     };
    } else if (recoverySuggestion) {
        userInfo = @{
                     NSLocalizedDescriptionKey:localizedDescription,
                     NSLocalizedRecoverySuggestionErrorKey: recoverySuggestion
                     };
    } else {
        userInfo = @{
                     NSLocalizedDescriptionKey:localizedDescription
                     };
    }
    
    NSError *returnError = [NSError errorWithDomain:[self errorDomain]
                                               code:errorCodeIdentifier.intValue
                                           userInfo:userInfo] ;
    
    return returnError;
}

@end
