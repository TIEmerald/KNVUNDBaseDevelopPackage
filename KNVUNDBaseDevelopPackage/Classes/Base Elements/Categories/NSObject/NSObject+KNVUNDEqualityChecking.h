//
//  NSObject+KNVUNDEqualityChecking.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 30/1/18.
//

#import <Foundation/Foundation.h>

@interface NSObject (KNVUNDEqualityChecking)

#pragma mark - Equality
- (BOOL)isEqual:(id _Nonnull)object exceptPropertyNames:(NSArray * _Nullable)propertyNames exceptPropertyShouldNotBeSame:(BOOL)exceptValueShouldNotBeSame;

@end
