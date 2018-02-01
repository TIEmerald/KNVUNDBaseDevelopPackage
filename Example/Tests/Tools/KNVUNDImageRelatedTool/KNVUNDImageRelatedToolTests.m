//
//  KNVUNDBaseDevelopPackageTests.m
//  KNVUNDBaseDevelopPackageTests
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

// https://github.com/Specta/Specta

#import "KNVUNDImageRelatedTool.h"
#import "KNVUNDImageRelatedTool+ImageModifyRelated.h"

SpecBegin(KNVUNDImageRelatedTool)

describe(@"ImageRelatedTool", ^{
    
    NSArray *barcodeTestStrings = @[@"123123", @"avcdwer", @"133cxfse34f:fasdwe'r"];
    
    
    describe(@"barcode related", ^{
        it(@"generate with empty string", ^{
            expect([KNVUNDImageRelatedTool generateSpecialBarCodeFromString:nil
                                                        withZXBarcodeFormat:kBarcodeFormatCode128
                                                                      width:300
                                                                  andHeight:300]).to.beNil();
            expect([KNVUNDImageRelatedTool generateSpecialBarCodeFromString:@""
                                                        withZXBarcodeFormat:kBarcodeFormatCode128
                                                                      width:300
                                                                  andHeight:300]).to.beNil();
        });
        
        it(@"read from empty image", ^{
            expect([KNVUNDImageRelatedTool readResultFromBarcodeFormatedImage:[UIImage new]].text).to.beNil();
        });
        
        it(@"generate barcode and read it", ^{
            for(NSString *testingString in barcodeTestStrings) {
                UIImage *barImage = [KNVUNDImageRelatedTool generateSpecialBarCodeFromString:testingString
                                                                         withZXBarcodeFormat:kBarcodeFormatCode128
                                                                                       width:300
                                                                                   andHeight:300];
                UIImage *qrCodeImage = [KNVUNDImageRelatedTool generateSpecialBarCodeFromString:testingString
                                                                            withZXBarcodeFormat:kBarcodeFormatQRCode
                                                                                          width:300
                                                                                      andHeight:300];
                expect([KNVUNDImageRelatedTool readResultFromBarcodeFormatedImage:barImage].text).to.equal(testingString);
                expect([KNVUNDImageRelatedTool readResultFromBarcodeFormatedImage:barImage].barcodeFormat).to.equal(kBarcodeFormatCode128);
                expect([KNVUNDImageRelatedTool readResultFromBarcodeFormatedImage:qrCodeImage].text).to.equal(testingString);
                expect([KNVUNDImageRelatedTool readResultFromBarcodeFormatedImage:qrCodeImage].barcodeFormat).to.equal(kBarcodeFormatQRCode);
            }
        });
    });
    
    describe(@"base64 crypt related", ^{
        it(@"barcode", ^{
            for(NSString *testingString in barcodeTestStrings) {
                UIImage *barImage = [KNVUNDImageRelatedTool generateSpecialBarCodeFromString:testingString
                                                                         withZXBarcodeFormat:kBarcodeFormatCode128
                                                                                       width:300
                                                                                   andHeight:300];
                NSString *encryptImageString = [KNVUNDImageRelatedTool getBase64EncodedStringFromUIImage:barImage];
                UIImage *decodedImage = [KNVUNDImageRelatedTool getOriginalImageFromBase64EncodedString:encryptImageString];
                
                expect([KNVUNDImageRelatedTool readResultFromBarcodeFormatedImage:decodedImage].text).to.equal(testingString);
                expect([KNVUNDImageRelatedTool readResultFromBarcodeFormatedImage:decodedImage].barcodeFormat).to.equal(kBarcodeFormatCode128);
            }
        });
    });
    
    describe(@"image corping related", ^{
        CGFloat subImageMaximumHeight = 225;
        UIColor *backgroundColor = [UIColor whiteColor];
        BOOL containEmptyImage = YES;
        
        void (^checkingImagCorpingIntoArrayFunc)(NSString *imageName, NSArray *lookingSubImageSizeStrings) = ^(NSString *imageName, NSArray *lookingSubImageSizeStrings){
            UIImage *testingImage1 = [UIImage imageNamed:imageName];
            NSArray *resultImages = [KNVUNDImageRelatedTool getImageArrayByCropImageHorizentally:testingImage1
                                                                withMaximumSubImageHeightInPixel:subImageMaximumHeight
                                                                                 backgroundColor:backgroundColor
                                                           andShouldAcceptSubImageWithoutContent:containEmptyImage];
            for (int index = 0 ; index < resultImages.count ; index += 1){
                UIImage *resultImage = [resultImages objectAtIndex:index];
                NSString *resultImageSizeString = NSStringFromCGSize(resultImage.size);
                NSString *lookingForResultSizeString = [lookingSubImageSizeStrings objectAtIndex:index];
                expect([lookingForResultSizeString isEqualToString:resultImageSizeString]).to.beTruthy();
                
            }
        };
        
        NSString *const corpingImageToArrayTestImageName1 = @"image corping related image 1";
        NSArray *const lookingForResultSizeStrings1 = @[@"{194, 187}",@"{194, 225}",@"{194, 95}",@"{194, 225}",@"{194, 176}",@"{194, 222}",@"{194, 225}",@"{194, 145}"];
        it(@"to array 1", ^{
            checkingImagCorpingIntoArrayFunc(corpingImageToArrayTestImageName1, lookingForResultSizeStrings1);
        });
        
        NSString *const corpingImageToArrayTestImageName2 = @"image corping related image 2";
        NSArray *const lookingForResultSizeStrings2 = @[@"{173, 225}",@"{173, 223}",@"{173, 225}",@"{173, 225}",@"{173, 216}",@"{173, 225}",@"{173, 161}"];
        it(@"to array 2", ^{
            checkingImagCorpingIntoArrayFunc(corpingImageToArrayTestImageName2, lookingForResultSizeStrings2);
        });
    });
});

SpecEnd

