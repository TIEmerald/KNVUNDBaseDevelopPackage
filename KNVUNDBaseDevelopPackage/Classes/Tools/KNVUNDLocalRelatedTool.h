//
//  KNVUNDCurrencyRelatedTool.h
//  Expecta
//
//  Created by Erjian Ni on 10/12/17.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDLocalRelatedTool : KNVUNDBaseModel

#pragma mark - Constants
//// Please change User Default for this value, if you want to change the default Local;
extern NSString *const KNVUNDLocalRelatedTool_UserDefault_Key_StoredDefaultLocal_Identifier;

#pragma mark - Locale Related
/*!
 * @brief This method return the Country Name for current device setted locale in English. Like if you set your device Setting Region to Australia this method will return "Australia"
 * @return NSString The country name based on which region your device is setted.
 */
+ (NSString *)getCurrentLocaleEnglishName;

+ (NSLocale *)getCurrentLocal;
+ (void)logLocaleDetailsFromLocale:(NSLocale *)checkingLocale;

#pragma mark - Date Parsing Related
#pragma mark General
+ (NSString *)formatDate:(NSDate *)inputDate withFormat:(NSString *)formatStr;
+ (NSDate *)parseDateForString:(NSString *)dateStr withFormat:(NSString *)formatStr;

#pragma mark Locale Related
+ (NSString *)formatDate:(NSDate *)inputDate withPattern:(NSString *)pattern;
+ (NSString *)formatDate:(NSDate *)inputDate withFormatTemplate:(NSString *)template andLocale:(NSLocale *)locale;
+ (NSDate *)parseDateFromLocaleFormatedString:(NSString *)localFormatedString withPattern:(NSString *)pattern;
+ (NSDate *)parseDateFromLocaleFormatedString:(NSString *)localFormatedString withFormatTemplate:(NSString *)template andLocale:(NSLocale *)locale;

#pragma mark - Currency Related
#pragma mark Display
+ (NSString *_Nonnull)getCurrencySymbolFromLocal:(NSLocale *_Nonnull)checkingLocale;

/*!
 * @brief I build this method is considering that perhaps in the future we might need to support other currency. To save us from much changes, we can use this method in the place we need to format currency.
 * @param value The money value you want to formate
 * @return NSString Formated Currecy String based on certain value.
 */
+ (NSString *_Nonnull)getDefaultCurrencyStringFromValue:(NSNumber * _Nullable)value;

/*!
 * @brief This is a method used to get the number base on the smallest Unit From the value you input.
 */
+ (NSNumber *_Nonnull)getNumberWithTheSmallestUnitFromValue:(NSNumber *_Nullable)value;
+ (NSDecimalNumber *_Nonnull)getOriginalValueFromNumberBasedOnTheSmallestUnit:(NSNumber *_Nonnull)numberBasedOnTheSmallestUnit;

+ (NSNumber *_Nonnull)getCurrencyValueFromDefaultCurrencyString:(NSString * _Nullable)defaultCurrencyString;
+ (NSNumber *_Nonnull)getCurrencyValueFromDefaultCurrencyString:(NSString * _Nullable)defaultCurrencyString containingCurrencySymbol:(BOOL)isContainingCurrencySymbol;

#pragma mark Support Methods
/*!
 * @brief You could call this method to get current Currency Number Formatter, in case you need use it.
 */
+ (NSNumberFormatter *_Nonnull)getCurrentCurrencyNumberFormatter;

@end
