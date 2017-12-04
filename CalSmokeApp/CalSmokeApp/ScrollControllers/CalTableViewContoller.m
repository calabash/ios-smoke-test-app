#import "CalTableViewContoller.h"
#import "CalBarButtonItemFactory.h"
#import "UIView+Positioning.h"
#import "LjsLabelAttributes.h"
#import "NSString+IOSSizeOf.h"
#import "UIColor+LjsAdditions.h"

static NSString *const CalLogoRowIdentifier = @"logoRow";

typedef enum : NSInteger {
  kTagRowImageView = 3030,
  kTagRowLabel,
  kTagRowLabelSubview
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

  _logoNames =
  @[
    @"amazon",
    @"android",
    @"apple",
    @"basecamp",
    @"blogger",
    @"digg",
    @"dropbox",
    @"evernote",
    @"facebook",
    @"fancy",
    @"flickr",
    @"foursquare",
    @"github",
    @"google-plus",
    @"google",
    @"icloud",
    @"instagram",
    @"linkedin",
    @"paypal",
    @"pinterest",
    @"quora",
    @"rdio",
    @"reddit",
    @"skype",
    @"spotify",
    @"steam",
    @"twitter",
    @"windows",
    @"wordpress",
    @"youtube"
    ];

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

- (UILabel *) labelForRowTitle {
  CGRect frame = CGRectMake(78, 10, 120, 24);
  UILabel *label = [[UILabel alloc] initWithFrame:frame];
  label.tag = kTagRowLabel;
  label.backgroundColor = [UIColor whiteColor];
  label.textAlignment = NSTextAlignmentLeft;
  label.textColor = [UIColor blackColor];
  label.font = [UIFont fontWithName:@"Avenir" size:18];

  return label;
}

- (UIView *)subviewForRowTitleLabel {
  UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
  view.tag = kTagRowLabelSubview;
  return view;
}

- (UIImageView *) imageViewForRow {
  CGRect frame = CGRectMake(20, 2, 40, 40);
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
  imageView.tag = kTagRowImageView;
  imageView.opaque = YES;
  return imageView;
}

- (UIImage *) imageForRowAtIndexPath:(NSIndexPath *) indexPath {
  NSUInteger row = indexPath.row;
  if (row >= self.logoImages.count) {
    NSString *logoName = self.logoNames[row];
    NSString *imageName = [NSString stringWithFormat:@"logo-%@", logoName];
    UIImage *image = [UIImage imageNamed:imageName];
    self.logoImages[row] = image;
  }
  return self.logoImages[row];
}

- (NSString *) textForRowAtIndexPath:(NSIndexPath *) indexPath {
  NSUInteger row = indexPath.row;
  if (row >= self.companyNames.count) {
    NSString *logoName = self.logoNames[row];
    NSString *companyName = [logoName copy];

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
    UILabel *titleLabel = [self labelForRowTitle];
    [titleLabel addSubview:[self subviewForRowTitleLabel]];
    [cell.contentView addSubview:titleLabel];
    [cell.contentView addSubview:[self imageViewForRow]];

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.backgroundColor = [UIColor whiteColor];
    cell.imageView.backgroundColor = [UIColor whiteColor];
  }

  UILabel *titleLabel = [cell.contentView viewWithTag:kTagRowLabel];
  UIView *subview = [titleLabel viewWithTag:kTagRowLabelSubview];
  UIImageView *imageView = [cell.contentView viewWithTag:kTagRowImageView];

  NSString *text = [self textForRowAtIndexPath:indexPath];
  titleLabel.text = text;
  subview.accessibilityIdentifier = [text stringByAppendingString:@" SUBVIEW"];

  imageView.image = [self imageForRowAtIndexPath:indexPath];
  cell.accessibilityIdentifier = [text lowercaseString];

  return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat) tableView:(UITableView *) tableView heightForRowAtIndexPath:(NSIndexPath *) indexPath {
  return 44;
}

#pragma mark - Orientation / Rotation

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000
- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}
#else
- (NSUInteger) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}
#endif

- (BOOL) shouldAutorotate {
  return YES;
}

#pragma mark - View Lifecycle

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
