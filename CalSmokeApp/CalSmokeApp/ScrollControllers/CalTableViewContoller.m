#import "CalTableViewContoller.h"
#import "CalBarButtonItemFactory.h"
#import "UIView+Positioning.h"

static NSString *const CalLogoRowIdentifier = @"logoRow";

@interface CalTableViewContoller ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic, readonly) NSArray *logoNames;

@end

@implementation CalTableViewContoller

#pragma mark - Memory Management

@synthesize logoNames = _logoNames;
@synthesize tableView = _tableView;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (NSArray *) logoNames {
  if (_logoNames) { return _logoNames; }

  NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
  NSArray *dirContents = [[NSFileManager defaultManager]
                          contentsOfDirectoryAtPath:bundleRoot
                          error:nil];

  NSPredicate *begins = [NSPredicate predicateWithFormat:@"self BEGINSWITH 'logo-'"];
  NSPredicate *png = [NSPredicate predicateWithFormat:@"pathExtension='png'"];
  NSPredicate *at = [NSPredicate predicateWithFormat:@"self CONTAINS '@'"];
  NSPredicate *notAt = [NSCompoundPredicate notPredicateWithSubpredicate:at];
  NSPredicate *and = [NSCompoundPredicate andPredicateWithSubpredicates:@[begins, png, notAt]];
  NSArray *logos = [dirContents filteredArrayUsingPredicate:and];

  NSMutableArray *stripped = [[NSMutableArray alloc] initWithCapacity:[logos count]];
  [logos enumerateObjectsUsingBlock:^(NSString *name, NSUInteger idx, BOOL *stop) {
    NSArray *tokens = [name componentsSeparatedByString:@"."];
    [stripped addObject:tokens[0]];
  }];

  _logoNames = [NSArray arrayWithArray:stripped];

  return _logoNames;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) aSection {
  return [self.logoNames count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
  return 1;
}

- (UITableViewCell *) tableView:(UITableView *) tableView
          cellForRowAtIndexPath:(NSIndexPath *) indexPath {
  UITableViewCell *cell;
  cell = [tableView dequeueReusableCellWithIdentifier:CalLogoRowIdentifier];

  NSString *logoName = [self logoNames][indexPath.item];
  UIImage *image = [UIImage imageNamed:logoName];
  cell.imageView.image = image;
  NSString *companyName = [logoName stringByReplacingOccurrencesOfString:@"logo-"
                                                              withString:@""];

  if ([companyName isEqualToString:@"google-plus"]) {
    companyName = @"google +";
  }
  cell.accessibilityIdentifier = companyName;
  cell.accessibilityLabel = [companyName capitalizedString];

  cell.textLabel.text = [companyName capitalizedString];
  return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
  return 44;
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

- (void) buttonTouchedBack:(id) sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.accessibilityIdentifier = @"table views page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Table views", @"A view with table views.");

  [self.tableView registerClass:[UITableViewCell class]
         forCellReuseIdentifier:CalLogoRowIdentifier];
  self.tableView.accessibilityIdentifier = @"logos";
  self.tableView.accessibilityLabel =
  NSLocalizedString(@"Logos", @"A table of corporate logos");
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

  self.navigationItem.title = NSLocalizedString(@"Tables",
                                                @"Title of navigation bar");

  CalBarButtonItemFactory *factory = [[CalBarButtonItemFactory alloc] init];
  UIBarButtonItem *backButton;
  backButton = [factory barButtonItemBackWithTarget:self
                                             action:@selector(buttonTouchedBack:)];

  backButton.accessibilityLabel = [CalBarButtonItemFactory stringLocalizedBack];

  self.navigationItem.hidesBackButton = YES;
  self.navigationItem.backBarButtonItem = nil;
  self.navigationItem.leftBarButtonItem = backButton;

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
