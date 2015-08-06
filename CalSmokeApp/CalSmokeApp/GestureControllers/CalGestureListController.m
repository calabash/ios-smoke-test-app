#import "CalGestureListController.h"
#import "CalBarButtonItemFactory.h"
#import "UIView+Positioning.h"
#import "CalPanController.h"
#import "CalPinchController.h"
#import "CalTapGestureController.h"

static NSString *const CalCellIdentifier = @"cell identifier";

typedef enum : NSInteger {
  kRowTapping = 0,
  kRowPanning,
  kRowSwiping,
  kRowPinching,
  kRowRotating
} rows;

@interface CalGestureListController ()
<UITableViewDataSource, UITableViewDelegate>

@property(copy, nonatomic) NSArray *cellTitles;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CalGestureListController

#pragma mark - Memory Management

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    NSString *title =
    NSLocalizedString(@"Gestures", @"Title of tab bar item for views that respond to gestures.".);
    self.title = title;

    self.cellTitles = @[
                        @"Tapping",
                        @"Panning",
                        @"Swiping / Flicking",
                        @"Pinching",
                        @"Rotating"
                        ];
  }
  return self;
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) aSection {
  return [[self cellTitles] count];
}

- (UITableViewCell *) tableView:(UITableView *) tableView
          cellForRowAtIndexPath:(NSIndexPath *) indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CalCellIdentifier];

  NSString *title = self.cellTitles[indexPath.row];

  cell.textLabel.text = title;
  cell.accessibilityIdentifier = [NSString stringWithFormat:@"%@ row",
                                  [title lowercaseString]];

  return cell;
}

#pragma mark - UITableViewDelegate


#pragma mark UITableViewDelegate  Providing Table Cells for the Table View

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
  return 44;
}

- (void) tableView:(UITableView *) tableView willDisplayCell:(UITableViewCell *) aCell
 forRowAtIndexPath:(NSIndexPath *) indexPath {

}

#pragma mark - UITableViewDelegate Managing Selections


- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
  NSInteger row = indexPath.row;
  UIViewController *controller = nil;
  switch (row) {
    case kRowTapping: {
      controller = [[CalTapGestureController alloc]
                    initWithNibName:NSStringFromClass([CalTapGestureController class])
                    bundle:nil];
      break;
    }
    case kRowPanning: {
      controller = [[CalPanController alloc]
                    initWithNibName:NSStringFromClass([CalPanController class])
                    bundle:nil];
      break;
    }

    case kRowSwiping: {

      break;
    }

    case kRowPinching: {
      controller = [[CalPinchController alloc]
                    initWithNibName:NSStringFromClass([CalPinchController class])
                    bundle:nil];
      break;
    }

    case kRowRotating: {

      break;
    }
    default:
      break;
  }

  if (controller) {
    [self.navigationController pushViewController:controller animated:YES];
  }

  double delayInSeconds = 0.4;
  dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
  dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
  });
}

- (void) tableView:(UITableView *) tableView didDeselectRowAtIndexPath:(NSIndexPath *) indexPath {
  
}


#pragma mark - Orientation / Rotation

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
  return YES;
}

#pragma mark - View Lifecycle

- (void) setContentInsets:(UITableView *)tableView {
  UINavigationBar *navBar = self.navigationController.navigationBar;
  CGFloat topHeight = navBar.height;
  if (![[UIApplication sharedApplication] isStatusBarHidden]) {
    CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
    topHeight = topHeight + frame.size.height;
  }
  UITabBar *tabBar = self.tabBarController.tabBar;
  CGFloat bottomHeight = tabBar.height;

  tableView.contentInset = UIEdgeInsetsMake(topHeight, 0, bottomHeight, 0);
}


- (void) viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"gestures page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Gestures!", @"A view that responds to gestures.");

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:CalCellIdentifier];
  self.tableView.accessibilityIdentifier = @"List of gestures";
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self setContentInsets:self.tableView];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  UINavigationController *navcon = self.navigationController;
  if ([navcon respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    navcon.interactivePopGestureRecognizer.enabled = NO;
    navcon.interactivePopGestureRecognizer.delegate = nil;
    [navcon.interactivePopGestureRecognizer removeTarget:nil
                                                  action:NULL];
  }
  [self setContentInsets:self.tableView];
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
