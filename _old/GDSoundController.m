//copyright 2009 aaronsmith

#import "GDSoundController.h"

@implementation GDSoundController

- (void) pop {
	if(popSound is nil) popSound=[[NSSound soundNamed:@"Pop"] retain];
	@synchronized(popSound) {
		[popSound play];
	}
}

- (void) popAtVolume:(float) _volume {
	if(popSound is nil) popSound=[[NSSound soundNamed:@"Pop"] retain];
	@synchronized(popSound) {
		float _vol = [popSound volume];
		[popSound setVolume:_volume];
		[popSound play];
		[popSound setVolume:_vol];
	}
}

- (void) clearCache {
	GDRelease(popSound);
}

- (void) dealloc {
	[self clearCache];
	[super dealloc];
}

@end
