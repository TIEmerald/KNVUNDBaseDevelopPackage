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
    
    NSTimeInterval const KNVUNDPropertyModifyRelated_Performance_100Testing_TimeLimit = 4;
    
    it(@"performance time checking", ^{
        NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
        KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
        NSDate *beforeStartTime = [NSDate date];
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateObejctBasedOnSelf:convertedModel avoidObjectPropertyNames:[KNVUNDLotsOfPropertiesModel generatePropertiesArrayWithCount:100]];
        }
        NSTimeInterval spendingTime = [[NSDate date] timeIntervalSinceDate:beforeStartTime];
        NSLog(@"Update Object logic, Time Spent for 100 ignore Properties: %f",spendingTime); /// Right now it's around 2s for 100 updating process for objects with 300 properties.
        expect(spendingTime<KNVUNDPropertyModifyRelated_Performance_100Testing_TimeLimit).to.beTruthy();
        
        beforeStartTime = [NSDate date];
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateObejctBasedOnSelf:convertedModel];
        }
        spendingTime = [[NSDate date] timeIntervalSinceDate:beforeStartTime];
        NSLog(@"Update Object logic, Time Spent for without ignore Properties: %f",spendingTime); /// Right now it's around 2.5s for 100 updating process for objects with 300 properties.
        expect(spendingTime<KNVUNDPropertyModifyRelated_Performance_100Testing_TimeLimit).to.beTruthy();
        
        beforeStartTime = [NSDate date];
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateSelfWithObject:convertedModel avoidObjectPropertyNames:[KNVUNDLotsOfPropertiesModel generatePropertiesArrayWithCount:100]];
        }
        spendingTime = [[NSDate date] timeIntervalSinceDate:beforeStartTime];
        NSLog(@"Update Self logic, Time Spent for 100 ignore Properties: %f",spendingTime); /// Right now it's around 2s for 100 updating process for objects with 300 properties.
        expect(spendingTime<KNVUNDPropertyModifyRelated_Performance_100Testing_TimeLimit).to.beTruthy();
        
        beforeStartTime = [NSDate date];
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateSelfWithObject:convertedModel];
        }
        spendingTime = [[NSDate date] timeIntervalSinceDate:beforeStartTime];
        NSLog(@"Update Self logic, Time Spent for without ignore Properties: %f",spendingTime); /// Right now it's around 2.5s for 100 updating process for objects with 300 properties.
        expect(spendingTime<KNVUNDPropertyModifyRelated_Performance_100Testing_TimeLimit).to.beTruthy();
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

