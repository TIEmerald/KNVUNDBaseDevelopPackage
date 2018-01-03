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

@implementation KNVUNDFSRToolHTMLLikeStringModel

NSString *const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start = @"<";
NSString *const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End = @">";
NSString *const KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier = @"/";

NSString *const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start = @"[";
NSString *const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End = @"]";

NSString *const KNVUNDFSRToolHTMLLikeStringModel_Additional_Attributes_Property_Equal = @"=";

#pragma mark - Initial
- (instancetype)initWithType:(KNVUNDFSRToolHTMLLikeStringModel_Type)type andLocation:(NSUInteger)location
{
    if (self = [super init]) {
        self.type = type;
        self.location = location;
    }
    return self;
}

@end

@implementation KNVUNDFormatedStringRelatedTool

#pragma mark - HTML-like Strings
#pragma mark - Generating
+ (NSString *_Nullable)generateFormatedStringWithHTMLLikeStringModel:(KNVUNDFSRToolHTMLLikeStringModel *_Nonnull)fromModel withError:(NSError *_Nullable * _Nullable)error
{
    if ([[fromModel.propertyName stringByTrimmingWhiteSpaces] length] == 0) {
        *error = [KNVUNDRootErrorCodeTool generateErrorWithMessage:@"Failed to Generate Formated String ---- Please assign a valid property name which is not empty."];
        return nil;
    }
    
    switch (fromModel.type) {
        case KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder:
            return [self generatePlaceholderTypeFormatedStringFromModel:fromModel
                                                              withError:error];
        default:
            return [self generateFormatTypeFormatedStringFromModel:fromModel
                                                         withError:error];
    }
}

#pragma mark Support Method
+ (NSString *_Nonnull)generateFormatTypeFormatedStringFromModel:(KNVUNDFSRToolHTMLLikeStringModel *_Nonnull)fromModel withError:(NSError ** _Nullable)error
{
    NSMutableString *returnString = [NSMutableString stringWithString:KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start];
    
    [returnString appendString:fromModel.propertyName];
    [returnString appendString:[self generateFomatedStringFromAdditionalAttributes:fromModel.additionalAttribute]];
    [returnString appendString:KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
    [returnString appendString:fromModel.contentValue ?: @""];
    [returnString appendFormat:@"%@%@%@%@",
     KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
     KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier,
     fromModel.propertyName,
     KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
    
    return returnString;
}

+ (NSString *_Nonnull)generatePlaceholderTypeFormatedStringFromModel:(KNVUNDFSRToolHTMLLikeStringModel *_Nonnull)fromModel withError:(NSError ** _Nullable)error
{
    NSMutableString *returnString = [NSMutableString stringWithString:KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start];
    
    [returnString appendString:fromModel.propertyName];
    [returnString appendString:[self generateFomatedStringFromAdditionalAttributes:fromModel.additionalAttribute]];
    [returnString appendString:KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End];
    
    return returnString;
}

+ (NSString *_Nonnull)generateFomatedStringFromAdditionalAttributes:(NSDictionary *_Nonnull)additionalAttributes
{
    NSMutableString *returnString = [NSMutableString stringWithString:@""];
    for (NSString *key in additionalAttributes.allKeys) {
        
        /// Step One, Get the Value String for current key.
        NSString *valueString = @"";
        id value = additionalAttributes[key];
        if ([value isKindOfClass:[NSString class]]) {
            valueString = [NSString stringWithFormat:@"\"%@\"",
                           value];
        } else if ([value isKindOfClass:[NSNumber class]]) {
            valueString = [NSString stringWithFormat:@"%@",
                           value];
        } else {
            continue; /// We only support NSString or NSNumber
        }
        
        /// Step Two, Adding Attribute to return string.
        NSString *appendingString = [NSString stringWithFormat:@" %@%@%@",
                                     key,
                                     KNVUNDFSRToolHTMLLikeStringModel_Additional_Attributes_Property_Equal,
                                     valueString];
        
        [returnString appendString:appendingString];
    }
    return returnString;
}

#pragma mark - Reading
+ (NSArray *_Nonnull)readFormatedString:(NSMutableString *_Nonnull)formatedString withPropertyName:(NSString *_Nonnull)propertyName fromStartCheckingLocation:(NSUInteger)startCheckingLocation checkingTimes:(NSUInteger)checkingTimes shouldRemoveContentValue:(BOOL)shouldRemoveContentValue
{
    
    NSString *usingPropertyName = [propertyName stringByTrimmingWhiteSpaces];
    
    if ([usingPropertyName length] == 0) {
        return [NSArray new]; // We won't support empty property name.
    }
    
    NSUInteger checkingIndex = startCheckingLocation;
    
    return [self readFormatedString:formatedString
                   withPropertyName:usingPropertyName
                      checkingIndex:&checkingIndex
                      checkingTimes:checkingTimes
           shouldRemoveContentValue:shouldRemoveContentValue
          andNewHTMLLikeStringModel:nil];
}

+ (NSArray *_Nonnull)readFormatedString:(NSMutableString *_Nonnull)formatedString withPropertyName:(NSString *_Nonnull)propertyName checkingIndex:(NSUInteger *)checkingIndex checkingTimes:(NSUInteger)checkingTimes shouldRemoveContentValue:(BOOL)shouldRemoveContentValue andNewHTMLLikeStringModel:(KNVUNDFSRToolHTMLLikeStringModel *_Nullable)newModel
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    KNVUNDFSRToolHTMLLikeStringModel *foundModel = newModel;
    BOOL shouldStopChecking = NO;
    
    NSUInteger remainingCheckingTimes = checkingTimes;
    
    NSUInteger checkingIndexInFormatWrapperStart = 0;
    NSUInteger checkingIndexInPlaceholderWrapperStart = 0;
    
    NSString *formatTypeFirstPartBeginString = [KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start stringByAppendingString:propertyName];
    NSString *formatTypeFirstPartEndString = KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End;
    NSString *formatTypeSecondPartString = [NSString stringWithFormat:@"%@%@%@%@",
                                            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
                                            KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier,
                                            propertyName,
                                            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
    
    NSString *placeholderTypeBeginString = [KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start stringByAppendingString:propertyName];
    NSString *placeholderTypeEndString = KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End;
    
    while (*checkingIndex < formatedString.length && !shouldStopChecking) {
        char currentCheckingChar = [formatedString characterAtIndex:*checkingIndex];
        BOOL foundFormatTypeFirstPartBeginString = [self findMatchedString:formatTypeFirstPartBeginString
                                                         withCheckingIndex:&checkingIndexInFormatWrapperStart
                                                            andCompareChar:currentCheckingChar];
        BOOL foundPlaceholderTypeBeginString = [self findMatchedString:placeholderTypeBeginString
                                                     withCheckingIndex:&checkingIndexInPlaceholderWrapperStart
                                                        andCompareChar:currentCheckingChar];
        if (foundFormatTypeFirstPartBeginString) {
            KNVUNDFSRToolHTMLLikeStringModel *newModel = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithType:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                    andLocation:*checkingIndex - checkingIndexInFormatWrapperStart + 1];
            if (foundModel == nil) {
                foundModel = newModel;
            } else if(remainingCheckingTimes != 1) {
                NSArray *newFoundModels = [self readFormatedString:formatedString
                                                  withPropertyName:propertyName
                                                     checkingIndex:&*checkingIndex
                                                     checkingTimes:remainingCheckingTimes - 1
                                          shouldRemoveContentValue:shouldRemoveContentValue
                                         andNewHTMLLikeStringModel:newModel];
                if (remainingCheckingTimes != 0) {
                    remainingCheckingTimes -= [newFoundModels count];
                }
                [returnArray addObjectsFromArray:newFoundModels];
            }
        }
        
        if (foundPlaceholderTypeBeginString) {
            KNVUNDFSRToolHTMLLikeStringModel *newModel = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithType:KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder
                                                                                                    andLocation:*checkingIndex - checkingIndexInPlaceholderWrapperStart + 1];
            if (foundModel == nil) {
                foundModel = newModel;
            } else if(remainingCheckingTimes != 1) {
                NSArray *newFoundModels = [self readFormatedString:formatedString
                                                  withPropertyName:propertyName
                                                     checkingIndex:&*checkingIndex
                                                     checkingTimes:remainingCheckingTimes - 1
                                          shouldRemoveContentValue:shouldRemoveContentValue
                                         andNewHTMLLikeStringModel:newModel];
                if (remainingCheckingTimes != 0) {
                    remainingCheckingTimes -= [newFoundModels count];
                }
                [returnArray addObjectsFromArray:newFoundModels];
            }
        }
        
        *checkingIndex += 1;
    }
    
    return returnArray;
}

#pragma mark Support Methods
+ (BOOL)findMatchedString:(NSString *)checkingString withCheckingIndex:(NSUInteger *)checkingIndex andCompareChar:(char)comparingChar
{
    NSUInteger index = *checkingIndex;
    if (index >= checkingString.length) {
        index = 0;
    }
    char charInCheckingString = [checkingString characterAtIndex:index];
    if (charInCheckingString == comparingChar) {
        *checkingIndex = index + 1;
    } else {
        *checkingIndex = 0;
    }
    
    if (*checkingIndex >= checkingString.length) {
        return YES;
    } else {
        return NO;
    }
}

@end
