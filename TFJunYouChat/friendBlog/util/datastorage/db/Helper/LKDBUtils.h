#import <Foundation/Foundation.h>
@interface LKDBUtils:NSObject
+(NSString*) getDocumentPath;
+(NSString*) getDirectoryForDocuments:(NSString*) dir;
+(NSString*) getPathForDocuments:(NSString*)filename;
+(NSString*) getPathForDocuments:(NSString *)filename inDir:(NSString*)dir;
+(BOOL) isFileExists:(NSString*)filepath;
+(BOOL)deleteWithFilepath:(NSString*)filepath;
+(NSArray*)getFilenamesWithDir:(NSString*)dir;
+(BOOL)checkStringIsEmpty:(NSString *)string;
+(NSString*)stringWithDate:(NSDate*)date;
+(NSDate *)dateWithString:(NSString *)str;
@end
