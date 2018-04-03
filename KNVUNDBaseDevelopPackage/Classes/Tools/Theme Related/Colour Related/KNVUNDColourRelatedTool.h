//
//  KNVUNDColourRelatedTool.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 22/3/18.
//

#import "KNVUNDBaseModel.h"

@interface KNVUNDColourRelatedTool : KNVUNDBaseModel

#pragma mark - General Methods
/*!
 * @discussion This method convert an HexString Color to UIColor.
 * @param hexString The HexString For Colors. We support four type of HEXString - "#RBG", "#ARGB", "#RRGGBB", or "#AARRGGBB" with or without "#" Symbol
 * @return UIColor The UIColor converted from hexString.
 */
+ (UIColor *)colorWithHexString: (NSString *) hexString;

@end
