#import "TFJunYou_XLsn0wScrollUnderlineButton.h"
static NSString *const cellIdentifier = @"TFJunYou_XLsn0wScrollUnderlineButtonCell";
@interface TFJunYou_XLsn0wScrollUnderlineButton () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@end
@implementation TFJunYou_XLsn0wScrollUnderlineButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _normalFont = _selectedFont = [UIFont systemFontOfSize:14];
        _normalColor = [UIColor blackColor];
        _selectedColor = [UIColor blueColor];
        _currentIndex = 0;
        _lineEdgeInsets = UIEdgeInsetsMake(0, 3, 2, 3);
        _cursorEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
-(UIView*)lineView
{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor purpleColor];
        [self.collectionView addSubview:_lineView];
    }
    return _lineView;
}
-(UICollectionView*)collectionView {
    if (!_collectionView) {
        _layout = [[UICollectionViewFlowLayout alloc]init];
        _layout.minimumLineSpacing = 0;
        _layout.minimumInteritemSpacing = 0;
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        CGRect rect = CGRectMake(_cursorEdgeInsets.left, _cursorEdgeInsets.top, CGRectGetWidth(self.bounds)-_cursorEdgeInsets.left-_cursorEdgeInsets.right, CGRectGetHeight(self.bounds)-_cursorEdgeInsets.top-_cursorEdgeInsets.bottom);
        _collectionView = [[UICollectionView alloc]initWithFrame:rect collectionViewLayout:_layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[TFJunYou_XLsn0wScrollUnderlineButtonCell class] forCellWithReuseIdentifier:cellIdentifier];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}
- (void)reloadData {
    [self.collectionView reloadData];
}
-(void)setTitles:(NSArray *)titles {
    _titles = titles;
    [self reloadData];
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
}
-(void)setContentOffsetWithCellFrame:(CGRect)frame
{
    CGFloat width = CGRectGetWidth(self.collectionView.frame)/2;
    CGFloat offsetX = 0;
    if (CGRectGetMidX(frame) <= width) {
        offsetX = 0;
    }else if (CGRectGetMidX(frame) + width >= self.collectionView.contentSize.width) {
        if (CGRectGetMaxX(frame) <= self.collectionView.frame.size.width) {
            offsetX = 0;
        } else {
            offsetX = self.collectionView.contentSize.width - CGRectGetWidth(self.collectionView.frame);
        }
    }else{
        offsetX = CGRectGetMidX(frame)-CGRectGetWidth(self.collectionView.frame)/2;
    }
    [self.collectionView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}
-(void)resizeLineViewWihtCellFrame:(CGRect)frame animated:(BOOL)animated
{
    CGFloat height = 3.0f;
    CGRect rect = CGRectMake(CGRectGetMinX(frame)+_lineEdgeInsets.left,
                             CGRectGetHeight(self.collectionView.frame)-height-_lineEdgeInsets.bottom,
                             CGRectGetWidth(frame)-_lineEdgeInsets.left*2, height-_lineEdgeInsets.top);
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            self.lineView.frame = rect;
        }];
    }else{
        self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.collectionView.frame)-height-_lineEdgeInsets.bottom, 50, 3);
        [self setContentOffsetWithCellFrame:self.lineView.frame];
    }
}
-(void)selectItemAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_currentIndex inSection:0];
    [self.collectionView selectItemAtIndexPath:indexPath
                                      animated:YES
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    [self selectItemAtIndexPath:indexPath];
}
-(void)selectItemAtIndexPath:(NSIndexPath*)indexPath {
    TFJunYou_XLsn0wScrollUnderlineButtonCell *cell = (TFJunYou_XLsn0wScrollUnderlineButtonCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = YES;
    CGRect rect = cell.frame;
    if (!cell) {
        UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
        rect = attributes.frame;
    }
    [self setContentOffsetWithCellFrame:rect];
    [self resizeLineViewWihtCellFrame:rect animated:YES];
}
-(void)deselectItemAtIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    TFJunYou_XLsn0wScrollUnderlineButtonCell *cell = (TFJunYou_XLsn0wScrollUnderlineButtonCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TFJunYou_XLsn0wScrollUnderlineButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    NSString *title = _titles[indexPath.item];
    cell.title = title;
    cell.normalFont = self.normalFont;
    cell.selectedFont = self.selectedFont;
    cell.normalColor = self.normalColor;
    cell.selectedColor = self.selectedColor;
    cell.selected = (indexPath.item == _currentIndex);
    if (collectionView.indexPathsForSelectedItems.count <= 0) {
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:_currentIndex inSection:0]
                                          animated:NO
                                    scrollPosition:UICollectionViewScrollPositionNone];
        [self resizeLineViewWihtCellFrame:cell.frame animated:NO];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_currentIndex == indexPath.item) {
        return;
    }
    _currentIndex = indexPath.item;
    self.scrollUnderlineButtonBlock(indexPath.item);
    [self selectItemAtIndexPath:indexPath];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    TFJunYou_XLsn0wScrollUnderlineButtonCell *cell = (TFJunYou_XLsn0wScrollUnderlineButtonCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.selected = NO;
}
#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = _titles[indexPath.item];
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:self.selectedFont}];
    size = CGSizeMake(size.width+20, CGRectGetHeight(self.bounds));
    return size;
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
@interface TFJunYou_XLsn0wScrollUnderlineButtonCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation TFJunYou_XLsn0wScrollUnderlineButtonCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _selectedColor = [UIColor blueColor];
        _normalColor = [UIColor whiteColor];
        _selectedFont = _normalFont = [UIFont systemFontOfSize:14];
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    _titleLabel.text = _title;
}
-(void)setSelected:(BOOL)selected
{
    super.selected = selected;
    if (selected) {
        _titleLabel.font = _selectedFont;
        _titleLabel.textColor = _selectedColor;
    }else{
        _titleLabel.font = _normalFont;
        _titleLabel.textColor = _normalColor;
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = self.bounds;
}
@end
