
#import "SoundHelper.h"

@implementation SoundHelper

+ (void) playSoundNamed:(NSString *) soundName {
	[[NSSound soundNamed:soundName] play];
}

+ (void) playSoundNamed:(NSString *) soundName atVolume:(CGFloat) volume; {
	NSSound * sound = [NSSound soundNamed:soundName];
	sound.volume = volume;
	[sound play];
}

+ (void) glass; {
	[self playSoundNamed:@"glass"];
}

+ (void) glassAtVolume:(CGFloat) volume; {
	[self playSoundNamed:@"glass" atVolume:volume];
}

+ (void) pop; {
	[self playSoundNamed:@"pop"];
}

+ (void) popAtVolume:(CGFloat) volume; {
	[self playSoundNamed:@"pop" atVolume:volume];
}

@end
