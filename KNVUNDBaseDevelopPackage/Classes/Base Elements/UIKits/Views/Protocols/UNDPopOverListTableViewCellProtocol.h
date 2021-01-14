//
//  UNDPopOverListTableViewCellProtocol.h
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#ifndef UNDPopOverListTableViewCellProtocol_h
#define UNDPopOverListTableViewCellProtocol_h

#import <UIKit/UIKit.h>

@protocol UNDPopOverListTableViewCellProtocol <NSObject>
+ (NSString *)cellIdentifier;
- (UILabel *)mainTextLabel;
@end

#endif /* UNDPopOverListTableViewCellProtocol_h */
