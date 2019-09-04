//
//  KNVUNDNumberPadInputHelper.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 1/9/19.
//

#import "KNVUNDBasePadInputModel.h"

/// Tools
#import "KNVUNDThreadRelatedTool.h"

@interface KNVUNDBasePadInputModel() {
    BOOL _hasHadFirstInput;
    
    NSString *_displayingString;
    NSString *_rawString;
}

@property (readonly) NSString *usingDecimalSeparator;

@end

@implementation KNVUNDBasePadInputModel

#pragma mark - Override Methods
- (BOOL)couldAccumulateValue
{
    return NO; // Only Number Related Input Model support This function
}

- (BOOL)couldAppendString:(NSString *)appendingString toRawString:(NSString *)rawString
{
    if (appendingString.length == 0) {  /// Pointless appending
        return NO;
    }
    return YES;
}

- (BOOL)couldAppendDotToRawString:(NSString *)rawString
{
    return ![rawString containsString:self.usingDecimalSeparator];
}

- (NSString *)generateRawStringBasedOnDisplayingString:(NSString *)displayingString
{
    return displayingString;
}

- (NSString *)generateDisplayingStringBasedOnRawString:(NSString *)rawString
{
    return rawString;
}

#pragma mark - Getters && Setters
#pragma mark - Getters
- (NSString *)displayingString
{
    if (_displayingString == nil) {
        _displayingString = @"";
    }
    return _displayingString;
}

- (NSString *)rawString
{
    if (_rawString == nil) {
        _rawString = @"";
    }
    return _rawString;
}

- (NSString *)usingDecimalSeparator
{
    return [[self usingLocale] objectForKey:NSLocaleDecimalSeparator];
}

- (NSLocale *)usingLocale
{
    if (_usingLocale == nil) {
        return [NSLocale currentLocale];
    }
    return _usingLocale;
}

#pragma mark - Setters
- (void)setDisplayingString:(NSString *)displayingString
{
    _displayingString = displayingString;
    _rawString = [self generateRawStringBasedOnDisplayingString:_displayingString];
    [self updateDisplayingUIWithDisplayingString];
}

- (void)setDisplayingUI:(id<KNVUNDBasePadInputModelDisplayUIProtocol>)displayingUI
{
    _displayingUI = displayingUI;
    [self updateDisplayingUIWithDisplayingString];
}

- (void)setRawString:(NSString *)rawString
{
    _rawString = rawString;
    _displayingString = [self generateDisplayingStringBasedOnRawString:_rawString];
    [self updateDisplayingUIWithDisplayingString];
}

#pragma mark Support Methods
- (void)updateDisplayingUIWithDisplayingString
{
    if ([self.displayingUI respondsToSelector:@selector(setAttributedText:)]) {
        [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
            [self.displayingUI setAttributedText:[[NSAttributedString alloc] initWithString:self.displayingString]];
        }];
    } else if ([self.displayingUI respondsToSelector:@selector(setText:)]) {
        [KNVUNDThreadRelatedTool performBlockInMainQueue:^{
            [self.displayingUI setText:self.displayingString];
        }];
    } 
}

#pragma mark - General Method
- (void)tapedInputPadButton:(UIButton *)inputPadButton
{
    if (!_hasHadFirstInput && self.shouldResetValueForFirstInput) {
        self.rawString = @"";
    }
    NSString *titleString = inputPadButton.titleLabel.text;
    switch (inputPadButton.tag) {
        case KNVUNDBasePadIMButtonTag_Type_Append:
            if ([self couldAppendString:titleString toRawString:self.rawString]) {
                self.rawString = [self.rawString stringByAppendingString:titleString];
            }
            break;
        case KNVUNDBasePadIMButtonTag_Type_Delete:
            if (self.rawString.length > 0) {
                self.rawString = [self.rawString substringToIndex:self.rawString.length - 1];
            }
            break;
        case KNVUNDBasePadIMButtonTag_Type_Accumulate_Value:
            if ([self couldAccumulateValue]) {
//                self.rawString = [self.rawString substringToIndex:self.rawString.length - 1];
            }
            break;
        case KNVUNDBasePadIMButtonTag_Type_Decimal_Dot:
            if (self.rawString.length == 0) {
                self.rawString = @"0";
            }
            if ([self couldAppendDotToRawString:self.rawString]) {
                self.rawString = [self.rawString stringByAppendingString:self.usingDecimalSeparator];
            }
        default:
            break;
    }
}

@end

//@interface KNVUNDNumberPadInputHelper()
//
//@property (strong, nonatomic) KNVUNDNumberPadInputModel *currentLinkedParams;
//
//@end

//@implementation KNVUNDNumberPadInputHelper
//
//#pragma mark - General Method
//- (void)tapedNumberPadButton:(UIButton *)numberPadButton;
//{
////    if (!_hasHadFirstInput && self.shouldResetValueForFirstInput) {
////        self.rawDisplayingString = @"";
////    }
//    switch (numberPadButton.tag) {
//        case KNVNumberPadIHButtonTag_Type_Append:
//            [self appendStringToRawInputedNumberString:numberPadButton.titleLabel.text];
//            break;
//        case KNVNumberPadIHButtonTag_Type_Delete:
//            if(self.rawInputedNumberString.length > 0)
//                self.rawInputedNumberString = [NSMutableString stringWithString:[self.rawInputedNumberString substringToIndex:self.rawInputedNumberString.length - 1]];
//            break;
//        case KNVNumberPadIHButtonTag_Type_Accumulate_Integer:
//            [self accumulateStringAmountToRawInputedNumberString:numberPadButton.titleLabel.text];
//            break;
//        case KNVNumberPadIHButtonTag_Type_Decimal_Dot:
//            if (self.rawDisplayingString.length == 0) {
//                self.rawDisplayingString = @"0";
//            }
//            [self appendStringToRawInputedNumberString:KNVNumberPadInputHelper_Using_Decimal_Dot];
//            break;
//    }
//    [self setupTextInDisplayingTextField];
//    _hasHadFirstInput = YES;
//}
//
//#pragma mark - Support Method
//- (void)setupTextInDisplayingTextField
//{
//    // Clean up Raw Inputed Number String For displaying
//    /// Remove aheading "0" if it is not necessary
//    while (self.rawDisplayingString.length > 1 && [self.rawDisplayingString characterAtIndex:0] == '0' && [self.rawDisplayingString characterAtIndex:1] != '.') {
//        self.rawDisplayingString = [self.rawDisplayingString substringFromIndex:1];
//    }
//
//    // Formating the Displaying string.
//    NSString *formatedDisplayingString = self.rawInputedNumberString;
//
//    switch (self.type) {
//        case KNVNumberPadType_Currency:
//            formatedDisplayingString = [self getFormatedStringForCurrencyType];
//            break;
//        case KNVNumberPadType_Unit:
//        case KNVNumberPadType_Default:
//        default:
//            break;
//    }
//
//    if (_relatedTextUpdatingBlock) {
//        [self performABlockInMainThread:^{
//            _relatedTextUpdatingBlock(self.displayingTextField, self.rawDisplayingString, formatedDisplayingString);
//        }];
//    } else {
//        [self performABlockInMainThread:^{
//            self.displayingTextField.text = formatedDisplayingString;
//        }];
//    }
//}
//
//@end
