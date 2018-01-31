//
//  KNVUNDFormatedStringReadingHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 31/1/18.
//

#import "KNVUNDFormatedStringReadingHelper.h"

// Categories
#import "NSString+KNVUNDBasic.h"
#import "KNVUNDFSRToolHTMLLikeStringModel+PackageInternal.h"

typedef enum : NSUInteger {
    KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_FormatTypeFirstPartBeginString,
    KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_FormatTypeSecondPartString,
    KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_PlaceholderTypeBeginString
} KNVUNDFSRHSReadingModel_CheckingSpecialString_Type;

@interface KNVUNDFSReadingHelperSingleReadingModel : KNVUNDBaseModel

/// Base Checking Settings
@property (nonatomic, strong) NSString *propertyName;
@property (nonatomic, strong) NSString *formatTypeFirstPartBeginString;
@property (nonatomic, strong) NSString *formatTypeSecondPartString;
@property (nonatomic, strong) NSString *placeholderTypeBeginString;
@property (nonatomic) BOOL shouldRemoveContentValue;

/// Properties for searching
@property (nonatomic) NSUInteger *checkingIndexPointer;
@property (nonatomic) NSUInteger remainingCheckingTimes;
@property (nonatomic, strong) KNVUNDFSRToolHTMLLikeStringModel *relatedStringModel;
@property (nonatomic) NSUInteger relatedStringModelLocationModifier;

/// Properties for Each searching Loop
@property (nonatomic) NSUInteger checkingIndexInFormatTypeFirstWrapperStart;
@property (nonatomic) NSUInteger checkingIndexInPlaceholderTypeWrapperStart;
@property (nonatomic) NSUInteger checkingIndexInFormatTypeSecondWrapper;

@property (nonatomic) BOOL hasStartSingleQuotationMark;
@property (nonatomic) BOOL hasStartDoubleQuotationMark;
@property (nonatomic) BOOL shouldIgnoreNextFunctionChar;
@property (nonatomic) BOOL hasCheckedAttributesPartForRelatedStringModel; /// For Format Type is the first part and for the Property Type is all
@property (nonatomic) BOOL hasCheckedFullInformationForRelatedStringModel;
@property (nonatomic, strong) NSString *currentReadingString;
@property (nonatomic, strong) NSString *lastReadingCompleteString;
@property (nonatomic, strong) NSString *storedAttributeKeyValue;

@end

@implementation KNVUNDFSReadingHelperSingleReadingModel

#pragma mark - KNVUNDBaseModel
- (BOOL)shouldShowRelatedLog
{
    return NO;
}

#pragma mark - Getters & Setters
#pragma mark - Getters
- (NSString *)currentReadingString
{
    if (!_currentReadingString) {
        _currentReadingString = @"";
    }
    return _currentReadingString;
}

- (NSString *)lastReadingCompleteString
{
    if (!_lastReadingCompleteString) {
        _lastReadingCompleteString = @"";
    }
    return _lastReadingCompleteString;
}

- (NSString *)storedAttributeKeyValue
{
    if (!_storedAttributeKeyValue) {
        _storedAttributeKeyValue = @"";
    }
    return _storedAttributeKeyValue;
}

#pragma mark - Public Mehtods
- (KNVUNDFSReadingHelperSingleReadingModel *)copySelfToANewSingleReadingModel
{
    KNVUNDFSReadingHelperSingleReadingModel *returnModel = [KNVUNDFSReadingHelperSingleReadingModel new];
    returnModel.formatTypeFirstPartBeginString = self.formatTypeFirstPartBeginString;
    returnModel.formatTypeSecondPartString = self.formatTypeSecondPartString;
    returnModel.placeholderTypeBeginString = self.placeholderTypeBeginString;
    returnModel.shouldRemoveContentValue = self.shouldRemoveContentValue;
    returnModel.propertyName = self.propertyName;
    returnModel.checkingIndexPointer = self.checkingIndexPointer;
    returnModel.remainingCheckingTimes = self.remainingCheckingTimes == 0 ? 0 : self.remainingCheckingTimes - 1;
    return returnModel;
}

- (void)prepareNextLeveCheckingWith:(NSUInteger *)checkingIndexPointer remainingCheckingTimes:(NSUInteger)remainingCheckingTimes relatedStringModel:(KNVUNDFSRToolHTMLLikeStringModel *)relatedStringModel andrelatedStringModelLocationModifier:(NSUInteger)relatedStringModelLocationModifier
{
    self.checkingIndexPointer = checkingIndexPointer;
    self.remainingCheckingTimes = remainingCheckingTimes;
    self.relatedStringModel = relatedStringModel;
    self.relatedStringModelLocationModifier = relatedStringModelLocationModifier;
}

- (BOOL)checkIfShouldPassCurrentCharacter:(char)currentChar
{
    if (self.shouldIgnoreNextFunctionChar) {
        self.shouldIgnoreNextFunctionChar = NO;
        [self readOneCharacterForAttribute:currentChar];
        [self resetIndexIdentifierForChecking];
        return YES;
    }
    
    if (currentChar == '\\') {
        self.shouldIgnoreNextFunctionChar = YES;
        return YES;
    }
    
    if (currentChar == '\'') {
        self.hasStartSingleQuotationMark = !self.hasStartSingleQuotationMark;
        [self completeCurrentReadingFunctionAndShouldRemoveLastChar:NO];
        return YES;
    }
    
    if (currentChar == '"') {
        self.hasStartDoubleQuotationMark = !self.hasStartDoubleQuotationMark;
        if (!self.hasStartDoubleQuotationMark) {
            self.hasStartSingleQuotationMark = NO;
        }
        [self completeCurrentReadingFunctionAndShouldRemoveLastChar:NO];
        return YES;
    }
    
    BOOL inQuotation = self.hasStartSingleQuotationMark || self.hasStartDoubleQuotationMark;
    if (inQuotation) {
        [self readOneCharacterForAttribute:currentChar];
        return YES;
    }
    
    return NO;
}

- (void)haveUpdatedStringModelsCount:(NSUInteger)foundModelsCount
{
    if (self.remainingCheckingTimes >= foundModelsCount) {
        self.remainingCheckingTimes -= foundModelsCount;
    } else {
        self.remainingCheckingTimes = 0;
    }
}

- (BOOL)haveFoundMarthingSpecialStringWithType:(KNVUNDFSRHSReadingModel_CheckingSpecialString_Type)type andCurrentChar:(char)currentChar isNextCompareCharValid:(BOOL)isNextCompareCharValid
{
    NSString *checkingString;
    NSUInteger index;
    NSUInteger updatingIdex;
    switch (type) {
        case KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_PlaceholderTypeBeginString:
            checkingString = self.placeholderTypeBeginString;
            index = self.checkingIndexInPlaceholderTypeWrapperStart;
            break;
        case KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_FormatTypeSecondPartString:
            checkingString = self.formatTypeSecondPartString;
            index = self.checkingIndexInFormatTypeSecondWrapper;
            break;
        default:
            checkingString = self.formatTypeFirstPartBeginString;
            index = self.checkingIndexInFormatTypeFirstWrapperStart;
            break;
    }
    if (index >= checkingString.length) {
        index = 0;
    }
    char charInCheckingString = [checkingString characterAtIndex:index];
    if (charInCheckingString == currentChar) {
        updatingIdex = index + 1;
    } else {
        updatingIdex = 0;
    }
    switch (type) {
        case KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_PlaceholderTypeBeginString:
            self.checkingIndexInPlaceholderTypeWrapperStart = updatingIdex;
            break;
        case KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_FormatTypeSecondPartString:
            self.checkingIndexInFormatTypeSecondWrapper = updatingIdex;
            break;
        default:
            self.checkingIndexInFormatTypeFirstWrapperStart = updatingIdex;
            break;
    }
    if (updatingIdex >= checkingString.length && isNextCompareCharValid) {
        return YES;
    } else {
        return NO;
    }
}

- (void)haveFoundEqualSignInAttributeParts
{
    [self completeCurrentReadingFunctionAndShouldRemoveLastChar:YES];
    self.storedAttributeKeyValue = self.lastReadingCompleteString;
    self.lastReadingCompleteString = @"";
    [self performConsoleLogWithLogStringFormat:@"Setting Stored Attribtue Key Value --- %@",
     self.storedAttributeKeyValue];
}

- (void)haveEndedCheckingValueForStoredAttributeKey
{
    if (self.storedAttributeKeyValue.length > 0) {
        [self performConsoleLogWithLogStringFormat:@"Adding Attribut Key - Value --- %@ - %@",
         self.storedAttributeKeyValue,
         self.lastReadingCompleteString];
        [self.relatedStringModel updateAddictionalAttributeKey:self.storedAttributeKeyValue
                                                     withValue:self.lastReadingCompleteString];
        self.storedAttributeKeyValue = @"";
        self.lastReadingCompleteString = @"";
    }
}

- (void)haveFoundEndingPartOfAttributPartForCurrentRelatedStringModel
{
    if (self.currentReadingString.length > 1) {
        [self completeCurrentReadingFunctionAndShouldRemoveLastChar:YES];
    }
    [self haveEndedCheckingValueForStoredAttributeKey];
    self.hasCheckedAttributesPartForRelatedStringModel = YES;
}

- (KNVUNDFSRToolHTMLLikeStringModel *)completeRelatedStirngModelChecking
{
    KNVUNDFSRToolHTMLLikeStringModel *returnModel = self.relatedStringModel;
    returnModel.location -= self.relatedStringModelLocationModifier; // We need to modify the Location... because we will remove some code in out side of current method call
    
    // Reset Values
    self.relatedStringModel = nil;
    self.hasCheckedAttributesPartForRelatedStringModel = NO;
    self.hasCheckedFullInformationForRelatedStringModel = NO;
    [self resetIndexIdentifierForChecking];
    
    if (self.remainingCheckingTimes > 1) {
        self.remainingCheckingTimes -= 1;
    }
    return returnModel;
}

#pragma mark - Updating In Each Searching Loop
- (void)resetIndexIdentifierForChecking
{
    self.checkingIndexInFormatTypeFirstWrapperStart = 0;
    self.checkingIndexInPlaceholderTypeWrapperStart = 0;
    self.checkingIndexInFormatTypeSecondWrapper = 0;
}

- (void)readOneCharacterForAttribute:(char)aChar
{
    if (self.relatedStringModel != nil && !self.hasCheckedAttributesPartForRelatedStringModel) {
        self.currentReadingString = [self.currentReadingString stringByAppendACharacter:aChar];
        [self performConsoleLogWithLogStringFormat:@"Current Attributes Checking Reading Content is: %@",
         self.currentReadingString];
    }
}

- (void)completeCurrentReadingFunctionAndShouldRemoveLastChar:(BOOL)shouldRemoveLastChar
{
    if (!self.hasStartSingleQuotationMark && !self.hasStartDoubleQuotationMark) {
        if (shouldRemoveLastChar) {
            self.currentReadingString = [self.currentReadingString substringToIndex:self.currentReadingString.length - 1];
        }
        self.lastReadingCompleteString = self.currentReadingString;
        self.currentReadingString = @"";
        [self performConsoleLogWithLogStringFormat:@"Stop Previous Reading Scope --- Last Reading Scope Content: %@",
         self.lastReadingCompleteString];
    }
    [self resetIndexIdentifierForChecking];
}

@end


@interface KNVUNDFSReadingHelperSettingModel()

@end

@implementation KNVUNDFSReadingHelperSettingModel

- (KNVUNDFSReadingHelperSingleReadingModel *)generateSingleReadingModelFromSelf
{
    KNVUNDFSReadingHelperSingleReadingModel *returnModel = [KNVUNDFSReadingHelperSingleReadingModel new];
    returnModel.formatTypeFirstPartBeginString = [NSString stringWithFormat:@"%c%@",
                                                  KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
                                                  self.propertyName];
    returnModel.formatTypeSecondPartString = [NSString stringWithFormat:@"%c%c%@%c",
                                              KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_Start,
                                              KNVUNDFSRToolHTMLLikeStringModel_Format_Ending_Identifier,
                                              self.propertyName,
                                              KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
    returnModel.placeholderTypeBeginString = [NSString stringWithFormat:@"%c%@",
                                              KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_Start,
                                              self.propertyName];
    returnModel.shouldRemoveContentValue = self.shouldRemoveContentValue;
    returnModel.propertyName = self.propertyName;
    
    return returnModel;
}

@end

@implementation KNVUNDFormatedStringReadingHelper{
    KNVUNDFSReadingHelperSettingModel *_relatedSettingModel;
}

#pragma mark - KNVUNDBaseModel
- (BOOL)shouldShowRelatedLog
{
    return NO;
}

#pragma mark - Initial
- (instancetype)initWithSettingModel:(KNVUNDFSReadingHelperSettingModel *)settingModel
{
    if (self = [self init]) {
        _relatedSettingModel = settingModel;
    }
    return self;
}

#pragma mark - Reading Method
- (NSArray *)readAndRetrievingStringModels
{
    KNVUNDFSReadingHelperSingleReadingModel *initalReadingModel = [_relatedSettingModel generateSingleReadingModelFromSelf];
    
    if (initalReadingModel == nil) {
        return @[];
    }
    
    NSUInteger checkingIndex = _relatedSettingModel.startCheckingLocation;
    
    [initalReadingModel prepareNextLeveCheckingWith:&checkingIndex
                             remainingCheckingTimes:_relatedSettingModel.maximumOutputModelCount
                                 relatedStringModel:nil
              andrelatedStringModelLocationModifier:0];
    
    return [self readAndRetrievingStringModelsForOneLevelFromReadingContent:_relatedSettingModel.readingContent
                                                     withSingleReadingModel:initalReadingModel];
}

#pragma mark Support Methods
- (NSArray *)readAndRetrievingStringModelsForOneLevelFromReadingContent:(NSMutableString *)readingContent withSingleReadingModel:(KNVUNDFSReadingHelperSingleReadingModel *)singleReadingModel
{
    NSMutableArray *returnArray = [NSMutableArray array];
    NSUInteger insertingModelInsertLocation = 0;
    BOOL shouldBackToLastLevelWhenFinished = singleReadingModel.relatedStringModel != nil; /// If we have passed newModel which means this method is called in nested... we need to back to privious level when this level checking is finished
    if (shouldBackToLastLevelWhenFinished) {
        [self performConsoleLogWithLogString:@"Enter Next Level Retrieving Loop Method --- Reason: Find another String Reading Model inside anther Reading Model."];
    } else {
        [self performConsoleLogWithLogString:@"Enter Initial Retrieving Loop Method."];
    }
    BOOL shouldStop = NO;
    NSRange formatTypeFirstPartRange;
    
    NSUInteger *checkingIndex = singleReadingModel.checkingIndexPointer;
    
    while (*checkingIndex < readingContent.length && !shouldStop) {
        char currentCheckingChar = [readingContent characterAtIndex:*checkingIndex];
        
        [self performConsoleLogWithLogStringFormat:@"Checking Character at Index: %@ ---- \'%c\'",
         @(*checkingIndex),
         currentCheckingChar];
        
        NSUInteger currentCheckingIndex = *checkingIndex;
        // The reason why we want to increase to next checking Index in here because it's easier for us to handle the deleting property range logic
        *checkingIndex += 1;
        
        
        ///// Current Character Checking.....
        ////// Special Characters
        if ([singleReadingModel checkIfShouldPassCurrentCharacter:currentCheckingChar]) {
            continue;
        }
        
        ////// Spaces Checking
        char previousChar = (currentCheckingIndex == 0) ? ' ' : [readingContent characterAtIndex:currentCheckingIndex - 1];
        BOOL isPreviousCharEmpty = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:previousChar];
        BOOL isCurrentCharacterEmpty = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:currentCheckingChar];
        char nextChar = (currentCheckingIndex >= (readingContent.length - 1)) ? ' ' : [readingContent characterAtIndex:currentCheckingIndex + 1];
        BOOL isNextCharEmpty = [[NSCharacterSet whitespaceCharacterSet] characterIsMember:nextChar];
        
        if (isCurrentCharacterEmpty) {
            if (singleReadingModel.currentReadingString.length > 0) {
                [singleReadingModel completeCurrentReadingFunctionAndShouldRemoveLastChar:NO];
            }
            if (isPreviousCharEmpty) {
                continue;
            }
        } else {
            [singleReadingModel readOneCharacterForAttribute:currentCheckingChar];
        }
        
        ////// Find if we could find place holder starting part or not// Part One: Check the Property Starting Identifiers.
        BOOL foundFormatTypeFirstPartBeginString = [singleReadingModel haveFoundMarthingSpecialStringWithType:KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_FormatTypeFirstPartBeginString
                                                                                               andCurrentChar:currentCheckingChar
                                                                                       isNextCompareCharValid:isNextCharEmpty || nextChar == KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End];
        BOOL foundPlaceholderTypeBeginString = [singleReadingModel haveFoundMarthingSpecialStringWithType:KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_PlaceholderTypeBeginString
                                                                                               andCurrentChar:currentCheckingChar
                                                                                       isNextCompareCharValid:isNextCharEmpty || nextChar == KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End];
        
        if (foundFormatTypeFirstPartBeginString) {
            KNVUNDFSRToolHTMLLikeStringModel *newModel = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:singleReadingModel.propertyName
                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                            andLocation:currentCheckingIndex - singleReadingModel.checkingIndexInFormatTypeFirstWrapperStart + 1];
            [self performConsoleLogWithLogStringFormat:@"Found Possible Format Type Property at Location: %@.",
             @(newModel.location)];
            
            if (singleReadingModel.relatedStringModel == nil) {
                singleReadingModel.relatedStringModel = newModel;
            } else if(singleReadingModel.remainingCheckingTimes != 1) {
                KNVUNDFSReadingHelperSingleReadingModel *nextLevelSignleReadingModel = [singleReadingModel copySelfToANewSingleReadingModel];
                nextLevelSignleReadingModel.relatedStringModel = newModel;
                nextLevelSignleReadingModel.relatedStringModelLocationModifier = singleReadingModel.relatedStringModelLocationModifier + formatTypeFirstPartRange.length;
                NSArray *newFoundModels = [self readAndRetrievingStringModelsForOneLevelFromReadingContent:readingContent
                                                                                    withSingleReadingModel:nextLevelSignleReadingModel];
                newModel.location = newModel.location - singleReadingModel.relatedStringModel.location; /// Location only trackes the the location in parent's content string.
                newModel.parentLevelModel = singleReadingModel.relatedStringModel;
                [singleReadingModel haveUpdatedStringModelsCount:[newFoundModels count]];
                [returnArray addObjectsFromArray:newFoundModels];
            }
        }
        
        if (foundPlaceholderTypeBeginString) {
            KNVUNDFSRToolHTMLLikeStringModel *newModel = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:singleReadingModel.propertyName
                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder
                                                                                                            andLocation:currentCheckingIndex - singleReadingModel.checkingIndexInPlaceholderTypeWrapperStart + 1];
            [self performConsoleLogWithLogStringFormat:@"Found Possible Placeholder Type Property at Location: %@.",
             @(newModel.location)];
            
            if (singleReadingModel.relatedStringModel == nil) {
                singleReadingModel.relatedStringModel = newModel;
            } else if(singleReadingModel.remainingCheckingTimes != 1) {
                KNVUNDFSReadingHelperSingleReadingModel *nextLevelSignleReadingModel = [singleReadingModel copySelfToANewSingleReadingModel];
                nextLevelSignleReadingModel.relatedStringModel = newModel;
                nextLevelSignleReadingModel.relatedStringModelLocationModifier = singleReadingModel.relatedStringModelLocationModifier + formatTypeFirstPartRange.length;
                NSArray *newFoundModels = [self readAndRetrievingStringModelsForOneLevelFromReadingContent:readingContent
                                                                                    withSingleReadingModel:nextLevelSignleReadingModel];
                newModel.location = newModel.location - singleReadingModel.relatedStringModel.location; /// Location only trackes the the location in parent's content string.
                newModel.parentLevelModel = singleReadingModel.relatedStringModel;
                [singleReadingModel haveUpdatedStringModelsCount:[newFoundModels count]];
                [returnArray addObjectsFromArray:newFoundModels];
            }
        }
        
        KNVUNDFSRToolHTMLLikeStringModel *foundModel = singleReadingModel.relatedStringModel;
        
        // We will process this part of logic only if we have found Model
        /////  This part is for checking the attribute related part.
        if (foundModel != nil && !singleReadingModel.hasCheckedAttributesPartForRelatedStringModel) {
            // Part Two: We will going to check attribute for current Model
            BOOL findEqualSign = currentCheckingChar == KNVUNDFSRToolHTMLLikeStringModel_Additional_Attributes_Property_Equal;
            if (findEqualSign) {
                // 1. Remove the equal Sign from the current reading String
                [singleReadingModel haveFoundEqualSignInAttributeParts];
            }
            
            BOOL findAttributeValue = isCurrentCharacterEmpty;
            if (findAttributeValue) {
                [singleReadingModel haveEndedCheckingValueForStoredAttributeKey];
            }
            
            
            // Part Three: Before we find the ending part... We need to check the the Attributs of current found Model
            BOOL foundTheEndPartOfTheProperty = NO;
            if ([foundModel isPlaceholderType]) {
                foundTheEndPartOfTheProperty = currentCheckingChar == KNVUNDFSRToolHTMLLikeStringModel_Placeholder_Wrapper_End;
            } else {
                foundTheEndPartOfTheProperty = currentCheckingChar == KNVUNDFSRToolHTMLLikeStringModel_Format_Wrapper_End;
            }
            
            // Logic of found the end part
            if (foundTheEndPartOfTheProperty) {
                // 1. Mark we have found the Attribute.
                [singleReadingModel haveFoundEndingPartOfAttributPartForCurrentRelatedStringModel];
                NSRange propertyPartRange = NSMakeRange(foundModel.location, currentCheckingIndex - foundModel.location + 1);
                
                // 2. if the found Model Type is Placeholder, we will stop checking
                if ([foundModel isPlaceholderType]) {
                    NSString *beforeDeletingString = [NSString stringWithString:readingContent];
                    NSUInteger beforeDeletingIndex = *checkingIndex;
                    
                    NSString *propertyFullString = [readingContent substringWithRange:propertyPartRange];
                    
                    [readingContent deleteCharactersInRange:propertyPartRange];
                    *checkingIndex = *checkingIndex - propertyPartRange.length;
                    [foundModel updateFullLengthFromReading:propertyPartRange.length];
                    
                    [self performConsoleLogWithLogStringFormat:@"Confirm Placeholder Type Property at Range: %@  ----  %@ \nChange Next Checking Index %@ --> %@\n Change Formated String:\n  From: %@ \n  To: %@",
                     NSStringFromRange(propertyPartRange),
                     propertyFullString,
                     @(beforeDeletingIndex),
                     @(*checkingIndex),
                     beforeDeletingString,
                     readingContent];
                    
                    singleReadingModel.hasCheckedFullInformationForRelatedStringModel = YES;
                } else {
                    formatTypeFirstPartRange = propertyPartRange; /// Stored for the deleting logic
                    [self performConsoleLogWithLogStringFormat:@"Update Stored Format Type First Part Range --- %@",
                     NSStringFromRange(formatTypeFirstPartRange)];
                    
                }
            }
        }
        
        // We will process this part of logic only if we have found Model
        /////  This part is for checking the second part for format type model.
        if ([foundModel isFormatType] && singleReadingModel.hasCheckedAttributesPartForRelatedStringModel) {
            BOOL foundFormatTypeSecondPart = [singleReadingModel haveFoundMarthingSpecialStringWithType:KNVUNDFSRHSReadingModel_CheckingSpecialString_Type_FormatTypeSecondPartString
                                                                                                   andCurrentChar:currentCheckingChar
                                                                                           isNextCompareCharValid:YES];
            if (foundFormatTypeSecondPart) {
                NSRange secondPartRange = NSMakeRange(currentCheckingIndex - singleReadingModel.checkingIndexInFormatTypeSecondWrapper + 1, singleReadingModel.checkingIndexInFormatTypeSecondWrapper);
                NSUInteger contentStartingIndex = formatTypeFirstPartRange.location + formatTypeFirstPartRange.length;
                NSRange contentRange = NSMakeRange(contentStartingIndex, secondPartRange.location - contentStartingIndex);
                NSRange fullRange = NSMakeRange(formatTypeFirstPartRange.location, contentRange.length + formatTypeFirstPartRange.length + secondPartRange.length);
                
                foundModel.contentValue = [readingContent substringWithRange:contentRange];
                [foundModel updateFullLengthFromReading:fullRange.length];
                NSString *fullString = [readingContent substringWithRange:fullRange];
                
                if (singleReadingModel.shouldRemoveContentValue) {
                    NSString *beforeDeletingString = [NSString stringWithString:readingContent];
                    NSUInteger beforeDeletingIndex = *checkingIndex;
                    
                    [readingContent deleteCharactersInRange:fullRange];
                    *checkingIndex = *checkingIndex - fullRange.length;
                    
                    [self performConsoleLogWithLogStringFormat:@"Confirm Format Type Property at Range: %@ ----  %@ \nContent: %@\nChange Next Checking Index %@ --> %@\n Change Formated String:\n  From: %@ \n  To: %@",
                     NSStringFromRange(fullRange),
                     fullString,
                     foundModel.contentValue,
                     @(beforeDeletingIndex),
                     @(*checkingIndex),
                     beforeDeletingString,
                     readingContent];
                } else {
                    NSString *beforeDeletingString = [NSString stringWithString:readingContent];
                    NSUInteger beforeDeletingIndex = *checkingIndex;
                    
                    [readingContent deleteCharactersInRange:secondPartRange];
                    *checkingIndex = *checkingIndex - secondPartRange.length;
                    
                    [readingContent deleteCharactersInRange:formatTypeFirstPartRange];
                    *checkingIndex = *checkingIndex - formatTypeFirstPartRange.length;
                    
                    [self performConsoleLogWithLogStringFormat:@"Confirm Format Type Property at Range: %@ and %@ ----  %@ \nContent: %@\nChange Checking Index %@ --> %@\n Change Formated String:\n  From: %@ \n  To: %@",
                     NSStringFromRange(formatTypeFirstPartRange),
                     NSStringFromRange(secondPartRange),
                     fullString,
                     foundModel.contentValue,
                     @(beforeDeletingIndex),
                     @(*checkingIndex),
                     beforeDeletingString,
                     readingContent];
                }
                singleReadingModel.hasCheckedFullInformationForRelatedStringModel = YES;
            }
        }
        
        /// The last part is if we have confirmed one checking process for one model, we will restart for next one.
        if (singleReadingModel.hasCheckedFullInformationForRelatedStringModel) {
            KNVUNDFSRToolHTMLLikeStringModel *completedModel = [singleReadingModel completeRelatedStirngModelChecking];
            [self performConsoleLogWithLogStringFormat:@"Found Model:\n%@",
             completedModel.description];
            [returnArray insertObject:completedModel
                              atIndex:insertingModelInsertLocation];
            insertingModelInsertLocation = [returnArray count];
        
            if (singleReadingModel.remainingCheckingTimes == 1 || shouldBackToLastLevelWhenFinished) {
                if (shouldBackToLastLevelWhenFinished) {
                    [self performConsoleLogWithLogString:@"Stop Retrieving Loop Method --- Reason: Going To Previous Level Retrieving Loop."];
                } else {
                    [self performConsoleLogWithLogString:@"Stop Retrieving Loop Method --- Reason: Reached the highest checking limit."];
                }
                shouldStop = YES;
            }
        }
    }
    
    return returnArray;
}


@end

