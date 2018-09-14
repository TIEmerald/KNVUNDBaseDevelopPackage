//
//  KNVUNDActivityIndicatorButton.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 14/9/18.
//

#import "KNVUNDActivityIndicatorButton.h"

@interface KNVUNDActivityIndicatorButton()

@end

@implementation KNVUNDActivityIndicatorButton

#pragma mark - Overrride Methods
#pragma mark - Inits
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self superInitialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self superInitialize];
    }
    return self;
}

#pragma mark Support Methods
- (void)superInitialize
{
    
}

#pragma mark - General Methods
- (void)startActivityProgress
{
    self.hidden = YES;
    [self.activityIndicatorView startAnimating];
}

- (void)stopActivityProgress
{
    self.hidden = NO;
    [self.activityIndicatorView stopAnimating];
}

@end
