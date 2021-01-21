//
//  NSObject+KNVUNDPropertyModifyRelated.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/1/18.
//

#import <Foundation/Foundation.h>

#import "KNVUNDRuntimeRelatedTool.h"

@interface NSObject (KNVUNDPropertyModifyRelated)

#pragma mark - Override Methods
/// The format of the dictionary is <String(property name in object), @[String(property name in Self)]>
+ (NSDictionary *)objectMappingDictionary;
/// The formate of this dictionary is <String(property type name in object), @[String(property type name in Self)]>
+ (NSDictionary *)objectObjectTypePropertNameMappingDictionary;
+ (BOOL)supportObjectPropertyType:(KNVUNDRuntimeRelatedTool_PropertyType)objectPropertyType;
/// Override this method if you want to ensure the value is not nil;
+ (id)getDefaultValueForPropertyDetails:(KNVUNDRRTPropertyDetailsModel *)propertyDetails;
- (id)converObjectTypeValue:(id)value fromPropertyTypeName:(NSString *)fromTypeName toPropertytypeName:(NSString *)toTypeName;

#pragma mark - Initial
/// By Default we are using [Class objectMappingDictionary] as Dictionary
- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary;
- (instancetype)initWithObject:(id)object avoidObjectPropertyNames:(NSArray *)avoidingProperties;
- (instancetype)initWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties;

#pragma mark Support Methods
- (void)updateSelfWithObject:(id)object;
- (void)updateSelfWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary;
- (void)updateSelfWithObject:(id)object avoidObjectPropertyNames:(NSArray *)avoidingProperties;
- (void)updateSelfWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties;

#pragma mark - Updating Related Methods
/// By Default we are using [Class objectMappingDictionary] as Dictionary
- (void)updateObjectBasedOnSelf:(id)object;
- (void)updateObjectBasedOnSelf:(id)object avoidObjectPropertyNames:(NSArray *)avoidingProperties;
- (void)updateObjectBasedOnSelf:(id)object withMappingDictionary:(NSDictionary *)mappingDictionary;
- (void)updateObjectBasedOnSelf:(id)object withMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties;

#pragma mark - Deprecated Methods
- (void)updateObejctBasedOnSelf:(id)object __attribute__((deprecated("Pls use - (void)updateObjectBasedOnSelf: instead.")));
- (void)updateObejctBasedOnSelf:(id)object avoidObjectPropertyNames:(NSArray *)avoidingProperties __attribute__((deprecated("Pls use - (void)updateObjectBasedOnSelf:avoidObjectPropertyNames: instead.")));
- (void)updateObejctBasedOnSelf:(id)object withMappingDictionary:(NSDictionary *)mappingDictionary __attribute__((deprecated("Pls use - (void)updateObjectBasedOnSelf:withMappingDictionary: instead.")));
- (void)updateObejctBasedOnSelf:(id)object withMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties __attribute__((deprecated("Pls use - (void)updateObjectBasedOnSelf:withMappingDictionary:avoidObjectPropertyNames: instead.")));

@end
