
#import "CalTextField.h"

@interface CalTextField ()

- (void)handleTap:(UITapGestureRecognizer *)recognizer;
- (void)addTapGestureRecognizer;

@end

@implementation CalTextField

//- (id)initWithFrame:(CGRect)frame {
//  self = [super initWithFrame:frame];
//  if (self) {
//    [self addTapGestureRecognizer];
//  }
//  return self;
//}

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
  return [self.text length] > 0;
}

- (void)insertText:(NSString *)text {
  NSString *appended = [[self text] stringByAppendingString:text];
  self.text = appended;
}

- (void)deleteBackward {
  if (![self hasText]) { return; }
  if ([[self text] length] == 1) {
     self.text = @"";
  } else {
    self.text = [self.text substringToIndex:[[self text] length] - 2];
  }
}

@end
