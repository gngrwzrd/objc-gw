
#import <Foundation/Foundation.h>

@interface NSData (GZIP)

- (NSData *)gzippedDataWithCompressionLevel:(int)level;
- (NSData *)gzippedData;
- (NSData *)gunzippedData;

@end
