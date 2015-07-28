#import "CalTableViewContoller.h"
#import "CalBarButtonItemFactory.h"
#import "UIView+Positioning.h"
#import "LjsLabelAttributes.h"
#import "NSString+IOSSizeOf.h"
#import "UIColor+LjsAdditions.h"

static NSString *const CalLogoRowIdentifier = @"logoRow";

typedef enum : NSInteger {
  kTagRowImageView = 3030,
  kTagRowLabel
} row_tags;

@interface CalTableViewContoller ()

@property(weak, nonatomic) IBOutlet UITableView *tableView;
@property(strong, nonatomic, readonly) NSArray *logoNames;
@property(strong, nonatomic, readonly) NSMutableArray *logoImages;
@property(strong, nonatomic, readonly) NSMutableArray *companyNames;

@end

@implementation CalTableViewContoller

#pragma mark - Memory Management

@synthesize logoNames = _logoNames;
@synthesize tableView = _tableView;
@synthesize logoImages = _logoImages;
@synthesize companyNames = _companyNames;

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

- (NSMutableArray *) logoImages {
  if (_logoImages) { return _logoImages; }

  _logoImages = [[NSMutableArray alloc] initWithCapacity:[self.logoNames count]];
  return _logoImages;
}

- (NSMutableArray *) companyNames {
  if (_companyNames) { return _companyNames; }

  _companyNames = [[NSMutableArray alloc] initWithCapacity:[self.logoNames count]];
  return _companyNames;
}

#pragma mark - <UITableViewDataSource>

- (NSInteger) tableView:(UITableView *) tableView
  numberOfRowsInSection:(NSInteger) aSection {
  return [self.logoNames count];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
  return 1;
}

- (UILabel *) labelForRowAtIndexPath:(NSIndexPath *) indexPath {
  CGRect frame = CGRectMake(78, 10, 120, 24);
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.tag = kTagRowLabel;
  label.text = [self textForRowAtIndexPath:indexPath];
  label.backgroundColor = [UIColor whiteColor];
  label.textAlignment = NSTextAlignmentLeft;
  label.textColor = [UIColor blackColor];
  label.font = [UIFont fontWithName:@"Avenir" size:18];
  return label;
}

- (UIImageView *) imageViewForRowAtIndexPath:(NSIndexPath *) indexPath {
  CGRect frame = CGRectMake(20, 2, 40, 40);
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
  imageView.tag = kTagRowImageView;
  imageView.image = [self imageForRowAtIndexPath:indexPath];
  imageView.opaque = YES;
  return imageView;
}

- (UIImage *) imageForRowAtIndexPath:(NSIndexPath *) indexPath {
  NSUInteger row = indexPath.row;
  if (row >= self.logoImages.count) {
    UIImage *image = [UIImage imageNamed:self.logoNames[row]];
    self.logoImages[row] = image;
  }
  return self.logoImages[row];
}

- (NSString *) textForRowAtIndexPath:(NSIndexPath *) indexPath {
  NSUInteger row = indexPath.row;
  if (row >= self.companyNames.count) {
    NSString *logoName = self.logoNames[row];
    NSString *companyName = [logoName stringByReplacingOccurrencesOfString:@"logo-"
                                                                withString:@""];

    if ([companyName isEqualToString:@"google-plus"]) {
      companyName = @"Google +";
    } else if ([companyName isEqualToString:@"icloud"]) {
      companyName = @"iCloud";
    } else {
      companyName = [companyName capitalizedString];
    }

    self.companyNames[row] =  companyName;
  }

  return self.companyNames[row];
}

- (UITableViewCell *) tableView:(UITableView *) tableView
          cellForRowAtIndexPath:(NSIndexPath *) indexPath {
  UITableViewCell *cell;
  cell = [tableView dequeueReusableCellWithIdentifier:CalLogoRowIdentifier];

  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                  reuseIdentifier:CalLogoRowIdentifier];

    [cell.contentView addSubview:[self imageViewForRowAtIndexPath:indexPath]];
    [cell.contentView addSubview:[self labelForRowAtIndexPath:indexPath]];
    cell.accessibilityIdentifier = [[self textForRowAtIndexPath:indexPath]
                                    lowercaseString];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.imageView.backgroundColor = [UIColor whiteColor];
  } else {
    UIImage *image = [self imageForRowAtIndexPath:indexPath];
    NSString *text = [self textForRowAtIndexPath:indexPath];

    UIView *contentView = cell.contentView;
    UIImageView *imageView = (UIImageView *)[contentView viewWithTag:kTagRowImageView];
    imageView.image = image;

    UILabel *label = (UILabel *)[contentView viewWithTag:kTagRowLabel];
    label.text = text;
    cell.accessibilityLabel = [text lowercaseString];
  }

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

  self.tableView.accessibilityIdentifier = @"logos";
  self.tableView.accessibilityLabel =
  NSLocalizedString(@"Logos", @"A table of corporate logos");
  self.tableView.backgroundColor = [UIColor whiteColor];
  self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
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

  UINavigationController *navcon = self.navigationController;
  if ([navcon respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
    navcon.interactivePopGestureRecognizer.enabled = YES;
    navcon.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [navcon.interactivePopGestureRecognizer addTarget:self
                                               action:@selector(buttonTouchedBack:)];
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
