
#import "NSColor+Additions.h"

@implementation NSColor (Additions)

- (NSString *) hexValue; {
	double redFloatValue, greenFloatValue, blueFloatValue;
	int redIntValue, greenIntValue, blueIntValue;
	NSString *redHexValue, *greenHexValue, *blueHexValue;
	NSColor * convertedColor = [self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	if(convertedColor) {
		[convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:NULL];
		redIntValue = redFloatValue*255.99999f;
		greenIntValue = greenFloatValue*255.99999f;
		blueIntValue = blueFloatValue*255.99999f;
		redHexValue = [NSString stringWithFormat:@"%02x", redIntValue];
		greenHexValue = [NSString stringWithFormat:@"%02x", greenIntValue];
		blueHexValue = [NSString stringWithFormat:@"%02x", blueIntValue];
		return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
	}
	return nil;
}

+ (NSColor *) colorWithHexColorString:(NSString *) hexColorString; {
	return [NSColor colorWithHexColorString:hexColorString alpha:1];
}

+ (NSColor *) colorWithHexColorString:(NSString *) hexColorString alpha:(CGFloat) alpha; {
	if(!hexColorString) {
		return [NSColor blackColor];
	}
	
	if([hexColorString hasPrefix:@"#"]) {
		hexColorString = [hexColorString substringWithRange:NSMakeRange(1,[hexColorString length]-1)];
	}
	
	unsigned int colorCode = 0;
	NSScanner * scanner = [NSScanner scannerWithString:hexColorString];
	[scanner scanHexInt:&colorCode];
	
	NSColor * result = [NSColor colorWithDeviceRed:((colorCode>>16)&0xFF)/255.0 green:((colorCode>>8)&0xFF)/255.0 blue:((colorCode)&0xFF)/255.0 alpha:1.0];
	return result;
}

@end
