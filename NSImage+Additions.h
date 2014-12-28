
#import <Cocoa/Cocoa.h>

@interface NSImage (Additions)
+ (NSImage *) imageWithData:(NSData *) data;
- (NSData *) PNGRepresentationWithOptions:(NSDictionary *) options;
- (NSData *) JPEGRepresentationWithOptions:(NSDictionary *) options;
@end
