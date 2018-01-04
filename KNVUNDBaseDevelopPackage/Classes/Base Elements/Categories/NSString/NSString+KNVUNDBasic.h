//
//  NSString+KNVUNDBasic.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 3/1/18.
//

#import <Foundation/Foundation.h>

@interface NSString (KNVUNDBasic)

#pragma mark - Modify
#pragma mark Trimming
- (NSString *)stringByTrimmingWhiteSpaces;

#pragma mark Character Related
- (NSString *)stringByAppendACharacter:(char)aChar;

@end
