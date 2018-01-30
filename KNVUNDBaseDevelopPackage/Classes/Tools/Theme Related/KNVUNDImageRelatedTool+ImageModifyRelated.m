//
//  KNVUNDImageRelatedTool+ImageModifyRelated.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 29/12/17.
//

#import "KNVUNDImageRelatedTool+ImageModifyRelated.h"

@implementation KNVUNDImageRelatedTool (ImageModifyRelated)

#pragma mark - Modify Images
#pragma mark - Cropping
struct PixelColors
{
    CGFloat red; // 0.0 - 255.0
    CGFloat blue; // 0.0 - 255.0
    CGFloat green; // 0.0 - 255.0
    CGFloat alpha; // 0.0 - 1.0
};

+ (NSArray *_Nonnull)getImageArrayByCropImageHorizentally:(UIImage *_Nonnull)originImage withMaximumSubImageHeightInPixel:(CGFloat)maximumSubImageHeightInPixel backgroundColor:(UIColor *_Nullable)backgroundColor andShouldAcceptSubImageWithoutContent:(BOOL)acceptImageWithoutContent
{
    
    NSMutableArray *returnImageArray = [NSMutableArray new];
    
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
    
    // Cutting Logic
    NSUInteger lastYCutPointInPixel = 0;
    BOOL hasContentBetweenLastPixelYCutAndLastPixelYThatCouldCut = NO;
    BOOL hasContentBetweenLastPixelYThatCouldCutAndCurrentCheckingPixelY = NO;
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
            if (hasContentBetweenLastPixelYThatCouldCutAndCurrentCheckingPixelY) {
                hasContentBetweenLastPixelYCutAndLastPixelYThatCouldCut = YES;
                hasContentBetweenLastPixelYThatCouldCutAndCurrentCheckingPixelY = NO;
            }
        } else {
            hasContentBetweenLastPixelYThatCouldCutAndCurrentCheckingPixelY = YES;
        }
        
        // Logic Two... If checking Pixel exceed the unit height, or reach the end, we will perform cut function
        // There are two scenario we need to handle
        BOOL didReachTheMaximumImageHeightInPixel = (checkingPixelY - lastYCutPointInPixel >= maximumSubImageHeightInPixel);
        BOOL didReachTheEndLineOfOriginImage = checkingPixelY == height - 1;
        if (didReachTheMaximumImageHeightInPixel) {
            BOOL hasCouldCutPixelYBetweenLastCutPixelYAndCurrentCheckingPixelY = lastPixelYThatCouldCut == NSNotFound;
            NSUInteger newYCutPointInPixel = hasCouldCutPixelYBetweenLastCutPixelYAndCurrentCheckingPixelY ? checkingPixelY : lastPixelYThatCouldCut;
            BOOL imageHasContent = hasCouldCutPixelYBetweenLastCutPixelYAndCurrentCheckingPixelY ? (hasContentBetweenLastPixelYThatCouldCutAndCurrentCheckingPixelY || hasContentBetweenLastPixelYCutAndLastPixelYThatCouldCut) : hasContentBetweenLastPixelYCutAndLastPixelYThatCouldCut;
            
            CGRect cuttingSize = CGRectMake(0,
                                            lastYCutPointInPixel / scale,
                                            originImage.size.width,
                                            (newYCutPointInPixel - lastYCutPointInPixel) / scale);
            UIImage *newImage = [self cropImage:originImage
                                       withRect:cuttingSize];
            if (newImage != nil && (acceptImageWithoutContent || imageHasContent)) {
                [returnImageArray addObject:newImage];
            }
            
            lastYCutPointInPixel = newYCutPointInPixel;
            hasContentBetweenLastPixelYCutAndLastPixelYThatCouldCut = NO;
            if (hasCouldCutPixelYBetweenLastCutPixelYAndCurrentCheckingPixelY) {
                hasContentBetweenLastPixelYThatCouldCutAndCurrentCheckingPixelY = NO;
            }
        }
        
        if (didReachTheEndLineOfOriginImage && lastYCutPointInPixel != checkingPixelY) { // Which means we have reached the last line of the image
            BOOL imageHasContent = hasContentBetweenLastPixelYThatCouldCutAndCurrentCheckingPixelY || hasContentBetweenLastPixelYCutAndLastPixelYThatCouldCut;
            CGRect cuttingSize = CGRectMake(0,
                                            lastYCutPointInPixel / scale,
                                            originImage.size.width,
                                            (height - lastYCutPointInPixel) / scale);
            UIImage *newImage = [self cropImage:originImage
                                       withRect:cuttingSize];
            if (newImage != nil && (acceptImageWithoutContent || imageHasContent)) {
                [returnImageArray addObject:newImage];
            }
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

#pragma mark - Rotation
// Reference: https://stackoverflow.com/questions/14857728/how-to-rotate-uiimage
+ (UIImage *_Nullable)getImageFromImage:(UIImage *_Nonnull)sourceImage withOrientation:(UIImageOrientation)orientation
{
    CGSize originalSize = sourceImage.size;
    CGSize usingSize;
    switch (orientation) {
            case UIImageOrientationLeft:
            case UIImageOrientationRight:
            case UIImageOrientationLeftMirrored:
            case UIImageOrientationRightMirrored:
            usingSize = CGSizeMake(originalSize.height, originalSize.width);
            break;
        default:
            usingSize = originalSize;
            break;
    }
    UIGraphicsBeginImageContext(usingSize);
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:orientation] drawInRect:CGRectMake(0,0,usingSize.width ,usingSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

+ (UIImage *_Nullable)getImageFromImage:(UIImage *_Nonnull)sourceImage withRotatedDegree:(CGFloat)degrees
{
    CGFloat radians = DEGREES_TO_RADIANS(degrees);
    
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0, sourceImage.size.width, sourceImage.size.height)];
    CGAffineTransform t = CGAffineTransformMakeRotation(radians);
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(rotatedSize, NO, [[UIScreen mainScreen] scale]);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(bitmap, rotatedSize.width / 2, rotatedSize.height / 2);
    
    CGContextRotateCTM(bitmap, radians);
    
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-sourceImage.size.width / 2, -sourceImage.size.height / 2 , sourceImage.size.width, sourceImage.size.height), sourceImage.CGImage );
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
