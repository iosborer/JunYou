#import "HBHttpRequestCache.h"
#import "HBHttpCacheData.h"
#import <CommonCrypto/CommonDigest.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
@implementation HBHttpRequestCache
-(id)init
{
    self=[super init];
    if(self){
        _dbHelper=[[LKDBHelper alloc]init];
        [_dbHelper createTableWithModelClass:[HBHttpCacheData class]];
        NSArray * paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSMutableString * path=[NSMutableString stringWithString:[paths objectAtIndex:0]];
        [path appendFormat:@"/HBHttpCache"];
        _cacheFilePath=path;
        NSFileManager * manager=[NSFileManager defaultManager];
        if(![manager fileExistsAtPath:_cacheFilePath])
           [manager createDirectoryAtPath:_cacheFilePath withIntermediateDirectories:YES attributes:nil error:NULL];
        _memoryCache=[[NSCache alloc]init];
        [_memoryCache setTotalCostLimit:7*1024*1024];   
        _queue=dispatch_queue_create("com.HBHhttp.imageCache", NULL);
        _staleTime=24*60*60*3;
        _timeLimit=NO;   
    }
    return self;
}
#pragma -mark  私有方法
-(void)clearCache
{
    dispatch_async(_queue, ^{
        NSArray* array=[_dbHelper search:[HBHttpCacheData class] where:[NSString stringWithFormat:@"cacheType=%d",HBHttpCacheDataTypeImage] orderBy:nil offset:0 count:MAXFLOAT];
        NSFileManager * manager=[NSFileManager defaultManager];
        for(HBHttpCacheData * cache in array){
            [manager removeItemAtPath:cache.cacheData error:nil];      
        }
        [LKDBHelper clearTableData:[HBHttpCacheData class]];         
        [self clearMemoryCache];   
    });
}
-(BOOL)timeOutCheck:(HBHttpCacheData*)data
{
    NSDate * date=[NSDate date];
    long long now=(long long)date.timeIntervalSince1970;
    if((now-data.timestamp.longLongValue)>_staleTime){
        [self timeOutCheck:data];
        return YES;
    }else{
        return NO;
    }
}
-(void)timeOutAction:(HBHttpCacheData*)data
{
    if(data.cacheType==HBHttpCacheDataTypeText){
        [_dbHelper deleteToDB:data];
    }else if(data.cacheType==HBHttpCacheDataTypeImage){
        NSFileManager * manager=[NSFileManager defaultManager];
        [manager removeItemAtPath:data.cacheData error:nil];
        [_dbHelper deleteToDB:data];
    }
}
#pragma -mark  接口方法
+(HBHttpRequestCache*)shareCache
{
    static HBHttpRequestCache * server=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server=[[HBHttpRequestCache alloc]init];
    });
    return server;
}
+(void)clearCache
{
    [[self shareCache] clearCache];
}
- (void)clearOneCache:(NSString *)url{
    [_memoryCache removeObjectForKey:url];
}
-(void)setTimeLimit:(long long)time
{
    _staleTime=time;
}
-(NSString *)getFileName:(NSString*)key
{
    const char *str = [key UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
}
-(BOOL)storeTextToDB:(NSString*)text withUrl:(NSString*)url
{
    HBHttpCacheData * cache=[[HBHttpCacheData alloc]init];
    cache.cacheData=text;
    cache.cacheUrl=url;
    cache.cacheType=HBHttpCacheDataTypeText;
    int rowCount=[_dbHelper rowCount:[HBHttpCacheData class] where:@{@"cacheUrl":url}];
    if(rowCount==0)
        return [_dbHelper insertToDB:cache];   
    else {
        if([_dbHelper deleteToDB:cache])
           return  [_dbHelper insertToDB:cache];
        else
           return NO;
    }   
}
-(NSString*) getTextFromDB:(NSString*)url
{
    HBHttpCacheData * cache=[_dbHelper searchSingle:[HBHttpCacheData class] where:@{@"cacheUrl":url} orderBy:nil];
    if(_timeLimit){
       if([self timeOutCheck:cache])
            return nil;
    }
    if(cache&&cache.cacheType==HBHttpCacheDataTypeText)
        return cache.cacheData;
    return nil;
}
-(BOOL)storeBitmapToMemory:(UIImage*)image withKey:(NSString*)key
{
    id object=[_memoryCache objectForKey:key];
    if(object==nil){
        if(image){
            [_memoryCache setObject:image forKey:key];
            return YES;
        }else
            return NO;
    }else
        return NO;
}
-(void)storeBitmapToDisk:(UIImage*)image withKey:(NSString*)key complete:(void(^)(BOOL))complete
{
    dispatch_async(_queue, ^{
        BOOL success=NO;
        NSMutableString * fileName=[NSMutableString stringWithString:_cacheFilePath];
        [fileName appendFormat:@"/%@",[self getFileName:key]];
        HBHttpCacheData * cache=[[HBHttpCacheData alloc]init];
        cache.cacheData=fileName;
        cache.cacheType=HBHttpCacheDataTypeImage;
        cache.cacheUrl=key;
        int rowCount=[_dbHelper rowCount:[HBHttpCacheData class] where:@{@"cacheUrl":key}];
        if(rowCount==0){     
            if([_dbHelper insertToDB:cache]){       
                NSFileManager * manager=[NSFileManager defaultManager];
                if(![manager createFileAtPath:fileName contents:UIImageJPEGRepresentation(image, 0.5) attributes:nil]){
                    [_dbHelper deleteToDB:cache];   
                }else{
                    success=YES;
                }
            }
        }else{          
            NSFileManager * manager=[NSFileManager defaultManager];
            [manager removeItemAtPath:cache.cacheData error:nil];
            if(![manager createFileAtPath:fileName contents:UIImageJPEGRepresentation(image, 0.5) attributes:nil]){
                [_dbHelper deleteToDB:cache];           
            }else{
                success=YES;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(success);
        });
    });
  }
-(void)storeBitmap:(UIImage*)image withKey:(NSString*)key complete:(void(^)(BOOL))complete
{
    [self storeBitmapToDisk:image withKey:key complete:^(BOOL success) {
        if(success){  
            [self storeBitmapToMemory:image withKey:key];
        }
        if(complete){
            complete(success);
        }
    }];
}
-(UIImage*)getBitmapFromMemory:(NSString*)key
{
    return [_memoryCache objectForKey:key];
}
-(void)getBitmapFromDisk:(NSString*)key complete:(void(^)(UIImage *))complete
{
    dispatch_async(_queue, ^{
        HBHttpCacheData * cache=[_dbHelper searchSingle:[HBHttpCacheData class] where:@{@"cacheUrl":key} orderBy:nil];
        if(_timeLimit){
            if([self timeOutCheck:cache]){
                complete(nil);
            }
        }
        if(cache&&cache.cacheType==HBHttpCacheDataTypeImage){          
            NSFileManager * manager=[NSFileManager defaultManager];
            if(![manager fileExistsAtPath:cache.cacheData]){
                [_dbHelper deleteToDB:cache];
                complete(nil);   
            }
            UIImage *image=[UIImage imageWithContentsOfFile:cache.cacheData];
            if(image==nil){
                [_dbHelper deleteToDB:cache];
                [manager removeItemAtPath:cache.cacheData error:nil];
                complete(nil);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(image);
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(nil);
            });
        }
    });
}
-(UIImage*)getBitmapFromDisk:(NSString *)key
{
    HBHttpCacheData * cache=[_dbHelper searchSingle:[HBHttpCacheData class] where:@{@"cacheUrl":key} orderBy:nil];
    if(_timeLimit){
        if([self timeOutCheck:cache]){
            return nil;
        }
    }
    if(cache&&cache.cacheType==HBHttpCacheDataTypeImage){          
        NSFileManager * manager=[NSFileManager defaultManager];
        if(![manager fileExistsAtPath:cache.cacheData]){
            [_dbHelper deleteToDB:cache];
            return nil;   
        }
        UIImage *image=[UIImage imageWithContentsOfFile:cache.cacheData];
        if(image==nil){
            [_dbHelper deleteToDB:cache];
            [manager removeItemAtPath:cache.cacheData error:nil];
            return nil;
        }
        return image;
    }
    return nil;
}
-(void)getBitmap:(NSString*)key  complete:(void(^)(UIImage *))complete
{
    UIImage * image=[self getBitmapFromMemory:key];
    if(image)
        complete(image);
    else{
        [self getBitmapFromDisk:key complete:^(UIImage * image){
            if(image){
               [self storeBitmapToMemory:image withKey:key];
            }
            if(complete){
                complete(image);
            }
        }];
    }    
}
-(void) clearMemoryCache
{
    [_memoryCache removeAllObjects];
}
-(void) clearDiskCache
{
    NSFileManager * manager=[NSFileManager defaultManager];
    if([manager fileExistsAtPath:_cacheFilePath]){
        [manager removeItemAtPath:_cacheFilePath error:NULL];
        [manager createDirectoryAtPath:_cacheFilePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}
-(void)setDirectoryAtPath:(NSString*) path
{
    _cacheFilePath=path;
    NSFileManager * manager=[NSFileManager defaultManager];
    if(![manager fileExistsAtPath:_cacheFilePath])
        [manager createDirectoryAtPath:_cacheFilePath withIntermediateDirectories:YES attributes:nil error:NULL];
}
@end
