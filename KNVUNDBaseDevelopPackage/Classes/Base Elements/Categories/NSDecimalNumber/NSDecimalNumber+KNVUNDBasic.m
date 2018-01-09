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
    return [self decimalNumberBySafelyAdding:decimalNumber
                                withBehavior:nil];
}

- (NSDecimalNumber * _Nonnull)decimalNumberBySafelyAdding:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberByAdding:rightOperand withBehavior:behavior];
}

- (NSDecimalNumber *)decimalNumberBySafelySubtracting:(NSDecimalNumber *)decimalNumber
{
    return [self decimalNumberBySafelyAdding:decimalNumber
                         withBehavior:nil];
}

- (NSDecimalNumber *_Nonnull)decimalNumberBySafelySubtracting:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberBySubtracting:rightOperand withBehavior:behavior];
}

- (NSDecimalNumber *)decimalNumberBySafelyMultiplyingBy:(NSDecimalNumber *)decimalNumber
{
    return [self decimalNumberBySafelyMultiplyingBy:decimalNumber
                                withBehavior:nil];
}

- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyMultiplyingBy:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [leftOperand decimalNumberByMultiplyingBy:rightOperand withBehavior:behavior];
}

- (NSDecimalNumber *)decimalNumberBySafelyDividingBy:(NSDecimalNumber *)decimalNumber
{
    return [self decimalNumberBySafelyDividingBy:decimalNumber
                             withBehavior:nil];
}

- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyDividingBy:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior
{
    NSDecimalNumber *leftOperand = [self couldPassToOperator] ? self : [NSDecimalNumber zero];
    NSDecimalNumber *rightOperand = [decimalNumber couldPassToOperator] ? decimalNumber : [NSDecimalNumber zero];
    return [rightOperand isEqualToNumber:[NSDecimalNumber zero]] ? [NSDecimalNumber zero] : [leftOperand decimalNumberByDividingBy:rightOperand withBehavior:behavior];
}

@end
