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
@property (nonatomic, strong) NSString *property_B;
@property (nonatomic, strong) NSString *property_C;

@end

@interface KNVUNDPropertyConvertingModel : KNVUNDBaseModel

@property (nonatomic, strong) NSString *property_A_1;
@property (nonatomic, strong) NSString *property_A_2;
@property (nonatomic, strong) NSString *property_C_1;
@property (nonatomic, strong) NSString *property_D_1;
@property (nonatomic, strong) NSString *property_D_2;

@end

NS_ASSUME_NONNULL_END
