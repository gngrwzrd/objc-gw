
#import <Cocoa/Cocoa.h>

/**
 * @file GDCrashReporterDelegate.h
 *
 * Header file for GDCrashReporterDelegate.
 */

/**
 * Optional protocol for GDCrashReporter.
 */
@interface NSObject (GDCrashReporterDelegate)

/**
 * When the crash reporter's "cancel" button is pressed.
 */
- (void) crashReporterDidCancel:(id) sender;

/**
 * When the crash reporter's "send" button is pressed.
 */
- (void) crashReporterDidSend:(id) sender;

/**
 * When the send operation completes.
 */
- (void) crashReporterDidFinish:(id) sender;

@end

/**
 * @protocol GDCrashReporterDelegate
 *
 * The GDCrashReporterDelegate is a protocol your delegate can implement.
 */
@protocol GDCrashReporterDelegate <NSObject>
@end
