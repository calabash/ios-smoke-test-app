#import "CalDatePickerController.h"
#import "CalDatePickerView.h"


typedef enum : NSInteger {
  kTagPickerView = 3030,
  kTagButtonTime,
  kTagButtonDate,
  kTagButtonDateAndTime,
  kTagButtonCountdown
} view_tags;



@interface CalDatePickerController ()

@property (nonatomic, strong) CalDatePickerView *pickerView;

- (void) buttonTouchedDoneDatePicking:(id) sender;
- (void) setButtonsHidden:(BOOL) aHidden;
- (UIDatePickerMode) modeForButton:(UIButton *) aButton;
- (void) buttonTouched:(UIButton *) aButton;
- (CalDatePickerView *) pickerViewForMode:(UIDatePickerMode) aMode;

@end

@implementation CalDatePickerController

@synthesize pickerView = _pickerView;

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

    UIImage *image = [UIImage imageNamed:@"tab-bar-elephant"];
    UIImage *selected = [UIImage imageNamed:@"tab-bar-elephant-selected"];
    NSString *title = NSLocalizedString(@"Date Picker",
                                        @"Title of tab with date pickers.");
    self.tabBarItem = [[UITabBarItem alloc]
                       initWithTitle:title
                       image:image
                       selectedImage:selected];
  }
  return self;
}


- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}


- (CalDatePickerView *) pickerView {
  return _pickerView;
}

- (CalDatePickerView *) pickerViewForMode:(UIDatePickerMode) aMode {
  return [[CalDatePickerView alloc]
                 initWithDate:[NSDate date]
                 delegate:self
                 mode:aMode];
}

#pragma mark - Actions

- (void) buttonTouchedDoneDatePicking:(id)sender {
  NSLog(@"done date editing button touched");
}


- (void) setButtonsHidden:(BOOL) aHidden {
  NSArray *buttons =
  @[self.buttonTime,
    self.buttonDate,
    self.buttonDateAndTime,
    self.buttonCountdown];
  [buttons enumerateObjectsUsingBlock:^(UIButton *button,
                                        NSUInteger idx,
                                        BOOL *stop) {
    button.hidden = aHidden;
  }];
}

- (UIDatePickerMode) modeForButton:(UIButton *) aButton {
  if (self.buttonTime == aButton) { return UIDatePickerModeTime; }
  if (self.buttonDate == aButton) { return UIDatePickerModeDate; }
  if (self.buttonDateAndTime == aButton) { return UIDatePickerModeDateAndTime; }
  if (self.buttonCountdown == aButton) { return UIDatePickerModeCountDownTimer; }
  return NSNotFound;
}

- (void) buttonTouched:(UIButton *) aButton {
  UIDatePickerMode mode = [self modeForButton:aButton];
  _pickerView = [self pickerViewForMode:mode];
  
  [self setButtonsHidden:YES];
  
  typeof(self) wself = self;
  [CalDatePickerAnimationHelper
   animateDatePickerOnWithController:wself
   animations:^{
     
   } completion:^(BOOL finished) {
    
   }];
}

- (IBAction)buttonTouchedTime:(id)sender {
  NSLog(@"show picker button touched");
  [self buttonTouched:sender];
}

- (IBAction)buttonTouchedDateAndTime:(id)sender {
  NSLog(@"show picker button touched");
  [self buttonTouched:sender];
}

- (IBAction)buttonTouchedDate:(id)sender {
  NSLog(@"show picker button touched");
  [self buttonTouched:sender];
}

- (IBAction)buttonTouchedCountdown:(id)sender {
  NSLog(@"show countdown button touched");
  [self buttonTouched:sender];
}

#pragma mark - <CalDatePickerViewDelegate>

- (void) datePickerViewCancelButtonTouched {
  NSLog(@"cancel date picking button touched");
  typeof(self) wself = self;
  [CalDatePickerAnimationHelper
   animateDatePickerOffWithController:wself
   before:^{
     
   } animations:^{
     
   } completion:^(BOOL finished) {
     [wself setButtonsHidden:NO];
   }];
}

- (void) datePickerViewDoneButtonTouchedWithDate:(NSDate *)aDate {
  NSLog(@"picker view done button touched with date: %@",  [aDate debugDescription]);
  
  typeof(self) wself = self;
  [CalDatePickerAnimationHelper
   animateDatePickerOffWithController:wself
   before:^{

   } animations:^{

   } completion:^(BOOL finished) {
     [wself setButtonsHidden:NO];
   }];
}

#pragma mark - Orientation

- (NSUInteger) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}

- (BOOL) shouldAutorotate {
  return NO;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"date picker page";
  self.buttonTime.accessibilityIdentifier = @"show time picker";
  self.buttonTime.tag = kTagButtonTime;
  self.buttonDate.accessibilityIdentifier = @"show date picker";
  self.buttonDate.tag = kTagButtonDate;
  self.buttonDateAndTime.accessibilityIdentifier = @"show date and time picker";
  self.buttonDateAndTime.tag = kTagButtonDateAndTime;
  self.buttonCountdown.accessibilityIdentifier = @"show countdown picker";
  self.buttonCountdown.tag = kTagButtonCountdown;
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
  [self datePickerViewCancelButtonTouched];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

@end
