
#import "NSCoding+Additions.h"

const char * property_getTypeString(objc_property_t property) {
	const char * attrs = property_getAttributes(property);
	if(attrs == NULL) return NULL;
	static char buffer[256];
	const char * e = strchr(attrs,',');
	if (e == NULL) return NULL;
	int len = (int)(e-attrs);
	memcpy(buffer,attrs,len);
	buffer[len] = '\0';
	return buffer;
}

@implementation NSKeyedArchiver (Additions)

- (void) encodeEntireObject:(NSObject <NSCodingKeys> *) instance; {
	[self encodeArchiveKeys:instance];
}

- (void) encodeArchiveKeys:(NSObject <NSCodingKeys> *) instance; {
	NSArray * keys = [instance archiveKeys];
	for(NSString * key in keys) {
		id val = [instance valueForKey:key];
		NSLog(@"encode key: %@, val: %@",key,val);
		[self encodeObject:val forKey:key];
	}
}

- (void) encodeArchiveKeysByPropertyTypes:(NSObject <NSCodingKeys> *) instance {
	NSArray * keys = [instance archiveKeys];
	for(NSString * key in keys) {
		objc_property_t property = class_getProperty([instance class],[key UTF8String]);
		if(property == NULL) {
			NSLog(@"key: %@ not able to archive",key);
			continue;
		}
		__unused const char * type = property_getTypeString(property);
		id value = [instance valueForKey:key];
		[self encodeObject:value forKey:key];
	}
}

@end

@implementation NSKeyedUnarchiver (Additions)

- (void) decodeEntireObject:(NSObject<NSCodingKeys> *) instance {
	[self decodeArchiveKeys:instance];
}

- (void) decodeArchiveKeys:(NSObject <NSCodingKeys> *) instance; {
	NSArray * keys = [instance archiveKeys];
	for(NSString * key in keys) {
		id value = [self decodeObjectForKey:key];
		NSLog(@"decode key: %@, value: %@",key,value);
		[instance setValue:value forKey:key];
	}
}

- (void) decodeArchiveKeysByPropertyTypes:(NSObject <NSCodingKeys> *) instance {
	NSArray * keys = [instance archiveKeys];
	for(NSString * key in keys) {
		objc_property_t property = class_getProperty([instance class],[key UTF8String]);
		if(property == NULL) {
			NSLog(@"key: %@ not able to archive",key);
			continue;
		}
		__unused const char * type = property_getTypeString(property);
		id value = [self decodeObjectForKey:key];
		[instance setValue:value forKey:key];
	}
}

@end
