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
            __block BOOL shouldRemoveContentValue = NO;
            __block NSString *checkingPropertyName = @"test";
            NSUInteger startCheckingLocation = 0;
            NSUInteger checkingTimes = KNVUNDFormatedStringRelatedTool_ReadFunction_MaximumCheckTimes;
            
            beforeEach(^{
                // This is run before each example.
                shouldRemoveContentValue = NO;
                checkingPropertyName = @"test";
            });
            
            void(^normalParameterReadFunctionTesting)(NSString *, NSString *, NSArray *) = ^(NSString *checkingFormat, NSString *expectResultString, NSArray *expectResultResultArray){
                NSString *usingString = [checkingFormat stringByReplacingOccurrencesOfString:@"%@"
                                                                                  withString:checkingPropertyName];
                NSMutableString *checkingString = [NSMutableString stringWithString:usingString];
                NSArray *readedResult = [KNVUNDFormatedStringRelatedTool readFormatedString:checkingString
                                                                           withPropertyName:checkingPropertyName
                                                                  fromStartCheckingLocation:startCheckingLocation
                                                                              checkingTimes:checkingTimes
                                                                   shouldRemoveContentValue:shouldRemoveContentValue];
                
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
            
            NSString *specialTestPropertyName1_1 = @"knvdiv";
            NSString *checkingFormatedStringPurePropertyFormat1_1 = [NSMutableString stringWithString:@"<%@>[logo]</%@>"];
            NSString *checkingFormatedStringPurePropertyResult1_1 = [NSMutableString stringWithString:@""];
            NSArray *checkingFormatedStringPurePropertyExpectResult1_1 = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:specialTestPropertyName1_1
                                                                                                                                     type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                 location:0
                                                                                                                     attributesDictionary:nil
                                                                                                                          andContentValue:@"[logo]"]];
            it(@"Pure Property Format 1", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat1,
                                                   checkingFormatedStringPurePropertyResult1,
                                                   checkingFormatedStringPurePropertyExpectResult1);
                
                shouldRemoveContentValue = YES;
                checkingPropertyName = specialTestPropertyName1_1;
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat1_1,
                                                   checkingFormatedStringPurePropertyResult1_1,
                                                   checkingFormatedStringPurePropertyExpectResult1_1);
                
            });
            
            NSString *checkingFormatedStringPurePropertyFormat2 = [NSMutableString stringWithString:@"<%@ ></%@>"];
            NSString *checkingFormatedStringPurePropertyResult2 = [NSMutableString stringWithString:@""];
            NSArray *checkingFormatedStringPurePropertyExpectResult2 = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                   type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                               location:0
                                                                                                                   attributesDictionary:nil
                                                                                                                        andContentValue:@""]];
            it(@"Pure Property Format 2", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat2,
                                                   checkingFormatedStringPurePropertyResult2,
                                                   checkingFormatedStringPurePropertyExpectResult2);
            });
            
            NSString *checkingFormatedStringPurePropertyFormat3 = [NSMutableString stringWithString:@"<%@>1<%@>2</%@></%@>"];
            NSString *checkingFormatedStringPurePropertyResult3 = [NSMutableString stringWithString:@"12"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest3ResultModel1 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:0
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"12"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest3ResultModel2 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:1
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"2"];
            purePropertyTest3ResultModel2.parentLevelModel = purePropertyTest3ResultModel1;
            NSArray *checkingFormatedStringPurePropertyExpectResult3 = @[purePropertyTest3ResultModel1,
                                                                         purePropertyTest3ResultModel2];
            
            it(@"Pure Property Format 3", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat3,
                                                   checkingFormatedStringPurePropertyResult3,
                                                   checkingFormatedStringPurePropertyExpectResult3);
            });
            
            NSString *checkingFormatedStringPurePropertyFormat4 = [NSMutableString stringWithString:@"<%@>1<%@>2</%@></%@> 3 <%@>4</%@>"];
            NSString *checkingFormatedStringPurePropertyResult4 = [NSMutableString stringWithString:@"12 3 4"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest4ResultModel1 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:0
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"12"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest4ResultModel2 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:1
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"2"];
            purePropertyTest4ResultModel2.parentLevelModel = purePropertyTest4ResultModel1;
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest4ResultModel3 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:5
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"4"];
            NSArray *checkingFormatedStringPurePropertyExpectResult4 = @[purePropertyTest4ResultModel1, purePropertyTest4ResultModel2, purePropertyTest4ResultModel3];
            
            it(@"Pure Property Format 4", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat4,
                                                   checkingFormatedStringPurePropertyResult4,
                                                   checkingFormatedStringPurePropertyExpectResult4);
            });
            
            NSString *checkingFormatedStringPurePropertyFormat5 = [NSMutableString stringWithString:@"<%@>1<%@>2</%@></%@> 3 <%@><%@>4</%@>5</%@>"];
            NSString *checkingFormatedStringPurePropertyResult5 = [NSMutableString stringWithString:@"12 3 45"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest5ResultModel1 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:0
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"12"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest5ResultModel2 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:1
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"2"];
            purePropertyTest5ResultModel2.parentLevelModel = purePropertyTest5ResultModel1;
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest5ResultModel3 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:5
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"45"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest5ResultModel4 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:0
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"4"];
            purePropertyTest5ResultModel4.parentLevelModel = purePropertyTest5ResultModel3;
            NSArray *checkingFormatedStringPurePropertyExpectResult5 = @[purePropertyTest5ResultModel1, purePropertyTest5ResultModel2, purePropertyTest5ResultModel3, purePropertyTest5ResultModel4];
            
            it(@"Pure Property Format 5", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat5,
                                                   checkingFormatedStringPurePropertyResult5,
                                                   checkingFormatedStringPurePropertyExpectResult5);
            });
            
            NSString *checkingFormatedStringPurePropertyFormat6 = [NSMutableString stringWithString:@"<%@>1<%@>2</%@></%@> 3 <%@>4</%@>"];
            NSString *checkingFormatedStringPurePropertyResult6 = [NSMutableString stringWithString:@" 3 "];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest6ResultModel1 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:0
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"1"];
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest6ResultModel2 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:1
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"2"];
            purePropertyTest6ResultModel2.parentLevelModel = purePropertyTest6ResultModel1;
            KNVUNDFSRToolHTMLLikeStringModel *purePropertyTest6ResultModel3 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                        type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                    location:3
                                                                                                                        attributesDictionary:nil
                                                                                                                             andContentValue:@"4"];
            NSArray *checkingFormatedStringPurePropertyExpectResult6 = @[purePropertyTest6ResultModel1, purePropertyTest6ResultModel2, purePropertyTest6ResultModel3];
            
            it(@"Pure Property Format 6", ^{
                shouldRemoveContentValue = YES;
                normalParameterReadFunctionTesting(checkingFormatedStringPurePropertyFormat6,
                                                   checkingFormatedStringPurePropertyResult6,
                                                   checkingFormatedStringPurePropertyExpectResult6);
            });
            
            
            NSString *attributeKeyName1 = @"attribute1";
            NSString *attributeValue1 = @"attributeValue1";
            
            NSString *checkingFormatedStringPropertyWithAttributesFormat1 = [NSMutableString stringWithString:[NSString stringWithFormat:@"<%%@ %@=\"%@\"></%%@>",
                                                                                                               attributeKeyName1,
                                                                                                               attributeValue1]];
            NSString *checkingFormatedStringPropertyWithAttributesResult1 = [NSMutableString stringWithString:@""];
            NSArray *checkingFormatedStringPropertyWithAttributesExpectResult1 = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:checkingPropertyName
                                                                                                                                             type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                         location:0
                                                                                                                             attributesDictionary:@{attributeKeyName1:attributeValue1}
                                                                                                                                  andContentValue:@""]];
            
            NSString *attributeKeyName1_1_1 = @"orientation_direction";
            NSString *attributeValue1_1_1 = @"TOP_RIGHT";
            NSString *attributeKeyName1_1_2 = @"width";
            NSString *attributeValue1_1_2 = @"75";
            
            NSString *checkingFormatedStringPropertyWithAttributesFormat1_1 = [NSMutableString stringWithString:[NSString stringWithFormat:@"<%%@ %@=\"%@\" %@=\"%@\">[logo]</%%@>",
                                                                                                               attributeKeyName1_1_1,
                                                                                                               attributeValue1_1_1,
                                                                                                               attributeKeyName1_1_2,
                                                                                                               attributeValue1_1_2]];
            NSString *checkingFormatedStringPropertyWithAttributesResult1_1 = [NSMutableString stringWithString:@""];
            NSArray *checkingFormatedStringPropertyWithAttributesExpectResult1_1 = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:specialTestPropertyName1_1
                                                                                                                                             type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                         location:0
                                                                                                                             attributesDictionary:@{attributeKeyName1_1_1 : attributeValue1_1_1,
                                                                                                                                                    attributeKeyName1_1_2 : attributeValue1_1_2
                                                                                                                                                    }
                                                                                                                                  andContentValue:@"[logo]"]];
            
            NSString *checkingFormatedStringPropertyWithAttributesFormat1_1_plus = [NSMutableString stringWithString:[NSString stringWithFormat:@"<%%@ %@=\"%@\" %@=%@>[logo]</%%@>",
                                                                                                                 attributeKeyName1_1_1,
                                                                                                                 attributeValue1_1_1,
                                                                                                                 attributeKeyName1_1_2,
                                                                                                                 attributeValue1_1_2]];
            NSString *checkingFormatedStringPropertyWithAttributesResult1_1_plus = [NSMutableString stringWithString:@""];
            NSArray *checkingFormatedStringPropertyWithAttributesExpectResult1_1_plus = @[[[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:specialTestPropertyName1_1
                                                                                                                                               type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                           location:0
                                                                                                                               attributesDictionary:@{attributeKeyName1_1_1 : attributeValue1_1_1,
                                                                                                                                                      attributeKeyName1_1_2 : attributeValue1_1_2
                                                                                                                                                      }
                                                                                                                                    andContentValue:@"[logo]"]];
            
            it(@"Property with Attributes Format 1", ^{
                normalParameterReadFunctionTesting(checkingFormatedStringPropertyWithAttributesFormat1,
                                                   checkingFormatedStringPropertyWithAttributesResult1,
                                                   checkingFormatedStringPropertyWithAttributesExpectResult1);
                
                shouldRemoveContentValue = YES;
                checkingPropertyName = specialTestPropertyName1_1;
                normalParameterReadFunctionTesting(checkingFormatedStringPropertyWithAttributesFormat1_1,
                                                   checkingFormatedStringPropertyWithAttributesResult1_1,
                                                   checkingFormatedStringPropertyWithAttributesExpectResult1_1);
                
                normalParameterReadFunctionTesting(checkingFormatedStringPropertyWithAttributesFormat1_1_plus,
                                                   checkingFormatedStringPropertyWithAttributesResult1_1_plus,
                                                   checkingFormatedStringPropertyWithAttributesExpectResult1_1_plus);
            });
            
            
            NSString *checkingFormatedStringPropertyWithAttributesFormat2 = @"<%@ orientation_direction=\"TOP_DOWN\"><%@ orientation_direction=\"TOP_RIGHT\" width=75>[logo]</%@><%@ orientation_direction=\"TOP_LEFT\" width=150>[logo]</%@></%@>";
            NSString *checkingFormatedStringPropertyWithAttributesResult2 = [NSMutableString stringWithString:@""];
            KNVUNDFSRToolHTMLLikeStringModel *attributTest2ResultModel1 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:specialTestPropertyName1_1
                                                                                                                                    type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                location:0
                                                                                                                    attributesDictionary:@{@"orientation_direction" : @"TOP_DOWN"}
                                                                                                                         andContentValue:@""];
            KNVUNDFSRToolHTMLLikeStringModel *attributTest2ResultModel2 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:specialTestPropertyName1_1
                                                                                                                                    type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                location:0
                                                                                                                    attributesDictionary:@{@"orientation_direction" : @"TOP_RIGHT",
                                                                                                                                           @"width" : @"75"
                                                                                                                                           }
                                                                                                                         andContentValue:@"[logo]"];
            attributTest2ResultModel2.parentLevelModel = attributTest2ResultModel1;
            KNVUNDFSRToolHTMLLikeStringModel *attributTest2ResultModel3 = [[KNVUNDFSRToolHTMLLikeStringModel alloc] initWithPropertyName:specialTestPropertyName1_1
                                                                                                                                    type:KNVUNDFSRToolHTMLLikeStringModel_Type_Format
                                                                                                                                location:0
                                                                                                                    attributesDictionary:@{@"orientation_direction" : @"TOP_LEFT",
                                                                                                                                           @"width" : @"150"}
                                                                                                                         andContentValue:@"[logo]"];
            attributTest2ResultModel3.parentLevelModel = attributTest2ResultModel1;
            NSArray *checkingFormatedStringPropertyWithAttributesExpectResult3 = @[attributTest2ResultModel1,
                                                                                   attributTest2ResultModel2,
                                                                                   attributTest2ResultModel3];
            
            it(@"Property with Attributes Format 2", ^{
                shouldRemoveContentValue = YES;
                checkingPropertyName = specialTestPropertyName1_1;
                normalParameterReadFunctionTesting(checkingFormatedStringPropertyWithAttributesFormat2,
                                                   checkingFormatedStringPropertyWithAttributesResult2,
                                                   checkingFormatedStringPropertyWithAttributesExpectResult3);
            });
            
        });
    });
});

SpecEnd

