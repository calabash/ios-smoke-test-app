#import "CalViewWithArbitrarySelectors.h"

// A UIView subclass to test Calabash's ability to call arbitrary selectors
// on a view.

typedef struct {
  NSInteger code;
  CGFloat visibility;
  NSUInteger decibels;
} CalSmokeAlarm;

@interface SmokeAlarm : NSObject

@property(nonatomic, assign) NSInteger code;
@property(nonatomic, assign) CGFloat visibility;
@property(nonatomic, assign) NSUInteger decibels;
@property(nonatomic, assign, getter=isOn, setter=setIsOn:) BOOL on;

@end

@implementation SmokeAlarm

- (instancetype) init {
  self = [super init];
  if (self) {
    _code = -1;
    _visibility = 0.5;
    _decibels = 100;
    _on = NO;
  }
  return self;
}

- (NSArray *) selectorWithArg:(NSString *) arg0
                          arg:(NSString *) arg1
                          arg:(NSString *) arg2 {
  return @[arg0, arg1, arg2];
}

@end

@interface CalViewWithArbitrarySelectors ()

@property(nonatomic, strong, readonly) SmokeAlarm *alarm;

@end

@implementation CalViewWithArbitrarySelectors

@synthesize alarm = _alarm;

- (SmokeAlarm *) alarm {
  if (_alarm) { return _alarm; }
  _alarm = [SmokeAlarm new];
  return _alarm;
}

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
- (CalSmokeAlarm) returnSmokeAlarm {
  CalSmokeAlarm alarm;
  alarm.code = -1;
  alarm.visibility = 0.5;
  alarm.decibels = 10;
  return alarm;
}

- (NSString *) stringFromMethodWithSelf:(id) arg {
  if (arg == self) {
   return @"Self reference! Hurray!";
  } else {
    return [NSString stringWithFormat:@"ACK! arg '%@' was not self!",
           arg];
  }
}

- (NSArray *) selectorWithArg:(NSString *) arg0
                          arg:(NSString *) arg1
                          arg:(NSString *) arg2 {
  return @[arg0, arg1, arg2];
}

@end
