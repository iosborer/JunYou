#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class RATreeView, RATreeNodeCollectionController, RATreeNode;
typedef enum {
    RATreeViewStylePlain = 0,
    RATreeViewStyleGrouped
} RATreeViewStyle;
typedef enum RATreeViewCellSeparatorStyle {
    RATreeViewCellSeparatorStyleNone = 0,
    RATreeViewCellSeparatorStyleSingleLine,
    RATreeViewCellSeparatorStyleSingleLineEtched
} RATreeViewCellSeparatorStyle;
typedef enum RATreeViewScrollPosition {
    RATreeViewScrollPositionNone = 0,
    RATreeViewScrollPositionTop,
    RATreeViewScrollPositionMiddle,
    RATreeViewScrollPositionBottom
} RATreeViewScrollPosition;
typedef enum RATreeViewRowAnimation {
    RATreeViewRowAnimationFade = 0,
    RATreeViewRowAnimationRight,
    RATreeViewRowAnimationLeft,
    RATreeViewRowAnimationTop,
    RATreeViewRowAnimationBottom,
    RATreeViewRowAnimationNone,
    RATreeViewRowAnimationMiddle,
    RATreeViewRowAnimationAutomatic = UITableViewRowAnimationAutomatic
} RATreeViewRowAnimation;
@protocol RATreeViewDataSource <NSObject>
- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(nullable id)item;
- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(nullable id)item;
- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(nullable id)item;
@optional
- (void)treeView:(RATreeView *)treeView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowForItem:(id)item;
- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item;
@end
@protocol RATreeViewDelegate <NSObject>
@optional
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item;
- (CGFloat)treeView:(RATreeView *)treeView estimatedHeightForRowForItem:(id)item NS_AVAILABLE_IOS(7_0);
- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item;
- (void)treeView:(RATreeView *)treeView accessoryButtonTappedForRowForItem:(id)item;
- (BOOL)treeView:(RATreeView *)treeView shouldExpandRowForItem:(id)item;
- (BOOL)treeView:(RATreeView *)treeView shouldCollapaseRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView willExpandRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView willCollapseRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didExpandRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didCollapseRowForItem:(id)item;
- (id)treeView:(RATreeView *)treeView willSelectRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item;
- (id)treeView:(RATreeView *)treeView willDeselectRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didDeselectRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView willBeginEditingRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didEndEditingRowForItem:(id)item;
- (UITableViewCellEditingStyle)treeView:(RATreeView *)treeView editingStyleForRowForItem:(id)item;
- (NSString *)treeView:(RATreeView *)treeView titleForDeleteConfirmationButtonForRowForItem:(id)item;
- (BOOL)treeView:(RATreeView *)treeView shouldIndentWhileEditingRowForItem:(id)item;
- (NSArray *)treeView:(RATreeView *)treeView editActionsForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didEndDisplayingCell:(UITableViewCell *)cell forItem:(id)item;
- (BOOL)treeView:(RATreeView *)treeView shouldShowMenuForRowForItem:(id)item;
- (BOOL)treeView:(RATreeView *)treeView canPerformAction:(SEL)action forRowForItem:(id)item withSender:(id)sender;
- (void)treeView:(RATreeView *)treeView performAction:(SEL)action forRowForItem:(id)item withSender:(id)sender;
- (BOOL)treeView:(RATreeView *)treeView shouldHighlightRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didHighlightRowForItem:(id)item;
- (void)treeView:(RATreeView *)treeView didUnhighlightRowForItem:(id)item;
@end
@interface RATreeView : UIView
- (id)initWithFrame:(CGRect)frame style:(RATreeViewStyle)style;
@property (nonatomic, nullable, weak) id<RATreeViewDataSource> dataSource;
@property (nonatomic, nullable, weak) id<RATreeViewDelegate> delegate;
- (NSInteger)numberOfRows;
@property (nonatomic, readonly) RATreeViewStyle style;
@property (nonatomic) RATreeViewCellSeparatorStyle separatorStyle;
@property (nonatomic, nullable, strong) UIColor *separatorColor;
@property (nonatomic) CGFloat rowHeight;
@property (nonatomic) CGFloat estimatedRowHeight NS_AVAILABLE_IOS(7_0);
@property (nonatomic) CGFloat estimatedSectionHeaderHeight;
@property (nonatomic) CGFloat estimatedSectionFooterHeight;
@property (nonatomic) UIEdgeInsets separatorInset NS_AVAILABLE_IOS(7_0);
@property (nonatomic, nullable, copy) UIVisualEffect *separatorEffect NS_AVAILABLE_IOS(8_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic) BOOL cellLayoutMarginsFollowReadableWidth NS_AVAILABLE_IOS(9_0);
@property (nonatomic, nullable, strong) UIView *backgroundView;
- (void)expandRowForItem:(nullable id)item expandChildren:(BOOL)expandChildren withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)expandRowForItem:(nullable id)item withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)expandRowForItem:(nullable id)item;
- (void)collapseRowForItem:(nullable id)item collapseChildren:(BOOL)collapseChildren withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)collapseRowForItem:(nullable id)item withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)collapseRowForItem:(nullable id)item;
@property (nonatomic) BOOL expandsChildRowsWhenRowExpands;
@property (nonatomic) BOOL collapsesChildRowsWhenRowCollapses;
@property (nonatomic) RATreeViewRowAnimation rowsExpandingAnimation;
@property (nonatomic) RATreeViewRowAnimation rowsCollapsingAnimation;
- (void)beginUpdates;
- (void)endUpdates;
- (void)insertItemsAtIndexes:(NSIndexSet *)indexes inParent:(nullable id)parent withAnimation:(RATreeViewRowAnimation)animation;
- (void)moveItemAtIndex:(NSInteger)oldIndex inParent:(nullable id)oldParent toIndex:(NSInteger)newIndex inParent:(nullable id)newParent;
- (void)deleteItemsAtIndexes:(NSIndexSet *)indexes inParent:(nullable id)parent withAnimation:(RATreeViewRowAnimation)animation;
- (void)registerClass:(nullable Class)cellClass forCellReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (void)registerNib:(nullable UINib *)nib forCellReuseIdentifier:(NSString *)identifier;
- (nullable id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (void)registerNib:(UINib *)nib forHeaderFooterViewReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (void)registerClass:(Class)aClass forHeaderFooterViewReuseIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier NS_AVAILABLE_IOS(6_0);
@property (nonatomic, nullable, strong) UIView *treeHeaderView;
@property (nonatomic, nullable, strong) UIView *treeFooterView;
- (BOOL)isCellForItemExpanded:(id)item;
- (BOOL)isCellExpanded:(UITableViewCell *)cell;
- (NSInteger)levelForCellForItem:(id)item;
- (NSInteger)levelForCell:(UITableViewCell *)cell;
- (nullable id)parentForItem:(id)parent;
- (nullable UITableViewCell *)cellForItem:(id)item;
- (nullable NSArray *)visibleCells;
- (nullable id)itemForCell:(UITableViewCell *)cell;
- (nullable id)itemForRowAtPoint:(CGPoint)point;
- (nullable id)itemsForRowsInRect:(CGRect)rect;
@property (nonatomic, nullable, copy, readonly) NSArray *itemsForVisibleRows;
- (void)scrollToRowForItem:(id)item atScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (void)scrollToNearestSelectedRowAtScrollPosition:(RATreeViewScrollPosition)scrollPosition animated:(BOOL)animated;
- (nullable id)itemForSelectedRow;
- (nullable NSArray *)itemsForSelectedRows;
- (void)selectRowForItem:(nullable id)item animated:(BOOL)animated scrollPosition:(RATreeViewScrollPosition)scrollPosition;
- (void)deselectRowForItem:(id)item animated:(BOOL)animated;
@property (nonatomic) BOOL allowsSelection;
@property (nonatomic) BOOL allowsMultipleSelection;
@property (nonatomic) BOOL allowsSelectionDuringEditing;
@property (nonatomic) BOOL allowsMultipleSelectionDuringEditing;
- (void)setEditing:(BOOL)editing animated:(BOOL)animated;
@property (nonatomic, getter = isEditing) BOOL editing;
- (void)reloadData;
- (void)reloadRowsForItems:(NSArray *)items withRowAnimation:(RATreeViewRowAnimation)animation;
- (void)reloadRows;
@property (nonatomic, strong, readonly) UIScrollView *scrollView;
@end
NS_ASSUME_NONNULL_END
