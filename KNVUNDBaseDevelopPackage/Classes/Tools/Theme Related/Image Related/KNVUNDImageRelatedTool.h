//
//  KNVUNDImageRelatedTool.h
//  Expecta
//
//  Created by Erjian Ni on 13/12/17.
//

#import "KNVUNDBaseModel.h"

#import "ZXingObjC.h"

@interface KNVUNDImageRelatedTool : KNVUNDBaseModel

#pragma mark - Image Generating Related
/// This method use ZXingObjC Package to generating related BarCode.
+ (UIImage *_Nullable)generateSpecialBarCodeFromString:(NSString *_Nonnull)barcodeString withZXBarcodeFormat:(ZXBarcodeFormat)generatingFormat width:(CGFloat)width andHeight:(CGFloat)height;
+ (ZXResult *_Nullable)readResultFromBarcodeFormatedImage:(UIImage *_Nonnull)checkingImage; /// In the Result will tell you what string have encoded inside this image and what format it is.

/// This method we will get a pure Image with Color
+ (UIImage *_Nonnull)generateImageWithColor:(UIColor *_Nonnull)fromColor;

/*!
 * @brief In this method we will generate an image from related Attributed String.
 * @param attributedString The attribute string you want to convert into an image.
 * @param imageWidth The image width you want to set to. If this value is 0, we will use the default value 576 --- for most printer paper's width.
 * @param shouldFixingWidth This property will tell us if you want to keep the width of the returning image to be fixed or not... in case the attributedString you passed in cannot take all content of the whole width.
 * @param backgroundColor By default, this background color is white color.
 * @param textColor By default, the text color is black color.
 * @return UIImage the image generated from the attribute string you passed in.
 */
+ (UIImage *_Nullable)generateImageFromAttributedString:(NSAttributedString *_Nonnull)attributedString imageWidth:(CGFloat)imageWidth shouldFixingWidth:(BOOL)shouldFixingWidth backgroundColor:(UIColor *_Nullable)backgroundColor andTextColor:(UIColor *_Nullable)textColor;

#pragma mark - Encoding and Decoding Related
/// It's better to ensure these two methods are used as a pair.
+ (NSString *_Nullable)getBase64EncodedStringFromUIImage:(UIImage *_Nonnull)originalImage;
+ (UIImage *_Nullable)getOriginalImageFromBase64EncodedString:(NSString *_Nonnull)encodedImageString;

@end
