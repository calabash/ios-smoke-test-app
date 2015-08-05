#import "CalPinchController.h"
#import "CalBarButtonItemFactory.h"
#import "UIView+Positioning.h"

static NSString *const CalRestZoomLevelNotification =
@"sh.calaba.CalSmokeApp Pan Clearn Touch Points";

@interface UIView (CalPinchResetZoom)

@end

@implementation UIView (CalPinchResetZoom)

- (void) resetZoomLevel {
  [[NSNotificationCenter defaultCenter]
   postNotificationName:CalRestZoomLevelNotification
   object:nil];
}

@end

@interface CalPinchController ()

@property (weak, nonatomic) IBOutlet UIView *box;

@end

@implementation CalPinchController

#pragma mark - Memory Management

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleResetZoomLevel:)
     name:CalRestZoomLevelNotification
     object:nil];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Orientation / Rotation

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
  return YES;
}

#pragma mark - Pinching

- (void) handleResetZoomLevel:(NSNotification *) notification {
  self.box.height = 88;
  self.box.width = 88;
  self.box.center = self.view.center;
}

- (void) handlePinch:(UIPinchGestureRecognizer *) recognizer {
  UIView *view = recognizer.view;
  if (view.height < 88 || view.width < 88) {
    [self handleResetZoomLevel:nil];
  } else {
    view.transform = CGAffineTransformScale(view.transform,
                                            recognizer.scale,
                                            recognizer.scale);
    CGPoint center = self.view.center;
    view.center = center;
  }
  recognizer.scale = 1.0;
}

#pragma mark - View Lifecycle

- (void) buttonTouchedBack:(id) sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"pinching page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Panning page", @"A view with you can pan on.");

  self.box.accessibilityIdentifier = @"box";
  self.box.accessibilityLabel =
  NSLocalizedString(@"Pinch box", @"A view you can pinch.");

  UIPinchGestureRecognizer *pincher;
  pincher = [[UIPinchGestureRecognizer alloc]
             initWithTarget:self
             action:@selector(handlePinch:)];

  [self.box addGestureRecognizer:pincher];
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self handleResetZoomLevel:nil];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.navigationItem.title =
  NSLocalizedString(@"Pinching",
                    @"Title of navbar for view where you can pinch");

  CalBarButtonItemFactory *factory = [[CalBarButtonItemFactory alloc] init];
  UIBarButtonItem *backButton;
  backButton = [factory barButtonItemBackWithTarget:self
                                             action:@selector(buttonTouchedBack:)];

  backButton.accessibilityLabel = [CalBarButtonItemFactory stringLocalizedBack];

  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.backBarButtonItem = nil;
  self.navigationItem.leftBarButtonItem = backButton;

  [self handleResetZoomLevel:nil];
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
