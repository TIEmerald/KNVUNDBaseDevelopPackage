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

/*!
 * @discussion This method will tell user if two color is similar to each other or not, we will only compare RBG with 3D distence for now..
 * @param colorA The first color you input
 * @param colorB The second color you input
 * @param tolerance The accepted difference we could accept to treat these two input colors are similar
 * @return BOOL if the two parameter colors look similar or not.
 */
+ (BOOL)checkColourSimilarityBetween:(UIColor *)colorA and:(UIColor *)colorB withTolerance:(CGFloat)tolerance;
+ (UIColor *)getDifferentColorFrom:(UIColor *)fromColor withTolerance:(CGFloat)tolerance;


@end
