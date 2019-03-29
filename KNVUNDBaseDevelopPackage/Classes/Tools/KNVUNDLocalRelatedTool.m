//
//  KNVUNDCurrencyRelatedTool.m
//  Expecta
//
//  Created by Erjian Ni on 10/12/17.
//

#import "KNVUNDLocalRelatedTool.h"

/// Categories
#import "NSNumber+KNVUNDBasic.h"

/// Tools
#import "KNVUNDGeneralUtilsTool.h"

@implementation KNVUNDLocalRelatedTool

#pragma mark - Constants
NSString *const KNVUNDLocalRelatedTool_UserDefault_Key_StoredDefaultLocal_Identifier = @"KNVUNDLocalRelatedTool_UserDefault_Key_StoredDefaultLocal_Identifier";

#pragma mark - Locale Related
/*!
 * @brief This method return the Country Name for current device setted locale in English. Like if you set your device Setting Region to Australia this method will return "Australia"
 * @return NSString The country name based on which region your device is setted.
 */
+ (NSString *)getCurrentLocaleEnglishName
{
    // We return the CoutryCode based on the Country Region you set in the General Settings from your iPhone.
    NSLocale *locale = [self getCurrentLocal];
    NSString *countryCode = [locale objectForKey: NSLocaleCountryCode];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    return [usLocale displayNameForKey: NSLocaleCountryCode value: countryCode];
}

+ (NSLocale *)getCurrentStoredDefaultLocal
{
    NSString *storedDefaultLocalIdentifier = [KNVUNDGeneralUtilsTool getDataFromUserDefaults:KNVUNDLocalRelatedTool_UserDefault_Key_StoredDefaultLocal_Identifier];
    return [[NSLocale alloc] initWithLocaleIdentifier:storedDefaultLocalIdentifier] ?: [NSLocale currentLocale];
}

+ (NSLocale *)getCurrentLocal
{
    return [NSLocale currentLocale];
}

+ (void)logLocaleDetailsFromLocale:(NSLocale *)checkingLocale
{
    NSString *logMessage = @"";
    for (NSLocaleKey localKey in [self localRelatedKeyArray]) {
        logMessage = [logMessage stringByAppendingString:[NSString stringWithFormat:@"Local Key %@ : %@ \n",
                                                          localKey,
                                                          [checkingLocale objectForKey:localKey]]];
    }
    logMessage = [logMessage stringByAppendingString:[NSString stringWithFormat:@"Maximum Fraction Digits : %lu \n",
                                                      (unsigned long)[self getCurrentCurrencyNumberFormatter].maximumFractionDigits]];
    logMessage = [logMessage stringByAppendingString:[NSString stringWithFormat:@"Maximum Integer Digits : %lu \n",
                                                      (unsigned long)[self getCurrentCurrencyNumberFormatter].maximumIntegerDigits]];
    logMessage = [logMessage stringByAppendingString:[NSString stringWithFormat:@"Group Size : %lu \n",
                                                      (unsigned long)[self getCurrentCurrencyNumberFormatter].groupingSize]];
    
    [self performConsoleLogWithLogString:logMessage];
}

#pragma mark Support Methods
+ (NSArray *)localRelatedKeyArray
{
    return @[NSLocaleIdentifier, NSLocaleLanguageCode, NSLocaleCountryCode, NSLocaleScriptCode, NSLocaleVariantCode, NSLocaleExemplarCharacterSet, NSLocaleCalendar, NSLocaleCollationIdentifier, NSLocaleUsesMetricSystem, NSLocaleMeasurementSystem, NSLocaleDecimalSeparator, NSLocaleGroupingSeparator, NSLocaleCurrencySymbol, NSLocaleCurrencyCode, NSLocaleCollatorIdentifier, NSLocaleQuotationBeginDelimiterKey, NSLocaleQuotationEndDelimiterKey, NSLocaleAlternateQuotationBeginDelimiterKey, NSLocaleAlternateQuotationEndDelimiterKey];
}

#pragma mark - Date Parsing Related
#pragma mark General
+ (NSString *)formatDate:(NSDate *)inputDate withFormat:(NSString *)formatStr
{
    return [self formatDate:inputDate
                 withFormat:formatStr
      andTimezoneIanaFormat:nil];
}

+ (NSString *)formatDate:(NSDate *)inputDate withFormat:(NSString *)formatStr andTimezoneIanaFormat:(NSString *_Nullable)timezoneIanaFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (timezoneIanaFormat.length != nil) {
        NSTimeZone *usingTimeZone = [NSTimeZone timeZoneWithName:timezoneIanaFormat];
        formatter.timeZone = usingTimeZone;
    }
    [formatter setDateFormat:formatStr];
    return [formatter stringFromDate:inputDate];
}

+ (NSDate *)parseDateForString:(NSString *)dateStr withFormat:(NSString *)formatStr
{
    return [self parseDateForString:dateStr
                         withFormat:formatStr
              andTimezoneIanaFormat:nil];
}

+ (NSDate *)parseDateForString:(NSString *)dateStr withFormat:(NSString *)formatStr andTimezoneIanaFormat:(NSString *_Nullable)timezoneIanaFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (timezoneIanaFormat.length != nil) {
        NSTimeZone *usingTimeZone = [NSTimeZone timeZoneWithName:timezoneIanaFormat];
        formatter.timeZone = usingTimeZone;
    }
    [formatter setDateFormat:formatStr];
    return [formatter dateFromString:dateStr];
}

#pragma mark Locale Related
+ (NSString *)formatDate:(NSDate *)inputDate withPatternType:(KNVUNDLocalRelatedTool_DateFormatTemplate_Type)patternType
{
    return [self formatDate:inputDate withPatternType:patternType andTimezoneIanaFormat:nil];
}

+ (NSString *)formatDate:(NSDate *)inputDate withPatternType:(KNVUNDLocalRelatedTool_DateFormatTemplate_Type)patternType andTimezoneIanaFormat:(NSString *)timezoneIanaFormat
{
    NSString *templateString = @"jmma";
    switch (patternType) {
        case KNVUNDLocalRelatedTool_DateFormatTemplate_Type_ShortDate:
            templateString = @"yyyyLLd";
            break;
        case KNVUNDLocalRelatedTool_DateFormatTemplate_Type_LongDate:
            templateString = @"yyyyLLLd";
            break;
        case KNVUNDLocalRelatedTool_DateFormatTemplate_Type_TimeAndShortDate:
            templateString = @"yyyyLLdjmma";
            break;
        case KNVUNDLocalRelatedTool_DateFormatTemplate_Type_TimeAndLongDate:
            templateString = @"yyyyLLLdjmma";
            break;
        case KNVUNDLocalRelatedTool_DateFormatTemplate_Type_Time:
        default:
            break;
    }
    return [self formatDate:inputDate
                withPattern:templateString
      andTimezoneIanaFormat:timezoneIanaFormat];
}

+ (NSString *)formatDate:(NSDate *)inputDate withPattern:(NSString *)pattern
{
    return [self formatDate:inputDate withPattern:pattern andTimezoneIanaFormat:nil];
}

+ (NSString *)formatDate:(NSDate *)inputDate withPattern:(NSString *)pattern andTimezoneIanaFormat:(NSString *)timezoneIanaFormat
{
    return [self formatDate:inputDate
                withPattern:pattern
                  andLocale:[self getCurrentLocal]
      andTimezoneIanaFormat:timezoneIanaFormat];
}

// I guess it will display date based on the locale I copy it from the method above because it seems like this is what code actually does.
// The template is just tell format how many componants should be displayed in this format. and locale decide how is the format look like
+ (NSString *)formatDate:(NSDate *)inputDate withPattern:(NSString *)pattern andLocale:(NSLocale *)locale
{
    return [self formatDate:inputDate
                withPattern:pattern
                  andLocale:locale
      andTimezoneIanaFormat:nil];
}

+ (NSString *)formatDate:(NSDate *)inputDate withPattern:(NSString *)pattern andLocale:(NSLocale *)locale andTimezoneIanaFormat:(NSString *_Nullable)timezoneIanaFormat
{
    if (!inputDate) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (timezoneIanaFormat.length != nil) {
        NSTimeZone *usingTimeZone = [NSTimeZone timeZoneWithName:timezoneIanaFormat];
        formatter.timeZone = usingTimeZone;
    }
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:pattern options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    return [formatter stringFromDate:inputDate];
}

#pragma mark - Currency Related
#pragma mark Display
+ (NSString *_Nonnull)getCurrencySymbolFromLocal:(NSLocale *_Nonnull)checkingLocale
{
    return [checkingLocale objectForKey:NSLocaleCurrencySymbol];
}

+ (NSString *_Nonnull)getDefaultCurrencyStringFromValue:(NSNumber * _Nullable)value
{
    NSNumberFormatter *currencyFormatter = [self getCurrentCurrencyNumberFormatter];
    return [currencyFormatter stringFromNumber:value ?: @(0)];
}

/*!
 * @brief This is a method used to get the number base on the smallest Unit From the value you input.
 */
+ (NSNumber *_Nonnull)getNumberWithTheSmallestUnitFromValue:(NSNumber *_Nullable)value
{
    //// Update this method in multiple currency
    NSDecimalNumber *originalDeciamNumber = [NSDecimalNumber decimalNumberWithString:value.stringValue];
    NSUInteger fractionDigits = [self getCurrentCurrencyNumberFormatter].maximumFractionDigits;
    for (int i = 0; i < fractionDigits ; i += 1) {
        originalDeciamNumber = [originalDeciamNumber decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"10"]];
    }
    return @(originalDeciamNumber.integerValue);
}

+ (NSDecimalNumber *_Nonnull)getOriginalValueFromNumberBasedOnTheSmallestUnit:(NSNumber *_Nonnull)numberBasedOnTheSmallestUnit
{
    NSNumberFormatter *usingCurrencyNumberFormatter = [self getCurrentCurrencyNumberFormatter];
    NSDecimalNumber *resultDecimalNumber = numberBasedOnTheSmallestUnit.decimalNumber;
    NSDecimalNumber *tenDecimalNumber = [NSDecimalNumber decimalNumberWithString:@"10"];
    NSUInteger fractionDigits = usingCurrencyNumberFormatter.maximumFractionDigits;
    for (int i = 0; i < fractionDigits ; i += 1) {
        resultDecimalNumber = [resultDecimalNumber decimalNumberByDividingBy:tenDecimalNumber];
    }
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:usingCurrencyNumberFormatter.maximumFractionDigits raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    resultDecimalNumber = [resultDecimalNumber decimalNumberByRoundingAccordingToBehavior:handler];
    return resultDecimalNumber;
}

+ (NSNumber *_Nonnull)getCurrencyValueFromDefaultCurrencyString:(NSString * _Nullable)defaultCurrencyString
{
    return [self getCurrencyValueFromDefaultCurrencyString:defaultCurrencyString
                                  containingCurrencySymbol:YES];
}

+ (NSNumber *_Nonnull)getCurrencyValueFromDefaultCurrencyString:(NSString * _Nullable)defaultCurrencyString containingCurrencySymbol:(BOOL)isContainingCurrencySymbol
{
    NSNumber *returnNumber = nil;
    NSNumberFormatter *currencyFormatter = [self getCurrentCurrencyNumberFormatter];
    if (!isContainingCurrencySymbol) {
        currencyFormatter.currencySymbol = @"";
    }
    if (defaultCurrencyString != nil) {
        returnNumber = [currencyFormatter numberFromString:defaultCurrencyString];
    }
    return returnNumber ?: @(0);
}

#pragma mark Support Methods
+ (NSNumberFormatter *)getCurrentCurrencyNumberFormatter
{
    NSLocale *currencyLocale = [self getCurrentStoredDefaultLocal];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = currencyLocale;
    [formatter setGroupingSeparator:[currencyLocale objectForKey:NSLocaleGroupingSeparator]];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    return formatter;
}

#pragma mark - Deprecated Methods
+ (NSDate *)parseDateFromLocaleFormatedString:(NSString *)localFormatedString withPattern:(NSString *)pattern
{
    return [self parseDateFromLocaleFormatedString:localFormatedString withFormatTemplate:pattern andLocale:[self getCurrentLocal]];
}

// This is the anti-method for + (NSString *)formatDate:(NSDate *)inputDate withFormatTemplate:(NSString *)template andLocale:(NSLocale *)locale
// I hope it works..... it will only convert locale formated String.
+ (NSDate *)parseDateFromLocaleFormatedString:(NSString *)localFormatedString withFormatTemplate:(NSString *)template andLocale:(NSLocale *)locale
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:template options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    return [formatter dateFromString:localFormatedString];
}

@end
