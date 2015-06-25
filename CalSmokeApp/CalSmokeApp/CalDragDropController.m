// http://www.edumobile.org/ios/simple-drag-and-drop-on-iphone/

#import "CalDragDropController.h"

typedef enum : NSInteger {
  kTagRedImageView = 3030,
  kTagBlueImageView,
  kTagGreenImageView
} ViewTags;

@interface CalDragDropController ()

@property (weak, nonatomic) IBOutlet UIImageView *redImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;
@property (weak, nonatomic) IBOutlet UIView *leftDropTarget;
@property (weak, nonatomic) IBOutlet UIView *rightDropTarget;

@property (strong, nonatomic, readonly) UIColor *redColor;
@property (strong, nonatomic, readonly) UIColor *blueColor;
@property (strong, nonatomic, readonly) UIColor *greenColor;

- (UIColor *)colorForImageView:(UIImageView *)imageView;

@end

@implementation CalDragDropController

#pragma mark - Memory Management

@synthesize redColor = _redColor;
@synthesize blueColor = _blueColor;
@synthesize greenColor = _greenColor;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.tabBarItem = [[UITabBarItem alloc]
                       initWithTabBarSystemItem:UITabBarSystemItemContacts
                       tag:2];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - Colors

- (UIColor *)redColor {
  if (_redColor) { return _redColor; }
  _redColor = [UIColor colorWithRed:153/255.0
                              green:39/255.0
                               blue:39/255.0
                              alpha:1.0];
  return _redColor;
}

- (UIColor *)blueColor {
  if (_blueColor) { return _blueColor; }
  _blueColor = [UIColor colorWithRed:29/255.0
                              green:90/255.0
                               blue:171/255.0
                              alpha:1.0];
  return _blueColor;
}

- (UIColor *)greenColor {
  if (_greenColor) { return _greenColor; }
  _greenColor = [UIColor colorWithRed:33/255.0
                               green:128/255.0
                                blue:65/255.0
                               alpha:1.0];
  return _greenColor;
}

- (UIColor *)colorForImageView:(UIImageView *)imageView {
  NSInteger tag = imageView.tag;
  switch (tag) {
    case kTagRedImageView: { return self.redColor; }
    case kTagBlueImageView: { return self.blueColor; }
    case kTagGreenImageView: { return self.greenColor; }
    default:
      return nil;
      break;
  }
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"third page";
  self.view.accessibilityLabel = NSLocalizedString(@"Third page",
                                                   @"The third page of the app.");

  self.redImageView.accessibilityIdentifier = @"red";
  self.redImageView.accessibilityLabel = NSLocalizedString(@"red",
                                                            @"The color red");
  self.redImageView.tag = kTagRedImageView;

  self.blueImageView.accessibilityIdentifier = @"blue";
  self.blueImageView.accessibilityLabel = NSLocalizedString(@"blue",
                                                            @"The color blue");
  self.blueImageView.tag = kTagBlueImageView;

  self.greenImageView.accessibilityIdentifier = @"green";
  self.greenImageView.accessibilityLabel = NSLocalizedString(@"green",
                                                             @"The color green");
  self.greenImageView.tag = kTagGreenImageView;

  self.leftDropTarget.accessibilityIdentifier = @"left well";
  self.leftDropTarget.accessibilityLabel = NSLocalizedString(@"Left drop target",
                                                             @"The drop target on the left side");

  self.rightDropTarget.accessibilityIdentifier = @"right well";
  self.rightDropTarget.accessibilityLabel = NSLocalizedString(@"Right drop target",
                                                             @"The drop target on the right side");
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
