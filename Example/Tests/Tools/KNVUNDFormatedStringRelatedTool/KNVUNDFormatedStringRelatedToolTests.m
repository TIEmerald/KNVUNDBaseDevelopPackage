//
//  KNVUNDBaseDevelopPackageTests.m
//  KNVUNDBaseDevelopPackageTests
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

// https://github.com/Specta/Specta

#import "KNVUNDFormatedStringRelatedTool.h"

// Models
#import "KNVUNDFSRToolHTMLLikeStringModel+TestRelated.h"

SpecBegin(KNVUNDFormatedStringRelatedTool)

describe(@"FormatedStringRelatedTool", ^{
    
    
    describe(@"Reading Function", ^{
        describe(@"Normal Parameter", ^{
            // start lcation = 0, checking times = KNVUNDFormatedStringRelatedTool_ReadFunction_MaximumCheckTimes(0) should remove content value = NO
            
            NSString *checkingPropertyName = @"test";
            
            void(^normalParameterReadFunctionTesting)(NSString *, NSString *, NSArray *) = ^(NSString *checkingFormat, NSString *expectResultString, NSArray *expectResultResultArray){
                
                NSString *usingString = [checkingFormat stringByReplacingOccurrencesOfString:@"%@"
                                                                                  withString:checkingPropertyName];
                NSMutableString *checkingString = [NSMutableString stringWithString:usingString];
                NSArray *readedResult = [KNVUNDFormatedStringRelatedTool readFormatedString:checkingString
                                                                           withPropertyName:checkingPropertyName
                                                                  fromStartCheckingLocation:0
                                                                              checkingTimes:KNVUNDFormatedStringRelatedTool_ReadFunction_MaximumCheckTimes
                                                                   shouldRemoveContentValue:NO];
                
                expect([checkingString isEqualToString:expectResultString]).to.beTruthy();
                expect([expectResultResultArray count] == [readedResult count]).to.beTruthy();
                for(int index = 0; index < [readedResult count]; index += 1) {
                    KNVUNDFSRToolHTMLLikeStringModel *getResultModel = readedResult[index];
                    KNVUNDFSRToolHTMLLikeStringModel *expectedResultModel = expectResultResultArray[index];
                    expect([getResultModel isEqual:expectedResultModel]).to.beTruthy();
                }
            };
            
            NSString *checkingFormatedStringPurePropertyFormat1 = [NSMutableString stringWithString:@"<%@></%@>"];
            NSString *checkingFormatedStringPurePropertyResult1 = [NSMutableString stringWithString:@""];
            NSArray *checkingFormatedStringPurePropertyExpectResult1 = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                               location:0
                                                                                                                   attributesDictionary:nil
                                                                                                                        andContentValue:@""]];
            it(@"Pure Property Format 1", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat1,
                                                   checkingFormatedStringPurePropertyResult1,
                                                   checkingFormatedStringPurePropertyExpectResult1);
            });
            
            NSString *checkingFormatedStringPurePropertyFormat2 = [NSMutableString stringWithString:@"<%@>1<%@>2</%@></%@>"];
            NSString *checkingFormatedStringPurePropertyResult2 = [NSMutableString stringWithString:@"12"];
            NSArray *checkingFormatedStringPurePropertyExpectResult2 = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                    type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                location:0
                                                                                                                    attributesDictionary:nil
                                                                                                                         andContentValue:@"12"],
                                                                          [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                    type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                location:1
                                                                                                                    attributesDictionary:nil
                                                                                                                         andContentValue:@"2"]];
            
            it(@"Pure Property Format 2", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat2,
                                                   checkingFormatedStringPurePropertyResult2,
                                                   checkingFormatedStringPurePropertyExpectResult2);
            });
            
            NSString *checkingFormatedStringPurePropertyFormat3 = [NSMutableString stringWithString:@"<%@>1<%@>2</%@></%@> 3 <%@>4</%@>"];
            NSString *checkingFormatedStringPurePropertyResult3 = [NSMutableString stringWithString:@"12 3 4"];
            NSArray *checkingFormatedStringPurePropertyExpectResult3 = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                               location:0
                                                                                                                   attributesDictionary:nil
                                                                                                                        andContentValue:@"12"],
                                                                         [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                               location:1
                                                                                                                   attributesDictionary:nil
                                                                                                                        andContentValue:@"2"],
                                                                         [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                               location:5
                                                                                                                   attributesDictionary:nil
                                                                                                                        andContentValue:@"4"]];
            
            it(@"Pure Property Format 3", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat3,
                                                   checkingFormatedStringPurePropertyResult3,
                                                   checkingFormatedStringPurePropertyExpectResult3);
            });
        });
    });
});

SpecEnd

