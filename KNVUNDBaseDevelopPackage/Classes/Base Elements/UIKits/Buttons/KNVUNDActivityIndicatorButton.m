//
//  KNVUNDActivityIndicatorButton.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 14/9/18.
//

#import "KNVUNDActivityIndicatorButton.h"

@interface KNVUNDActivityIndicatorButton() {
    BOOL _hasUserSetButtonToHidden;
}

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

#pragma mark Setters
- (void)setHidden:(BOOL)hidden
{
    [self stopActivityProgress];
    [super setHidden:hidden];
    _hasUserSetButtonToHidden = hidden;
}

#pragma mark Support Methods
- (void)superInitialize
{
    
}

#pragma mark - General Methods
- (void)startActivityProgress
{
    if (_hasUserSetButtonToHidden) {
        return;
    }
    [super setHidden:YES];
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)stopActivityProgress
{
    if (_hasUserSetButtonToHidden) {
        return;
    }
    [super setHidden:NO];
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

@end
