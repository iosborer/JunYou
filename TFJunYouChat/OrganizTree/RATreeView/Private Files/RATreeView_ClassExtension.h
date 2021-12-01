#import "RATreeView.h"
@class RABatchChanges;
@interface RATreeView ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) RATreeNodeCollectionController *treeNodeCollectionController;
@property (nonatomic, strong) RABatchChanges *batchChanges;
@end
