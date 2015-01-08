//
//  NSDate+GWAdditions.m
//  deepfreeze.io
//
//  Created by Aaron Smith on 7/8/14.
//  Copyright (c) 2014 Long Access. All rights reserved.
//

#import "NSDate+GWAdditions.h"

@implementation NSDate (GWAdditions)

-(NSDate *) toLocalTime {
	NSTimeZone *tz = [NSTimeZone defaultTimeZone];
	NSInteger seconds = [tz secondsFromGMTForDate: self];
	return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

-(NSDate *) toGlobalTime {
	NSTimeZone *tz = [NSTimeZone defaultTimeZone];
	NSInteger seconds = -[tz secondsFromGMTForDate: self];
	return [NSDate dateWithTimeInterval: seconds sinceDate: self];
}

@end
