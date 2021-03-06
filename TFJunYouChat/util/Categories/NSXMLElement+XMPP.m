#import "NSXMLElement+XMPP.h"
#import "NSNumber+XMPP.h"
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif
@implementation NSXMLElement (XMPP)
+ (NSXMLElement *)elementWithName:(NSString *)name numberValue:(NSNumber *)number
{
    return [self elementWithName:name stringValue:[number stringValue]];
}
- (id)initWithName:(NSString *)name numberValue:(NSNumber *)number
{
    return [self initWithName:name stringValue:[number stringValue]];
}
+ (NSXMLElement *)elementWithName:(NSString *)name objectValue:(id)objectValue
{
    if([objectValue isKindOfClass:[NSString class]])
    {
        return [self elementWithName:name stringValue:objectValue];
    }
    else if([objectValue isKindOfClass:[NSNumber class]])
    {
        return [self elementWithName:name numberValue:objectValue];
    }
    else if([objectValue respondsToSelector:@selector(stringValue)])
    {
        return [self elementWithName:name stringValue:[objectValue stringValue]];
    }
    else
    {
        return [self elementWithName:name];
    }
}
- (id)initWithName:(NSString *)name objectValue:(id)objectValue
{
    if([objectValue isKindOfClass:[NSString class]])
    {
        return [self initWithName:name stringValue:objectValue];
    }
    else if([objectValue isKindOfClass:[NSNumber class]])
    {
        return [self initWithName:name numberValue:objectValue];
    }
    else if([objectValue respondsToSelector:@selector(stringValue)])
    {
        return [self initWithName:name stringValue:[objectValue stringValue]];
    }
    else
    {
        return [self initWithName:name];
    }
}
+ (NSXMLElement *)elementWithName:(NSString *)name xmlns:(NSString *)ns
{
	NSXMLElement *element = [NSXMLElement elementWithName:name];
	[element setXmlns:ns];
	return element;
}
- (id)initWithName:(NSString *)name xmlns:(NSString *)ns
{
	if ((self = [self initWithName:name]))
	{
		[self setXmlns:ns];
	}
	return self;
}
- (NSArray *)elementsForXmlns:(NSString *)ns
{
	NSMutableArray *elements = [NSMutableArray array];
	for (NSXMLNode *node in [self children])
	{
		if ([node isKindOfClass:[NSXMLElement class]])
		{
			NSXMLElement *element = (NSXMLElement *)node;
			if ([[element xmlns] isEqual:ns])
			{
				[elements addObject:element];
			}
		}
	}
	return elements;
}
- (NSArray *)elementsForXmlnsPrefix:(NSString *)nsPrefix
{
    NSMutableArray *elements = [NSMutableArray array];
	for (NSXMLNode *node in [self children])
	{
		if ([node isKindOfClass:[NSXMLElement class]])
		{
			NSXMLElement *element = (NSXMLElement *)node;
			if ([[element xmlns] hasPrefix:nsPrefix])
			{
				[elements addObject:element];
			}
		}
	}
	return elements;
}
- (NSXMLElement *)elementForName:(NSString *)name
{
	NSArray *elements = [self elementsForName:name];
	if ([elements count] > 0)
	{
		return elements[0];
	}
	else
	{
		return nil;
	}
}
- (NSXMLElement *)elementForName:(NSString *)name xmlns:(NSString *)xmlns
{
	NSArray *elements = [self elementsForLocalName:name URI:xmlns];
	if ([elements count] > 0)
	{
		return elements[0];
	}
	else
	{
		return nil;
	}
}
- (NSXMLElement *)elementForName:(NSString *)name xmlnsPrefix:(NSString *)xmlnsPrefix{
    NSXMLElement *result = nil;
	for (NSXMLNode *node in [self children])
	{
		if ([node isKindOfClass:[NSXMLElement class]])
		{
			NSXMLElement *element = (NSXMLElement *)node;
			if ([[element name] isEqualToString:name] && [[element xmlns] hasPrefix:xmlnsPrefix])
			{
				result = element;
                break;
			}
		}
	}
	return result;
}
- (void)removeElementForName:(NSString *)name
{
    NSXMLElement *element = [self elementForName:name];
    if(element)
    {
        [self removeChildAtIndex:[[self children] indexOfObject:element]];
    }
}
- (void)removeElementsForName:(NSString *)name
{
    NSArray *elements = [self elementsForName:name];
    for(NSXMLElement *element in elements)
    {
        [self removeChildAtIndex:[[self children] indexOfObject:element]];
    }
}
- (void)removeElementForName:(NSString *)name xmlns:(NSString *)xmlns
{
    NSXMLElement *element = [self elementForName:name xmlns:xmlns];
    if(element)
    {
        [self removeChildAtIndex:[[self children] indexOfObject:element]];
    }
}
- (void)removeElementForName:(NSString *)name xmlnsPrefix:(NSString *)xmlnsPrefix
{
    NSXMLElement *element = [self elementForName:name xmlnsPrefix:xmlnsPrefix];
    if(element)
    {
        [self removeChildAtIndex:[[self children] indexOfObject:element]];
    }
}
- (NSString *)xmlns
{
	return [[self namespaceForPrefix:@""] stringValue];
}
- (void)setXmlns:(NSString *)ns
{
	[self addNamespace:[NSXMLNode namespaceWithName:@"" stringValue:ns]];
}
- (NSString *)prettyXMLString
{
	return [self XMLStringWithOptions:(NSXMLNodePrettyPrint | NSXMLNodeCompactEmptyElement)];
}
- (NSString *)compactXMLString
{
    return [self XMLStringWithOptions:NSXMLNodeCompactEmptyElement];
}
- (void)addAttributeWithName:(NSString *)name intValue:(int)intValue
{
  [self addAttributeWithName:name numberValue:@(intValue)];
}
- (void)addAttributeWithName:(NSString *)name boolValue:(BOOL)boolValue
{
  [self addAttributeWithName:name numberValue:@(boolValue)];
}
- (void)addAttributeWithName:(NSString *)name floatValue:(float)floatValue
{
  [self addAttributeWithName:name numberValue:@(floatValue)];
}
- (void)addAttributeWithName:(NSString *)name doubleValue:(double)doubleValue
{
  [self addAttributeWithName:name numberValue:@(doubleValue)];
}
- (void)addAttributeWithName:(NSString *)name integerValue:(NSInteger)integerValue
{
  [self addAttributeWithName:name numberValue:@(integerValue)];
}
- (void)addAttributeWithName:(NSString *)name unsignedIntegerValue:(NSUInteger)unsignedIntegerValue
{
  [self addAttributeWithName:name numberValue:@(unsignedIntegerValue)];
}
- (void)addAttributeWithName:(NSString *)name stringValue:(NSString *)string
{
	[self addAttribute:[NSXMLNode attributeWithName:name stringValue:string]];
}
- (void)addAttributeWithName:(NSString *)name numberValue:(NSNumber *)number
{
    [self addAttributeWithName:name stringValue:[number stringValue]];
}
- (void)addAttributeWithName:(NSString *)name objectValue:(id)objectValue
{
    if([objectValue isKindOfClass:[NSString class]])
    {
        [self addAttributeWithName:name stringValue:objectValue];
    }
    else if([objectValue isKindOfClass:[NSNumber class]])
    {
        [self addAttributeWithName:name numberValue:objectValue];
    }
    else if([objectValue respondsToSelector:@selector(stringValue)])
    {
        [self addAttributeWithName:name stringValue:[objectValue stringValue]];
    }
}
- (int)attributeIntValueForName:(NSString *)name
{
	return [[self attributeStringValueForName:name] intValue];
}
- (BOOL)attributeBoolValueForName:(NSString *)name
{
    NSString *attributeStringValueForName = [self attributeStringValueForName:name];
    BOOL result = NO;
    if ([attributeStringValueForName isEqualToString:@"true"] || [attributeStringValueForName isEqualToString:@"1"])
    {
        result = YES;
    }
    else if([attributeStringValueForName isEqualToString:@"false"] || [attributeStringValueForName isEqualToString:@"0"])
    {
        result = NO;
    }
    else
    {
        result = [attributeStringValueForName boolValue];
    }
    return result;
}
- (float)attributeFloatValueForName:(NSString *)name
{
	return [[self attributeStringValueForName:name] floatValue];
}
- (double)attributeDoubleValueForName:(NSString *)name
{
	return [[self attributeStringValueForName:name] doubleValue];
}
- (int32_t)attributeInt32ValueForName:(NSString *)name
{
	int32_t result = 0;
	[NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoInt32:&result];
	return result;
}
- (uint32_t)attributeUInt32ValueForName:(NSString *)name
{
	uint32_t result = 0;
	[NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoUInt32:&result];
	return result;
}
- (int64_t)attributeInt64ValueForName:(NSString *)name
{
	int64_t result;
	[NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoInt64:&result];
	return result;
}
- (uint64_t)attributeUInt64ValueForName:(NSString *)name
{
	uint64_t result;
	[NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoUInt64:&result];
	return result;
}
- (NSInteger)attributeIntegerValueForName:(NSString *)name
{
	NSInteger result;
	[NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoNSInteger:&result];
	return result;
}
- (NSUInteger)attributeUnsignedIntegerValueForName:(NSString *)name
{
	NSUInteger result = 0;
	[NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoNSUInteger:&result];
	return result;
}
- (NSString *)attributeStringValueForName:(NSString *)name
{
	return [[self attributeForName:name] stringValue];
}
- (NSNumber *)attributeNumberIntValueForName:(NSString *)name
{
	return @([self attributeIntValueForName:name]);
}
- (NSNumber *)attributeNumberBoolValueForName:(NSString *)name
{
	return @([self attributeBoolValueForName:name]);
}
- (NSNumber *)attributeNumberFloatValueForName:(NSString *)name
{
	return @([self attributeFloatValueForName:name]);
}
- (NSNumber *)attributeNumberDoubleValueForName:(NSString *)name
{
	return @([self attributeDoubleValueForName:name]);
}
- (NSNumber *)attributeNumberInt32ValueForName:(NSString *)name
{
	return @([self attributeInt32ValueForName:name]);
}
- (NSNumber *)attributeNumberUInt32ValueForName:(NSString *)name
{
	return @([self attributeUInt32ValueForName:name]);
}
- (NSNumber *)attributeNumberInt64ValueForName:(NSString *)name
{
	return @([self attributeInt64ValueForName:name]);
}
- (NSNumber *)attributeNumberUInt64ValueForName:(NSString *)name
{
	return @([self attributeUInt64ValueForName:name]);
}
- (NSNumber *)attributeNumberIntegerValueForName:(NSString *)name
{
	return @([self attributeIntegerValueForName:name]);
}
- (NSNumber *)attributeNumberUnsignedIntegerValueForName:(NSString *)name
{
	return @([self attributeUnsignedIntegerValueForName:name]);
}
- (int)attributeIntValueForName:(NSString *)name withDefaultValue:(int)defaultValue
{
	NSXMLNode *attr = [self attributeForName:name];
	return (attr) ? [[attr stringValue] intValue] : defaultValue;
}
- (BOOL)attributeBoolValueForName:(NSString *)name withDefaultValue:(BOOL)defaultValue
{
	NSXMLNode *attr = [self attributeForName:name];
	return (attr) ? [[attr stringValue] boolValue] : defaultValue;
}
- (float)attributeFloatValueForName:(NSString *)name withDefaultValue:(float)defaultValue
{
	NSXMLNode *attr = [self attributeForName:name];
	return (attr) ? [[attr stringValue] floatValue] : defaultValue;
}
- (double)attributeDoubleValueForName:(NSString *)name withDefaultValue:(double)defaultValue
{
	NSXMLNode *attr = [self attributeForName:name];
	return (attr) ? [[attr stringValue] doubleValue] : defaultValue;
}
- (int32_t)attributeInt32ValueForName:(NSString *)name withDefaultValue:(int32_t)defaultValue
{
	int32_t result = 0;
	if ([NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoInt32:&result])
		return result;
	else
		return defaultValue;
}
- (uint32_t)attributeUInt32ValueForName:(NSString *)name withDefaultValue:(uint32_t)defaultValue
{
	uint32_t result = 0;
	if ([NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoUInt32:&result])
		return result;
	else
		return defaultValue;
}
- (int64_t)attributeInt64ValueForName:(NSString *)name withDefaultValue:(int64_t)defaultValue
{
	int64_t result = 0;
	if ([NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoInt64:&result])
		return result;
	else
		return defaultValue;
}
- (uint64_t)attributeUInt64ValueForName:(NSString *)name withDefaultValue:(uint64_t)defaultValue
{
	uint64_t result = 0;
	if ([NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoUInt64:&result])
		return result;
	else
		return defaultValue;
}
- (NSInteger)attributeIntegerValueForName:(NSString *)name withDefaultValue:(NSInteger)defaultValue
{
	NSInteger result = 0;
	if ([NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoNSInteger:&result])
		return result;
	else
		return defaultValue;
}
- (NSUInteger)attributeUnsignedIntegerValueForName:(NSString *)name withDefaultValue:(NSUInteger)defaultValue
{
	NSUInteger result = 0;
	if ([NSNumber xmpp_parseString:[self attributeStringValueForName:name] intoNSUInteger:&result])
		return result;
	else
		return defaultValue;
}
- (NSString *)attributeStringValueForName:(NSString *)name withDefaultValue:(NSString *)defaultValue
{
    NSXMLNode *attr = [self attributeForName:name];
    return (attr) ? [attr stringValue] : defaultValue;
}
- (NSNumber *)attributeNumberIntValueForName:(NSString *)name withDefaultValue:(int)defaultValue
{
	return @([self attributeIntValueForName:name withDefaultValue:defaultValue]);
}
- (NSNumber *)attributeNumberBoolValueForName:(NSString *)name withDefaultValue:(BOOL)defaultValue
{
	return @([self attributeBoolValueForName:name withDefaultValue:defaultValue]);
}
- (NSMutableDictionary *)attributesAsDictionary
{
	NSArray *attributes = [self attributes];
	NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:[attributes count]];
	NSUInteger i;
	for(i = 0; i < [attributes count]; i++)
	{
		NSXMLNode *node = attributes[i];
		result[[node name]] = [node stringValue];
	}
	return result;
}
- (int)stringValueAsInt
{
	return [[self stringValue] intValue];
}
- (BOOL)stringValueAsBool
{
	return [[self stringValue] boolValue];
}
- (float)stringValueAsFloat
{
	return [[self stringValue] floatValue];
}
- (double)stringValueAsDouble
{
	return [[self stringValue] doubleValue];
}
- (int32_t)stringValueAsInt32
{
	int32_t result;
	if ([NSNumber xmpp_parseString:[self stringValue] intoInt32:&result])
		return result;
	else
		return 0;
}
- (uint32_t)stringValueAsUInt32
{
	uint32_t result;
	if ([NSNumber xmpp_parseString:[self stringValue] intoUInt32:&result])
		return result;
	else
		return 0;
}
- (int64_t)stringValueAsInt64
{
	int64_t result = 0;
	if ([NSNumber xmpp_parseString:[self stringValue] intoInt64:&result])
		return result;
	else
		return 0;
}
- (uint64_t)stringValueAsUInt64
{
	uint64_t result = 0;
	if ([NSNumber xmpp_parseString:[self stringValue] intoUInt64:&result])
		return result;
	else
		return 0;
}
- (NSInteger)stringValueAsNSInteger
{
	NSInteger result = 0;
	if ([NSNumber xmpp_parseString:[self stringValue] intoNSInteger:&result])
		return result;
	else
		return 0;
}
- (NSUInteger)stringValueAsNSUInteger
{
	NSUInteger result = 0;
	if ([NSNumber xmpp_parseString:[self stringValue] intoNSUInteger:&result])
		return result;
	else
		return 0;
}
- (void)addNamespaceWithPrefix:(NSString *)prefix stringValue:(NSString *)string
{
	[self addNamespace:[NSXMLNode namespaceWithName:prefix stringValue:string]];
}
- (NSString *)namespaceStringValueForPrefix:(NSString *)prefix
{
	return [[self namespaceForPrefix:prefix] stringValue];
}
- (NSString *)namespaceStringValueForPrefix:(NSString *)prefix withDefaultValue:(NSString *)defaultValue
{
	NSXMLNode *namespace = [self namespaceForPrefix:prefix];
	return (namespace) ? [namespace stringValue] : defaultValue;
}
@end
