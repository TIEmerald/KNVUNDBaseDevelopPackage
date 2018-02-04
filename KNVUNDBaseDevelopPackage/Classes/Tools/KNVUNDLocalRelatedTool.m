//
//  KNVUNDCurrencyRelatedTool.m
//  Expecta
//
//  Created by Erjian Ni on 10/12/17.
//

#import "KNVUNDLocalRelatedTool.h"

@implementation KNVUNDLocalRelatedTool


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
    NSLocale *currencyLocale = [self getCurrentLocal];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.locale = currencyLocale;
    [formatter setGroupingSeparator:[currencyLocale objectForKey:NSLocaleGroupingSeparator]];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    return formatter;
}

@end
