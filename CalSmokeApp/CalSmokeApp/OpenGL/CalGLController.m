#import "CalGLController.h"
#import "OpenGLView.h"

typedef enum : NSInteger {
  kTagGLView = 3030,
  kTagDismissButton
} ViewTags;

@interface CalGLController ()

@property(strong, nonatomic) UIButton *dismissButton;
@property(strong, nonatomic) OpenGLView *glView;

@end

@implementation CalGLController

#pragma mark Memory Management

@synthesize dismissButton = _dismissButton;
@synthesize glView = _glView;

- (UIButton *) dismissButton {
  if (_dismissButton) { return _dismissButton; }

  UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];

  CGRect wFrame = self.view.frame;
  CGFloat wWidth = wFrame.size.width;
  CGFloat maxY = wFrame.size.height;
  CGFloat width = 134;
  CGFloat height = 64;
  CGFloat x = (wWidth/2.0) - (width/2.0);
  CGFloat y = maxY - height - 20;

  button.frame = CGRectMake(x, y, width, height);

  [button addTarget:self
             action:@selector(buttonTouchedDismiss:)
   forControlEvents:UIControlEventTouchUpInside];

  [button setTitle:@"Dismiss" forState:UIControlStateNormal];
  [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [button setBackgroundColor:[UIColor brownColor]];
  button.tag = kTagDismissButton;
  button.accessibilityIdentifier = @"dismiss";
  _dismissButton = button;
  return _dismissButton;
}

- (OpenGLView *) glView {
  if (_glView) { return _glView; }
  _glView = [[OpenGLView alloc] initWithFrame:self.view.frame];
  _glView.tag = kTagGLView;
  _glView.accessibilityIdentifier = @"glview";
  return _glView;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark Actions

- (void) buttonTouchedDismiss:(UIButton *) button {
  NSLog(@"Dismiss button touched.");
  UIViewController *presenter = [self presentingViewController];
  [presenter dismissViewControllerAnimated:YES
                                completion:^{
                                  NSLog(@"Dismissed.");
                                }];
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}
#else
- (NSUInteger) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskPortrait;
}
#endif


- (BOOL) shouldAutorotate {
  return NO;
}

#pragma mark View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  OpenGLView *glView = self.glView;

  if (![self.view viewWithTag:kTagGLView]) {
    NSLog(@"Adding OpenGLView");
    [self.view addSubview:glView];
  }

  if (![self.view viewWithTag:kTagDismissButton]) {
    NSLog(@"Adding dismiss button");
    [self.view insertSubview:self.dismissButton aboveSubview:glView];
  }
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
