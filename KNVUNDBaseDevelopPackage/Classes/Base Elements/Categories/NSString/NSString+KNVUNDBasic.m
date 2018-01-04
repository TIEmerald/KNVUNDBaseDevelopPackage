//
//  NSString+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "NSString+KNVUNDBasic.h"

@implementation NSString (KNVUNDBasic)

#pragma mark - Modify
#pragma mark Trimming
- (NSString *)stringByTrimmingWhiteSpaces
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark Character Related
- (NSString *)stringByAppendACharacter:(char)aChar
{
    return [self stringByAppendingString:[NSString stringWithFormat:@"%c",
                                          aChar]];
}

@end
