//
//  NSString+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "NSString+KNVUNDBasic.h"

@implementation NSString (KNVUNDBasic)

- (NSString *)stringByTrimmingWhiteSpaces
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

@end
