#import "XamViewController.h"
#import "UIView+Positioning.h"

typedef enum : NSInteger {
  kTagTextField = 3030
} view_tags;

@interface XamFirstView : UIView <UITextFieldDelegate>

@property (nonatomic, readonly, strong) UITextField *textField;

@end

@implementation XamFirstView

@synthesize textField = _textField;

- (id) initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.accessibilityIdentifier = @"first page";
    self.accessibilityLabel = NSLocalizedString(@"First page", @"ACCESSIBILITY: the first page");
    self.backgroundColor = [UIColor whiteColor];
  }
  return self;
}

- (UITextField *) textField {
  if (_textField) { return _textField; }
  UITextField *textField = [[UITextField alloc] initWithFrame:CGRectZero];
  textField.accessibilityIdentifier = @"text";
  textField.accessibilityLabel = NSLocalizedString(@"Text field", @"ACCESSIBILITY a text field");
  textField.tag = kTagTextField;
  textField.borderStyle =  UITextBorderStyleLine;
  textField.clearsOnBeginEditing = YES;
  textField.returnKeyType = UIReturnKeyDone;
  textField.delegate = self;
  _textField = textField;
  return _textField;
}


- (void) layoutSubviews {
  UITextField *existingTextField = (UITextField *)[self viewWithTag:kTagTextField];
  NSString *existingText = nil;
  if (existingTextField) {
    existingText = existingTextField.text;
    [existingTextField removeFromSuperview];
    _textField = nil;
  }

  UITextField *textField = [self textField];

  CGFloat x = 20;
  CGFloat y = 64;
  CGFloat height = 28;
  CGFloat width = self.width - 40;
  textField.frame = CGRectMake(x, y, width, height);
  textField.text = existingText;
  textField.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.2];
  [self addSubview:textField];
}

#pragma  mark Text Field Delegate

- (void) textFieldDidBeginEditing:(UITextField *) aTextField {

}

- (void) textFieldDidEndEditing:(UITextField *) aTextField {

}

- (BOOL) textFieldShouldClear:(UITextField *) aTextField {
  return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *) aTextField {
  [aTextField resignFirstResponder];
  return YES;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) aTextField {
  return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *) aTextField {
  return YES;
}

- (BOOL) textField:(UITextField *) aTextField shouldChangeCharactersInRange:(NSRange) aRange replacementString:(NSString *) aString {
  return YES;
}


@end


@interface XamViewController () < UITextFieldDelegate>

@end

@implementation XamViewController

#pragma mark - Memory Management

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

#pragma mark View Lifecycle

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) loadView {
  CGRect frame = [[UIScreen mainScreen] applicationFrame];
  XamFirstView *view = [[XamFirstView alloc] initWithFrame:frame];
  
  view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = view;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

@end
