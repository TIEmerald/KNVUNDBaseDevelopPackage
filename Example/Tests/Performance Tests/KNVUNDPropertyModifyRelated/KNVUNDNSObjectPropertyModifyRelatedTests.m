//
//  KNVUNDNSObjectPropertyModifyRelatedTests.m
//  KNVUNDBaseDevelopPackage_Tests
//
//  Created by Erjian Ni on 9/9/19.
//  Copyright © 2019 niyejunze.j@gmail.com. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KNVUNDLotsOfPropertiesModel.h"
#import "KNVUNDPropertyConvertingModel.h"

@interface KNVUNDNSObjectPropertyModifyRelatedTests : XCTestCase

@end

@implementation KNVUNDNSObjectPropertyModifyRelatedTests

#pragma mark - Constants
NSTimeInterval const KNVUNDNSObjectPropertyModifyRelated_Performance_100Testing_TimeLimit = 4;

#pragma mark - General Methods
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

#pragma mark - Test Methods
- (void)testEquanlityUpdateObejctBasedOnSelf
{
    NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
    KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    [testingModel updateObejctBasedOnSelf:convertedModel];
    XCTAssertTrue([testingModel isEqual:convertedModel], @"updateSelfWithObject: should make convertedModel all property be the same as testing");
}

- (void)testEquanlityUpdateSelfWithObject
{
    NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
    KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    [testingModel updateSelfWithObject:convertedModel];
    XCTAssertTrue([testingModel isEqual:convertedModel], @"updateSelfWithObject: should make testingModel's all property be the same as convertedModel");
}

- (void)testPerformanceTimeUpdateObjectWith300Properties {
    // This is an example of a performance test case.
    NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
    KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    [self measureBlock:^{
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateObjectBasedOnSelf:convertedModel];
        }
    }];
}

- (void)testPerformanceTimeUpdateObjectWith300Properties_Ignoring100Properties {
    // This is an example of a performance test case.
    NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
    KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    [self measureBlock:^{
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateObjectBasedOnSelf:convertedModel avoidObjectPropertyNames:[KNVUNDLotsOfPropertiesModel generatePropertiesArrayWithCount:100]];
        }
    }];
}

- (void)testPerformanceTimeUpdateSelfBasedOnObjectWith300Properties {
    // This is an example of a performance test case.
    NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
    KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    [self measureBlock:^{
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateSelfWithObject:convertedModel];
        }
    }];
}

- (void)testPerformanceTimeUpdateSelfBasedOnObjectWith300Properties_Ignoring100Properties {
    // This is an example of a performance test case.
    NSArray *usingPropertyTypeArray = [KNVUNDLotsOfPropertiesModel randomValueTypeArray];
    KNVUNDLotsOfPropertiesModel *testingModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    KNVUNDLotsOfPropertiesModel *convertedModel = [[KNVUNDLotsOfPropertiesModel alloc] initWithPropertyTypeArray:usingPropertyTypeArray];
    [self measureBlock:^{
        for (int i = 0; i < 100; i += 1) {
            [testingModel updateSelfWithObject:convertedModel avoidObjectPropertyNames:[KNVUNDLotsOfPropertiesModel generatePropertiesArrayWithCount:100]];
        }
    }];
}

- (void)testWorkflowMappingDictionaryContainsSomePropertyNotExisted
{
    KNVUNDPropertyConvertingModel *modelA = [KNVUNDPropertyConvertingModel new];
    KNVUNDPropertyConvertedModel *modelB = [KNVUNDPropertyConvertedModel new];
    [modelA updateSelfWithObject:modelB];
    XCTAssertTrue([modelA.property_A_1 isEqual:modelB.property_A], @"updateSelfWithObject: modelA.property_A_1 should be same as modelB.property_A");
    XCTAssertTrue([modelA.property_A_2 isEqual:modelB.property_A], @"updateSelfWithObject: modelA.property_A_2 should be same as modelB.property_A");
    XCTAssertTrue([modelA.property_C_1 isEqual:modelB.property_C], @"updateSelfWithObject: modelA.property_C_1 should be same as modelB.property_C");
    
    modelA = [KNVUNDPropertyConvertingModel new];
    modelB = [KNVUNDPropertyConvertedModel new];
    [modelA updateObjectBasedOnSelf:modelB];
    XCTAssert([modelB.property_A isEqual:modelA.property_A_2], @"updateObjectBasedOnSelf: modelB.property_A should be same as modelA.property_A_2");
    XCTAssert([modelB.property_C isEqual:modelA.property_C_1], @"updateObjectBasedOnSelf: modelB.property_C should be same as modelA.property_C_1");
}

- (void)testWorkflowAccessorsBehaviour_UpdateSelfWithObject_Normal
{
    KNVUNDPropertyConvertingModel *modelA = [KNVUNDPropertyConvertingModel new];
    KNVUNDPropertyConvertedModel *modelB = [KNVUNDPropertyConvertedModel new];
    [modelA updateSelfWithObject:modelB];
    XCTAssertTrue(modelA.property_A_1_setter_been_called, @"[modelA updateSelfWithObject:modelB], modelA's property A_1 setter methods should be called");
    XCTAssertTrue(modelA.property_A_2_setter_been_called, @"[modelA updateSelfWithObject:modelB], modelA's property A_2 setter methods should be called");
    XCTAssertTrue(modelA.property_C_1_setter_been_called, @"[modelA updateSelfWithObject:modelB], modelA's property C_1 setter methods should be called");
    XCTAssertFalse(modelA.property_D_1_setter_been_called, @"[modelA updateSelfWithObject:modelB], modelA's property D_1 setter methods shouldn't be called");
    XCTAssertFalse(modelA.property_D_2_setter_been_called, @"[modelA updateSelfWithObject:modelB], modelA's property D_2 setter methods shouldn't be called");
    XCTAssertTrue(modelB.property_A_getter_been_called, @"[modelA updateSelfWithObject:modelB], modelB's property A getter methods should be called");
    XCTAssertTrue(modelB.property_B_getter_been_called, @"[modelA updateSelfWithObject:modelB], modelB's property B getter methods should be called");
    XCTAssertTrue(modelB.property_C_getter_been_called, @"[modelA updateSelfWithObject:modelB], modelB's property C getter methods should be called");
}

- (void)testWorkflowAccessorsBehaviour_UpdateObjectBasedOnSelf_Normal
{
    KNVUNDPropertyConvertingModel *modelA = [KNVUNDPropertyConvertingModel new];
    KNVUNDPropertyConvertedModel *modelB = [KNVUNDPropertyConvertedModel new];
    [modelA updateObjectBasedOnSelf:modelB];
    XCTAssertTrue(modelA.property_A_1_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelA's property A_1 getter methods should be called");
    XCTAssertTrue(modelA.property_A_2_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelA's property A_2 getter methods should be called");
    XCTAssertTrue(modelA.property_C_1_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelA's property C_1 getter methods should be called");
    XCTAssertFalse(modelA.property_D_1_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelA's property D_1 getter methods shouldn't be called");
    XCTAssertFalse(modelA.property_D_2_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelA's property D_2 getter methods shouldn't be called");
    XCTAssertTrue(modelB.property_A_setter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelB's property A setter methods should be called");
    XCTAssertFalse(modelB.property_B_setter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelB's property B setter methods shouldn't be called");
    XCTAssertTrue(modelB.property_C_setter_been_called, @"[modelA updateObjectBasedOnSelf:modelB], modelB's property C setter methods should be called");
}

- (void)testWorkflowAccessorsBehaviour_UpdateSelfWithObject_NotIncludeAB
{
    KNVUNDPropertyConvertingIgnoreABModel *modelA = [KNVUNDPropertyConvertingIgnoreABModel new];
    KNVUNDPropertyConvertedModel *modelB = [KNVUNDPropertyConvertedModel new];
    [modelA updateSelfWithObject:modelB];
    XCTAssertFalse(modelA.property_A_1_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelA's property A_1 setter methods shouldn't be called");
    XCTAssertFalse(modelA.property_A_2_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelA's property A_2 setter methods shouldn't be called");
    XCTAssertTrue(modelA.property_C_1_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelA's property C_1 setter methods should be called");
    XCTAssertFalse(modelA.property_D_1_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelA's property D_1 setter methods shouldn't be called");
    XCTAssertFalse(modelA.property_D_2_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelA's property D_2 setter methods shouldn't be called");
    XCTAssertFalse(modelB.property_A_getter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelB's property A getter methods shouldn't be called");
    XCTAssertFalse(modelB.property_B_getter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelB's property B getter methods shouldn't be called");
    XCTAssertTrue(modelB.property_C_getter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelB's property C getter methods should be called");
}

- (void)testWorkflowAccessorsBehaviour_UpdateObjectBasedOnSelf_NotIncludeAB
{
    KNVUNDPropertyConvertingIgnoreABModel *modelA = [KNVUNDPropertyConvertingIgnoreABModel new];
    KNVUNDPropertyConvertedModel *modelB = [KNVUNDPropertyConvertedModel new];
    [modelA updateObjectBasedOnSelf:modelB];
    XCTAssertFalse(modelA.property_A_1_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB] (no A, B), modelA's property A_1 getter methods shouldn't be called");
    XCTAssertFalse(modelA.property_A_2_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB] (no A, B), modelA's property A_2 getter methods shouldn't be called");
    XCTAssertTrue(modelA.property_C_1_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB] (no A, B), modelA's property C_1 getter methods should be called");
    XCTAssertFalse(modelA.property_D_1_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB] (no A, B), modelA's property D_1 getter methods shouldn't be called");
    XCTAssertFalse(modelA.property_D_2_getter_been_called, @"[modelA updateObjectBasedOnSelf:modelB] (no A, B), modelA's property D_2 getter methods shouldn't be called");
    XCTAssertFalse(modelB.property_A_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelB's property A setter methods shouldn't be called");
    XCTAssertFalse(modelB.property_B_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelB's property B setter methods shouldn't be called");
    XCTAssertTrue(modelB.property_C_setter_been_called, @"[modelA updateSelfWithObject:modelB] (no A, B), modelB's property C setter methods should be called");
}

@end
