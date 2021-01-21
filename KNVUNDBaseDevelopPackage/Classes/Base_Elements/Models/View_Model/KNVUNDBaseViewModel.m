//
//  KNVUNDBaseVCViewModel.m
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 2/9/19.
//

#import "KNVUNDBaseViewModel.h"

@implementation KNVUNDBaseViewModel

#pragma mark - Support Methods
- (void)showUpErrorInDelegateWithTitle:(NSString *)title andMessage:(NSString *)message
{
    if ([self.delegate respondsToSelector:@selector(showUpErrorWithTitle:andMessage:)]) {
        [self.delegate showUpErrorWithTitle:title andMessage:message];
    }
}

- (void)updateDisplayingUIInDelegate
{
    if ([self.delegate respondsToSelector:@selector(updateDisplayingUIBasedOnViewModel)]) {
        [self.delegate updateDisplayingUIBasedOnViewModel];
    }
}

@end
