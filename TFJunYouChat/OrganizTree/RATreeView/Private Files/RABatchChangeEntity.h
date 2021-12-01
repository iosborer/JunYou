#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, RABatchChangeType) {
    RABatchChangeTypeItemRowInsertion = 0,
    RABatchChangeTypeItemRowExpansion,
    RABatchChangeTypeItemRowDeletion,
    RABatchChangeTypeItemRowCollapse,
    RABatchChangeTypeItemMove
};
@interface RABatchChangeEntity : NSObject
@property (nonatomic) RABatchChangeType type;
@property (nonatomic) NSInteger ranking;
@property (nonatomic, copy) void(^updatesBlock)();
+ (instancetype)batchChangeEntityWithBlock:(void(^)())updates type:(RABatchChangeType)type ranking:(NSInteger)ranking;
@end
