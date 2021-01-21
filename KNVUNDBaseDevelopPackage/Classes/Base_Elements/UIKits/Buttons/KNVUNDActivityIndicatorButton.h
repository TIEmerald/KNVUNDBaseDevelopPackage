//
//  KNVUNDActivityIndicatorButton.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 14/9/18.
//

#import <UIKit/UIKit.h>

@interface KNVUNDActivityIndicatorButton : UIButton

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

#pragma mark - General Methods
- (void)startActivityProgress;
- (void)stopActivityProgress;

@end
