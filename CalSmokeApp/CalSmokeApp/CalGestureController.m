#import "CalGestureController.h"
#import "CalBarButtonItemFactory.h"

@interface CalGestureController ()

@end

@implementation CalGestureController

#pragma mark - Memory Management

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    UIImage *image = [UIImage imageNamed:@"tab-bar-gestures"];
    UIImage *selected = [UIImage imageNamed:@"tab-bar-gestures-selected"];
    NSString *title = NSLocalizedString(@"Gestures",
                                        @"Title of tab bar page where gestures can be performed");
    self.tabBarItem = [[UITabBarItem alloc]
                       initWithTitle:title
                       image:image
                       selectedImage:selected];
  }
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void) buttonTouchedBack:(id) sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"gestures page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Gestures!", @"A view that responds to gestures.");
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.navigationItem.title =
  NSLocalizedString(@"Gestures",
                    @"Title of navigation bar for page that responds to gestures");

  CalBarButtonItemFactory *factory = [[CalBarButtonItemFactory alloc] init];
  UIBarButtonItem *backButton;
  backButton = [factory barButtonItemBackWithTarget:self
                                             action:@selector(buttonTouchedBack:)];

  backButton.accessibilityLabel = [CalBarButtonItemFactory stringLocalizedBack];

  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.backBarButtonItem = nil;
  self.navigationItem.leftBarButtonItem = backButton;

  UINavigationController *navcon = self.navigationController;
  if ([navcon respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    navcon.interactivePopGestureRecognizer.enabled = YES;
    navcon.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [navcon.interactivePopGestureRecognizer addTarget:self
                                               action:@selector(buttonTouchedBack:)];
  }
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
