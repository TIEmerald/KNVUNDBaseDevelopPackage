//
//  NSDecimalNumber+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 9/1/18.
//

#import "NSDecimalNumber+KNVUNDBasic.h"

@implementation NSDecimalNumber (KNVUNDBasic)

#pragma mark - Statistic Methods
+ (NSDecimalNumber *)negativeDecimal
{
    return [NSDecimalNumber decimalNumberWithMantissa:1 exponent:0 isNegative:YES];
}

#pragma mark - Getters & Setters
#pragma mark - Getters
- (NSDecimalNumber *)negativeDecimalNumber
{
    return [self decimalNumberBySafelyMultiplyingBy:[NSDecimalNumber negativeDecimal]];
}

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

- (NSDecimalNumber * _Nonnull)decimalNumberBySafelyAdding:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberByAdding:rightOperand withBehavior:behavior];
}

- (NSDecimalNumber *)decimalNumberBySafelySubtracting:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberBySubtracting:rightOperand];
}

- (NSDecimalNumber *_Nonnull)decimalNumberBySafelySubtracting:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberBySubtracting:rightOperand withBehavior:behavior];
}

- (NSDecimalNumber *)decimalNumberBySafelyMultiplyingBy:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberByMultiplyingBy:rightOperand];
}

- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyMultiplyingBy:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberByMultiplyingBy:rightOperand withBehavior:behavior];
}

- (NSDecimalNumber *)decimalNumberBySafelyDividingBy:(NSDecimalNumber *)decimalNumber
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [rightOperand isEqualToNumber:[NSDecimalNumber zero]] ? [NSDecimalNumber zero] : [leftOperand decimalNumberByDividingBy:rightOperand];
}

- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyDividingBy:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [rightOperand isEqualToNumber:[NSDecimalNumber zero]] ? [NSDecimalNumber zero] : [leftOperand decimalNumberByDividingBy:rightOperand withBehavior:behavior];
}

@end
