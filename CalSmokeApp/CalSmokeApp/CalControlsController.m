#import "CalControlsController.h"
#import "UIView+Positioning.h"
#import "CalViewWithArbitrarySelectors.h"

static NSString *const kUserDefaultsSwitchState = @"sh.calaba.CalSmokeApp Switch State";

@interface CalControlsController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *uiSwitch;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end


@implementation CalControlsController

#pragma mark - Memory Management

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

    UIImage *image = [UIImage imageNamed:@"tab-bar-controls"];
    UIImage *selected = [UIImage imageNamed:@"tab-bar-controls-selected"];
    NSString *title =
    NSLocalizedString(@"Controls",
                      @"Title of tab bar page with controls like switches and buttons");
    self.tabBarItem = [[UITabBarItem alloc]
                       initWithTitle:title
                       image:image
                       selectedImage:selected];
  }
  return self;
}

- (void) didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Actions

- (IBAction) switchValueChanged:(UISwitch *) sender {
  NSLog(@"switch value changed");
  BOOL state = sender.isOn;
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setBool:state forKey:kUserDefaultsSwitchState];
  [defaults synchronize];
}

- (IBAction)sliderValueChanged:(id)sender {

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

#pragma mark View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"controls page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"UI controls",
                    @"Name of page with UI controls like switches, buttons, text fields, and sliders.");

  self.textField.accessibilityIdentifier = @"text";
  self.textField.clearButtonMode = UITextFieldViewModeAlways;
  self.textField.returnKeyType = UIReturnKeyDone;
  self.uiSwitch.accessibilityIdentifier = @"switch";
  self.slider.accessibilityIdentifier = @"slider";
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  /*
   NSLog(@"Text input Capitalization Types");
   NSLog(@"     none = %@", @(UITextAutocapitalizationTypeNone));
   NSLog(@"    words = %@", @(UITextAutocapitalizationTypeWords));
   NSLog(@"sentences = %@", @(UITextAutocapitalizationTypeSentences));
   NSLog(@"      all = %@", @(UITextAutocapitalizationTypeAllCharacters));

   NSLog(@"Text input Correction Types");
   NSLog(@"  default = %@", @(UITextAutocorrectionTypeDefault));
   NSLog(@"       no = %@", @(UITextAutocorrectionTypeNo));
   NSLog(@"      yes = %@", @(UITextAutocorrectionTypeYes));

   NSLog(@"Text input Spell Checking Types");
   NSLog(@"  default = %@", @(UITextSpellCheckingTypeDefault));
   NSLog(@"       no = %@", @(UITextSpellCheckingTypeNo));
   NSLog(@"      yes = %@", @(UITextSpellCheckingTypeYes));
 */

  [super viewWillAppear:animated];

  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  BOOL lastSwitchState = [defaults boolForKey:kUserDefaultsSwitchState];
  [self.uiSwitch setOn:lastSwitchState];
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
