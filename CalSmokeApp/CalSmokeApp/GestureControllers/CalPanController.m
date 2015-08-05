#import "CalPanController.h"
#import "UIView+Positioning.h"
#import "CalBarButtonItemFactory.h"

static NSString *const CalPanClearTouchPointsNotification =
@"sh.calaba.CalSmokeApp Pan Clearn Touch Points";

@interface UIView (CalPanClearTouchPoints)

@end

@implementation UIView (CalPanClearTouchPoints)

- (void) clearTouchPoints {
  [[NSNotificationCenter defaultCenter]
   postNotificationName:CalPanClearTouchPointsNotification
   object:nil];
}

@end

typedef enum : NSInteger {
  kTagPanBegin = 3030,
  kTagPanEnd
} PanPointViews;

@interface CalPanController ()

@property (weak, nonatomic) IBOutlet UILabel *screenPanStartLabel;
@property (weak, nonatomic) IBOutlet UILabel *screenPanEndLabel;
@property (weak, nonatomic) IBOutlet UIView *labelContainer;
@property (weak, nonatomic) IBOutlet UIView *box;

@end

@implementation CalPanController

#pragma mark - Memory Management

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleClearTouchPointsNotification:)
     name:CalPanClearTouchPointsNotification
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

#pragma mark - Recognizers

- (void) centerBoxOnTwoDoubleTap:(UITapGestureRecognizer *) recognizer {
  NSLog(@"Centering!");
  UIGestureRecognizerState state = [recognizer state];
  if (UIGestureRecognizerStateEnded == state) {
    self.box.center = self.view.center;
  }
}

- (void) handleClearTouchPointsNotification:(NSNotification *) notification {
  [self removePreviousTouches];
  self.screenPanStartLabel.text = @"";
  self.screenPanEndLabel.text = @"";
}

- (void) removePreviousTouches {
  [@[@(kTagPanBegin), @(kTagPanEnd)] enumerateObjectsUsingBlock:^(NSNumber *tag,
                                                    NSUInteger idx,
                                                    BOOL *stop) {
    UIView *view = [self.view viewWithTag:[tag integerValue]];
    if (view) {
      [view removeFromSuperview];
    }
  }];
}

- (UIView *) viewForPanTouchWithCenter:(CGPoint) center
                                   tag:(PanPointViews) tag {
  CGRect frame = CGRectMake(0, 0, 44, 44);
  UIView *view = [[UIView alloc] initWithFrame:frame];
  view.center = center;
  view.layer.cornerRadius = 44/2;
  view.tag = tag;
  
  switch (tag) {
    case kTagPanBegin: {
      view.backgroundColor = [UIColor blueColor];
      view.accessibilityIdentifier = @"begin";
      break;
    }

    case kTagPanEnd: {
      view.backgroundColor = [UIColor redColor];
      view.accessibilityIdentifier = @"end";
      break;
    }
  }
  return view;
}

- (void) panView:(UIPanGestureRecognizer *) recognizer {
  CGPoint point = [recognizer locationInView:self.view];
  UIGestureRecognizerState state = [recognizer state];
  if (UIGestureRecognizerStateBegan == state) {
    [self removePreviousTouches];

    self.screenPanStartLabel.text = [NSString stringWithFormat:@"Start: (%@, %@)",
                                     @([@(point.x) integerValue]),
                                     @([@(point.y) integerValue])];
    self.screenPanEndLabel.text = @"Waiting...";

    [self.view addSubview:[self viewForPanTouchWithCenter:point tag:kTagPanBegin]];

  } else if (UIGestureRecognizerStateEnded == state) {
    self.screenPanEndLabel.text = [NSString stringWithFormat:@"End: (%@, %@)",
                                   @([@(point.x) integerValue]),
                                   @([@(point.y) integerValue])];

    [self.view addSubview:[self viewForPanTouchWithCenter:point tag:kTagPanEnd]];
  }
}

- (void) panBox:(UIPanGestureRecognizer *) recognizer {
  CGPoint touchLocation = [recognizer locationInView:self.view];
  self.box.center = touchLocation;
}

#pragma mark - View Lifecycle

- (void) buttonTouchedBack:(id) sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) layoutLabelContainer:(UIView *) containerView {
  UITabBar *tabBar = self.tabBarController.tabBar;

  containerView.y = self.view.height - (tabBar.height + 10);
}

- (void)viewDidLoad {
  [super viewDidLoad];


  self.view.accessibilityIdentifier = @"panning page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Panning page", @"A view with you can pan on.");

  UITapGestureRecognizer *doubleTap;
  doubleTap = [[UITapGestureRecognizer alloc]
               initWithTarget:self action:@selector(centerBoxOnTwoDoubleTap:)];

  doubleTap.numberOfTapsRequired = 2;
  doubleTap.numberOfTouchesRequired = 2;

  [self.view addGestureRecognizer:doubleTap];

  UIPanGestureRecognizer *viewPanner;
  viewPanner = [[UIPanGestureRecognizer alloc]
                initWithTarget:self action:@selector(panView:)];
  [self.view addGestureRecognizer:viewPanner];

  UIPanGestureRecognizer *boxPanner;
  boxPanner = [[UIPanGestureRecognizer alloc]
            initWithTarget:self action:@selector(panBox:)];
  [self.box addGestureRecognizer:boxPanner];

  self.screenPanEndLabel.accessibilityIdentifier = @"screen pan end";
  self.screenPanEndLabel.accessibilityLabel =
  NSLocalizedString(@"Screen pan end point",
                    @"The point where the screen pan ended.");
  self.screenPanEndLabel.text = @"";

  self.screenPanStartLabel.accessibilityIdentifier = @"screen pan start";
  self.screenPanStartLabel.accessibilityLabel =
  NSLocalizedString(@"Screen pan start point",
                    @"The point where the screen pan started.");
  self.screenPanStartLabel.text = @"";

  self.box.accessibilityIdentifier = @"box";
  self.box.accessibilityLabel =
  NSLocalizedString(@"Box", @"A box that can be dragged (panned) around");

}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self layoutLabelContainer:self.labelContainer];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.navigationItem.title =
  NSLocalizedString(@"Panning",
                    @"Title of navbar for view where you can pan");

  CalBarButtonItemFactory *factory = [[CalBarButtonItemFactory alloc] init];
  UIBarButtonItem *backButton;
  backButton = [factory barButtonItemBackWithTarget:self
                                             action:@selector(buttonTouchedBack:)];

  backButton.accessibilityLabel = [CalBarButtonItemFactory stringLocalizedBack];

  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.backBarButtonItem = nil;
  self.navigationItem.leftBarButtonItem = backButton;

  [self layoutLabelContainer:self.labelContainer];
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
