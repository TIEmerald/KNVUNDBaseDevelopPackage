//
//  NSString+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import "NSString+KNVUNDBasic.h"

@implementation NSString (KNVUNDBasic)

#pragma mark - Factory Methods
+ (NSString *)stringWithChar:(char)aChar andFullLength:(NSInteger)length
{
    NSMutableString *returnString = [NSMutableString new];
    for (int i = 0; i < length; i++) {
        [returnString appendFormat:@"%c", aChar];
    }
    return returnString;
}

#pragma mark - Modify
#pragma mark Trimming
- (NSString *)stringByTrimmingWhiteSpaces
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString *)stringByTrimmingWhiteSpacesAndNewlineCharacter
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark Character Related
- (NSString *)stringByAppendACharacter:(char)aChar
{
    return [self stringByAppendingString:[NSString stringWithFormat:@"%c",
                                          aChar]];
}

@end
