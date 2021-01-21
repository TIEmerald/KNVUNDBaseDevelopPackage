//
//  NSMutableAttributedString+KNVUNDBasic.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 23/2/18.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (KNVUNDBasic)

- (void)safelyAddAttribute:(NSAttributedStringKey)name value:(id)value range:(NSRange)range;

@end
