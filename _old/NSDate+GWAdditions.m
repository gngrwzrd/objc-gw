
#import "NSDate+GWAdditions.h"

@implementation NSDate (GWAdditions)

+ (NSDate *) dateWithoutTime {
	return [[NSDate date] dateAsDateWithoutTime];
}

- (NSDate *) dateByAddingDays:(NSInteger) numDays {
	NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents * comps = [[NSDateComponents alloc] init];
	[comps setDay:numDays];
	NSDate * date = [gregorian dateByAddingComponents:comps toDate:self options:0];
	[comps release];
	[gregorian release];
	return date;
}

- (NSDate *) dateAsDateWithoutTime {
	NSString * formattedString = [self formattedDateString];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"MMM dd, yyyy"];
	NSDate *ret = [formatter dateFromString:formattedString];
	[formatter release];
	return ret;
}

- (NSString *) formattedDateString {
    return [self formattedStringUsingFormat:@"MMM dd, yyyy"];
}

- (NSString *) formattedStringUsingFormat:(NSString *) dateFormat {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:dateFormat];
	NSString *ret = [formatter stringFromDate:self];
	[formatter release];
	return ret;
}

- (NSInteger) differenceInDaysTo:(NSDate *) toDate {
	NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents * components = [gregorian components:NSDayCalendarUnit fromDate:self toDate:toDate options:0];
	NSInteger days = [components day];
	[gregorian release];
	return days;
}

- (NSInteger) differenceInDaysFrom:(NSDate *) fromDate {
	NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents * components = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:self options:0];
	NSInteger days = [components day];
	[gregorian release];
	return days;
}

@end
