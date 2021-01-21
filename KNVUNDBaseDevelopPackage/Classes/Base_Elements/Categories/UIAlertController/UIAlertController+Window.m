//
//  UIAlertController+Window.m
//  FFM
//
//  Created by Eric Larson on 6/17/15.
//  Copyright (c) 2015 ForeFlight, LLC. All rights reserved.
//

#import "UIAlertController+Window.h"

@implementation UIAlertController (Window)

#pragma mark - Methods to Override
+ (UIWindowLevel)windowLevel
{
    return UIWindowLevelAlert + 1;
}

@end
