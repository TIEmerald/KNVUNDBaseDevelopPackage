//
//  KNVUNDPropertyConvertingModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 7/6/19.
//  Copyright © 2019 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDPropertyConvertingModel.h"

#import "KNVUNDGeneralUtilsTool.h"

@implementation KNVUNDPropertyConvertedModel

- (instancetype)init
{
    if (self = [super init]) {
        self.property_A = [KNVUNDGeneralUtilsTool generateUUID];
        self.property_B = [KNVUNDGeneralUtilsTool generateUUID];
        self.property_C = [KNVUNDGeneralUtilsTool generateUUID];
    }
    return self;
}

@end

@implementation KNVUNDPropertyConvertingModel

#pragma mark - Overrided Methods
+ (NSDictionary *)objectMappingDictionary
{
    return @{
             @"property_A":@[@"property_A_1", @"property_A_2"],
             @"property_B":@[@"property_B_1", @"property_B_2"],
             @"property_C":@[@"property_C_1", @"property_C_2"],
             @"property_D":@[@"property_D_1", @"property_D_2"],
             };
}

+ (NSDictionary *)objectObjectTypePropertNameMappingDictionary
{
    return @{@"":@[@""],@"NSString":@[@"NSString"],@"NSNumber":@[@"NSNumber"],@"NSDecimalNumber":@[@"NSDecimalNumber"],@"KNVUNDLotsOfPropertiesModel":@[@"KNVUNDLotsOfPropertiesModel"]};
}

+ (BOOL)supportObjectPropertyType:(KNVUNDRuntimeRelatedTool_PropertyType)objectPropertyType
{
    return YES;
}

/// Considering
+ (id)getDefaultValueForPropertyDetails:(KNVUNDRRTPropertyDetailsModel *)propertyDetails
{
    return nil;
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        self.property_A_1 = [KNVUNDGeneralUtilsTool generateUUID];
        self.property_A_2 = [KNVUNDGeneralUtilsTool generateUUID];
        self.property_C_1 = [KNVUNDGeneralUtilsTool generateUUID];
        self.property_D_1 = [KNVUNDGeneralUtilsTool generateUUID];
        self.property_D_2 = [KNVUNDGeneralUtilsTool generateUUID];
    }
    return self;
}

@end
