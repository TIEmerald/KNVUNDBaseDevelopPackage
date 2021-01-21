//
//  NSObject+KNVUNDEqualityChecking.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 30/1/18.
//

#import "NSObject+KNVUNDEqualityChecking.h"

// Tools
#import "KNVUNDRuntimeRelatedTool.h"

// Categories
#import "NSObject+KNVUNDLogRelated.h"

@implementation NSObject (KNVUNDEqualityChecking)

//#pragma mark - Equality
//- (BOOL)isEqual:(id)object exceptPropertyNames:(NSArray *)propertyNames exceptPropertyShouldNotBeSame:(BOOL)exceptValueShouldNotBeSame
//{
//    return [self isEqual:object
//     exceptPropertyNames:propertyNames
//exceptPropertyShouldNotBeSame:exceptValueShouldNotBeSame
//withHaveCheckedObjectSet:nil];
//}
//
//- (BOOL)isEqual:(id)object exceptPropertyNames:(NSArray *)propertyNames exceptPropertyShouldNotBeSame:(BOOL)exceptValueShouldNotBeSame withHaveCheckedObjectSet:(NSMutableSet *)checkedObjectSet
//{
//    // Step One, Check if the object you passed in is same Class or not.
//    if ([object class] != [self class]) {
//        [self performConsoleLogWithLogStringFormat:@"Equally Checking Failed..... Classes are not matching\nSelf Class: %@\nObject Class:%@",
//         NSStringFromClass([self class]),
//         NSStringFromClass([object class])];
//        return NO;
//    }
//    
//    __block BOOL returnValue = YES;
//    NSMutableSet *usingCheckedObjectSet = checkedObjectSet ?: [NSMutableSet new];
//    [usingCheckedObjectSet addObject:@[self, object]];
//    
//    [KNVUNDRuntimeRelatedTool loopThroughAllPropertiesOfObject:object
//                                                 withLoopBlock:^(KNVUNDRRTPropertyDetailsModel * _Nonnull detailsModel, BOOL *stopLoop) {
//                                                     KNVUNDRuntimeRelatedTool_PropertyType propertyType = detailsModel.propertyType;
//                                                     NSString *propertyName = (NSString *)detailsModel.propertyName;
//                                                     BOOL isObject = (propertyType == KNVUNDRuntimeRelatedTool_PropertyType_Object);
//                                                     id selfPropertyValue = [self valueForKey:propertyName];
//                                                     id objectPropertyValue = detailsModel.value;
//                                                     BOOL isExceptedProperty = [propertyNames containsObject:propertyName];
//                                                     
//                                                     for (NSArray *checkedPair in usingCheckedObjectSet.allObjects) {
//                                                         if (checkedPair[0] == selfPropertyValue && checkedPair[1] == objectPropertyValue) {
//                                                             [self performConsoleLogWithLogStringFormat:@"Equally Checking Passing..... We have already started or finished the equality checking for these value pair\nProperty Name: %@ \nThe value in self is: %@ \nBut the value in object is: %@",
//                                                              propertyName,
//                                                              selfPropertyValue,
//                                                              objectPropertyValue];
//                                                             return;
//                                                         }
//                                                     }
//                                                     
//                                                     if (!isExceptedProperty) {
//                                                         if (!isObject && selfPropertyValue == objectPropertyValue) {
//                                                             return;
//                                                         } else if (isObject){
//                                                             if ((selfPropertyValue == nil) && (objectPropertyValue == nil)) {
//                                                                 return;
//                                                             } else if([selfPropertyValue respondsToSelector:@selector(isEqual:exceptPropertyNames:exceptPropertyShouldNotBeSame:withHaveCheckedObjectSet:)] && [selfPropertyValue isEqual:objectPropertyValue exceptPropertyNames:nil exceptPropertyShouldNotBeSame:exceptValueShouldNotBeSame withHaveCheckedObjectSet:usingCheckedObjectSet]) {
//                                                                 return;
//                                                             } else if([selfPropertyValue respondsToSelector:@selector(isEqual:)] && [selfPropertyValue isEqual:objectPropertyValue]) {
//                                                                 return;
//                                                             }
//                                                         }
//                                                         [self performConsoleLogWithLogStringFormat:@"Equally Checking Failed.....\nProperty Name: %@ \nThe value in self is: %@ \nBut the value in object is: %@",
//                                                          propertyName,
//                                                          selfPropertyValue,
//                                                          objectPropertyValue];
//                                                         
//                                                         returnValue = NO;
//                                                         *stopLoop = YES;
//                                                     } else {
//                                                         if (exceptValueShouldNotBeSame) {
//                                                             if (!isObject && selfPropertyValue != objectPropertyValue) {
//                                                                 return;
//                                                             } else if (isObject){
//                                                                 if ((selfPropertyValue == nil) && (objectPropertyValue != nil)) {
//                                                                     return;
//                                                                 } else if([selfPropertyValue respondsToSelector:@selector(isEqual:exceptPropertyNames:exceptPropertyShouldNotBeSame:withHaveCheckedObjectSet:)] && ! [selfPropertyValue isEqual:objectPropertyValue exceptPropertyNames:nil exceptPropertyShouldNotBeSame:exceptValueShouldNotBeSame withHaveCheckedObjectSet:usingCheckedObjectSet]) {
//                                                                     return;
//                                                                 } else if ([selfPropertyValue respondsToSelector:@selector(isEqual:)] && ![selfPropertyValue isEqual:objectPropertyValue]){
//                                                                     return;
//                                                                 }
//                                                             }
//                                                             [self performConsoleLogWithLogStringFormat:@"Equally Checking Failed..... This Property shouldn't be same\nProperty Name: %@ \nThe value in self is: %@ \nBut the value in object is: %@",
//                                                              propertyName,
//                                                              selfPropertyValue,
//                                                              objectPropertyValue];
//                                                             
//                                                             returnValue = NO;
//                                                             *stopLoop = YES;
//                                                         }
//                                                     }
//                                                 }];
//    
//    return returnValue;
//}
@end
