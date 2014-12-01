
#import <Cocoa/Cocoa.h>

/**
 * This class is used inside of a commandline tool to connect to a GDCliProxy
 * and call methods that it exposes.
 *
 * Example usage:
 * #import "GDCliProxyConnector.m"
 * void main(int argc, char * argv[]) {
 *     GDCliProxyConnector * connector = [[[GDCliProxyConnector alloc] init];
 *     [connector setDistantProtocol:@protocol(MyProtocol)];
 *     
 *     //get the distant object. this will launch the application if the
 *     //connection is not available, and keep trying to connect.
 *     //it will attempt 50 connections.
 *     NSDistantObject * proxy = [connector getDistantObjectInApplication:@"com.mycompany.MyApplication" withConnectionName:@"cliConnection" andLaunchAppIfNotAvailable:true];
 *     
 *     //call a method on the distant object to do something
 *     //from within your application.
 *     [proxy myMethod];
 * }
 */
@interface CliProxyConnector : NSObject

/**
 * Get an NSDistantObject from a connection name. If the connection is
 * not available the application will be launched, and 50 connection attempt
 * will be made after it's launched or the distant object will be returned
 * if it's connected sooner. Returns nil after all attempts to connect to the
 * object have been exhausted.
 */
- (NSDistantObject *) getDistantObjectInApplication:(NSString *) bundleIdentifier withConnectionName:(NSString *) connectionName andLaunchAppIfNotAvailable:(BOOL) launch;

- (void) setDistantProtocol:(Protocol *) protocol;

@end
