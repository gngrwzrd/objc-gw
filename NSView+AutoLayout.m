
#import "NSView+AutoLayout.h"

@implementation NSView (AutoLayout)

- (void) removeConstraintsWithFirstAttribute:(NSLayoutAttribute) attribute; {
	NSMutableArray * remove = [NSMutableArray array];
	for(NSLayoutConstraint * constraint in self.constraints) {
		if(constraint.firstAttribute == attribute) {
			[remove addObject:constraint];
		}
	}
	if(remove.count > 0) {
		[self removeConstraints:remove];
	}
}

- (void) removeConstraintsWithSecondAttribute:(NSLayoutAttribute) attribute; {
	NSMutableArray * remove = [NSMutableArray array];
	for(NSLayoutConstraint * constraint in self.constraints) {
		if(constraint.secondAttribute == attribute) {
			[remove addObject:constraint];
		}
	}
	if(remove.count > 0) {
		[self removeConstraints:remove];
	}
}

- (void) removeConstraintsWithFirstAttribute:(NSLayoutAttribute) firstAttribute secondAttribute:(NSLayoutAttribute) secondAttribute; {
	NSMutableArray * remove = [NSMutableArray array];
	for(NSLayoutConstraint * constraint in self.constraints) {
		if(constraint.firstAttribute == firstAttribute && constraint.secondAttribute == secondAttribute) {
			[remove addObject:constraint];
		}
	}
	if(remove.count > 0) {
		[self removeConstraints:remove];
	}
}

- (void) alignEdgeByConstraint:(NSLayoutAttribute) edge toView:(NSView *) view; {
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:edge relatedBy:NSLayoutRelationEqual toItem:view attribute:edge multiplier:1 constant:0]];
}

- (void) alignEdgeByConstraint:(NSLayoutAttribute) edge toView:(NSView *) view atOffset:(CGFloat) offset; {
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:edge relatedBy:NSLayoutRelationEqual toItem:view attribute:edge multiplier:1 constant:offset]];
}

- (void) matchWidthByConstraintToView:(NSView *) view; {
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
}

- (void) matchHeightByConstraintToView:(NSView *) view {
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
}

- (void) setWidthByConstraint:(CGFloat) width {
	[self removeConstraintsWithFirstAttribute:NSLayoutAttributeWidth];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:width]];
}

- (void) setHeightByConstraint:(CGFloat) height; {
	[self removeConstraintsWithFirstAttribute:NSLayoutAttributeHeight];
	[self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height]];
}

- (void) centerHorizonalByConstraintInView:(NSView *) view; {
	[self removeConstraintsWithFirstAttribute:NSLayoutAttributeCenterX];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
}

- (void) centerVerticalByConstraintInView:(NSView *) view; {
	[self removeConstraintsWithFirstAttribute:NSLayoutAttributeCenterY];
	[view addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
}

@end
