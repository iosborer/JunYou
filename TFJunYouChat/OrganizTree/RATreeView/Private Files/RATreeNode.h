#import <Foundation/Foundation.h>
@class RATreeNodeItem;
@interface RATreeNode : NSObject
@property (nonatomic, readonly) BOOL expanded;
@property (strong, nonatomic, readonly) id item;
- (id)initWithLazyItem:(RATreeNodeItem *)item expandedBlock:(BOOL (^)(id))expandedBlock;
@end
