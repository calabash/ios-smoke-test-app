#import "CalGesturesController.h"

@interface CalGesturesController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *gestureBox;
@property (weak, nonatomic) IBOutlet UILabel *lastGestureLabel;

- (void) handleDoubleTap:(UITapGestureRecognizer *) recognizer;
- (void) handleLongPress:(UILongPressGestureRecognizer *) recognizer;

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

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"gestures page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Gestures page", @"Page where gestures are tested");

  self.gestureBox.accessibilityIdentifier = @"gestures box";
  self.gestureBox.accessibilityLabel =
  NSLocalizedString(@"Gestures box", @"A square view to perform gestures in");

  [self.gestureBox addGestureRecognizer:[self doubleTapRecognizer]];
  [self.gestureBox addGestureRecognizer:[self longPressRecognizerWithDuration:1.0]];
  [self.gestureBox addGestureRecognizer:[self longPressRecognizerWithDuration:2.0]];

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
