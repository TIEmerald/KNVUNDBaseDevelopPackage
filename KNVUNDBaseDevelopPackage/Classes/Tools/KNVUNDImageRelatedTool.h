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

@end
