#import <Foundation/Foundation.h>
#import "LKDBHelper.h"
@interface HBHttpRequestCache : NSObject
{
    LKDBHelper * _dbHelper;
    NSString *_cacheFilePath;
    NSCache * _memoryCache;
    dispatch_queue_t _queue;
    long long _staleTime;       
    BOOL _timeLimit;    
}
+(HBHttpRequestCache*)shareCache;
+(void)clearCache;
- (void)clearOneCache:(NSString *)url;
-(void)setTimeLimit:(long long)time;
-(BOOL)storeTextToDB:(NSString*)text withUrl:(NSString*)url;
-(NSString*) getTextFromDB:(NSString*)url;
-(BOOL)storeBitmapToMemory:(UIImage*)image withKey:(NSString*)key;
-(void)storeBitmapToDisk:(UIImage*)image withKey:(NSString*)key complete:(void(^)(BOOL))complete;
-(void)storeBitmap:(UIImage*)image  withKey:(NSString*)key complete:(void(^)(BOOL))complete;
-(UIImage*)getBitmapFromMemory:(NSString*)key;
-(UIImage*)getBitmapFromDisk:(NSString *)key;
-(void)getBitmapFromDisk:(NSString*)key complete:(void(^)(UIImage *))complete;
-(void)getBitmap:(NSString*)key  complete:(void(^)(UIImage *))complete;
-(void) clearDiskCache;
-(void) clearMemoryCache;
-(void) setDirectoryAtPath:(NSString*) path;
@end
