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

- (void) returnsVoid;
- (NSString *) returnsPointer;
- (char) returnsChar;
- (unichar) returnsUnsignedChar;
- (char *) returnsCString;
- (BOOL) returnsBOOL;
- (bool) returnsBool;
- (NSInteger) returnsInt;
- (NSUInteger) returnsUnsignedInt;
- (short) returnsShort;
- (unsigned short) returnsUnsignedShort;
- (double) returnsDouble;
- (long double) returnsLongDouble;
- (float) returnsFloat;
- (long) returnsLong;
- (unsigned long) returnsUnsignedLong;
- (long long) returnsLongLong;
- (unsigned long long) returnsUnsignedLongLong;
- (CGPoint) returnsPoint;
- (CGRect) returnsRect;

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

- (void) returnsVoid { return; }
- (NSString *) returnsPointer { return @"a pointer"; }
- (char) returnsChar { return -22; }
- (unichar) returnsUnsignedChar { return 'a'; }
- (char *) returnsCString { return "c string"; }
- (BOOL) returnsBOOL { return YES; }
- (bool) returnsBool { return true; }
- (NSInteger) returnsInt { return -3; }
- (NSUInteger) returnsUnsignedInt { return 3; }
- (short) returnsShort { return -2; }
- (unsigned short) returnsUnsignedShort { return 2; }
- (double) returnsDouble { return 0.5; }
- (long double) returnsLongDouble { return (long double)0.55; }
- (float) returnsFloat { return 3.14f; }
- (long) returnsLong { return (long)-4; }
- (unsigned long) returnsUnsignedLong { return (unsigned long)4; }
- (long long) returnsLongLong { return (long long)-5; }
- (unsigned long long) returnsUnsignedLongLong { return (unsigned long long)5; }
- (CGPoint) returnsPoint { return CGPointZero; }
- (CGRect) returnsRect { return CGRectZero; }

@end
