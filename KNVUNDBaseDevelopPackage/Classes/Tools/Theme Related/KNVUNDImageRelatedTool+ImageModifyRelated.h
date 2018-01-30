//
//  KNVUNDImageRelatedTool+ImageModifyRelated.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 29/12/17.
//

#import "KNVUNDImageRelatedTool.h"

@interface KNVUNDImageRelatedTool (ImageModifyRelated)

#pragma mark - Modify Images
#pragma mark - Cropping
+ (NSArray *_Nonnull)getImageArrayByCropImageHorizentally:(UIImage *_Nonnull)originImage withMaximumSubImageHeightInPixel:(CGFloat)maximumSubImageHeightInPixel backgroundColor:(UIColor *_Nullable)backgroundColor andShouldAcceptSubImageWithoutContent:(BOOL)acceptImageWithoutContent;
+ (UIImage *_Nullable)cropImage:(UIImage *_Nonnull)originImage withRect:(CGRect)rect;

#pragma mark - Rotation
// Reference: https://stackoverflow.com/questions/14857728/how-to-rotate-uiimage
+ (UIImage *_Nullable)getImageFromImage:(UIImage *_Nonnull)sourceImage withOrientation:(UIImageOrientation)orientation;
+ (UIImage *_Nullable)getImageFromImage:(UIImage *_Nonnull)sourceImage withRotatedDegree:(CGFloat)degrees;

@end
