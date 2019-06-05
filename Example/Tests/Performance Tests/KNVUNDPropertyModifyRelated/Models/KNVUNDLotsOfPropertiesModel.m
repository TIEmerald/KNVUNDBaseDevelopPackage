//
//  KNVUNDLotsOfPropertiesModel.m
//  KNVUNDBaseDevelopPackage_Tests
//
//  Created by Erjian Ni on 5/6/19.
//  Copyright © 2019 niyejunze.j@gmail.com. All rights reserved.
//

#include <objc/runtime.h>

#import "KNVUNDLotsOfPropertiesModel.h"

#import "KNVUNDGeneralUtilsTool.h"

typedef enum : NSUInteger {
    KNVUNDLotsOfPropertiesModel_Supported_Value_Type_String = 0,
    KNVUNDLotsOfPropertiesModel_Supported_Value_Type_NSNumber,
    KNVUNDLotsOfPropertiesModel_Supported_Value_Type_NSDecimalNumber,
    KNVUNDLotsOfPropertiesModel_Supported_Value_Type_TotalCount,
} KNVUNDLotsOfPropertiesModel_Supported_Value_Type;

@implementation KNVUNDLotsOfPropertiesModel

int const KNVUNDLotsOfPropertiesModel_PropertiesCount = 100;
int const KNVUNDLotsOfPropertiesModel_IgnoringPropertiesCount = 100;
NSString * const KNVUNDLotsOfPropertiesModel_PropertiesFormat = @"property_%d";

#pragma mark - Overrided Methods
+ (NSDictionary *)objectMappingDictionary
{
    NSMutableDictionary *tempDictionary = [NSMutableDictionary new];
    for (int i = 0; i < KNVUNDLotsOfPropertiesModel_PropertiesCount; i += 1) {
        NSString *propertyString = [NSString stringWithFormat:KNVUNDLotsOfPropertiesModel_PropertiesFormat, i];
        [tempDictionary setObject:@[propertyString]
                           forKey:propertyString];
    }
    return [NSDictionary dictionaryWithDictionary:tempDictionary];
}

+ (NSDictionary *)objectObjectTypePropertNameMappingDictionary
{
    return @{@"":@[@""]};
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

#pragma mark - Initial
- (instancetype)initWithPropertyTypeArray:(NSArray *)propertyTypeArray
{
    if (self = [self init]) {
        for (int i = 0; i < KNVUNDLotsOfPropertiesModel_PropertiesCount; i += 1) {
            NSString *propertyString = [NSString stringWithFormat:KNVUNDLotsOfPropertiesModel_PropertiesFormat, i];
            NSInteger propertyTypeArrayCount = [propertyTypeArray count];
            KNVUNDLotsOfPropertiesModel_Supported_Value_Type properType = KNVUNDLotsOfPropertiesModel_Supported_Value_Type_String;
            if (propertyTypeArrayCount > 0) {
                NSNumber *propertyTypeNumber = propertyTypeArray[i % propertyTypeArrayCount];
                if ([propertyTypeNumber respondsToSelector:@selector(intValue)]) {
                    properType = propertyTypeNumber.intValue % KNVUNDLotsOfPropertiesModel_Supported_Value_Type_TotalCount;
                }
            }
            id settingValue = [KNVUNDLotsOfPropertiesModel generateSupportedValue:properType];
            [self setValue:settingValue forKey:propertyString];
        }
    }
    return self;
}

#pragma mark Support Methods
+ (id)generateSupportedValue:(KNVUNDLotsOfPropertiesModel_Supported_Value_Type)type
{
    switch (type) {
        case KNVUNDLotsOfPropertiesModel_Supported_Value_Type_NSDecimalNumber:
            return [NSDecimalNumber decimalNumberWithString:[NSNumber numberWithInteger:arc4random()].stringValue];
        case KNVUNDLotsOfPropertiesModel_Supported_Value_Type_NSNumber:
            return [NSNumber numberWithInteger:arc4random()];
        default:
            return [KNVUNDGeneralUtilsTool generateUUID];
    }
}

#pragma mark - Equality Checking
- (BOOL)isEqual:(id)object
{
    for (int i = 0; i < KNVUNDLotsOfPropertiesModel_PropertiesCount; i += 1) {
        NSString *propertyString = [NSString stringWithFormat:KNVUNDLotsOfPropertiesModel_PropertiesFormat, i];
        id selfValue = [self valueForKey:propertyString];
        id comparingValue = [object valueForKey:propertyString];
        if (![comparingValue isKindOfClass:[selfValue class]]) {
            return false;
        }
        if (![comparingValue isEqual:selfValue]) {
            return false;
        }
    }
    return true;
}

#pragma mark - Support Methods
+ (NSArray *)randomValueTypeArray
{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int i = 0; i < KNVUNDLotsOfPropertiesModel_PropertiesCount; i += 1) {
        [tempArray addObject:[NSNumber numberWithInt:arc4random()]];
    }
    return [NSArray arrayWithArray:tempArray];
}

+ (NSArray *)generatePropertiesArrayWithCount:(NSInteger)propertiesCount
{
    NSMutableArray *tempArray = [NSMutableArray new];
    for (int i = 0; i < propertiesCount; i += 1) {
        NSString *propertyString = [NSString stringWithFormat:KNVUNDLotsOfPropertiesModel_PropertiesFormat, i];
        [tempArray addObject:propertyString];
    }
    return [NSArray arrayWithArray:tempArray];
}

@end
