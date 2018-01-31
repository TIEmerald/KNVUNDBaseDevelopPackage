//
//  KNVUNDFormatedStringRelatedTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "KNVUNDFormatedStringRelatedTool.h"

// Tools
#import "KNVUNDRootErrorCodeTool.h"

// Categories
#import "NSString+KNVUNDBasic.h"
#import "KNVUNDFSRToolHTMLLikeStringModel+PackageInternal.h"

// Helper
#import "KNVUNDFormatedStringReadingHelper.h"

@implementation KNVUNDFormatedStringRelatedTool

#pragma mark - KNVUNDBaseModel
+ (BOOL)shouldShowClassMethodLog
{
    return YES;
}

#pragma mark - HTML-like Strings
#pragma mark - Generating
+ (NSString *_Nullable)generateFormatedStringWithHTMLLikeStringModel:(KNVUNDFSRToolHTMLLikeStringModel *_Nonnull)fromModel withError:(NSError *_Nullable * _Nullable)error
{
    if ([[fromModel.propertyName stringByTrimmingWhiteSpaces] length] == 0) {
        *error = [KNVUNDRootErrorCodeTool generateErrorWithMessage:@"Failed to Generate Formated String ---- Please assign a valid property name which is not empty."];
        return nil;
    }
    
    return fromModel.fullFormatedString;
}

#pragma mark - Reading
NSUInteger KNVUNDFormatedStringRelatedTool_ReadFunction_MaximumCheckTimes = 0;

+ (NSArray *_Nonnull)readFormatedString:(NSMutableString *_Nonnull)formatedString withPropertyName:(NSString *_Nonnull)propertyName fromStartCheckingLocation:(NSUInteger)startCheckingLocation checkingTimes:(NSUInteger)checkingTimes shouldRemoveContentValue:(BOOL)shouldRemoveContentValue
{
    
    NSString *usingPropertyName = [propertyName stringByTrimmingWhiteSpaces];
    
    if ([usingPropertyName length] == 0) {
        return [NSArray new]; // We won't support empty property name.
    }
    
    [self performConsoleLogWithLogStringFormat:@"Checking Property Name: %@, \nStarting Checking Location: %@\n Checking Times: %@\n Should Remove Content Value: %@\n Checking Formated String: %@",
     propertyName,
     @(startCheckingLocation),
     @(checkingTimes),
     @(shouldRemoveContentValue),
     formatedString];
    
    KNVUNDFSReadingHelperSettingModel *usingSettingModel = [KNVUNDFSReadingHelperSettingModel new];
    usingSettingModel.readingContent = formatedString;
    usingSettingModel.propertyName = propertyName;
    usingSettingModel.startCheckingLocation = startCheckingLocation;
    usingSettingModel.maximumOutputModelCount = checkingTimes;
    usingSettingModel.shouldRemoveContentValue = shouldRemoveContentValue;
    
    KNVUNDFormatedStringReadingHelper *usingHelper = [[KNVUNDFormatedStringReadingHelper alloc] initWithSettingModel:usingSettingModel];
    
    return [usingHelper readAndRetrievingStringModels];
}

@end
