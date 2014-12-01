
#import <Cocoa/Cocoa.h>
#import "macros.h"
#import "GDCrashReporterDelegate.h"
#import "NSFileHandle+Additions.h"

/**
 * @file GDCrashReporter.h
 * 
 * Header file for GDCrashReporter.
 */

/**
 * The GDCrashReporter is a controller that implements post-trauma-pre-usage
 * crash reporting.
 */
@interface GDCrashReporter : NSObject {
	
	/**
	 * Whether or not a crash is available.
	 */
	BOOL hasCrash;
	
	/**
	 * Whether or not the crash reporter should delete the crash report after it's been reported.
	 */
	BOOL deleteCrashReport;
	
	/**
	 * Delegate for crash reporter hooks.
	 */
	id <GDCrashReporterDelegate> delegate;
	
	/**
	 * Placeholder string for the comments field.
	 */
	NSString * placeHolderComm;
	
	/**
	 * The crash file that is being reported.
	 */
	NSString * crashFile;
	
	/**
	 * Python binary location used if the crash reporter is sending
	 * the crash through email.
	 */
	NSString * pythonBinLocation;
	
	/**
	 * Python send file script location. This file is searched for
	 * in the GDKit.framework bundle.
	 */
	NSString * pythonSendFileScriptLocation;
	
	/**
	 * The user defaults prefix to use which records information
	 * about the last crash report that was reported.
	 */
	NSString * userDefaultsPrefix;
	
	/**
	 * The crash reporter window title.
	 */
	NSString * windowTitle;
	
	/**
	 * The crash message title.
	 */
	NSString * crashMessage;
	
	/**
	 * The company name for your software.
	 */
	NSString * companyName;
	
	/**
	 * Task used when sending the crash report.
	 */
	NSTask * task;
	
	/**
	 * Crash file search paths - there are some defaults used.
	 */
	NSMutableArray * searchPaths;
	
	/**
	 * Nib reference to the window.
	 */
	IBOutlet NSWindow * window;
	
	/**
	 * Nib outlet to the send button.
	 */
	IBOutlet NSButton * send;
	
	/**
	 * Nib outlet to the cancel button.
	 */
	IBOutlet NSButton * cancel;
	
	/**
	 * Nib outlet to the comments field.
	 */
	IBOutlet NSTextView * comments;
	
	/**
	 * Nib outlet to the details field.
	 */
	IBOutlet NSTextView * details;
	
	/**
	 * Nib outlet to the message field.
	 */
	IBOutlet NSTextField * message;
}

/**
 * The delegate for this crash reporter.
 */
@property (retain,nonatomic) id delegate;

/**
 * A user defaults key prefix. This is used when saving the last
 * crash found so that it's only reported once.
 */
@property (copy,nonatomic) NSString * userDefaultsPrefix;

/**
 * The python binary location (default is /usr/bin/python).
 */
@property (copy,nonatomic) NSString * pythonBinLocation;

/**
 * The python sendcrashreport.pyc file location. Default is
 * taken from getting a resource path from NSBundle.
 */
@property (copy,nonatomic) NSString * pythonSendFileScriptLocation;

/**
 * Whether or not a crash report is available.
 */
@property (readonly,nonatomic) BOOL hasCrash;

/**
 * The window title to use for the nib.
 */
@property (copy,nonatomic) NSString * windowTitle;

/**
 * The crash message to display in the window.
 */
@property (copy,nonatomic) NSString * crashMessage;

/**
 * The company name to display (if crashMessage is not used).
 */
@property (copy,nonatomic) NSString * companyName;

/**
 * Whether or not the crash report should be deleted after it's reported.
 */
@property (assign,nonatomic) BOOL deleteCrashReport;

/**
 * [Designated initializer] Inititlize this crash reporter with
 * a user defaults prefix.
 */
- (id) initWithUserDefaultsPrefix:(NSString *) _prefix;

/**
 * [internal] The application name.
 */
- (NSString *) applicationName;

/**
 * Add a crash report (core dump) file search path.
 */
- (void) addCrashSearchPath:(NSString *) _searchPath;

/**
 * IBAction for a cancel button.
 */
- (IBAction) oncancel:(id) sender;

/**
 * Force crash any app that is using this crash reporter (for testing).
 */
- (void) forceCrash;

/**
 * [internal] Initializes default search paths.
 */
- (void) initSearchPaths;

/**
 * [internal] Initializes UI components from the nib.
 */
- (void) initUI;

/**
 * [internal];
 */
- (void) performCrashReporterDidFinishOnDelegate;

/**
 * [internal];
 */
- (void) performCrashReporterDidSendOnDelegate;

/**
 * [internal];
 */
- (void) performCrashReporterDidCancelOnDelegate;

/**
 * IBAction for a send button.
 */
- (IBAction) onsend:(id) sender;

/**
 * [internal] Searches for crash reports and finds the latest one.
 */
- (void) searchForCrashReports;

/**
 * [internal] Used to delete a crash report.
 */
- (void) _deleteCrashReport;

/**
 * Shows the crash report nib.
 */
- (BOOL) show;


@end
