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

#pragma mark - Encoding and Decoding Related
/// It's better to ensure these two methods are used as a pair.
+ (NSString *_Nullable)getBase64EncodedStringFromUIImage:(UIImage *_Nonnull)originalImage;
+ (UIImage *_Nullable)getOriginalImageFromBase64EncodedString:(NSString *_Nonnull)encodedImageString;

@end
