
#import "NSControl+Additions.h"

@implementation NSControl (Additions)

//inspired from: [h]ttp://lapcatsoftware.com/blog/2007/11/25/working-without-a-nib-part-6-working-without-a-xib/
+ (void) initialize {
	[[[self class] superclass] initialize];
	Class NSControlClass = [NSControl class];
	Method oldInitWithCoder = class_getInstanceMethod(NSControlClass,@selector(initWithCoder:));
	Method newInitWithCoder = class_getInstanceMethod(NSControlClass,@selector(newInitWithCoder:));
	method_exchangeImplementations(oldInitWithCoder,newInitWithCoder);
}

//inspired from: [h]ttp://www.mikeash.com/pyblog/custom-nscells-done-right.html
- (id) newInitWithCoder:(NSCoder *) _coder {
	if(![_coder isKindOfClass:[NSKeyedUnarchiver class]]) return [self newInitWithCoder:_coder];
	NSKeyedUnarchiver * unarchiver = (NSKeyedUnarchiver *)_coder;
	Class supercell = [[self superclass] cellClass];
	Class selfcell = [[self class] cellClass];
	if(!selfcell || !supercell) return [self newInitWithCoder:_coder];
	NSString * supercellName = NSStringFromClass(supercell);
	[unarchiver setClass:selfcell forClassName:supercellName];
	self = [self newInitWithCoder:_coder];
	[unarchiver setClass:supercell forClassName:supercellName];
	return self;
}

@end
