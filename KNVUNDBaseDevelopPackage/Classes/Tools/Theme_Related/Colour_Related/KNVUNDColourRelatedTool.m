//
//  KNVUNDColourRelatedTool.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

#import "KNVUNDColourRelatedTool.h"

/// Libraries
#include "math.h"

@implementation KNVUNDColourRelatedTool

#pragma mark - General Methods
// This Code reference from http://stackoverflow.com/questions/1560081/how-can-i-create-a-uicolor-from-a-hex-string
+ (UIColor *) colorWithHexString: (NSString *) hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 1];
            green = [self colorComponentFrom: colorString start: 1 length: 1];
            blue  = [self colorComponentFrom: colorString start: 2 length: 1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom: colorString start: 0 length: 1];
            red   = [self colorComponentFrom: colorString start: 1 length: 1];
            green = [self colorComponentFrom: colorString start: 2 length: 1];
            blue  = [self colorComponentFrom: colorString start: 3 length: 1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: colorString start: 0 length: 2];
            green = [self colorComponentFrom: colorString start: 2 length: 2];
            blue  = [self colorComponentFrom: colorString start: 4 length: 2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: colorString start: 0 length: 2];
            red   = [self colorComponentFrom: colorString start: 2 length: 2];
            green = [self colorComponentFrom: colorString start: 4 length: 2];
            blue  = [self colorComponentFrom: colorString start: 6 length: 2];
            break;
        default:
            [NSException raise:@"Invalid color value" format: @"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
            break;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (BOOL)checkColourSimilarityBetween:(UIColor *)colorA and:(UIColor *)colorb withTolerance:(CGFloat)tolerance
{
    CGFloat r1, g1, b1, a1, r2, g2, b2, a2;
    [colorA getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [colorb getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    return powf((powf(r1 - r2, 2) + powf(g1 - g2, 2) + powf(b1 - b2, 2)), 0.5) <= tolerance;
}

+ (UIColor *)getDifferentColorFrom:(UIColor *)fromColor withTolerance:(CGFloat)tolerance
{
    CGFloat usingDimensionDifference = powf(MAX((powf(tolerance, 2) / 3), 0.1), 0.5);
    CGFloat r0, g0, b0, a0;
    [fromColor getRed:&r0 green:&g0 blue:&b0 alpha:&a0];
    CGFloat rNew = r0 > usingDimensionDifference ? r0 - usingDimensionDifference : r0 + usingDimensionDifference;
    CGFloat gNew = g0 > usingDimensionDifference ? g0 - usingDimensionDifference : g0 + usingDimensionDifference;
    CGFloat bNew = b0 > usingDimensionDifference ? b0 - usingDimensionDifference : b0 + usingDimensionDifference;
    return [UIColor colorWithRed:rNew green:gNew blue:bNew alpha:a0];
}

#pragma mark Support Methods
+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start length: (NSUInteger) length
{
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
