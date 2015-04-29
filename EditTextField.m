
#import "EditTextField.h"

NSString * const EditTextFieldEndEditing = @"EditTextFieldEndEditing";

@interface EditTextField ()
@property (weak) NSObject <NSTextFieldDelegate,NSTextViewDelegate> * userDelegate;
@property NSString * originalStringValue;
@property NSTimer * editTimer;
@property NSTrackingArea * editTrackingArea;
@end

@implementation EditTextField

- (void) dealloc {
	NSLog(@"DEALLOC: EditTextField");
	[self removeTrackingArea:self.editTrackingArea];
	self.editTrackingArea = nil;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id) initWithCoder:(NSCoder *)coder {
	self = [super initWithCoder:coder];
	[self defaultInit];
	return self;
}

- (id) initWithFrame:(NSRect)frameRect {
	self = [super initWithFrame:frameRect];
	[self defaultInit];
	return self;
}

- (id) init {
	self = [super init];
	[self defaultInit];
	return self;
}

- (void) defaultInit {
	self.delay = .8;
	NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
	[center addObserver:self selector:@selector(onEndEditing:) name:EditTextFieldEndEditing object:nil];
}

- (void) onEndEditing:(NSNotification *) notification {
	[self stopTracking];
	[self stopEditingCommitChanges:FALSE clearFirstResponder:TRUE];
}

- (void) mouseDown:(NSEvent *) theEvent {
	if(theEvent.clickCount == 2) {
		[self stopTracking];
		[self startEditing];
	} else {
		[super mouseDown:theEvent];
		if(self.editAfterDelay) {
			[self startTracking];
			self.editTimer = [NSTimer scheduledTimerWithTimeInterval:.8 target:self selector:@selector(startEditing) userInfo:nil repeats:FALSE];
		}
	}
}

- (void) startTracking {
	if(!self.editTrackingArea) {
		self.editTrackingArea = [[NSTrackingArea alloc] initWithRect:self.bounds options:NSTrackingMouseEnteredAndExited|NSTrackingMouseMoved|NSTrackingActiveInActiveApp|NSTrackingAssumeInside|NSTrackingInVisibleRect owner:self userInfo:nil];
	}
	[self addTrackingArea:self.editTrackingArea];
}

- (void) stopTracking {
	[self.editTimer invalidate];
	self.editTimer = nil;
	[self removeTrackingArea:self.editTrackingArea];
}

- (void) mouseExited:(NSEvent *)theEvent {
	[self stopTracking];
}

- (void) mouseMoved:(NSEvent *) theEvent {
	[self stopTracking];
}

- (void) startEditing {
	id firstResponder = self.window.firstResponder;
	if([firstResponder isKindOfClass:[NSTextView class]]) {
		NSTextView * tv = (NSTextView *)firstResponder;
		if(tv.delegate && [tv.delegate isKindOfClass:[EditTextField class]]) {
			EditTextField * fr = (EditTextField *)tv.delegate;
			[fr stopEditingCommitChanges:FALSE clearFirstResponder:FALSE];
		}
	}
	if(self.delegate != self && !self.userDelegate) {
		self.userDelegate = (NSObject <NSTextFieldDelegate,NSTextViewDelegate> *)self.delegate;
	}
	self.isEditing = TRUE;
	self.delegate = self;
	self.editable = TRUE;
	self.originalStringValue = self.stringValue;
	[self.window makeFirstResponder:self];
}

- (void) stopEditingCommitChanges:(BOOL) commitChanges clearFirstResponder:(BOOL) clearFirstResponder {
	if(!self.isEditing) {
		return;
	}
	
	id fieldEditor = self.window.firstResponder;
	
	self.editable = FALSE;
	self.isEditing = FALSE;
	self.delegate = nil;
	[self removeTrackingArea:self.editTrackingArea];
	
	if(!commitChanges) {
		self.stringValue = self.originalStringValue;
	}
	
	if(clearFirstResponder) {
		[self.window makeFirstResponder:nil];
	}
	
	[self sendControlTextDidEndEditing:fieldEditor didCommitChanges:commitChanges];
}

- (void) cancelOperation:(id) sender {
	if(self.commitChangesOnEscapeKey) {
		[self stopEditingCommitChanges:TRUE clearFirstResponder:TRUE];
	} else {
		[self stopEditingCommitChanges:FALSE clearFirstResponder:TRUE];
	}
}

- (BOOL) textView:(NSTextView *) textView doCommandBySelector:(SEL) commandSelector {
	BOOL handlesCommand = FALSE;
	NSString * selector = NSStringFromSelector(commandSelector);
	
	if(self.userDelegate) {
		
		if([self.userDelegate respondsToSelector:@selector(control:textView:doCommandBySelector:)]) {
			handlesCommand = [self.userDelegate control:self textView:textView doCommandBySelector:commandSelector];
		} else if([self.userDelegate respondsToSelector:@selector(textView:doCommandBySelector:)]) {
			handlesCommand = [self.userDelegate textView:textView doCommandBySelector:commandSelector];
		}
		
		if(!handlesCommand) {
			
			if([selector isEqualToString:@"insertNewline:"]) {
				[self stopEditingCommitChanges:TRUE clearFirstResponder:TRUE];
				handlesCommand = TRUE;
			}
			
			if([selector isEqualToString:@"insertTab:"]) {
				[self stopEditingCommitChanges:TRUE clearFirstResponder:FALSE];
				handlesCommand = FALSE;
			}
		}
		
	} else {
		
		if([selector isEqualToString:@"insertNewline:"]) {
			[self stopEditingCommitChanges:TRUE clearFirstResponder:TRUE];
			handlesCommand = TRUE;
		}
		
		if([selector isEqualToString:@"insertTab:"]) {
			[self stopEditingCommitChanges:TRUE clearFirstResponder:FALSE];
			handlesCommand = FALSE;
		}
	}
	
	return handlesCommand;
}

- (void) controlTextDidBeginEditing:(NSNotification *)obj {
	if(self.userDelegate && [self.userDelegate respondsToSelector:@selector(controlTextDidBeginEditing:)]) {
		[self.userDelegate controlTextDidBeginEditing:obj];
	}
}

- (void) controlTextDidChange:(NSNotification *)obj {
	if(self.userDelegate && [self.userDelegate respondsToSelector:@selector(controlTextDidChange:)]) {
		[self.userDelegate controlTextDidChange:obj];
	}
}

- (void) sendControlTextDidEndEditing:(NSText *) fieldEditor didCommitChanges:(BOOL) didCommitChanges {
	NSMutableDictionary * info = [NSMutableDictionary dictionary];
	info[@"NSFieldEditor"] = fieldEditor;
	info[@"DidCommitChanges"] = [NSNumber numberWithBool:didCommitChanges];
	NSNotification * notification = [NSNotification notificationWithName:NSControlTextDidEndEditingNotification object:self userInfo:info];
	if(self.userDelegate && [self.userDelegate respondsToSelector:@selector(controlTextDidEndEditing:)]) {
		[self.userDelegate controlTextDidEndEditing:notification];
	}
}

@end
