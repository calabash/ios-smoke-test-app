#import "CalViewWithArbitrarySelectors.h"

// A UIView subclass to test Calabash's ability to call arbitrary selectors
// on a view.

@interface CalViewWithArbitrarySelectors ()

- (BOOL) takesPointer:(id) arg;
- (BOOL) takesInt:(NSInteger) arg;
- (BOOL) takesUnsignedInt:(NSUInteger) arg;
- (BOOL) takesShort:(short) arg;
- (BOOL) takesUnsignedShort:(unsigned short) arg;
- (BOOL) takesFloat:(float) arg;
- (BOOL) takesDouble:(double) arg;
- (BOOL) takesLongDouble:(long double) arg;
- (BOOL) takesCString:(char *) arg;
- (BOOL) takesChar:(char) arg;
- (BOOL) takesUnsignedChar:(unichar) arg;
- (BOOL) takesBOOL:(BOOL) arg;
- (BOOL) takesLong:(long) arg;
- (BOOL) takesUnsignedLong:(unsigned long) arg;
- (BOOL) takesLongLong:(long long) arg;
- (BOOL) takesUnsignedLongLong:(unsigned long long) arg;

- (BOOL) takesPoint:(CGPoint) arg;
- (BOOL) takesRect:(CGRect) arg;

@end

@implementation CalViewWithArbitrarySelectors

- (BOOL) takesPointer:(id) arg { return YES; }
- (BOOL) takesInt:(NSInteger) arg { return YES; }
- (BOOL) takesUnsignedInt:(NSUInteger) arg { return YES; }
- (BOOL) takesShort:(short) arg { return YES; }
- (BOOL) takesUnsignedShort:(unsigned short) arg { return YES; }
- (BOOL) takesFloat:(float) arg { return YES; }
- (BOOL) takesDouble:(double) arg { return YES; }
- (BOOL) takesLongDouble:(long double) arg { return YES; }
- (BOOL) takesCString:(char *) arg { return YES; }
- (BOOL) takesChar:(char) arg { return YES; }
- (BOOL) takesUnsignedChar:(unichar) arg { return YES; }
- (BOOL) takesBOOL:(BOOL) arg { return YES; }
- (BOOL) takesLong:(long) arg { return YES; }
- (BOOL) takesUnsignedLong:(unsigned long) arg { return YES; }
- (BOOL) takesLongLong:(long long) arg { return YES; }
- (BOOL) takesUnsignedLongLong:(unsigned long long) arg { return YES; }

- (BOOL) takesPoint:(CGPoint) arg { return YES; }
- (BOOL) takesRect:(CGRect) arg { return YES; }

@end
