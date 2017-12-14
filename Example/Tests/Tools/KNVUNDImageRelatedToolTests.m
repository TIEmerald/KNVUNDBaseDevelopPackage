//
//  KNVUNDBaseDevelopPackageTests.m
//  KNVUNDBaseDevelopPackageTests
//
//  Created by niyejunze.j@gmail.com on 12/08/2017.
//  Copyright (c) 2017 niyejunze.j@gmail.com. All rights reserved.
//

// https://github.com/Specta/Specta

#import "KNVUNDViewController.h"

SpecBegin(KNVUNDImageRelatedTool)

describe(@"KNVUNDImageRelatedTool", ^{
    
    context(@"when generate barcode image", ^{
        context(@"when input string is empty", ^{
            it(@"returns nil", ^{
                expect([KNVUNDImageRelatedTool generateSpecialBarCodeFromString:nil
                                                            withZXBarcodeFormat:kBarcodeFormatCode128
                                                                          width:300
                                                                      andHeight:300]).to.beNil();
            });
        });
    });
    
});

SpecEnd

