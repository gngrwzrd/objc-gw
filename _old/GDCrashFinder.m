
#import "GDCrashFinder.h"

@implementation GDCrashFinder

+ (NSString * ) getLatestCrashReportForApplication:(NSString *) anAppName {
	NSMutableArray * searchPaths = [NSMutableArray array];
	NSMutableArray * allFiles = [NSMutableArray array];
	[searchPaths addObject:[@"~/Library/Logs/CrashReporter/" stringByExpandingTildeInPath]];
	[searchPaths addObject:[@"~/Library/Logs/DiagnosticReports/" stringByExpandingTildeInPath]];
	[searchPaths addObject:@"/Library/Logs/CrashReporter/"];
	[searchPaths addObject:@"/Library/Logs/DiagnosticReports/"];
	NSFileManager * fman = [NSFileManager defaultManager];
	NSString * file, * path, * fullPath;
	NSArray * files;
	NSDate * modDate;
	NSDictionary * attributes;
	for(path in searchPaths) {
		files = [fman contentsOfDirectoryAtPath:path error:nil];
		if(files and [files count]>0) {
			for(file in files) {
				if([file hasPrefix:anAppName]) {
					fullPath = [path stringByAppendingPathComponent:file];
					attributes = [fman attributesOfItemAtPath:fullPath error:nil];
					if(!attributes) continue;
					modDate = [attributes valueForKey:NSFileModificationDate];
					[allFiles addObject:[NSDictionary dictionaryWithObjectsAndKeys:fullPath,@"path",modDate,@"modDate",nil]];
				}
			}
		}
	}
	if([allFiles count] < 1) {
		return nil;
	}
	NSSortDescriptor * dateSortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"modDate" ascending:true];
	NSArray * sortedFiles = [allFiles sortedArrayUsingDescriptors:[NSArray arrayWithObject:dateSortDescriptor]];
	NSString * crashFile = [[[sortedFiles lastObject] objectForKey:@"path"] copy];
	[dateSortDescriptor release];
	return [crashFile autorelease];
}

@end
