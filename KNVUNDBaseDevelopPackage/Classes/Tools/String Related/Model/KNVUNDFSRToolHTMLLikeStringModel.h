//
//  KNVUNDFSRToolHTMLLikeStringModel.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 31/1/18.
//

#import "KNVUNDBaseModel.h"

typedef enum : NSUInteger {
    KNVUNDFSRToolHTMLLikeStringModel_Type_Format, /// Property will be "<propertyName>contentValue</propertyName>"
    KNVUNDFSRToolHTMLLikeStringModel_Type_PlaceHolder /// Property wrapped inside "[" and "]"
} KNVUNDFSRToolHTMLLikeStringModel_Type;

@interface KNVUNDFSRToolHTMLLikeStringModel : KNVUNDBaseModel

@property (nonatomic, strong, nonnull) NSString *propertyName;
@property (nonatomic) KNVUNDFSRToolHTMLLikeStringModel_Type type;
@property (nonatomic, strong, nullable) NSDictionary *additionalAttribute; //// Only Support <String: NSString or NSNumber>, //// Curently, from Reading Method, we will only return <String: String>

/// Remember... This value normally only related to it's parent content string index..... if it don't have parent, it will be the outCome
@property (nonatomic) NSUInteger location; /// If the formated String is "abac<propertyName>123456</propertyName>" the location will be 4.
/// If the formated String is "abac<propertyName>123456</propertyName><propertyName>123456</propertyName>" the frist location will be 4 and the second location will be 10
/// If the formated String is "12345675[propertyName]123456" the location will be 8.

/// These two properties are used to identify the hiearchy of the String Content's Level...
@property (nonatomic, strong, nullable) KNVUNDFSRToolHTMLLikeStringModel *parentLevelModel;
@property (readonly, nonnull) NSArray *relatdChildrenModels;

@property (readonly, nonnull) NSString *fullAttributesString;
@property (readonly, nonnull) NSString *fullFormatedString;
@property (readonly) NSUInteger fullLength;/// If the formated String is "abac<propertyName>123456</propertyName>" the fullLength will be 35.
/// If the formated String is "abac<propertyName >123456</propertyName>" the fullLength you read from Formated String will be 36.
/// If the formated String is "12345675[propertyName]123456" the fullLength will be 14.

//// This value only useful for KNVUNDFSRToolHTMLLikeStringModel_Type_Format..
@property (nonatomic, strong, nullable) NSString *contentValue; /// If this value is not nil, the formated string will be <propertyName additionalAttributeKey=additionalAttributeValue>contentValue</propertyName>

#pragma mark - Getters && Setters
#pragma mark - Setters
- (void)updateAddictionalAttributeKey:(NSString *_Nonnull)key withValue:(id _Nonnull)value;
- (void)updateFullLengthFromReading:(NSUInteger)fullLength;

#pragma mark - Initial
- (instancetype _Nonnull)initWithPropertyName:(NSString *_Nonnull)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type andLocation:(NSUInteger)location;
- (instancetype _Nonnull)initWithPropertyName:(NSString *_Nonnull)propertyName type:(KNVUNDFSRToolHTMLLikeStringModel_Type)type location:(NSUInteger)location attributesDictionary:(NSDictionary *_Nullable)attributes andContentValue:(NSString *_Nullable)contentValue;

#pragma mark - Getter Methods
- (id _Nullable)getAttributeValueFromAttributeKey:(NSString *_Nonnull)attributKey;

@end
