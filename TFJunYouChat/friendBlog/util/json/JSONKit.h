#include <stddef.h>
#include <stdint.h>
#include <limits.h>
#include <TargetConditionals.h>
#include <AvailabilityMacros.h>
#ifdef    __OBJC__
#import <Foundation/NSArray.h>
#import <Foundation/NSData.h>
#import <Foundation/NSDictionary.h>
#import <Foundation/NSError.h>
#import <Foundation/NSObjCRuntime.h>
#import <Foundation/NSString.h>
#endif 
#ifdef __cplusplus
extern "C" {
#endif
#ifndef   NSINTEGER_DEFINED
#define   NSINTEGER_DEFINED
#if       defined(__LP64__) || defined(NS_BUILD_32_LIKE_64)
typedef long           NSInteger;
typedef unsigned long  NSUInteger;
#define NSIntegerMin   LONG_MIN
#define NSIntegerMax   LONG_MAX
#define NSUIntegerMax  ULONG_MAX
#else  
typedef int            NSInteger;
typedef unsigned int   NSUInteger;
#define NSIntegerMin   INT_MIN
#define NSIntegerMax   INT_MAX
#define NSUIntegerMax  UINT_MAX
#endif 
#endif 
#ifndef _JSONKIT_H_
#define _JSONKIT_H_
#if defined(__GNUC__) && (__GNUC__ >= 4) && defined(__APPLE_CC__) && (__APPLE_CC__ >= 5465)
#define JK_DEPRECATED_ATTRIBUTE __attribute__((deprecated))
#else
#define JK_DEPRECATED_ATTRIBUTE
#endif
#define JSONKIT_VERSION_MAJOR 1
#define JSONKIT_VERSION_MINOR 4
typedef NSUInteger JKFlags;
enum {
  JKParseOptionNone                     = 0,
  JKParseOptionStrict                   = 0,
  JKParseOptionComments                 = (1 << 0),
  JKParseOptionUnicodeNewlines          = (1 << 1),
  JKParseOptionLooseUnicode             = (1 << 2),
  JKParseOptionPermitTextAfterValidJSON = (1 << 3),
  JKParseOptionValidFlags               = (JKParseOptionComments | JKParseOptionUnicodeNewlines | JKParseOptionLooseUnicode | JKParseOptionPermitTextAfterValidJSON),
};
typedef JKFlags JKParseOptionFlags;
enum {
  JKSerializeOptionNone                 = 0,
  JKSerializeOptionPretty               = (1 << 0),
  JKSerializeOptionEscapeUnicode        = (1 << 1),
  JKSerializeOptionEscapeForwardSlashes = (1 << 4),
  JKSerializeOptionValidFlags           = (JKSerializeOptionPretty | JKSerializeOptionEscapeUnicode | JKSerializeOptionEscapeForwardSlashes),
};
typedef JKFlags JKSerializeOptionFlags;
#ifdef    __OBJC__
typedef struct JKParseState JKParseState; 
@interface JSONDecoder : NSObject {
  JKParseState *parseState;
}
+ (id)decoder;
+ (id)decoderWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
- (id)initWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
- (void)clearCache;
- (id)parseUTF8String:(const unsigned char *)string length:(size_t)length                         JK_DEPRECATED_ATTRIBUTE; 
- (id)parseUTF8String:(const unsigned char *)string length:(size_t)length error:(NSError **)error JK_DEPRECATED_ATTRIBUTE; 
- (id)parseJSONData:(NSData *)jsonData                                                            JK_DEPRECATED_ATTRIBUTE; 
- (id)parseJSONData:(NSData *)jsonData error:(NSError **)error                                    JK_DEPRECATED_ATTRIBUTE; 
- (id)objectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length;
- (id)objectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length error:(NSError **)error;
- (id)objectWithData:(NSData *)jsonData;
- (id)objectWithData:(NSData *)jsonData error:(NSError **)error;
- (id)mutableObjectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length;
- (id)mutableObjectWithUTF8String:(const unsigned char *)string length:(NSUInteger)length error:(NSError **)error;
- (id)mutableObjectWithData:(NSData *)jsonData;
- (id)mutableObjectWithData:(NSData *)jsonData error:(NSError **)error;
@end
#pragma mark Deserializing methods
@interface NSString (JSONKitDeserializing)
- (id)objectFromJSONString;
- (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
- (id)objectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
- (id)mutableObjectFromJSONString;
- (id)mutableObjectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
- (id)mutableObjectFromJSONStringWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end
@interface NSData (JSONKitDeserializing)
- (id)objectFromJSONData;
- (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
- (id)objectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
- (id)mutableObjectFromJSONData;
- (id)mutableObjectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags;
- (id)mutableObjectFromJSONDataWithParseOptions:(JKParseOptionFlags)parseOptionFlags error:(NSError **)error;
@end
#pragma mark Serializing methods
@interface NSString (JSONKitSerializing)
- (NSData *)JSONData;     
- (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions includeQuotes:(BOOL)includeQuotes error:(NSError **)error;
- (NSString *)JSONString; 
- (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions includeQuotes:(BOOL)includeQuotes error:(NSError **)error;
@end
@interface NSArray (JSONKitSerializing)
- (NSData *)JSONData;
- (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
- (NSString *)JSONString;
- (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
@end
@interface NSDictionary (JSONKitSerializing)
- (NSData *)JSONData;
- (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
- (NSString *)JSONString;
- (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions error:(NSError **)error;
- (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingDelegate:(id)delegate selector:(SEL)selector error:(NSError **)error;
@end
#ifdef __BLOCKS__
@interface NSArray (JSONKitSerializingBlockAdditions)
- (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
- (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
@end
@interface NSDictionary (JSONKitSerializingBlockAdditions)
- (NSData *)JSONDataWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
- (NSString *)JSONStringWithOptions:(JKSerializeOptionFlags)serializeOptions serializeUnsupportedClassesUsingBlock:(id(^)(id object))block error:(NSError **)error;
@end
#endif
#endif 
#endif 
#ifdef __cplusplus
}  
#endif
