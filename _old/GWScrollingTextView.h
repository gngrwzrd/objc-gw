
#import <Cocoa/Cocoa.h>

@interface GWScrollingTextView : NSView
@property (nonatomic) NSAttributedString * attributedText;
@property (nonatomic) NSTimeInterval speed;
- (void) startScrolling;
- (void) stopScrolling;
@end
