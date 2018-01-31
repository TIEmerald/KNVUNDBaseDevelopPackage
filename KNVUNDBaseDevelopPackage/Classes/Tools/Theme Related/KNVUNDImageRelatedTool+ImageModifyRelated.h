//
//  KNVUNDImageRelatedTool+ImageModifyRelated.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 29/12/17.
//

#import "KNVUNDImageRelatedTool.h"

typedef enum : NSUInteger {
    KNVUNDImageRelatedTool_CombiningOrientation_Horizontal,
    KNVUNDImageRelatedTool_CombiningOrientation_Vertical
} KNVUNDImageRelatedTool_CombiningOrientation;

@interface KNVUNDImageRelatedTool (ImageModifyRelated)

#pragma mark - Modify Images
#pragma mark - Cropping
+ (NSArray *_Nonnull)getImageArrayByCropImageHorizentally:(UIImage *_Nonnull)originImage withMaximumSubImageHeightInPixel:(CGFloat)maximumSubImageHeightInPixel backgroundColor:(UIColor *_Nullable)backgroundColor andShouldAcceptSubImageWithoutContent:(BOOL)acceptImageWithoutContent;
+ (UIImage *_Nullable)cropImage:(UIImage *_Nonnull)originImage withRect:(CGRect)rect;

#pragma mark - Rotation
// Reference: https://stackoverflow.com/questions/14857728/how-to-rotate-uiimage
+ (UIImage *_Nullable)getImageFromImage:(UIImage *_Nonnull)sourceImage withOrientation:(UIImageOrientation)orientation;
+ (UIImage *_Nullable)getImageFromImage:(UIImage *_Nonnull)sourceImage withRotatedDegree:(CGFloat)degrees;

#pragma mark - Combining
+ (UIImage *_Nullable)getImageFromCombiningImages:(NSArray *_Nonnull)fromImages withOrientation:(KNVUNDImageRelatedTool_CombiningOrientation)orientation;
/// defaultBackgroundColor --- the color we will fill in the canvas, By default is white
+ (UIImage *_Nullable)getImageFromCombiningImages:(NSArray *_Nonnull)fromImages withOrientation:(KNVUNDImageRelatedTool_CombiningOrientation)orientation withBackGroundColor:(UIColor *_Nullable)defaultBackgroundColor;

@end
