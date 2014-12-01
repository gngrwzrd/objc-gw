
#import <Cocoa/Cocoa.h>

@interface SoundHelper : NSObject

+ (void) playSoundNamed:(NSString *) soundName;
+ (void) playSoundNamed:(NSString *) soundName atVolume:(CGFloat) volume;
+ (void) glass;
+ (void) glassAtVolume:(CGFloat) volume;
+ (void) pop;
+ (void) popAtVolume:(CGFloat) volume;

@end
