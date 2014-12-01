
#import <Cocoa/Cocoa.h>

@interface NSView (AutoLayout)

- (void) removeConstraintsWithFirstAttribute:(NSLayoutAttribute) attribute;
- (void) removeConstraintsWithSecondAttribute:(NSLayoutAttribute) attribute;
- (void) removeConstraintsWithFirstAttribute:(NSLayoutAttribute) firstAttribute secondAttribute:(NSLayoutAttribute) secondAttribute;
- (void) alignEdgeByConstraint:(NSLayoutAttribute) edge toView:(NSView *) view;
- (void) alignEdgeByConstraint:(NSLayoutAttribute) edge toView:(NSView *) view atOffset:(CGFloat) offset;
- (void) setWidthByConstraint:(CGFloat) width;
- (void) setHeightByConstraint:(CGFloat) height;
- (void) centerHorizonalByConstraintInView:(NSView *) view;
- (void) centerVerticalByConstraintInView:(NSView *) view;
- (void) matchHeightByConstraintToView:(NSView *) view;
- (void) matchWidthByConstraintToView:(NSView *) view;

@end
