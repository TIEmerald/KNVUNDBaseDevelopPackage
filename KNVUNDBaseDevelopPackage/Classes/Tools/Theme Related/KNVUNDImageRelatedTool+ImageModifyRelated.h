//
//  KNVUNDImageRelatedTool+ImageModifyRelated.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 29/12/17.
//

#import "KNVUNDImageRelatedTool.h"

@interface KNVUNDImageRelatedTool (ImageModifyRelated)

#pragma mark - Modify Images
+ (NSArray *_Nonnull)getImageArrayByCropImageHorizentally:(UIImage *_Nonnull)originImage withMaximumSubImageHeightInPixel:(CGFloat)maximumSubImageHeightInPixel backgroundColor:(UIColor *_Nullable)backgroundColor andShouldAcceptSubImageWithoutContent:(BOOL)acceptImageWithoutContent;
+ (UIImage *_Nullable)cropImage:(UIImage *_Nonnull)originImage withRect:(CGRect)rect;

@end
