//
//  KNVUNDImageRelatedTool.m
//  Expecta
//
//  Created by Erjian Ni on 13/12/17.
//

#import "KNVUNDImageRelatedTool.h"

@implementation KNVUNDImageRelatedTool

#pragma mark - Image Generating Related
/// This method use ZXingObjC Package to generating related BarCode.
+ (UIImage *_Nullable)generateSpecialBarCodeFromString:(NSString *_Nonnull)barcodeString withZXBarcodeFormat:(ZXBarcodeFormat)generatingFormat width:(CGFloat)width andHeight:(CGFloat)height
{
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:barcodeString
                                  format:generatingFormat
                                   width:width
                                  height:height
                                   error:&error];
    if (result) {
        CGImageRef image = [[ZXImage imageWithMatrix:result] cgimage];
        return [UIImage imageWithCGImage:image];
    }
    else {
        [self performConsoleLogWithLogStringFormat:@"Failed to generating BarCode Image with - %@ (Error: %@)",
         barcodeString,
         error.localizedDescription];
        return nil;
    }
}

#pragma mark - Encoding and Decoding Related
/// It's better to ensure these two methods are used as a pair.
+ (NSString *_Nullable)getBase64EncodedStringFromUIImage:(UIImage *_Nonnull)originalImage
{
    NSData *imageData = UIImagePNGRepresentation(originalImage);
    return [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

+ (UIImage *_Nullable)getOriginalImageFromBase64EncodedString:(NSString *_Nonnull)encodedImageString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:encodedImageString
                                                      options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [UIImage imageWithData:data];
}

@end
