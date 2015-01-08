
#import <Cocoa/Cocoa.h>
#import "GWImageSlicer.h"

@interface GWNinePartImage : NSImage {
	BOOL _vertical;
	BOOL _isFlipped;
}
+ (NSArray *) sliceImageForDrawNine:(NSImage *) sourceImage cornerRectSize:(NSSize) cornerRectSize;
+ (instancetype) ninePartImageNamed:(NSString *) imageName;
+ (instancetype) ninePartImageNamed:(NSString *) imageName isFlipped:(BOOL) isFlipped;
+ (instancetype) ninePartImageNamed:(NSString *) imageName cornerSize:(NSSize) cornerSize;
+ (instancetype) ninePartImageNamed:(NSString *) imageName cornerSize:(NSSize) cornerSize isFlipped:(BOOL) isFlipped;
+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage;
+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage isFlipped:(BOOL) isFlipped;
+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage cornerSize:(NSSize) cornerSize;
+ (instancetype) ninePartImageFromSourceImage:(NSImage *) sourceImage cornerSize:(NSSize) cornerSize isFlipped:(BOOL) isFlipped;
@property NSArray * slices;
- (void) setIsFlipped:(BOOL) isFlipped;
@end
