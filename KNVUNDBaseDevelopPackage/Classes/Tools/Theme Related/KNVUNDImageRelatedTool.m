//
//  KNVUNDImageRelatedTool.m
//  Expecta
//
//  Created by Erjian Ni on 13/12/17.
//

#import "KNVUNDImageRelatedTool.h"

@implementation KNVUNDImageRelatedTool

#pragma mark - KNVUNDBaseModel
+ (BOOL)shouldShowClassMethodLog
{
    return YES;
}

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
    @catch(NSException *exception) {
        [self performConsoleLogWithLogStringFormat:@"Failed to generating BarCode Image with - %@ (Exception: %@)",
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
        [self performConsoleLogWithLogStringFormat:@"Failed to read barcode result from image - %@ (Exception: %@)",
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

#pragma mark - Modify Images
struct PixelColors
{
    CGFloat red; // 0.0 - 255.0
    CGFloat blue; // 0.0 - 255.0
    CGFloat green; // 0.0 - 255.0
    CGFloat alpha; // 0.0 - 1.0
};

+ (NSArray *_Nonnull)getImageArrayByCropImageHorizentally:(UIImage *_Nonnull)originImage withMaximumSubImageHeightInPixel:(CGFloat)maximumSubImageHeightInPixel andBackgroundColor:(UIColor *_Nullable)backgroundColor
{
    
    NSMutableArray *returnImageArray = [NSMutableArray new];
    
    NSUInteger lastYCutPointInPixel = 0;
    CGFloat scale = originImage.scale;
    
    // Step One.. Find out the cuting Points....
    CGImageRef imageRef = [originImage CGImage];
    
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitmapByteCount = bytesPerRow * height;
    
    unsigned char *rawData = (unsigned char*) calloc(bitmapByteCount, sizeof(unsigned char));
    
    NSUInteger bitsPerComponent = 8;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    NSInteger lastPixelYThatCouldCut = NSNotFound;
    struct PixelColors colorCouldCut = [self getPixelColorsFromUIColor:backgroundColor];
    
    for (NSUInteger checkingPixelY = 0; checkingPixelY < height; checkingPixelY += 1) {
        // Logic One.... Find out the Pixel that we could cut...
        BOOL couldCut = YES;
        for (NSUInteger checkingPixelX = 0; checkingPixelX < width; checkingPixelX += 1) {
            struct PixelColors colorAtCurrentPixel = [self getPixelColorFromRawData:rawData
                                                                           atPixelY:checkingPixelY
                                                                          andPixelX:checkingPixelX
                                                                  withBytesPerPixel:bytesPerPixel
                                                                     andBytesPerRow:bytesPerRow];
            BOOL isCurrentPixelCouldCut = [self checkIsPixelColors:colorAtCurrentPixel
                                               similarToPixelColor:colorCouldCut
                                                     withTolerance:0.0
                                               andShouldCheckAlpha:NO];
            if (!isCurrentPixelCouldCut) {
                couldCut = NO;
                break;
            }
        }
        if (couldCut) {
            lastPixelYThatCouldCut = checkingPixelY;
        }
        
        // Logic Two... If checking Pixel exceed the unit height, or reach the end, we will perform cut function
        if ((checkingPixelY - lastYCutPointInPixel >= maximumSubImageHeightInPixel) || checkingPixelY == height - 1 ){
            NSUInteger newYCutPointInPixel = (lastPixelYThatCouldCut == NSNotFound) ? checkingPixelY : lastPixelYThatCouldCut;
            CGRect cuttingSize = CGRectMake(0,
                                            lastYCutPointInPixel / scale,
                                            originImage.size.width,
                                            (newYCutPointInPixel - lastYCutPointInPixel) / scale);
            UIImage *newImage = [self cropImage:originImage
                                       withRect:cuttingSize];
            if (newImage != nil) {
                [returnImageArray addObject:newImage];
            }
            
            lastYCutPointInPixel = newYCutPointInPixel;
        }
    }
    
    return [NSArray arrayWithArray:returnImageArray];
}

+ (UIImage *_Nullable)cropImage:(UIImage *_Nonnull)originImage withRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([originImage CGImage], rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

#pragma mark Support Methods

// By Default we assuem that rawData contains the image data in the RGBA8888 pixel format.
+ (struct PixelColors)getPixelColorFromRawData:(unsigned char *)rawData atPixelY:(NSUInteger)pixelY andPixelX:(NSUInteger)pixelX withBytesPerPixel:(NSUInteger)bytesPerPixel andBytesPerRow:(NSUInteger)bytesPerRow
{
    struct PixelColors returnColors;
    NSUInteger byteIndex = (bytesPerRow * pixelY) + pixelX * bytesPerPixel;
    CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] ) / 255.0f;
    CGFloat red   = ((CGFloat) rawData[byteIndex]     ) / (alpha == 0 ? 1 : alpha);
    CGFloat green = ((CGFloat) rawData[byteIndex + 1] ) / (alpha == 0 ? 1 : alpha);
    CGFloat blue  = ((CGFloat) rawData[byteIndex + 2] ) / (alpha == 0 ? 1 : alpha);
    returnColors.alpha = alpha;
    returnColors.red = red;
    returnColors.green = green;
    returnColors.blue = blue;
    return returnColors;
}

+ (struct PixelColors)getPixelColorsFromUIColor:(UIColor *_Nullable)fromColor
{
    struct PixelColors returnColor; /// We will cut white color only.
    returnColor.red = 255.0;
    returnColor.blue = 255.0;
    returnColor.green = 255.0;
    returnColor.alpha = 1.0;
    if (fromColor) {
        CGFloat red, green, blue, alpha;
        [fromColor getRed:&red
                    green:&green
                     blue:&blue
                    alpha:&alpha];
        
        returnColor.red = red * 255.0;
        returnColor.green = green * 255.0;
        returnColor.blue = blue * 255.0;
        returnColor.alpha = alpha;
    }
    return returnColor;
}


+ (BOOL)checkIsPixelColors:(struct PixelColors)checkingColor similarToPixelColor:(struct PixelColors)targetColor withTolerance:(CGFloat)tolerance andShouldCheckAlpha:(BOOL)shouldCheckAlpha
{
    const float redRange[2] = {
        MAX(targetColor.red - (tolerance / 2.0), 0.0),
        MIN(targetColor.red + (tolerance / 2.0), 255.0)
    };
    
    const float greenRange[2] = {
        MAX(targetColor.green - (tolerance / 2.0), 0.0),
        MIN(targetColor.green + (tolerance / 2.0), 255.0)
    };
    
    const float blueRange[2] = {
        MAX(targetColor.blue - (tolerance / 2.0), 0.0),
        MIN(targetColor.blue + (tolerance / 2.0), 255.0)
    };
    
    const float alphaRange[2] = {
        MAX(targetColor.alpha - (tolerance / 255.0), 0.0),
        MIN(targetColor.alpha + (tolerance / 255.0), 1.0)
    };
    
    if (shouldCheckAlpha && (checkingColor.alpha > alphaRange[1] || checkingColor.alpha < alphaRange[0])) {
        return NO;
    }
    
    return ((checkingColor.red >= redRange[0]) && (checkingColor.red <= redRange[1])) && ((checkingColor.green >= greenRange[0]) && (checkingColor.green <= greenRange[1])) && ((checkingColor.blue >= blueRange[0]) && (checkingColor.blue <= blueRange[1]));
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
