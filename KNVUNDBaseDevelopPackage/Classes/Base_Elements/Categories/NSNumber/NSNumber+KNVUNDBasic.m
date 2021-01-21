//
//  NSNumber+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 7/9/18.
//

#import "NSNumber+KNVUNDBasic.h"

@implementation NSNumber (KNVUNDBasic)

#pragma mark - Getters & Setters
#pragma mark - Getters
- (NSDecimalNumber *)decimalNumber {
    return [NSDecimalNumber decimalNumberWithDecimal:self.decimalValue];
}

@end
