
#import <Foundation/Foundation.h>

//Category additions to NSObject.
@interface NSObject (GWAdditions)

//Performs the selector only if the object responds to it.
- (id) gw_ifRespondsPerformSelector:(SEL) selector;

//Performs the selector with an object only if the object responds to it.
- (id) gw_ifRespondsPerformSelector:(SEL) selector withObject:(id) object;

@end
