//
//  NSDecimalNumber+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 9/1/18.
//

#import "NSDecimalNumber+KNVUNDBasic.h"

@implementation NSDecimalNumber (KNVUNDBasic)

- (BOOL)couldBecomeDivisor
{
    return ![self isEqualToNumber:[NSDecimalNumber zero]] && ![self isEqualToNumber:[NSDecimalNumber notANumber]];
}

@end
