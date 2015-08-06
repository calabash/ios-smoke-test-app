#import "CalTapGestureController.h"
#import "CalBarButtonItemFactory.h"

@interface CalTapGestureController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *leftBox;
@property (weak, nonatomic) IBOutlet UIView *rightBox;
@property (weak, nonatomic) IBOutlet UILabel *lastGestureLabel;

- (void) handleDoubleTap:(UITapGestureRecognizer *) recognizer;
- (void) handleLongPress:(UILongPressGestureRecognizer *) recognizer;

@end

@implementation CalTapGestureController


#pragma mark - Memory Management

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

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

#pragma mark - GestureRecognizers

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
  return YES;
}

- (UIGestureRecognizer *) doubleTapRecognizer {
  SEL selector = @selector(handleDoubleTap:);
  UITapGestureRecognizer *recognizer;
  recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                       action:selector];
  recognizer.numberOfTapsRequired = 2;
  recognizer.numberOfTouchesRequired = 1;
  return recognizer;
}

- (void) handleDoubleTap:(UITapGestureRecognizer *) recognizer {
  UIGestureRecognizerState state = [recognizer state];
  if (UIGestureRecognizerStateEnded == state) {
    self.lastGestureLabel.text = @"Double tap";
  }
}

- (UILongPressGestureRecognizer *) longPressRecognizerWithDuration:(NSTimeInterval) duration {
  SEL selector = @selector(handleLongPress:);
  UILongPressGestureRecognizer *recognizer;
  recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                             action:selector];
  recognizer.minimumPressDuration = duration;
  recognizer.delegate = self;
  return recognizer;
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)recognizer {
  UIGestureRecognizerState state = [recognizer state];
  NSLog(@"Long press state = %@", @(state));
  if (UIGestureRecognizerStateBegan == state) {
    self.lastGestureLabel.text = @"Long press began";
  } else if (UIGestureRecognizerStateEnded == state) {

    self.lastGestureLabel.text = [NSString stringWithFormat:@"Long press: %@ seconds",
                                  @(recognizer.minimumPressDuration)];
  }
}

#pragma mark - View Lifecycle

- (void) buttonTouchedBack:(id) sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"tapping page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Tapping page", @"Page where tap gestures are tested");

  self.leftBox.accessibilityIdentifier = @"left box";
  self.leftBox.accessibilityLabel =
  NSLocalizedString(@"Left box", @"The tappable view on the left side of the page");

  [self.leftBox addGestureRecognizer:[self doubleTapRecognizer]];
  [self.leftBox addGestureRecognizer:[self longPressRecognizerWithDuration:1.0]];

  self.rightBox.accessibilityIdentifier = @"right box";
  self.rightBox.accessibilityLabel =
  NSLocalizedString(@"Right box", @"The tappable view on the right side of the page");
  [self.rightBox addGestureRecognizer:[self longPressRecognizerWithDuration:2.0]];

  self.lastGestureLabel.accessibilityIdentifier = @"last gesture";
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
  NSLocalizedString(@"Tapping",
                    @"Title of navbar for view where you can tap and press");

  CalBarButtonItemFactory *factory = [[CalBarButtonItemFactory alloc] init];
  UIBarButtonItem *backButton;
  backButton = [factory barButtonItemBackWithTarget:self
                                             action:@selector(buttonTouchedBack:)];

  backButton.accessibilityLabel = [CalBarButtonItemFactory stringLocalizedBack];

  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.backBarButtonItem = nil;
  self.navigationItem.leftBarButtonItem = backButton;

  self.lastGestureLabel.text = @"";
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
