#import "CalGesturesController.h"

@interface CalGesturesController ()

@property (weak, nonatomic) IBOutlet UIView *gestureBox;

@end

@implementation CalGesturesController


#pragma mark - Memory Management

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    NSString *title = NSLocalizedString(@"Gestures",
                                        @"Title of tab bar button");
    self.title = title;

    UIImage *unselected = [UIImage imageNamed:@"tab-bar-gestures"];
    UIImage *selected = [UIImage imageNamed:@"tab-bar-gestures-selected"];

    UITabBarItem *item = [[UITabBarItem alloc]
                          initWithTitle:title
                          image:unselected
                          selectedImage:selected];

    self.tabBarItem = item;
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Orientation / Rotation

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
  return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"gestures page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Gestures page", @"Page where gestures are tested");

  self.gestureBox.accessibilityIdentifier = @"gestures box";
  self.gestureBox.accessibilityLabel =
  NSLocalizedString(@"Gestures box", @"A square view to perform gestures in");
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
