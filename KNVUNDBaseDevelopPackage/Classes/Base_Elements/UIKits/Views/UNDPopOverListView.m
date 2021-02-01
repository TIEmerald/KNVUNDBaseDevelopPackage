//
//  UNDPopOverListView.m
//  KNVUNDBaseDevelopPackage
//
//  Created by UNDaniel on 2021/1/14.
//

#import "UNDPopOverListView.h"

#import "UNDPopOverListBaseTableViewCell.h"

@interface UNDPopOverListViewConfiguration()
@property (nonatomic) BOOL loadingFlag;
@end

@implementation UNDPopOverListViewConfiguration

#pragma mark - Constant
CGFloat const UNDPopOverListViewConfiguration_DefaultBorder = 1.0f;
CGFloat const UNDPopOverListViewConfiguration_DefaultCornerRadius = 3.0f;

CGFloat const UNDPopOverListViewConfiguration_DefaultWidthMargin = 12.0f;
CGFloat const UNDPopOverListViewConfiguration_DefaultWidthPadding = 12.0f;
CGFloat const UNDPopOverListViewConfiguration_DefaultHeightMargin = 6.0f;
CGFloat const UNDPopOverListViewConfiguration_DefaultHeightPadding = 2.5f;
CGFloat const UNDPopOverListViewConfiguration_DefaultArrowWidth = 13.5f;

CGFloat const UNDPopOverListViewConfiguration_DefaultCellHeight = 35.0f;

CGFloat const UNDPopOverListViewConfiguration_DefaultPopPointRatio = 0.9;

#pragma mark - Factory Methods
+ (UNDPopOverListViewConfiguration *)addressAutoFillConfiguration {
    UNDPopOverListViewConfiguration *returnConfiguration = [UNDPopOverListViewConfiguration new];
    returnConfiguration.shadowOffset = CGSizeMake(0.0f, 0.0f);
    returnConfiguration.shadowRadius = 2.0f;
    returnConfiguration.shadowOpacity = 0.60f;
    returnConfiguration.borderWidth = 0.0f;
    return returnConfiguration;
}

#pragma mark - Init
- (instancetype)init {
    if (self = [super init]) {
        self.borderWidth = UNDPopOverListViewConfiguration_DefaultBorder;
        self.cornerRadius = UNDPopOverListViewConfiguration_DefaultCornerRadius;
        self.arrowWidth = UNDPopOverListViewConfiguration_DefaultArrowWidth;
        self.defaultCellHeight = UNDPopOverListViewConfiguration_DefaultCellHeight;
        self.arrowPointRatio = UNDPopOverListViewConfiguration_DefaultPopPointRatio;
        self.shadowOpacity = 0.0;
        
        self.borderColor = [UIColor blackColor].CGColor;
        self.shadowColor = [UIColor blackColor].CGColor;
        
        self.margin = UIEdgeInsetsMake(UNDPopOverListViewConfiguration_DefaultHeightMargin
                                       , UNDPopOverListViewConfiguration_DefaultWidthMargin
                                       , UNDPopOverListViewConfiguration_DefaultHeightMargin
                                       , UNDPopOverListViewConfiguration_DefaultWidthMargin);
        self.padding = UIEdgeInsetsMake(UNDPopOverListViewConfiguration_DefaultHeightPadding
                                        , UNDPopOverListViewConfiguration_DefaultWidthPadding
                                        , UNDPopOverListViewConfiguration_DefaultHeightPadding
                                        , UNDPopOverListViewConfiguration_DefaultWidthPadding);
        
        self.arrowDirection = UNDPopOverListViewArrowDirectionTop;
        self.maxmumDisplayCell = 5;
    }
    return self;
}

@end

@interface UNDPopOverListView() <UITableViewDelegate, UITableViewDataSource> {
    NSSet *_storedCellClasses;
    UNDPopOverListViewConfiguration *_usingConfiguration;
}

@property (readonly) CGFloat contentHeight;
@property (readonly) BOOL isDisplayLoadingView;
@property (nonatomic) int displayCellCount;

@property (nonatomic) CGRect sourceRect;
@property (nonatomic, strong) NSArray<id<UNDPopOverListItemModelProtocol>> *cachedList;
@property (nonatomic, strong) UNDPopOverListCellSelectionBlock cellSelectionBlock;

@property (nonatomic, strong) CAShapeLayer *backgroundShapeLayer;
@property (nonatomic, strong) UITableView *displayTableView;
@property (nonatomic, strong) UIView *cachedLoadingView;

@end

@implementation UNDPopOverListView

#pragma mark - Accessers
#pragma mark - Getters
- (CGFloat)contentHeight {
    if (self.isDisplayLoadingView) {
        return _usingConfiguration.defaultCellHeight;
    } else {
        return self.displayCellCount * _usingConfiguration.defaultCellHeight;
    }
}
#pragma mark - Setters
- (BOOL)isDisplayLoadingView {
    return _usingConfiguration.loadingViewGenerator != nil && _usingConfiguration.loadingFlag;
}
- (void)setCachedList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)cachedList {
    _cachedList = cachedList;
    _displayCellCount = (int)MIN([cachedList count], _usingConfiguration.maxmumDisplayCell);
}


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

- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceRect:(CGRect)sourceRect configuration:(UNDPopOverListViewConfiguration *)configuration andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    if (self = [super initWithFrame:CGRectZero]) {
        
        self->_usingConfiguration = configuration ?: [UNDPopOverListViewConfiguration new]; // _usingConfiguration need be set up before cachedList as _displayCellCount is affected
        self.cachedList = list;
        self.sourceRect = sourceRect;
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

- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceRect:(CGRect)sourceRect arrowDirection:(UNDPopOverListViewArrowDirection)arrowDirect andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    UNDPopOverListViewConfiguration *configuration = [UNDPopOverListViewConfiguration new];
    configuration.arrowDirection = arrowDirect;
    return [self initWithList:list
                   sourceRect:sourceRect
                configuration:configuration
       andSelectionLogicBlock:selectionLogic];
}

- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceView:(UIView *)sourceView presentingView:(UIView *)presentingView arrowDirection:(UNDPopOverListViewArrowDirection)arrowDirect andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    CGRect sourceRect = [sourceView.superview convertRect:sourceView.frame
                                                   toView:presentingView];
    if (self = [[UNDPopOverListView alloc] initWithList:list
                                             sourceRect:sourceRect
                                         arrowDirection:arrowDirect
                                 andSelectionLogicBlock:selectionLogic]) {
        [presentingView addSubview:self];
    }
    return self;
}


- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceView:(UIView *)sourceView presentingView:(UIView *)presentingView andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    return [self initWithList:list
                   sourceView:sourceView
               presentingView:presentingView
                configuration:[UNDPopOverListViewConfiguration new]
       andSelectionLogicBlock:selectionLogic];
}

- (instancetype)initWithList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)list sourceView:(UIView *)sourceView presentingView:(UIView *)presentingView configuration:(UNDPopOverListViewConfiguration *)configuration andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    
    CGRect sourceRect = [sourceView.superview convertRect:sourceView.frame
                                                   toView:presentingView];
    CGRect checkingRect = sourceRect;
    UNDPopOverListViewArrowDirection arrowDirect = UNDPopOverListViewArrowDirectionBottom;
    if ([presentingView isKindOfClass:[UIScrollView class]]) {
        UIScrollView *convertedView = (UIScrollView *)presentingView;
        checkingRect = CGRectMake(sourceRect.origin.x - convertedView.contentOffset.x
                                  , sourceRect.origin.y - convertedView.contentOffset.y
                                  , sourceRect.size.width
                                  , sourceRect.size.height);
    }
    
    // Right now we only have two direction need to worry.
    CGFloat topArea = checkingRect.origin.y;
    CGFloat bottomArea = presentingView.bounds.size.height - checkingRect.origin.y - checkingRect.size.height;
    if (topArea > bottomArea) {
        arrowDirect = UNDPopOverListViewArrowDirectionBottom;
    } else {
        arrowDirect = UNDPopOverListViewArrowDirectionTop;
    }
    
    UNDPopOverListViewConfiguration *usingConfiguration = configuration ?: [UNDPopOverListViewConfiguration new];
    usingConfiguration.arrowDirection = arrowDirect;
    
    if (self = [[UNDPopOverListView alloc] initWithList:list
                                             sourceRect:sourceRect
                                          configuration:usingConfiguration
                                 andSelectionLogicBlock:selectionLogic]) {
        [presentingView addSubview:self];
    }
    return self;
}

- (instancetype)initLoadingViewWithSourceView:(UIView *)sourceView presentingView:(UIView *)presentingView configuration:(UNDPopOverListViewConfiguration *)configuration andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    configuration.loadingFlag = true;
    return [self initWithList:@[]
                   sourceView:sourceView
               presentingView:presentingView
                configuration:configuration
       andSelectionLogicBlock:selectionLogic];
}

#pragma mark Support Methods
- (void)setUpViewBasedOnContent {
    if (self.isDisplayLoadingView) {
        [self prepareSetUpLayouts];
        [self updateCurrentGeneralLayout];
        UIView *loadingView = _usingConfiguration.loadingViewGenerator();
        if (loadingView != nil) {
            [self setUpWithLoadingView:loadingView];
        } else {
            [self removeFromSuperview];
        }
    } else if (self.cachedList.count > 0) {
        [self prepareSetUpLayouts];
        [self updateCurrentGeneralLayout];
        [self setUpDisplayTableView];
    } else {
        [self removeFromSuperview];
    }
}

- (void)prepareSetUpLayouts {
    if (self.displayTableView.superview != nil) {
        [self.displayTableView removeFromSuperview];
        self.displayTableView = nil;
    }
    if (self.cachedLoadingView.superview != nil) {
        [self.cachedLoadingView removeFromSuperview];
        self.cachedLoadingView = nil;
    }
}

- (void)updateCurrentGeneralLayout {
    self.frame = [self calculateCurrentFrame];
    
    if (self.backgroundShapeLayer.superlayer != nil) {
        [self.backgroundShapeLayer removeFromSuperlayer];
    }
    self.backgroundShapeLayer.path = [self getBackgroundPath].CGPath;
    self.backgroundShapeLayer.lineWidth = _usingConfiguration.borderWidth;
    self.backgroundShapeLayer.shadowColor = _usingConfiguration.shadowColor;
    self.backgroundShapeLayer.shadowOpacity = _usingConfiguration.shadowOpacity;
    self.backgroundShapeLayer.shadowOffset = _usingConfiguration.shadowOffset;
    self.backgroundShapeLayer.shadowRadius = _usingConfiguration.shadowRadius;
    self.backgroundShapeLayer.shadowPath = nil;
    self.backgroundShapeLayer.fillColor = [UIColor whiteColor].CGColor;
    self.backgroundShapeLayer.strokeColor = _usingConfiguration.borderColor;
    
    [self.layer insertSublayer:_backgroundShapeLayer atIndex:0];
}

- (CGRect)calculateCurrentFrame {
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    switch (_usingConfiguration.arrowDirection) {
        case UNDPopOverListViewArrowDirectionTop:
            width = self.sourceRect.size.width;
            height = self.contentHeight + _usingConfiguration.padding.top + _usingConfiguration.padding.bottom + _usingConfiguration.margin.top + _usingConfiguration.margin.top;
            originX = self.sourceRect.origin.x;
            originY = self.sourceRect.origin.y + self.sourceRect.size.height;
            break;
            
        case UNDPopOverListViewArrowDirectionBottom:
        default:
            width = self.sourceRect.size.width;
            height = self.contentHeight + _usingConfiguration.padding.top + _usingConfiguration.padding.bottom + _usingConfiguration.margin.top + _usingConfiguration.margin.top;
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
    switch (_usingConfiguration.arrowDirection) {
        case UNDPopOverListViewArrowDirectionTop: {
            CGFloat pointedX = self.frame.size.width * _usingConfiguration.arrowPointRatio;
            [returnPath moveToPoint:CGPointMake(pointedX, 0)];
            [returnPath addLineToPoint:CGPointMake(pointedX - _usingConfiguration.arrowWidth / 2, _usingConfiguration.margin.top)];
            [returnPath addLineToPoint:CGPointMake(_usingConfiguration.margin.left + _usingConfiguration.cornerRadius, _usingConfiguration.margin.top)];
            [returnPath addArcWithCenter:CGPointMake(_usingConfiguration.margin.left + _usingConfiguration.cornerRadius
                                                     , _usingConfiguration.margin.top + _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:M_PI * 3 / 2
                                endAngle:M_PI
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(_usingConfiguration.margin.left,
                                                   self.frame.size.height - _usingConfiguration.margin.bottom - _usingConfiguration.cornerRadius)];
            [returnPath addArcWithCenter:CGPointMake(_usingConfiguration.margin.left + _usingConfiguration.cornerRadius
                                                     , self.frame.size.height - _usingConfiguration.margin.bottom - _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:M_PI
                                endAngle:M_PI / 2
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right - _usingConfiguration.cornerRadius,
                                                   self.frame.size.height - _usingConfiguration.margin.bottom)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right - _usingConfiguration.cornerRadius
                                                     , self.frame.size.height - _usingConfiguration.margin.bottom - _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:M_PI / 2
                                endAngle:0
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right,
                                                   _usingConfiguration.margin.top + _usingConfiguration.cornerRadius)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right - _usingConfiguration.cornerRadius
                                                     , _usingConfiguration.margin.top + _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:0
                                endAngle:M_PI * 3 /2
                               clockwise:false];
            [returnPath addLineToPoint:CGPointMake(pointedX + _usingConfiguration.arrowWidth / 2, _usingConfiguration.margin.top)];
            [returnPath closePath];
            break;
        }
        case UNDPopOverListViewArrowDirectionBottom:
        default: {
            CGFloat pointedX = self.frame.size.width * _usingConfiguration.arrowPointRatio;
            [returnPath moveToPoint:CGPointMake(pointedX, self.frame.size.height)];
            [returnPath addLineToPoint:CGPointMake(pointedX - _usingConfiguration.arrowWidth / 2
                                                   , self.frame.size.height - _usingConfiguration.margin.bottom)];
            [returnPath addLineToPoint:CGPointMake(_usingConfiguration.margin.left + _usingConfiguration.cornerRadius
                                                   , self.frame.size.height - _usingConfiguration.margin.bottom)];
            [returnPath addArcWithCenter:CGPointMake(_usingConfiguration.margin.left + _usingConfiguration.cornerRadius
                                                     , self.frame.size.height - _usingConfiguration.margin.bottom - _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:M_PI / 2
                                endAngle:M_PI
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(_usingConfiguration.margin.left
                                                   , _usingConfiguration.margin.top + _usingConfiguration.cornerRadius)];
            [returnPath addArcWithCenter:CGPointMake(_usingConfiguration.margin.left + _usingConfiguration.cornerRadius
                                                     , _usingConfiguration.margin.top + _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:M_PI
                                endAngle:M_PI * 3 / 2
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right - _usingConfiguration.cornerRadius,
                                                   _usingConfiguration.margin.top)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right - _usingConfiguration.cornerRadius
                                                     , _usingConfiguration.margin.top + _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:M_PI * 3 / 2
                                endAngle:0
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right,
                                                   self.frame.size.height - _usingConfiguration.margin.bottom - _usingConfiguration.cornerRadius)];
            [returnPath addArcWithCenter:CGPointMake(self.frame.size.width - _usingConfiguration.margin.right - _usingConfiguration.cornerRadius
                                                     , self.frame.size.height - _usingConfiguration.margin.bottom - _usingConfiguration.cornerRadius)
                                  radius:_usingConfiguration.cornerRadius
                              startAngle:0
                                endAngle:M_PI /2
                               clockwise:true];
            [returnPath addLineToPoint:CGPointMake(pointedX + _usingConfiguration.arrowWidth / 2
                                                   , self.frame.size.height - _usingConfiguration.margin.bottom)];
            [returnPath closePath];
            break;
        }
    }
    return returnPath;
}

- (void)setUpDisplayTableView {
    self.displayTableView = [UITableView new];
    for (Class<UNDPopOverListTableViewCellProtocol> cellClass in _storedCellClasses) {
        [self.displayTableView registerClass:cellClass
                      forCellReuseIdentifier:[cellClass cellIdentifier]];
    }
    self.displayTableView.delegate = self;
    self.displayTableView.dataSource = self;
    self.displayTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.displayTableView.frame = [self calculateContentViewFrame];
    
    self.displayTableView.exclusiveTouch = YES;
    
    [self addSubview:self.displayTableView];
    [self.displayTableView reloadData];
}

- (void)setUpWithLoadingView:(UIView *)loadingView {
    self.cachedLoadingView = loadingView;
    self.cachedLoadingView.frame = [self calculateContentViewFrame];
    [self addSubview:self.cachedLoadingView];
}

- (CGRect)calculateContentViewFrame {
    CGFloat width = 0.0f;
    CGFloat height = 0.0f;
    CGFloat originX = 0.0f;
    CGFloat originY = 0.0f;
    originX = _usingConfiguration.margin.left + _usingConfiguration.padding.left;
    originY = _usingConfiguration.margin.top + _usingConfiguration.padding.top;
    width = self.frame.size.width - 2 * originX;
    height = self.contentHeight;
    return CGRectMake(originX, originY, width, height);
}

#pragma mark - Override Methods
#pragma mark - UIView
- (void)removeFromSuperview {
    _usingConfiguration.loadingFlag = false;
    [super removeFromSuperview];
}

#pragma mark - General Methods
- (void)updateList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)newList {
    _usingConfiguration.loadingFlag = false;
    NSUInteger previousCount = self.displayCellCount;
    self.cachedList = newList;
    if (self.displayCellCount == previousCount) {
        
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

- (void)updateList:(NSArray<id<UNDPopOverListItemModelProtocol>> *)newList andSelectionLogicBlock:(UNDPopOverListCellSelectionBlock)selectionLogic {
    self.cellSelectionBlock = selectionLogic;
    [self updateList:newList];
}

- (void)showUpLoadingView {
    self.cachedList = @[];
    _storedCellClasses = [NSSet new];
    _usingConfiguration.loadingFlag = true;
    [self performInMainThread:^{
        [self setUpViewBasedOnContent];
    }];
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
    return _usingConfiguration.defaultCellHeight;
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performCellSelectionBlockWithIndexPath:indexPath];
}

#pragma mark - Support Methods
- (void)performCellSelectionBlockWithIndexPath:(NSIndexPath *)indexPath {
    id<UNDPopOverListItemModelProtocol> relatedModel = self.cachedList[indexPath.row];
    if (![relatedModel respondsToSelector:@selector(isSelectable)] || [relatedModel isSelectable]) {
        if ([relatedModel respondsToSelector:@selector(cachedData)]) {
            self.cellSelectionBlock([relatedModel cachedData]);
        }
    }
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
