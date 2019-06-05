//
//  KNVUNDBaseDevelopPackageTests.m
//  KNVUNDBaseDevelopPackageTests
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

// https://github.com/Specta/Specta

#import "KNVUNDLotsOfPropertiesModel.h"

SpecBegin(KNVUNDPropertyModifyRelated)

describe(@"NSObject_KNVUNDPropertyModifyRelated", ^{
    
    it(@"performance time checking", ^{
        NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
        KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        NSDate *beforeStartTime = [NSDate date];
        [testingModel updateObejctBasedOnSelf:convertedModel avoidObjectPropertyNames:[KNVUNDLotsOfPropertiesModel generatePropertiesArrayWithCount:10]];
        NSTimeInterval spendingTime = [[NSDate date] timeIntervalSinceDate:beforeStartTime];
        NSLog(@"Time Spent: %f",spendingTime);
        expect(spendingTime<1).to.beTruthy();
    });
    
    it(@"updateObejctBasedOnSelf", ^{
        NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
        KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        [testingModel updateObejctBasedOnSelf:convertedModel];
        expect([testingModel isEqual:convertedModel]).to.beTruthy();
    });
    
    it(@"updateSelfWithObject", ^{
        NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
        KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        [testingModel updateSelfWithObject:convertedModel];
        expect([testingModel isEqual:convertedModel]).to.beTruthy();
    });
});

SpecEnd

