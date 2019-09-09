//
//  KNVUNDPropertyConvertingModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 7/6/19.
//  Copyright © 2019 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDPropertyConvertingModel.h"

#import "KNVUNDGeneralUtilsTool.h"

@interface KNVUNDPropertyConvertedModel() {
    NSString *_property_A;
    BOOL _property_A_getter_been_called;
    BOOL _property_A_setter_been_called;
    
    NSString *_property_B;
    BOOL _property_B_getter_been_called;
    BOOL _property_B_setter_been_called;
    
    NSString *_property_C;
    BOOL _property_C_getter_been_called;
    BOOL _property_C_setter_been_called;
}


@end

@implementation KNVUNDPropertyConvertedModel

#pragma mark - Getters && Seters
#pragma mark - Getters
- (NSString *)property_A
{
    _property_A_getter_been_called = YES;
    return _property_A;
}

- (BOOL)property_A_getter_been_called
{
    return _property_A_getter_been_called;
}

- (BOOL)property_A_setter_been_called
{
    return _property_A_setter_been_called;
}

- (NSString *)property_B
{
    _property_B_getter_been_called = YES;
    return _property_B;
}

- (BOOL)property_B_getter_been_called
{
    return _property_B_getter_been_called;
}

- (BOOL)property_B_setter_been_called
{
    return _property_B_setter_been_called;
}

- (NSString *)property_C
{
    _property_C_getter_been_called = YES;
    return _property_C;
}

- (BOOL)property_C_getter_been_called
{
    return _property_C_getter_been_called;
}

- (BOOL)property_C_setter_been_called
{
    return _property_C_setter_been_called;
}

#pragma mark - Setters
- (void)setProperty_A:(NSString *)property_A
{
    _property_A_setter_been_called = YES;
    _property_A = property_A;
}

- (void)setProperty_B:(NSString *)property_B
{
    _property_B_setter_been_called = YES;
    _property_B = property_B;
}

- (void)setProperty_C:(NSString *)property_C
{
    _property_C_setter_been_called = YES;
    _property_C = property_C;
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        _property_A = [KNVUNDGeneralUtilsTool generateUUID];
        _property_B = [KNVUNDGeneralUtilsTool generateUUID];
        _property_C = [KNVUNDGeneralUtilsTool generateUUID];
    }
    return self;
}

@end

@interface KNVUNDPropertyConvertingModel () {
    NSString *_property_A_1;
    BOOL _property_A_1_getter_been_called;
    BOOL _property_A_1_setter_been_called;
    
    NSString *_property_A_2;
    BOOL _property_A_2_getter_been_called;
    BOOL _property_A_2_setter_been_called;
    
    NSString *_property_C_1;
    BOOL _property_C_1_getter_been_called;
    BOOL _property_C_1_setter_been_called;
    
    NSString *_property_D_1;
    BOOL _property_D_1_getter_been_called;
    BOOL _property_D_1_setter_been_called;
    
    NSString *_property_D_2;
    BOOL _property_D_2_getter_been_called;
    BOOL _property_D_2_setter_been_called;
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

#pragma mark - Getters && Seters
#pragma mark - Getters
- (NSString *)property_A_1
{
    _property_A_1_getter_been_called = YES;
    return _property_A_1;
}

- (BOOL)property_A_1_getter_been_called
{
    return _property_A_1_getter_been_called;
}

- (BOOL)property_A_1_setter_been_called
{
    return _property_A_1_setter_been_called;
}

- (NSString *)property_A_2
{
    _property_A_2_getter_been_called = YES;
    return _property_A_2;
}

- (BOOL)property_A_2_getter_been_called
{
    return _property_A_2_getter_been_called;
}

- (BOOL)property_A_2_setter_been_called
{
    return _property_A_2_setter_been_called;
}

- (NSString *)property_C_1
{
    _property_C_1_getter_been_called = YES;
    return _property_C_1;
}

- (BOOL)property_C_1_getter_been_called
{
    return _property_C_1_getter_been_called;
}

- (BOOL)property_C_1_setter_been_called
{
    return _property_C_1_setter_been_called;
}

- (NSString *)property_D_1
{
    _property_D_1_getter_been_called = YES;
    return _property_D_1;
}

- (BOOL)property_D_1_getter_been_called
{
    return _property_D_1_getter_been_called;
}

- (BOOL)property_D_1_setter_been_called
{
    return _property_D_1_setter_been_called;
}

- (NSString *)property_D_2
{
    _property_D_2_getter_been_called = YES;
    return _property_D_2;
}

- (BOOL)property_D_2_getter_been_called
{
    return _property_D_2_getter_been_called;
}

- (BOOL)property_D_2_setter_been_called
{
    return _property_D_2_setter_been_called;
}

#pragma mark - Setters
- (void)setProperty_A_1:(NSString *)property_A_1
{
    _property_A_1_setter_been_called = YES;
    _property_A_1 = property_A_1;
}

- (void)setProperty_A_2:(NSString *)property_A_2
{
    _property_A_2_setter_been_called = YES;
    _property_A_2 = property_A_2;
}

- (void)setProperty_C_1:(NSString *)property_C_1
{
    _property_C_1_setter_been_called = YES;
    _property_C_1 = property_C_1;
}

- (void)setProperty_D_1:(NSString *)property_D_1
{
    _property_D_1_setter_been_called = YES;
    _property_D_1 = property_D_1;
}

- (void)setProperty_D_2:(NSString *)property_D_2
{
    _property_D_2_setter_been_called = YES;
    _property_D_2 = property_D_2;
}

#pragma mark - Initial
- (instancetype)init
{
    if (self = [super init]) {
        _property_A_1 = [KNVUNDGeneralUtilsTool generateUUID];
        _property_A_2 = [KNVUNDGeneralUtilsTool generateUUID];
        _property_C_1 = [KNVUNDGeneralUtilsTool generateUUID];
        _property_D_1 = [KNVUNDGeneralUtilsTool generateUUID];
        _property_D_2 = [KNVUNDGeneralUtilsTool generateUUID];
    }
    return self;
}

@end

@interface KNVUNDPropertyConvertingIgnoreABModel() {
    BOOL _checkingBoolean;
}

@end

@implementation KNVUNDPropertyConvertingIgnoreABModel

+ (NSDictionary *)objectMappingDictionary
{
    return @{
             @"property_C":@[@"property_C_1", @"property_C_2"],
             @"property_D":@[@"property_D_1", @"property_D_2"],
             };
}

@end
