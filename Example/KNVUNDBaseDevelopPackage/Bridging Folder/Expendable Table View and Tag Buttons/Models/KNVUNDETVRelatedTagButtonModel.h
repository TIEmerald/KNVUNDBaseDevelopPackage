//
//  KNVUNDETVRelatedTagButtonModel.h
//  KNVUNDBaseDevelopPackage_Example
//
//  Created by Erjian Ni on 23/3/18.
//  Copyright © 2018 niyejunze.j@gmail.com. All rights reserved.
//

#import "KNVUNDExpendingTableViewRelatedModel.h"

@protocol KNVUNDETVRelatedTagButtonModelDelegate <NSObject>

- (void)selectTagButton:(UIButton *)tagButton;
- (void)tagButtonTriggeredWithAssociatedItem:(id)associatedItem;

@end

@interface KNVUNDETVRelatedTagButtonModel : KNVUNDExpendingTableViewRelatedModel

@property (nonatomic, weak) id<KNVUNDETVRelatedTagButtonModelDelegate> tagButtonDelegate;

//// Related Associated String
- (NSString *)associatedString;

//// Tag Button Releated
@property (readonly) UIButton *associatedTagButton;

//// General Methods
- (void)setupTagButton;
- (void)tapTagButton;

@end
