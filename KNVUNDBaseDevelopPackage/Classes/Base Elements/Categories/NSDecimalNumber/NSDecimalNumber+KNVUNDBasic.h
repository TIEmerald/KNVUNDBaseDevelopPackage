//
//  NSDecimalNumber+KNVUNDBasic.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 9/1/18.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (KNVUNDBasic)

#pragma mark - Statistic Methods
+ (NSDecimalNumber *)negativeDecimal;

#pragma mark - Getters
@property (readonly) NSDecimalNumber *negativeDecimalNumber;

#pragma mark - Validators
- (BOOL)couldBecomeDivisor;
- (BOOL)couldPassToOperator;

#pragma mark - Calculation Operator
/// In this Safely Calculation Methods, as long as the operand is invlid(is not number, or the value is nil), we will return zero.
- (NSDecimalNumber * _Nonnull)decimalNumberBySafelyAdding:(NSDecimalNumber *_Nullable)decimalNumber;
- (NSDecimalNumber * _Nonnull)decimalNumberBySafelyAdding:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior;
- (NSDecimalNumber *_Nonnull)decimalNumberBySafelySubtracting:(NSDecimalNumber *_Nullable)decimalNumber;
- (NSDecimalNumber *_Nonnull)decimalNumberBySafelySubtracting:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior;
- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyMultiplyingBy:(NSDecimalNumber *_Nullable)decimalNumber;
- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyMultiplyingBy:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior;
- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyDividingBy:(NSDecimalNumber *_Nullable)decimalNumber;
- (NSDecimalNumber *_Nonnull)decimalNumberBySafelyDividingBy:(NSDecimalNumber *_Nullable)decimalNumber withBehavior:(nullable id <NSDecimalNumberBehaviors>)behavior;

@end
