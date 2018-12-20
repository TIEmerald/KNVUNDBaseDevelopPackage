//
//  KNVUNDImageRelatedTool.m
//  Expecta
//
//  Created by Erjian Ni on 13/12/17.
//

#import "KNVUNDImageRelatedTool.h"

@implementation KNVUNDImageRelatedTool

#pragma mark - KNVUNDBaseModel
//+ (BOOL)shouldShowClassMethodLog
//{
//    return YES;
//}

#pragma mark - Image Generating Related
/// This method use ZXingObjC Package to generating related BarCode.
+ (UIImage *_Nullable)generateSpecialBarCodeFromString:(NSString *_Nonnull)barcodeString withZXBarcodeFormat:(ZXBarcodeFormat)generatingFormat width:(CGFloat)width andHeight:(CGFloat)height
{
    @try {
        NSError *error = nil;
        ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
        ZXBitMatrix* result = [writer encode:barcodeString
                                      format:generatingFormat
                                       width:width
                                      height:height
                                       error:&error];
        if (result) {
            /// https://stackoverflow.com/questions/12756295/uiimage-from-cgimageref
            //// The CGImageRef returned from CGImage is almost certainly an ivar of the UIImage and will be released when the UIImage is deallocted.
            CGImageRef image = CGImageRetain([[ZXImage imageWithMatrix:result] cgimage]);
            return [UIImage imageWithCGImage:image];
        }
        else {
            [self performConsoleLogWithLogLevel:NSObject_LogLevel_Error
                             andLogStringFormat:@"Failed to generating BarCode Image with - %@ (Error: %@)",
             barcodeString,
             error.localizedDescription];
            return nil;
        }
    }
    @catch(NSException *exception) {
        [self performConsoleLogWithLogLevel:NSObject_LogLevel_Error
                         andLogStringFormat:@"Failed to generating BarCode Image with - %@ (Exception: %@)",
         barcodeString,
         exception.reason];
        return nil;
    }
}

+ (ZXResult *_Nullable)readResultFromBarcodeFormatedImage:(UIImage *_Nonnull)checkingImage
{
    @try {
        ZXLuminanceSource *source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:checkingImage.CGImage];
        ZXBinaryBitmap *bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
        
        NSError *error = nil;
        
        // There are a number of hints we can give to the reader, including
        // possible formats, allowed lengths, and the string encoding.
        ZXDecodeHints *hints = [ZXDecodeHints hints];
        
        ZXMultiFormatReader *reader = [ZXMultiFormatReader reader];
        ZXResult *result = [reader decode:bitmap
                                    hints:hints
                                    error:&error];
        
        return result;
    }
    @catch(NSException *exception) {
        [self performConsoleLogWithLogLevel:NSObject_LogLevel_Error
                         andLogStringFormat:@"Failed to read barcode result from image - %@ (Exception: %@)",
         checkingImage,
         exception.reason];
        return nil;
    }
}

+ (UIImage *_Nonnull)generateImageWithColor:(UIColor *_Nonnull)fromColor
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [fromColor CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

CGFloat const KNVUNDImageRelatedTool_ImageFromString_Default_Width = 576;

+ (UIImage *_Nullable)generateImageFromAttributedString:(NSAttributedString *_Nonnull)attributedString imageWidth:(CGFloat)imageWidth shouldFixingWidth:(BOOL)shouldFixingWidth backgroundColor:(UIColor *_Nullable)backgroundColor andTextColor:(UIColor *_Nullable)textColor
{
    CGSize size = CGSizeMake(imageWidth == 0 ? KNVUNDImageRelatedTool_ImageFromString_Default_Width : imageWidth, CGFLOAT_MAX);
    CGRect textRect = [attributedString boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    size = CGSizeMake(shouldFixingWidth ? size.width : textRect.size.width, textRect.size.height);
    
    CGFloat newTextOriginX = (size.width - textRect.size.width) / 2; /// WE need center the text.. if the text size is maller than the size we expected
    textRect = CGRectMake(newTextOriginX, textRect.origin.y, textRect.size.width, textRect.size.height);
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);
        } else {
            UIGraphicsBeginImageContext(size);
        }
    } else {
        UIGraphicsBeginImageContext(size);
    }
    CGContextRef ctr = UIGraphicsGetCurrentContext();
    
    // Set background to white
    CGRect rect = CGRectMake(0, 0, size.width + 1, size.height + 1);
    UIColor *color = backgroundColor ?: [UIColor whiteColor];
    [color set];
    CGContextFillRect(ctr, rect);
    
    // Set text to black
    color = textColor ?: [UIColor blackColor];
    [color set];
    [attributedString drawInRect:textRect];
    
    // Transfer image & end context
    UIImage *image = [UIGraphicsGetImageFromCurrentImageContext() imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIGraphicsEndImageContext();
    
    return image;
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
