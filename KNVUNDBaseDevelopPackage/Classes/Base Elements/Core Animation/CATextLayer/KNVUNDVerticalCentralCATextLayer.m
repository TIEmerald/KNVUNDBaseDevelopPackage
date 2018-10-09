//
//  KNVUNDVerticalCentralCATextLayer.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 9/10/18.
//

#import "KNVUNDVerticalCentralCATextLayer.h"

@implementation KNVUNDVerticalCentralCATextLayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat height = self.bounds.size.height;
    CGFloat fontSize;
    CGFloat yDiff;
    if ([self.string isKindOfClass:[NSAttributedString class]]) {
        NSAttributedString *usingAttributString = (NSAttributedString *)self.string;
        fontSize = usingAttributString.size.height;
        yDiff = (height - fontSize) / 2;
    } else {
        fontSize = self.fontSize;
        yDiff = (height-fontSize) / 2 - fontSize / 10;
    }
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, 0.0, yDiff);
    [super drawInContext:ctx];
    CGContextRestoreGState(ctx);
}

@end
