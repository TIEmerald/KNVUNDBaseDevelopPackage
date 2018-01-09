//
//  NSDecimalNumber+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 9/1/18.
//

#import "NSDecimalNumber+KNVUNDBasic.h"

@implementation NSDecimalNumber (KNVUNDBasic)

#pragma mark - Validators
- (BOOL)couldBecomeDivisor
{
    return [self couldPassToOperator] && ![self isEqualToNumber:[NSDecimalNumber zero]];
}

- (BOOL)couldPassToOperator
{
    return ![self isEqualToNumber:[NSDecimalNumber notANumber]];
}

#pragma mark - Calculation Operator
- (NSDecimalNumber *)decimalNumberBySafelyAdding:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberByAdding:rightOperand];
}

- (NSDecimalNumber *)decimalNumberBySafelySubtracting:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberBySubtracting:rightOperand];
}

- (NSDecimalNumber *)decimalNumberBySafelyMultiplyingBy:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberByMultiplyingBy:rightOperand];
}

- (NSDecimalNumber *)decimalNumberBySafelyDividingBy:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [rightOperand isEqualToNumber:[NSDecimalNumber zero]] ? [NSDecimalNumber zero] : [leftOperand decimalNumberByDividingBy:rightOperand];
}

@end
