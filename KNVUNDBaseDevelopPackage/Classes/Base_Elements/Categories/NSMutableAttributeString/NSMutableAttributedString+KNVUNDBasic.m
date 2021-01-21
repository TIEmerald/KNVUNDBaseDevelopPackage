//
//  NSMutableAttributedString+KNVUNDBasic.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 23/2/18.
//

#import "NSMutableAttributedString+KNVUNDBasic.h"

@implementation NSMutableAttributedString (KNVUNDBasic)

- (void)safelyAddAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range
{
    if (range.location != 0 && range.length + range.location < self.length ) {
        [self addAttribute:name
                     value:value
                     range:range];
    }
}

@end
