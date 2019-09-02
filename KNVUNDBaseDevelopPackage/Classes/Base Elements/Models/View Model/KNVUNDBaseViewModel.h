//
//  KNVUNDBaseVCViewModel.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 2/9/19.
//

#import "KNVUNDBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KNVUNDBaseVMDelegate <NSObject>

    /// Pls Over write this method in your View
        /// if you want to bind View Model
- (void)updateDisplayingUIBasedOnViewModel;

@optional
- (void)showUpErrorWithTitle:(NSString *)title andMessage:(NSString *)message;

@end

@interface KNVUNDBaseViewModel : KNVUNDBaseModel

@property (weak, nonatomic) id <KNVUNDBaseVMDelegate> delegate;

#pragma mark - Support Methods
- (void)showUpErrorInDelegateWithTitle:(NSString *)title andMessage:(NSString *)message;
- (void)updateDisplayingUIInDelegate;

@end

NS_ASSUME_NONNULL_END
