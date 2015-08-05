#import "CalViewsThatScrollController.h"
#import "UIColor+LjsAdditions.h"
#import "UIView+Positioning.h"
#import "CalCollectionViewController.h"
#import "CalTableViewContoller.h"
#import "CalScollViewController.h"
#import "CalMapController.h"

static NSString *const CalCellIdentifier = @"cell identifier";

typedef enum : NSInteger {
  kRowTableViews = 0,
  kRowsCollectionViews,
  kRowsScrollViews,
  kRowsWebViews,
  kRowsMapViews
} rows;

@interface CalViewsThatScrollController ()
<UITableViewDataSource, UITableViewDelegate>

@property(copy, nonatomic) NSArray *cellTitles;
@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic, readonly) UIColor *lightPink;

- (void) setContentInsets:(UITableView *) tableView;

@end

@implementation CalViewsThatScrollController

#pragma mark - Memory Management

@synthesize tableView = _tableView;
@synthesize lightPink = _lightPink;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

    NSString *title =
    NSLocalizedString(@"Scrolls", @"Title of tab bar item for views that scroll".);
    self.title = title;

    self.cellTitles = @[
                        @"Table views",
                        @"Collection views",
                        @"Scroll views",
                        @"Web views",
                        @"Map views"
                        ];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (UIColor *) lightPink {
  if (_lightPink) { return _lightPink; }
  _lightPink = [UIColor colorWithR:255.0f g:0.0f b:0.0f a:0.04f];
  return _lightPink;
}

#pragma mark - Orientation / Rotation

- (NSUInteger) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
  return YES;
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
  aCell.textLabel.backgroundColor = self.lightPink;
}

#pragma mark - UITableViewDelegate Managing Selections


- (void) tableView:(UITableView *) tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
  if (indexPath.row == kRowsCollectionViews) {
    UIViewController *controller =
    [[CalCollectionViewController alloc]
    initWithNibName:NSStringFromClass([CalCollectionViewController class])
     bundle:nil];
    [self.navigationController pushViewController:controller
                                         animated:YES];
  } else if (indexPath.row == kRowTableViews) {
    UIViewController *controller =
    [[CalTableViewContoller alloc]
     initWithNibName:NSStringFromClass([CalTableViewContoller class])
     bundle:nil];
    [self.navigationController pushViewController:controller
                                         animated:YES];

  } else if (indexPath.row == kRowsScrollViews) {
    UIViewController *controller =
    [[CalScollViewController alloc]
    initWithNibName:NSStringFromClass([CalScollViewController class])
     bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
  } else if (indexPath.row == kRowsMapViews) {
    UIViewController *controller =
    [[CalMapController alloc]
     initWithNibName:NSStringFromClass([CalMapController class])
     bundle:nil];
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

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"scrolls page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"List of views that scroll", @"A list of views that scroll.");

  self.view.backgroundColor = self.lightPink;

  UITableView *tableView = self.tableView;

  [tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:CalCellIdentifier];
  tableView.delegate = self;
  tableView.dataSource = self;

  tableView.accessibilityIdentifier = @"table";
  tableView.accessibilityLabel =
  NSLocalizedString(@"List of scrolling views",
                    @"A table view that list the different kinds of scrolling views");
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

  self.navigationItem.title = self.title;
  [self setContentInsets:self.tableView];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];

  UINavigationController *navcon = self.navigationController;
  if ([navcon respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    navcon.interactivePopGestureRecognizer.enabled = NO;
    navcon.interactivePopGestureRecognizer.delegate = nil;
    [navcon.interactivePopGestureRecognizer removeTarget:nil
                                                  action:NULL];
  }
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
}

@end
