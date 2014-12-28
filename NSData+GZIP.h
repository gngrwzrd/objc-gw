
#import <Foundation/Foundation.h>

@interface NSData (GZIP)

//level is either -1 for default compression level, or 0 - 9. 0 = no compression, 9 = best compression.
- (NSData *) gzippedDataWithCompressionLevel:(int)level;

//save as calling gzippedDataWithCompressionLevel -1.
- (NSData *) gzippedData;
- (NSData *) gunzippedData;

@end
