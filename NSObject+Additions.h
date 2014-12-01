
#import <Foundation/Foundation.h>

@interface NSObject (Additions)
- (void) performSelectorIfResponds:(SEL) selector;
- (void) performSelectorIfResponds:(SEL) selector withObject:(id) object;
- (void) performSelectorIfConforms:(Protocol *) protocol andResponds:(SEL) selector;
- (void) performSelectorIfConforms:(Protocol *) protocol andResponds:(SEL) selector withObject:(id) object;
@end
