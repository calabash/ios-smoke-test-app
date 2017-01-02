
#import "CalTextField.h"

@interface CalTextField ()

- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)addTapGestureRecognizer;

@end

@implementation CalTextField

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    self.userInteractionEnabled = YES;
    NSLog(@"In init with coder");
    [self addTapGestureRecognizer];
  }
  return self;
}

- (void)addTapGestureRecognizer {
  UITapGestureRecognizer *recognizer;
  recognizer = [[UITapGestureRecognizer alloc]
                initWithTarget:self action:@selector(handleTap:)];
  [self addGestureRecognizer:recognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
  UIGestureRecognizerState state = [recognizer state];
  if (UIGestureRecognizerStateEnded == state) {
    NSLog(@"state ended");
    if (![self isFirstResponder]) {
      // Possibly implement the Focus protocols
      // [self setNeedsFocusUpdate];
      NSLog(@"become first responder!");
      [self becomeFirstResponder];
    } else {
      NSLog(@"already first responder!");
    }
  }
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (BOOL)canResignFirstResponder {
  return YES;
}

- (BOOL)hasText {
  return self.text && self.text.length > 0;
}

- (void)drawRect:(CGRect)rect {
  UIRectFrame(rect);

  NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
  paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
  paragraphStyle.alignment = NSTextAlignmentCenter;

  NSDictionary *attrs = @{
                          NSFontAttributeName : [UIFont systemFontOfSize:18],
                          NSParagraphStyleAttributeName : paragraphStyle,
                          NSForegroundColorAttributeName : [UIColor whiteColor]
                          };
  [self.text drawInRect:rect withAttributes:attrs];
}

- (void)insertText:(NSString *)text {
  if (!self.text) {
    self.text = @"";
  }

  if ([text length] == 1 && [text characterAtIndex:0] == 10) {
    [self resignFirstResponder];
  } else {
    NSString *appended = [[self text] stringByAppendingString:text];
    self.text = appended;
  }
  [self setNeedsDisplay];
}

- (void)deleteBackward {
  if ([self hasText]) {
    NSString *text = self.text;
    self.text = [text substringToIndex:[text length] - 1];
  }

  [self setNeedsDisplay];
}

@end
