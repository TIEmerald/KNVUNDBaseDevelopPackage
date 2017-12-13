//
//  KNVUNDCurrencyRelatedTool.h
//  Expecta
//
//  Created by Erjian Ni on 10/12/17.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDLocalRelatedTool : KNVUNDBaseModel

#pragma mark - Locale Related
/*!
 * @brief This method return the Country Name for current device setted locale in English. Like if you set your device Setting Region to Australia this method will return "Australia"
 * @return NSString The country name based on which region your device is setted.
 */
+ (NSString *)getCurrentLocaleEnglishName;

+ (NSLocale *)getCurrentLocal;
+ (void)logLocaleDetailsFromLocale:(NSLocale *)checkingLocale;

#pragma mark - Currency Related
#pragma mark Display
+ (NSString *_Nonnull)getCurrencySymbolFromLocal:(NSLocale *_Nonnull)checkingLocale;

/*!
 * @brief I build this method is considering that perhaps in the future we might need to support other currency. To save us from much changes, we can use this method in the place we need to format currency.
 * @param value The money value you want to formate
 * @return NSString Formated Currecy String based on certain value.
 */
+ (NSString *_Nonnull)getDefaultCurrencyStringFromValue:(NSNumber * _Nullable)value;

+ (NSNumber *_Nonnull)getCurrencyValueFromDefaultCurrencyString:(NSString * _Nullable)defaultCurrencyString;

#pragma mark Support Methods
/*!
 * @brief You could call this method to get current Currency Number Formatter, in case you need use it.
 */
+ (NSNumberFormatter *_Nonnull)getCurrentCurrencyNumberFormatter;

@end
