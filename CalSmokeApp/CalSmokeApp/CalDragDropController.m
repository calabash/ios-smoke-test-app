#import "CalDragDropController.h"

@interface CalDragDropController ()

@property (weak, nonatomic) IBOutlet UIImageView *redImageView;
@property (weak, nonatomic) IBOutlet UIImageView *blueImageView;
@property (weak, nonatomic) IBOutlet UIImageView *greenImageView;

@end

@implementation CalDragDropController

#pragma mark - Memory Management

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

#pragma mark View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"third page";
  self.view.accessibilityLabel = NSLocalizedString(@"Third page",
                                                   @"The third page of the app.");

  self.redImageView.accessibilityIdentifier = @"red";
  self.redImageView.accessibilityLabel = NSLocalizedString(@"red",
                                                            @"The color red");

  self.blueImageView.accessibilityIdentifier = @"blue";
  self.blueImageView.accessibilityLabel = NSLocalizedString(@"blue",
                                                            @"The color blue");

  self.greenImageView.accessibilityIdentifier = @"green";
  self.greenImageView.accessibilityLabel = NSLocalizedString(@"green",
                                                             @"The color green");
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
