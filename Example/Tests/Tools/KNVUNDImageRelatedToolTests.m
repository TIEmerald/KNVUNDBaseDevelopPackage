//
//  KNVUNDBaseDevelopPackageTests.m
//  KNVUNDBaseDevelopPackageTests
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

// https://github.com/Specta/Specta

#import "KNVUNDImageRelatedTool.h"

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
});

SpecEnd

