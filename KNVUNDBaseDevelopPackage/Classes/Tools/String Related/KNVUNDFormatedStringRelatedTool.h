//
//  KNVUNDFormatedStringRelatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "KNVUNDBaseModel.h"

#import "KNVUNDFSRToolHTMLLikeStringModel.h"

@interface KNVUNDFormatedStringRelatedTool : KNVUNDBaseModel

#pragma mark - HTML-like Strings
#pragma mark - Generating
+ (NSString *_Nullable)generateFormatedStringWithHTMLLikeStringModel:(KNVUNDFSRToolHTMLLikeStringModel *_Nonnull)fromModel withError:(NSError *_Nullable *_Nullable)error;

#pragma mark - Reading
extern NSUInteger KNVUNDFormatedStringRelatedTool_ReadFunction_MaximumCheckTimes;

/*!
 * @brief This method will read the property name you want to check inside the mutable string you passed in and will delete all formated logic from the same mutable string.
 * @param formatedString The formated String you want to read.
 * @param propertyName The property name you are going to read. Please ensure the property name is not empty.. and Please make sure your property Name doesn't start or end with white spaces.
 * @param startCheckingLocation From which index in formatedString we started checking.
 * @param checkingTimes How many propertyName we will check at most... if this value is 0, we won't have any limit for the checking.... A.K.A. we will check all placeholders with property name propertyName in formatedString
 * @param shouldRemoveContentValue If the type is KNVUNDFSRToolHTMLLikeStringModel_Type_Format, should we delete the contentValue from formatedString or not.
 * @return NSArray An array of KNVUNDFSRToolHTMLLikeStringModel
 */
+ (NSArray *_Nonnull)readFormatedString:(NSMutableString *_Nonnull)formatedString withPropertyName:(NSString *_Nonnull)propertyName fromStartCheckingLocation:(NSUInteger)startCheckingLocation checkingTimes:(NSUInteger)checkingTimes shouldRemoveContentValue:(BOOL)shouldRemoveContentValue;

///// if this property be set to yes, we won't check into the content, which means... some formate like <aaa><aaa></aaa></aaa> will only return one Model with contentValue = @"<aaa></aaa>"
/////// NOTICE that This method is not finished yet....
//+ (NSArray *_Nonnull)readFormatedString:(NSMutableString *_Nonnull)formatedString withPropertyName:(NSString *_Nonnull)propertyName fromStartCheckingLocation:(NSUInteger)startCheckingLocation checkingTimes:(NSUInteger)checkingTimes shouldRemoveContentValue:(BOOL)shouldRemoveContentValue andShouldDeepChecking:(BOOL)shouldDeepChecking;

@end
