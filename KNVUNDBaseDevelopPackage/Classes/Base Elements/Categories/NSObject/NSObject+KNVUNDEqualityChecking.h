//
//  NSObject+KNVUNDEqualityChecking.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 30/1/18.
//

#import <Foundation/Foundation.h>

@interface NSObject (KNVUNDEqualityChecking)

// This method is too messy, considering the array and dictionary, which might make the comparing logic out of control.... therefore, for equality checking, we highly suggest you convert your Object to a string and compare the string....
/////
//
//#pragma mark - Equality
//- (BOOL)isEqual:(id _Nonnull)object exceptPropertyNames:(NSArray * _Nullable)propertyNames exceptPropertyShouldNotBeSame:(BOOL)exceptValueShouldNotBeSame;

@end
