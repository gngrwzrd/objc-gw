
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
	[self playSoundNamed:@"Glass"];
}

+ (void) glassAtVolume:(CGFloat) volume; {
	[self playSoundNamed:@"Glass" atVolume:volume];
}

+ (void) pop; {
	[self playSoundNamed:@"Pop"];
}

+ (void) popAtVolume:(CGFloat) volume; {
	[self playSoundNamed:@"Pop" atVolume:volume];
}

@end
