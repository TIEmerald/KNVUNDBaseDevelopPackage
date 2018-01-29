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

@interface KNVUNDFSRToolHTMLLikeStringModel(){
    NSMutableDictionary *_storingAttringbutesDic;
}

@property (nonatomic, readwrite) NSUInteger fullLength;

@end

@implementation KNVUNDFSRToolHTMLLikeStringModel

char const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start = '<';
char const KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End = '>';
char const KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier = '/';

char const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start = '[';
char const KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End = ']';

NSString *const KNVUNDFSRToolHTMLLikeStringModel_Additional_Attributes_Property_Equal = @"=";

#pragma mark - KNVUNDBaseModel
- (BOOL)shouldShowRelatedLog
{
    return NO;
}

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSDictionary *)additionalAttribute
{
    return _storingAttringbutesDic;
}

- (NSString *)fullAttributesString
{
    NSMutableString *returnString = [NSMutableString stringWithString:@""];
    for (NSString *key in self.additionalAttribute.allKeys) {
        
        /// Step One, Get the Value String for current key.
        NSString *valueString = @"";
        id value = self.additionalAttribute[key];
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

- (NSString *)fullFormatedString
{
    switch (self.type) {
            case KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder:
            return [self generatePlaceholderTypeFormatedStringFromSelf];
        default:
            return [self generateFormatTypeFormatedStringFromSelf];
    }
}

- (NSUInteger)fullLength
{
    if (_fullLength == 0){
        /// Which means this model is not generated from read method, and it's a method we want to generate the formated string... Therefore the length should be consistent with fullFormatedString.
        _fullLength = self.fullFormatedString.length;
    }
    return _fullLength;
}

#pragma mark Support Methods

#pragma mark Support Method
- (NSString *_Nonnull)generateFormatTypeFormatedStringFromSelf
{
    NSString *endingWrapper = [NSString stringWithFormat:@"%c%c%@%c",
                               KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
                               KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier,
                               self.propertyName,
                               KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
    
    return [NSString stringWithFormat:@"%c%@%@%c%@%@",
            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
            self.propertyName,
            self.fullAttributesString,
            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End,
            self.contentValue ?: @"",
            endingWrapper];
}

- (NSString *_Nonnull)generatePlaceholderTypeFormatedStringFromSelf
{
    return [NSString stringWithFormat:@"%c%@%@%c",
            KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start,
            self.propertyName,
            self.fullAttributesString,
            KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End];
}

#pragma mark - Setters
- (void)setAdditionalAttribute:(NSDictionary *)additionalAttribute
{
    if (additionalAttribute == nil) {
        [_storingAttringbutesDic removeAllObjects];
    } else {
        for (NSString *keyValue in additionalAttribute.allKeys) {
            [_storingAttringbutesDic setValue:additionalAttribute[keyValue]
                                       forKey:keyValue];
        }
    }
}

- (void)updateAddictionalAttributeKey:(NSString *)key withValue:(id)value
{
    if (key != nil) {
        [_storingAttringbutesDic setValue:value
                                   forKey:key];
    }
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        _storingAttringbutesDic = [NSMutableDictionary new];
    }
    return self;
}

- (instancetype)initWithPropertyName:(NSString *)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type andLocation:(NSUInteger)location
{
    if (self = [self init]) {
        self.propertyName = propertyName;
        self.type = type;
        self.location = location;
    }
    return self;
}

- (instancetype)initWithPropertyName:(NSString *)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type location:(NSUInteger)location attributesDictionary:(NSDictionary *)attributes andContentValue:(NSString *)contentValue
{
    if (self = [self initWithPropertyName:propertyName type:type andLocation:location]) {
        self.additionalAttribute = attributes;
        self.contentValue = contentValue;
    }
    return self;
}

#pragma mark - Validators
- (BOOL)isFormatType
{
    return self.type == KNVUNDFSRToolHTMLLikeStringModel_Type_Format;
}

- (BOOL)isPlaceholderType
{
    return self.type == KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder;
}

@end

@implementation KNVUNDFormatedStringRelatedTool

#pragma mark - KNVUNDBaseModel
+ (BOOL)shouldShowClassMethodLog
{
    return NO;
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
    
    NSUInteger checkingIndex = startCheckingLocation;
    
    [self performConsoleLogWithLogStringFormat:@"Checking Property Name: %@, \nStarting Checking Location: %@\n Checking Times: %@\n Should Remove Content Value: %@\n Checking Formated String: %@",
     propertyName,
     @(startCheckingLocation),
     @(checkingTimes),
     @(shouldRemoveContentValue),
     formatedString];
    
    return [self readFormatedString:formatedString
                   withPropertyName:usingPropertyName
                      checkingIndex:&checkingIndex
                      checkingTimes:checkingTimes
           shouldRemoveContentValue:shouldRemoveContentValue
             newHTMLLikeStringModel:nil
        outsideFirstPartTotalLength:0];
}

+ (NSArray *_Nonnull)readFormatedString:(NSMutableString *_Nonnull)formatedString withPropertyName:(NSString *_Nonnull)propertyName checkingIndex:(NSUInteger *)checkingIndex checkingTimes:(NSUInteger)checkingTimes shouldRemoveContentValue:(BOOL)shouldRemoveContentValue newHTMLLikeStringModel:(KNVUNDFSRToolHTMLLikeStringModel *_Nullable)newModel outsideFirstPartTotalLength:(NSUInteger)outsideLength
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    KNVUNDFSRToolHTMLLikeStringModel *foundModel = newModel;
    KNVUNDFSRToolHTMLLikeStringModel *confirmedModel = nil;
    NSUInteger insertingModelInsertLocation = 0;
    BOOL shouldBackToLastLevelWhenFinished = newModel != nil; /// If we have passed newModel which means this method is called in nested... we need to back to privious level when this level checking is finished
    BOOL shouldStop = NO;
    BOOL haveCheckedAttributes = NO;
    
    NSUInteger remainingCheckingTimes = checkingTimes;
    
    NSString *formatTypeFirstPartBeginString = [NSString stringWithFormat:@"%c%@",
                                                KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
                                                propertyName];
    NSString *formatTypeSecondPartString = [NSString stringWithFormat:@"%c%c%@%c",
                                            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
                                            KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier,
                                            propertyName,
                                            KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
    
    NSString *placeholderTypeBeginString = [NSString stringWithFormat:@"%c%@",
                                            KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start,
                                            propertyName];
    
    __block NSUInteger checkingIndexInFormatTypeFirstWrapperStart = 0;
    __block NSUInteger checkingIndexInPlaceholderTypeWrapperStart = 0;
    __block NSUInteger checkingIndexInFormatTypeFirstWrapperEnd = 0;
    __block NSUInteger checkingIndexInPlaceholderTypeWrapperEnd = 0;
    __block NSUInteger checkingIndexInFormatTypeSecondWrapper = 0;
    __block NSUInteger checkingIndexForEqualSignInAttributes = 0;
    
    NSRange formatTypeFirstPartRange;
    
    NSString *storedAttributeKeyValue = @"";
    
    BOOL hasStartSingleQuotationMark = NO;
    BOOL hasStartDoubleQuotationMark = NO;
    BOOL shouldIgnoreNextFunctionChar = NO;
    __block NSString *currentReadingString = @"";
    __block NSString *lastReadingCompleteString = @"";
    
    void(^resetIdentifierStringChecking)(void) = ^(){
        checkingIndexInFormatTypeFirstWrapperStart = 0;
        checkingIndexInPlaceholderTypeWrapperStart = 0;
        checkingIndexInFormatTypeFirstWrapperEnd = 0;
        checkingIndexInPlaceholderTypeWrapperEnd = 0;
        checkingIndexInFormatTypeSecondWrapper = 0;
        checkingIndexForEqualSignInAttributes = 0;
    };
    
    void(^completeCurrentReadingFunction)(void) = ^(){
        if (!hasStartSingleQuotationMark && !hasStartDoubleQuotationMark) {
            lastReadingCompleteString = currentReadingString;
            currentReadingString = @"";
            [self performConsoleLogWithLogStringFormat:@"Stop Previous Reading Scope --- Last Reading Scope Content: %@",
             lastReadingCompleteString];
        }
        resetIdentifierStringChecking();
    };
    
    while (*checkingIndex < formatedString.length && !shouldStop) {
        char currentCheckingChar = [formatedString characterAtIndex:*checkingIndex];
        
        [self performConsoleLogWithLogStringFormat:@"Checking Character at Index: %@ ---- \'%c\'",
         @(*checkingIndex),
         currentCheckingChar];
        
        NSUInteger currentCheckingIndex = *checkingIndex;
        // The reason why we want to increase to next checking Index in here because it's easier for us to handle the deleting property range logic
        *checkingIndex += 1;
        
        if (shouldIgnoreNextFunctionChar) {
            shouldIgnoreNextFunctionChar = NO;
            currentReadingString = [currentReadingString stringByAppendACharacter:currentCheckingChar];
            resetIdentifierStringChecking();
            continue;
        }
        
        if (currentCheckingChar == '\\') {
            shouldIgnoreNextFunctionChar = YES;
            continue;
        }
        
        if (currentCheckingChar == '\'') {
            hasStartSingleQuotationMark = !hasStartSingleQuotationMark;
            completeCurrentReadingFunction();
            continue;
        }
        
        if (currentCheckingChar == '"') {
            hasStartDoubleQuotationMark = !hasStartDoubleQuotationMark;
            if (!hasStartDoubleQuotationMark) {
                hasStartSingleQuotationMark = NO;
            }
            completeCurrentReadingFunction();
            continue;
        }
        
        BOOL inQuotation = hasStartSingleQuotationMark || hasStartDoubleQuotationMark;
        if (inQuotation) {
            currentReadingString = [currentReadingString stringByAppendACharacter:currentCheckingChar];
            continue;
        }
        
        char previousChar = (currentCheckingIndex == 0) ? ' ' : [formatedString characterAtIndex:currentCheckingIndex - 1];
        BOOL isPreviousCharEmpty = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:previousChar];
        BOOL isCurrentCharacterEmpty = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:currentCheckingChar];
        char nextChar = (currentCheckingIndex >= (formatedString.length - 1)) ? ' ' : [formatedString characterAtIndex:currentCheckingIndex + 1];
        BOOL isNextCharEmpty = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:nextChar];
        
        if (isCurrentCharacterEmpty) {
            if (currentReadingString.length > 0) {
                completeCurrentReadingFunction();
            }
            if (isPreviousCharEmpty) {
                continue;
            }
        }
        
        currentReadingString = [currentReadingString stringByAppendACharacter:currentCheckingChar];
        
        // Part One: Check the Property Starting Identifiers.
        BOOL foundFormatTypeFirstPartBeginString = [self findMatchedString:formatTypeFirstPartBeginString
                                                         withCheckingIndex:&checkingIndexInFormatTypeFirstWrapperStart
                                                            andCompareChar:currentCheckingChar
                                                  isNextCompareCharValid:isNextCharEmpty || nextChar == KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
        BOOL foundPlaceholderTypeBeginString = [self findMatchedString:placeholderTypeBeginString
                                                     withCheckingIndex:&checkingIndexInPlaceholderTypeWrapperStart
                                                        andCompareChar:currentCheckingChar
                                              isNextCompareCharValid:isNextCharEmpty || nextChar == KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End];
        if (foundFormatTypeFirstPartBeginString) {
            KNVUNDFSRToolHTMLLikeStringModel *newModel = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:propertyName
                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                            andLocation:currentCheckingIndex - checkingIndexInFormatTypeFirstWrapperStart + 1];
            [self performConsoleLogWithLogStringFormat:@"Found Possible Format Type Property at Location: %@.",
             @(newModel.location)];
            
            if (foundModel == nil) {
                foundModel = newModel;
            } else if(remainingCheckingTimes != 1) {
                NSArray *newFoundModels = [self readFormatedString:formatedString
                                                  withPropertyName:propertyName
                                                     checkingIndex:&*checkingIndex
                                                     checkingTimes:remainingCheckingTimes - 1
                                          shouldRemoveContentValue:shouldRemoveContentValue
                                            newHTMLLikeStringModel:newModel
                                       outsideFirstPartTotalLength:outsideLength + formatTypeFirstPartRange.length];
                if (remainingCheckingTimes != 0) {
                    remainingCheckingTimes -= [newFoundModels count];
                }
                [returnArray addObjectsFromArray:newFoundModels];
            }
        }
        
        if (foundPlaceholderTypeBeginString) {
            KNVUNDFSRToolHTMLLikeStringModel *newModel = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:propertyName
                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder
                                                                                                            andLocation:currentCheckingIndex - checkingIndexInPlaceholderTypeWrapperStart + 1];
            [self performConsoleLogWithLogStringFormat:@"Found Possible Placeholder Type Property at Location: %@.",
             @(newModel.location)];
            
            if (foundModel == nil) {
                foundModel = newModel;
            } else if(remainingCheckingTimes != 1) {
                NSArray *newFoundModels = [self readFormatedString:formatedString
                                                  withPropertyName:propertyName
                                                     checkingIndex:&*checkingIndex
                                                     checkingTimes:remainingCheckingTimes - 1
                                          shouldRemoveContentValue:shouldRemoveContentValue
                                            newHTMLLikeStringModel:newModel
                                       outsideFirstPartTotalLength:outsideLength + formatTypeFirstPartRange.length];
                if (remainingCheckingTimes != 0) {
                    remainingCheckingTimes -= [newFoundModels count];
                }
                [returnArray addObjectsFromArray:newFoundModels];
            }
        }
        
        
        // Part Two: Before we find the ending part... We need to check the the Attributs of current found Model
        if (!haveCheckedAttributes && foundModel != nil) {
            BOOL foundTheEndPartOfTheProperty = NO;
            if ([foundModel isPlaceholderType]) {
                foundTheEndPartOfTheProperty = currentCheckingChar == KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End;
            } else {
                foundTheEndPartOfTheProperty = currentCheckingChar == KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End;
            }
            
            // Logic of found the end part
            if (foundTheEndPartOfTheProperty) {
                // 1. Mark we have found the Attribute.
                haveCheckedAttributes = YES;
                
                NSRange propertyPartRange = NSMakeRange(foundModel.location, currentCheckingIndex - foundModel.location + 1);
                
                // 2. if the found Model Type is Placeholder, we will stop checking
                if ([foundModel isPlaceholderType]) {
                    NSString *beforeDeletingString = [NSString stringWithString:formatedString];
                    NSUInteger beforeDeletingIndex = *checkingIndex;
                    
                    NSString *propertyFullString = [formatedString substringWithRange:propertyPartRange];
                    
                    [formatedString deleteCharactersInRange:propertyPartRange];
                    *checkingIndex = *checkingIndex - propertyPartRange.length;
                    foundModel.fullLength = propertyPartRange.length;
                    
                    [self performConsoleLogWithLogStringFormat:@"Confirm Placeholder Type Property at Range: %@  ----  %@ \nChange Next Checking Index %@ --> %@\n Change Formated String:\n  From: %@ \n  To: %@",
                     NSStringFromRange(propertyPartRange),
                     propertyFullString,
                     @(beforeDeletingIndex),
                     @(*checkingIndex),
                     beforeDeletingString,
                     formatedString];
                    
                    confirmedModel = foundModel;
                } else {
                    formatTypeFirstPartRange = propertyPartRange; /// Stored for the deleting logic
                    [self performConsoleLogWithLogStringFormat:@"Update Stored Format Type First Part Range --- %@",
                     NSStringFromRange(formatTypeFirstPartRange)];
                }
            }
            
            
            BOOL findEqualSign = currentCheckingChar == KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End;
            if (findEqualSign) {
                // 1. Remove the equal Sign from the current reading String
                currentReadingString = [currentReadingString substringToIndex:currentReadingString.length - 1];
                completeCurrentReadingFunction();
                storedAttributeKeyValue = lastReadingCompleteString;
            }
            
            if (isCurrentCharacterEmpty && storedAttributeKeyValue.length > 0) {
                [foundModel updateAddictionalAttributeKey:storedAttributeKeyValue
                                                withValue:lastReadingCompleteString];
            }
        }
        
        // We need to find out the Ending Part of the Format
        if (haveCheckedAttributes && [foundModel isFormatType]) {
            BOOL foundFormatTypeSecondPart = [self findMatchedString:formatTypeSecondPartString
                                                   withCheckingIndex:&checkingIndexInFormatTypeSecondWrapper
                                                      andCompareChar:currentCheckingChar
                                            isNextCompareCharValid:YES];
            
            if (foundFormatTypeSecondPart) {
                NSRange secondPartRange = NSMakeRange(currentCheckingIndex - checkingIndexInFormatTypeSecondWrapper + 1, checkingIndexInFormatTypeSecondWrapper);
                NSUInteger contentStartingIndex = formatTypeFirstPartRange.location + formatTypeFirstPartRange.length;
                NSRange contentRange = NSMakeRange(contentStartingIndex, secondPartRange.location - contentStartingIndex);
                NSRange fullRange = NSMakeRange(formatTypeFirstPartRange.location, contentRange.length + formatTypeFirstPartRange.length + secondPartRange.length);
                
                foundModel.contentValue = [formatedString substringWithRange:contentRange];
                foundModel.fullLength = fullRange.length;
                NSString *fullString = [formatedString substringWithRange:fullRange];
                
                if (shouldRemoveContentValue) {
                    NSString *beforeDeletingString = [NSString stringWithString:formatedString];
                    NSUInteger beforeDeletingIndex = *checkingIndex;
                    
                    [formatedString deleteCharactersInRange:fullRange];
                    *checkingIndex = *checkingIndex - fullRange.length;
                    
                    [self performConsoleLogWithLogStringFormat:@"Confirm Format Type Property at Range: %@ ----  %@ \nContent: %@\nChange Next Checking Index %@ --> %@\n Change Formated String:\n  From: %@ \n  To: %@",
                     NSStringFromRange(fullRange),
                     fullString,
                     foundModel.contentValue,
                     @(beforeDeletingIndex),
                     @(*checkingIndex),
                     beforeDeletingString,
                     formatedString];
                } else {
                    NSString *beforeDeletingString = [NSString stringWithString:formatedString];
                    NSUInteger beforeDeletingIndex = *checkingIndex;
                    
                    [formatedString deleteCharactersInRange:secondPartRange];
                    *checkingIndex = *checkingIndex - secondPartRange.length;
                    
                    [formatedString deleteCharactersInRange:formatTypeFirstPartRange];
                    *checkingIndex = *checkingIndex - formatTypeFirstPartRange.length;
                    
                    [self performConsoleLogWithLogStringFormat:@"Confirm Format Type Property at Range: %@ and %@ ----  %@ \nContent: %@\nChange Checking Index %@ --> %@\n Change Formated String:\n  From: %@ \n  To: %@",
                     NSStringFromRange(formatTypeFirstPartRange),
                     NSStringFromRange(secondPartRange),
                     fullString,
                     foundModel.contentValue,
                     @(beforeDeletingIndex),
                     @(*checkingIndex),
                     beforeDeletingString,
                     formatedString];
                }
                
                confirmedModel = foundModel;
            }
        }
        
        if (confirmedModel) {
            confirmedModel.location -= outsideLength; // We need to modify the Location... because we will remove some code in out side of current method call
            [returnArray insertObject:confirmedModel
                              atIndex:insertingModelInsertLocation];
            insertingModelInsertLocation = [returnArray count];
            
            foundModel = nil;
            confirmedModel = nil;
            haveCheckedAttributes = NO;
            
            if (remainingCheckingTimes == 1 || shouldBackToLastLevelWhenFinished) {
                shouldStop = YES;
            } else if (remainingCheckingTimes != 0) {
                remainingCheckingTimes -= 1;
            }
        }
    }
    
    return returnArray;
}

#pragma mark Support Methods
+ (BOOL)findMatchedString:(NSString *)checkingString withCheckingIndex:(NSUInteger *)checkingIndex andCompareChar:(char)comparingChar isNextCompareCharValid:(BOOL)isNextCompareCharIsEmpty // If we want to guarantee the checking string have been found.... if the next Char is not valid ... means the the Matched String might not match...
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
    
    if (*checkingIndex >= checkingString.length && isNextCompareCharIsEmpty) {
        return YES;
    } else {
        return NO;
    }
}

@end
