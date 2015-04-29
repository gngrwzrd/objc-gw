
#import <Cocoa/Cocoa.h>

extern NSString * const EditTextFieldEndEditing;

@interface EditTextField : NSTextField <NSTextDelegate,NSTextViewDelegate,NSTextFieldDelegate>

@property BOOL isEditing;
@property BOOL commitChangesOnEscapeKey;
@property BOOL editAfterDelay;
@property CGFloat delay;

@end
