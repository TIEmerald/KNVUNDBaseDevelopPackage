//
//  KNVUNDETVTagButtonReleatedBaseTableViewCell.h
//  KNVUNDBaseDevelopPackage
//
//  Created by Erjian Ni on 28/3/18.
//

#import "KNVUNDETVRelatedBasicTableViewCell.h"

// Models
#import "KNVUNDETVTagButtonRelatedBaseModel.h"

@interface KNVUNDETVTagButtonReleatedBaseTableViewCell : KNVUNDETVRelatedBasicTableViewCell <KNVUNDETVTagButtonRelatedBaseModelCellDelegate>

#pragma mark - Methods for Override
- (void)setUpTagSelectionStatusRelatedUIWithStatus:(BOOL)tagViewSelectionStatus;

@end
