//
//  KNVUNDPropertyConvertingModel.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 7/6/19.
//  Copyright © 2019 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDBaseModel.h"
#import "NSObject+KNVUNDPropertyModifyRelated.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNVUNDPropertyConvertedModel : KNVUNDBaseModel

@property (nonatomic, strong) NSString *property_A;
@property (readonly) BOOL property_A_getter_been_called;
@property (readonly) BOOL property_A_setter_been_called;

@property (nonatomic, strong) NSString *property_B;
@property (readonly) BOOL property_B_getter_been_called;
@property (readonly) BOOL property_B_setter_been_called;

@property (nonatomic, strong) NSString *property_C;
@property (readonly) BOOL property_C_getter_been_called;
@property (readonly) BOOL property_C_setter_been_called;

@end

@interface KNVUNDPropertyConvertingModel : KNVUNDBaseModel

@property (nonatomic, strong) NSString *property_A_1;
@property (readonly) BOOL property_A_1_getter_been_called;
@property (readonly) BOOL property_A_1_setter_been_called;

@property (nonatomic, strong) NSString *property_A_2;
@property (readonly) BOOL property_A_2_getter_been_called;
@property (readonly) BOOL property_A_2_setter_been_called;

@property (nonatomic, strong) NSString *property_C_1;
@property (readonly) BOOL property_C_1_getter_been_called;
@property (readonly) BOOL property_C_1_setter_been_called;

@property (nonatomic, strong) NSString *property_D_1;
@property (readonly) BOOL property_D_1_getter_been_called;
@property (readonly) BOOL property_D_1_setter_been_called;

@property (nonatomic, strong) NSString *property_D_2;
@property (readonly) BOOL property_D_2_getter_been_called;
@property (readonly) BOOL property_D_2_setter_been_called;

@end

@interface KNVUNDPropertyConvertingIgnoreABModel : KNVUNDPropertyConvertingModel

@end

NS_ASSUME_NONNULL_END
