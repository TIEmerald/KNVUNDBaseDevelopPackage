//
//  KNVUNDRegexReleatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 4/4/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDRegexRelatedTool : KNVUNDBaseModel

#pragma mark - Constants
extern NSString * const KNVUNDRegexRelatedTool_Pattern_Alphabets;
extern NSString * const KNVUNDRegexRelatedTool_Pattern_Numbers;
extern NSString * const KNVUNDRegexRelatedTool_Pattern_Email;
extern NSString * const KNVUNDRegexRelatedTool_Pattern_Name;
extern NSString * const KNVUNDRegexRelatedTool_Pattern_IPv4Address;
extern NSString * const KNVUNDRegexRelatedTool_Pattern_VoucherCode;

#pragma mark - Checks Registration
/*!
 * @discussion  Check if the day String is valid or not. It only checks if the year between 1 and 9999 or not
 * @param yearStr the String you input to represent the year.
 * @return BOOL the checking result
 */
+ (BOOL)checkYear:(NSString *)yearStr;

/*!
 * @discussion  Check if the day String is valid or not. It only checks if the month between 1 and 12 or not
 * @param monthStr the String you input to represent the month.
 * @return BOOL the checking result
 */
+ (BOOL)checkMonth:(NSString *)monthStr;

/*!
 * @discussion  Check if the day String is valid or not. It is the default method only check if the day is in range of 1 - 31 or not. If you need to check if day Stirng is valid or not with month and year, you need to call another method of RegexHelper:
 * @param dayStr the String you input to represent day in month.
 * @return BOOL the checking result
 */
+ (BOOL)checkDay:(NSString *)dayStr;

/*!
 * @discussion  Check if the day String is valid or not. It is an advanced one which will check if the day is valid in the particular year and month.
 * @param dayStr the String you input to represent day in month.
 * @param monthStr Not Null the String you input to represent the month.
 * @param yearStr Nullable the String you input to represent the year.
 * @return BOOL the checking result
 */
+ (BOOL)checkDay:(NSString *)dayStr withMonth:(NSString *)monthStr andYear:(NSString *)yearStr;

/*!
 * @discussion Check if the string consist only of the digits 0 through 9
 * @param aString the String you want to validate
 * @return BOOL the checking result
 */
+ (BOOL)checkOnlyContainDecimalDigit:(NSString *)aString;

+ (BOOL)validateString:(NSString *)string withPattern:(NSString *)pattern;

@end
