//
//  UNDPopOverListView.m
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#import "UNDPopOverListView.h"

#import "UNDPopOverListBaseTableViewCell.h"

@interface UNDPopOverListView() <UITableViewDelegate, UITableViewDataSource> {
    NSSet *_storedCellClasses;
}

@property (nonatomic) UNDPopOverListViewArrowDirection arrowDirection;
@property (nonatomic) CGRect sourceRect;
@property (nonatomic, strong) NSArray<id<UNDPopOverListItemModelProtocol>> *cachedList;
@property (nonatomic, strong) UNDPopOverListCellSelectionBlock cellSelectionBlock;

@property (nonatomic, strong) CAShapeLayer *backgroundShapeLayer;
@property (nonatomic, strong) UITableView *displayTableView;

@end

@implementation UNDPopOverListView

#pragma mark - Constant
CGFloat const UNDPopOverListViewBorder = 1.0f;
CGFloat const UNDPopOverListViewCornerRadius = 5.0f;

CGFloat const UNDPopOverListViewWidthMargin = 16.0f;
CGFloat const UNDPopOverListViewWidthPadding = 8.0f;
CGFloat const UNDPopOverListViewHeightMargin = 8.0f;
CGFloat const UNDPopOverListViewHeightPadding = 4.0f;
CGFloat const UNDPopOverListViewArrowWidth = 16.0f;

CGFloat const UNDPopOverListViewCellHeight = 38.0f;

CGFloat const UNDPopOverListViewPopPointRatio = 0.9;

#pragma mark - Init
- (instancetype)init {
    return [self initWithList:@[]
                   sourceRect:CGRectZero
               arrowDirection:UNDPopOverListViewArrowDirectionTop
       andSelectionLogicBlock:^(id _Nonnull item) { }];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self init];
}

- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceRect:(CGRect)sourceRect arrowDirection:(UNDPopOverListViewArrowDirection)arrowDirect andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    if (self = [super initWithFrame:CGRectZero]) {
        self.cachedList = list;
        self.sourceRect = sourceRect;
        self.arrowDirection = arrowDirect;
        self.cellSelectionBlock = selectionLogic;
        
        NSMutableSet *tempSet = [NSMutableSet new];
        for (id<UNDPopOverListItemModelProtocol> item in self.cachedList) {
            [tempSet addObject:[item relatedCellClass]];
        }
        _storedCellClasses = [NSSet setWithSet:tempSet];
        
        self.backgroundShapeLayer = [CAShapeLayer new];
        
        [self setUpViewBasedOnContent];
    }
    return self;
}

#pragma mark Support Methods
- (void)setUpViewBasedOnContent {
    if (self.cachedList.count > 0) {
        [self updateCurrentGeneralLayout];
        [self setUpDisplayTableView];
    } else {
        [self removeFromSuperview];
    }
}

- (void)updateCurrentGeneralLayout {
    self.frame = [self calculateCurrentFrame];
    
    if (self.backgroundShapeLayer.superlayer != nil) {
        [self.backgroundShapeLayer removeFromSuperlayer];
    }
    self.backgroundShapeLayer.path = [self getBackgroundPath].CGPath;
    self.backgroundShapeLayer.lineWidth = UNDPopOverListViewBorder;
    self.backgroundShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    self.backgroundShapeLayer.strokeColor = [UIColor blackColor].CGColor;
    
    [self.layer insertSublayer:_backgroundShapeLayer atIndex:0];
}

- (CGRect)calculateCurrentFrame {
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    switch (self.arrowDirection) {
        case UNDPopOverListViewArrowDirectionTop:
            width = self.sourceRect.size.width;
            height = [self.cachedList count] * UNDPopOverListViewCellHeight + 2 * UNDPopOverListViewHeightPadding + 2 * UNDPopOverListViewHeightMargin;
            originX = self.sourceRect.origin.x;
            originY = self.sourceRect.origin.y + self.sourceRect.size.height;
            break;
            
        case UNDPopOverListViewArrowDirectionBottom:
        default:
            width = self.sourceRect.size.width;
            height = [self.cachedList count] * UNDPopOverListViewCellHeight + 2 * UNDPopOverListViewHeightPadding + 2 * UNDPopOverListViewHeightMargin;
            originX = self.sourceRect.origin.x;
            originY = self.sourceRect.origin.y - height;
            break;
    }
    return CGRectMake(originX, originY, width, height);
}

- (UIBezierPath *)getBackgroundPath {
    UIBezierPath *returnPath = [UIBezierPath new];
    returnPath.lineJoinStyle = kCGLineJoinRound;
    returnPath.lineCapStyle = kCGLineCapRound;
    CGFloat marginPlusRadius = UNDPopOverListViewHeightMargin + UNDPopOverListViewCornerRadius;
    switch (self.arrowDirection) {
        case UNDPopOverListViewArrowDirectionTop: {
            CGFloat pointedX = self.frame.size.width * UNDPopOverListViewPopPointRatio;
            [returnPath moveToPoint:CGPointMake(pointedX, 0)];
            [returnPath addLineToPoint:CGPointMake(pointedX - UNDPopOverListViewArrowWidth / 2, UNDPopOverListViewHeightMargin)];
            [returnPath addLineToPoint:CGPointMake(marginPlusRadius, UNDPopOverListViewHeightMargin)];
            [returnPath addArcWithCenter:CGPointMake(marginPlusRadius, marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:M_PI * 3 / 2
                                endAngle:M_PI
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(UNDPopOverListViewHeightMargin,
                                                   self.frame.size.height - marginPlusRadius)];
            [returnPath addArcWithCenter:CGPointMake(marginPlusRadius, self.frame.size.height - marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:M_PI
                                endAngle:M_PI / 2
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - marginPlusRadius,
                                                   self.frame.size.height - UNDPopOverListViewHeightMargin)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - marginPlusRadius, self.frame.size.height - marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:M_PI / 2
                                endAngle:0
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - UNDPopOverListViewHeightMargin,
                                                   marginPlusRadius)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - marginPlusRadius, marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:0
                                endAngle:M_PI * 3 /2
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(pointedX + UNDPopOverListViewArrowWidth / 2, UNDPopOverListViewHeightMargin)];
            [returnPath closePath];
            break;
        }
        case UNDPopOverListViewArrowDirectionBottom:
        default: {
            CGFloat pointedX = self.frame.size.width * UNDPopOverListViewPopPointRatio;
            [returnPath moveToPoint:CGPointMake(pointedX, self.frame.size.height)];
            [returnPath addLineToPoint:CGPointMake(pointedX - UNDPopOverListViewArrowWidth / 2, self.frame.size.height - UNDPopOverListViewHeightMargin)];
            [returnPath addLineToPoint:CGPointMake(marginPlusRadius, self.frame.size.height - UNDPopOverListViewHeightMargin)];
            [returnPath addArcWithCenter:CGPointMake(marginPlusRadius, self.frame.size.height - marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:M_PI / 2
                                endAngle:M_PI
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(UNDPopOverListViewHeightMargin, marginPlusRadius)];
            [returnPath addArcWithCenter:CGPointMake(marginPlusRadius, marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:M_PI
                                endAngle:M_PI * 3 / 2
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - marginPlusRadius,
                                                   UNDPopOverListViewHeightMargin)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - marginPlusRadius, marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:M_PI * 3 / 2
                                endAngle:0
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - UNDPopOverListViewHeightMargin,
                                                   self.frame.size.height - marginPlusRadius)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - marginPlusRadius, self.frame.size.height - marginPlusRadius)
                                  radius:UNDPopOverListViewCornerRadius
                              startAngle:0
                                endAngle:M_PI /2
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(pointedX + UNDPopOverListViewArrowWidth / 2, self.frame.size.height - UNDPopOverListViewHeightMargin)];
            [returnPath closePath];
            break;
        }
    }
    return returnPath;
}

- (void)setUpDisplayTableView {
    if (self.displayTableView.superview != nil) {
        [self.displayTableView removeFromSuperview];
    }
    self.displayTableView = [UITableView new];
    for (Class<UNDPopOverListTableViewCellProtocol> cellClass in _storedCellClasses) {
        [self.displayTableView registerClass:cellClass
                      forCellReuseIdentifier:[cellClass cellIdentifier]];
    }
    self.displayTableView.delegate = self;
    self.displayTableView.dataSource = self;
    self.displayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.displayTableView.frame = [self calculateTableViewFrame];
    
    [self addSubview:self.displayTableView];
    [self.displayTableView reloadData];
}

- (CGRect)calculateTableViewFrame {
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    originX = UNDPopOverListViewWidthMargin + UNDPopOverListViewWidthPadding;
    originY = UNDPopOverListViewHeightMargin + UNDPopOverListViewHeightPadding;
    width = self.frame.size.width - 2 * originX;
    height = [self.cachedList count] * UNDPopOverListViewCellHeight;
    return CGRectMake(originX, originY, width, height);
}

#pragma mark - General Methods
- (void)updateList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)newList {
    NSUInteger previousCount = [self.cachedList count];
    self.cachedList = newList;
    if ([self.cachedList count] == previousCount) {
        
        // Update Cell Classes
        NSMutableSet *tempSet = [NSMutableSet setWithSet:_storedCellClasses];
        for (id<UNDPopOverListItemModelProtocol> item in self.cachedList) {
            Class<UNDPopOverListTableViewCellProtocol> cellClass = [item relatedCellClass];
            if (![tempSet containsObject:cellClass]) {
                [self.displayTableView registerClass:cellClass
                              forCellReuseIdentifier:[cellClass cellIdentifier]];
                [tempSet addObject:cellClass];
            }
        }
        _storedCellClasses = [NSSet setWithSet:tempSet];
        
        // Reload Table
        [self performInMainThread:^{
            [self.displayTableView reloadData];
        }];
    } else {
        
        // Update Cell Classes
        NSMutableSet *tempSet = [NSMutableSet new];
        for (id<UNDPopOverListItemModelProtocol> item in self.cachedList) {
            [tempSet addObject:[item relatedCellClass]];
        }
        _storedCellClasses = [NSSet setWithSet:tempSet];
        
        // Reload Table
        [self performInMainThread:^{
            [self setUpViewBasedOnContent];
        }];
    }
}

#pragma mark - Delegates
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.cachedList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UNDPopOverListViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<UNDPopOverListTableViewCellProtocol> *returnCell =
    [tableView dequeueReusableCellWithIdentifier:[UNDPopOverListBaseTableViewCell cellIdentifier]
                                    forIndexPath:indexPath];
    if (returnCell == nil) {
        returnCell = [UNDPopOverListBaseTableViewCell new];
    }
    if ([self.cachedList[indexPath.row] respondsToSelector:@selector(updateDisplayUIFromCell:)]) {
        [self.cachedList[indexPath.row] updateDisplayUIFromCell:returnCell];
    }
    return returnCell;
}

#pragma mark - Support Methods
- (void)performInMainThread:(void(^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

@end
