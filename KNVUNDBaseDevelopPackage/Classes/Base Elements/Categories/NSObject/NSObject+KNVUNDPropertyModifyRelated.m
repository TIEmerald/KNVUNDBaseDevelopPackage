//
//  NSObject+KNVUNDPropertyModifyRelated.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 8/1/18.
//

#import "NSObject+KNVUNDPropertyModifyRelated.h"

/// Third Party
#import <LinqToObjectiveC/LinqToObjectiveC.h>

@implementation NSObject (KNVUNDPropertyModifyRelated)

#pragma mark - Overrided Methods
+ (NSDictionary *)objectMappingDictionary
{
    return @{};
}

+ (NSDictionary *)objectObjectTypePropertNameMappingDictionary
{
    return @{};
}

+ (BOOL)supportObjectPropertyType:(KNVUNDRuntimeRelatedTool_PropertyType)objectPropertyType
{
    return YES;
}

/// Considering
+ (id)getDefaultValueForPropertyDetails:(KNVUNDRRTPropertyDetailsModel *)propertyDetails
{
    //    if ([propertyDetails.typeName isEqualToString:KNVBaseJSOMModel_Supported_Property_Type_NSNumber]) {
    //        return @(0);
    //    } else if([propertyDetails.typeName isEqualToString:KNVBaseJSOMModel_Supported_Property_Type_NSDecimalNumber]) {
    //        return [NSDecimalNumber zero];
    //    } else if([propertyDetails.typeName isEqualToString:KNVBaseJSOMModel_Supported_Property_Type_NSString]) {
    //        return @"";
    //    }
    return nil;
}

- (id)converObjectTypeValue:(id)value fromPropertyTypeName:(NSString *)fromTypeName toPropertytypeName:(NSString *)toTypeName
{
    return value;
}

#pragma mark - Initial
- (instancetype)initWithObject:(id)object
{
    return [self initWithObject:object
       avoidObjectPropertyNames:nil];
}

- (instancetype)initWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary
{
    return [self initWithObject:object
           andMappingDictionary:mappingDictionary
       avoidObjectPropertyNames:nil];
}

- (instancetype)initWithObject:(id)object avoidObjectPropertyNames:(NSArray *)avoidingProperties
{
    return [self initWithObject:object
           andMappingDictionary:[[self class] objectMappingDictionary]
       avoidObjectPropertyNames:avoidingProperties];
}

- (instancetype)initWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties
{
    if (self = [self init]) {
        [self updateSelfWithObject:object
              andMappingDictionary:mappingDictionary
          avoidObjectPropertyNames:avoidingProperties];
    }
    return self;
}

#pragma mark Support Methods
- (void)updateSelfWithObject:(id)object
{
    [self updateSelfWithObject:object
      avoidObjectPropertyNames:nil];
}

- (void)updateSelfWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary
{
    [self updateSelfWithObject:object
          andMappingDictionary:mappingDictionary
      avoidObjectPropertyNames:nil];
}

- (void)updateSelfWithObject:(id)object avoidObjectPropertyNames:(NSArray *)avoidingProperties
{
    [self updateSelfWithObject:object
          andMappingDictionary:[[self class] objectMappingDictionary]
      avoidObjectPropertyNames:avoidingProperties];
}

- (void)updateSelfWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties
{
    [self compareAndUpdatePropertiesWithObject:object
                          andMappingDictionary:mappingDictionary
                      avoidObjectPropertyNames:avoidingProperties
                       withModifyPropertyBlock:^(KNVUNDRRTPropertyDetailsModel *selfPropertyDetails, KNVUNDRRTPropertyDetailsModel *objectPropertyDetails, BOOL isTwoPropertyDetailsValid) {
                           if (selfPropertyDetails.isReadOnly) {
                               return;
                           }
                           id passingValue = nil;
                           if (isTwoPropertyDetailsValid) {
                               passingValue = objectPropertyDetails.value;
                               KNVUNDRuntimeRelatedTool_PropertyType propertyType = selfPropertyDetails.propertyType; // When we reach this block, we are sure that the property type are same.
                               NSString *selfPropertyTypeName = selfPropertyDetails.typeName;
                               NSString *objectPropertyTypeName = objectPropertyDetails.typeName;
                               
                               if (propertyType == KNVUNDRuntimeRelatedTool_PropertyType_Object &&
                                   ![selfPropertyTypeName isEqualToString:objectPropertyTypeName]) {
                                   passingValue = [self converObjectTypeValue:passingValue
                                                         fromPropertyTypeName:objectPropertyTypeName
                                                           toPropertytypeName:selfPropertyTypeName];
                               }
                           }
                           // We will update the value to default value if the the value is nil...
                           passingValue = passingValue ?: [[self class]getDefaultValueForPropertyDetails:objectPropertyDetails];
                           [self setValue:passingValue
                                   forKey:selfPropertyDetails.propertyName];
                       }];
}

#pragma mark - Updating Related Methods
- (void)updateObejctBasedOnSelf:(id)object
{
    [self updateObejctBasedOnSelf:object
         avoidObjectPropertyNames:nil];
}

- (void)updateObejctBasedOnSelf:(id)object withMappingDictionary:(NSDictionary *)mappingDictionary
{
    [self updateObejctBasedOnSelf:object
            withMappingDictionary:mappingDictionary
         avoidObjectPropertyNames:nil];
}

- (void)updateObejctBasedOnSelf:(id)object avoidObjectPropertyNames:(NSArray *)avoidingProperties
{
    [self updateObejctBasedOnSelf:object
            withMappingDictionary:[[self class] objectMappingDictionary]
         avoidObjectPropertyNames:avoidingProperties];
}

- (void)updateObejctBasedOnSelf:(id)object withMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties
{
    [self compareAndUpdatePropertiesWithObject:object
                          andMappingDictionary:mappingDictionary
                      avoidObjectPropertyNames:avoidingProperties
                       withModifyPropertyBlock:^(KNVUNDRRTPropertyDetailsModel *selfPropertyDetails, KNVUNDRRTPropertyDetailsModel *objectPropertyDetails, BOOL isTwoPropertyDetailsValid) {
                           if (objectPropertyDetails.isReadOnly) {
                               return;
                           }
                           id passingValue = nil;
                           if (isTwoPropertyDetailsValid) {
                               passingValue = selfPropertyDetails.value;
                               KNVUNDRuntimeRelatedTool_PropertyType propertyType = selfPropertyDetails.propertyType; // When we reach this block, we are sure that the property type are same.
                               NSString *selfPropertyTypeName = selfPropertyDetails.typeName;
                               NSString *objectPropertyTypeName = objectPropertyDetails.typeName;
                               
                               if (propertyType == KNVUNDRuntimeRelatedTool_PropertyType_Object &&
                                   ![selfPropertyTypeName isEqualToString:objectPropertyTypeName]) {
                                   passingValue = [self converObjectTypeValue:passingValue
                                                         fromPropertyTypeName:selfPropertyTypeName
                                                           toPropertytypeName:objectPropertyTypeName];
                               }
                           }
                           // We will update the value to default value if the the value is nil...
                           passingValue = passingValue ?: [[self class]getDefaultValueForPropertyDetails:objectPropertyDetails];
                           [object setValue:passingValue
                                     forKey:objectPropertyDetails.propertyName];
                       }];
}

#pragma mark - Suppor Methods
- (BOOL)containsPropertyName:(NSString *)checkintPropertyName withProertyDetailsModel:(KNVUNDRRTPropertyDetailsModel * __autoreleasing *)checkingDetailsModel
{
    if (checkintPropertyName.length == 0) {
        return NO;
    }
    
    __block BOOL returnValue = NO;
    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:self
                                         withLoopBlock:^(KNVUNDRRTPropertyDetailsModel * _Nonnull detailsModel, BOOL *stopLoop) {
                                             if ([checkintPropertyName isEqualToString:detailsModel.propertyName]) {
                                                 if (checkingDetailsModel) {
                                                     *checkingDetailsModel = detailsModel;
                                                 }
                                                 returnValue = YES;
                                                 *stopLoop = YES;
                                             }
                                         }];
    return returnValue;
}

- (BOOL)isSelfPropertyDetails:(KNVUNDRRTPropertyDetailsModel *)selfPropertyDetails isValidWithObjectPropertyDetails:(KNVUNDRRTPropertyDetailsModel *)objectPropertyDetails
{
    //DLog(@"Checking Property from Self: %@\n And Property from Object: %@.",
    //         selfPropertyDetails.debugDescription,
    //         objectPropertyDetails.debugDescription);
    if (selfPropertyDetails.propertyType != objectPropertyDetails.propertyType) {
        //DLog(@"Invalid, The property types are not matching");
        return NO;
    }
    
    if (![[self class] supportObjectPropertyType:selfPropertyDetails.propertyType]) {
        //DLog(@"Invalid, The property type is supported");
        return NO;
    }
    
    if (selfPropertyDetails.propertyType == KNVUNDRuntimeRelatedTool_PropertyType_Object) {
        NSArray *supportingSelfPropertyTypeNames = [[[self class] objectObjectTypePropertNameMappingDictionary] valueForKey:objectPropertyDetails.typeName];
        for (NSString *supportedPropertyName in supportingSelfPropertyTypeNames) {
            if ([selfPropertyDetails.typeName isEqualToString:supportedPropertyName]) {
                //DLog(@"Valid");
                return YES;
            }
        }
        //DLog(@"Invalid, The object property type property names are not matching");
        
        return NO;
    }
    //DLog(@"Valid");
    
    return YES;
}

- (void)compareAndUpdatePropertiesWithObject:(id)object andMappingDictionary:(NSDictionary *)mappingDictionary avoidObjectPropertyNames:(NSArray *)avoidingProperties withModifyPropertyBlock:(void(^)(KNVUNDRRTPropertyDetailsModel *selfPropertyDetails, KNVUNDRRTPropertyDetailsModel *objectPropertyDetails, BOOL isTwoPropertyDetailsValid))modifyPropertyBlock
{
    NSDictionary *usingMappingDictionary = [mappingDictionary linq_where:^BOOL(NSString *key, id value) {
        for (NSString *avoidingProperty in avoidingProperties) {
            if ([avoidingProperty isEqualToString:key]) {
                return NO;
            }
        }
        return YES;
    }];
    
    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:object
                                                 withLoopBlock:^(KNVUNDRRTPropertyDetailsModel * _Nonnull detailsModel, BOOL *stopLoop) {
                                                     NSArray *selfPropertyNames = usingMappingDictionary[detailsModel.propertyName];
                                                     for (NSString *selfPropertyName in selfPropertyNames) {
                                                         KNVUNDRRTPropertyDetailsModel *selfPropertyDetails;
                                                         if (![self containsPropertyName:selfPropertyName
                                                                 withProertyDetailsModel:&selfPropertyDetails]) {
                                                             return;
                                                         }
                                                         
                                                         if (modifyPropertyBlock) {
                                                             modifyPropertyBlock(selfPropertyDetails,
                                                                                 detailsModel,
                                                                                 [self isSelfPropertyDetails:selfPropertyDetails
                                                                            isValidWithObjectPropertyDetails:detailsModel]);
                                                         }
                                                     }
                                                 }];
}

@end
