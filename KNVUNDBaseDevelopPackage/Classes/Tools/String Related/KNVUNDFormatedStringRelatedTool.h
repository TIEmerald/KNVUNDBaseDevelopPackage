//
//  KNVUNDFormatedStringRelatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "KNVUNDBaseModel.h"

typedef enum : NSUInteger {
    KNVUNDFSRToolHTMLLikeStringModel_Type_Format, /// Property will be "<propertyName>contentValue</propertyName>"
    KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder /// Property wrapped inside "[" and "]"
} KNVUNDFSRToolHTMLLikeStringModel_Type;

@interface KNVUNDFSRToolHTMLLikeStringModel : KNVUNDBaseModel

@property (nonatomic, strong, nonnull) NSString *propertyName;
@property (nonatomic) KNVUNDFSRToolHTMLLikeStringModel_Type type;
@property (nonatomic, strong, nullable) NSDictionary *additionalAttribute; //// Only Support <String, NSString or NSNumber>,
@property (nonatomic) NSUInteger location; /// If the formated String is "abac<propertyName>123456</propertyName>" the location will be 4.
                                           /// If the formated String is "abac<propertyName>123456</propertyName><propertyName>123456</propertyName>" the frist location will be 4 and the second location will be 10
                                           /// If the formated String is "12345675[propertyName]123456" the location will be 8.

@property (readonly, nonnull) NSString *fullAttributesString;
@property (readonly, nonnull) NSString *fullFormatedString;
@property (readonly) NSUInteger fullLength;/// If the formated String is "abac<propertyName>123456</propertyName>" the fullLength will be 35.
                                           /// If the formated String is "abac<propertyName >123456</propertyName>" the fullLength you read from Formated String will be 36.
                                           /// If the formated String is "12345675[propertyName]123456" the fullLength will be 14.

//// This value only useful when you
@property (nonatomic, strong, nullable) NSString *contentValue; /// If this value is not nil, the formated string will be <propertyName additionalAttributeKey=additionalAttributeValue>contentValue</propertyName>

#pragma mark - Initial
- (instancetype _Nonnull)initWithPropertyName:(NSString *_Nonnull)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type andLocation:(NSUInteger)location;
- (instancetype _Nonnull)initWithPropertyName:(NSString *_Nonnull)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type location:(NSUInteger)location attributesDictionary:(NSDictionary *_Nullable)attributes andContentValue:(NSString *_Nullable)contentValue;

@end

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

@end
