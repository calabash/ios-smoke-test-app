#import "CalCollectionViewController.h"
#import "CalBarButtonItemFactory.h"
#import "UIView+Positioning.h"
#import "UIColor+LjsAdditions.h"


#pragma mark - CalLogoCell

static NSString *const CalLogoCellReuseIdentifier = @"logoCell";

@interface CalLogoCell : UICollectionViewCell

@property(strong, nonatomic) UIImageView *imageView;

@end

@implementation CalLogoCell

@synthesize imageView = _imageView;

- (instancetype) initWithFrame:(CGRect) frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIView *contentView = [self contentView];

    CGFloat padding = 16;
    CGFloat width = CGRectGetWidth(frame) - (2 * padding);
    CGFloat height = CGRectGetHeight(frame) - (2 * padding);
    CGRect imageViewFrame = CGRectMake(padding, padding, width, height);

    _imageView = [[UIImageView alloc] initWithFrame:imageViewFrame];

    [contentView addSubview:_imageView];

  }
  return self;
}

@end

#pragma mark - CalBoxCell

static NSString *const CalBoxCellReuseIdentifier = @"boxCell";

@interface CalBoxCell : UICollectionViewCell

@property(strong, atomic) UIView *colorView;

@end

@implementation CalBoxCell

@synthesize colorView = _colorView;

- (instancetype) initWithFrame:(CGRect) frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIView *contentView = [self contentView];

    CGFloat padding = 8;
    CGFloat width = CGRectGetWidth(frame) - (2 * padding);
    CGFloat height = CGRectGetHeight(frame) - (2 * padding);
    CGRect outerFrame = CGRectMake(padding, padding, width, height);

    UIView *outer = [[UIView alloc] initWithFrame:outerFrame];
    outer.backgroundColor = [UIColor colorWithR:204 g:204 b:204];
    [contentView addSubview:outer];


    padding = 2;
    width = CGRectGetWidth(outerFrame) - (2 * padding);
    height = CGRectGetHeight(outerFrame) - (2 * padding);
    CGRect colorFrame = CGRectMake(padding, padding, width, height);

    _colorView = [[UIView alloc] initWithFrame:colorFrame];

    [outer addSubview:_colorView];

  }
  return self;
}

@end

typedef enum : NSUInteger {
  kSectionRed = 0,
  kSectionBlue,
  kSectionGreen,
  kSectionOrange,
  kSectionPurple,
  kSectionBlack,
  kNumberOfSections
} ColoredBoxesSections;

#pragma mark - View Controller

@interface CalCollectionViewController ()

@property(weak, nonatomic) IBOutlet UICollectionView *logoCollectionView;
@property(strong, nonatomic, readonly) NSArray *logoNames;

@property(weak, nonatomic) IBOutlet UICollectionView *boxesCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boxesCollectionBottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *boxesCollectionTopConstraint;
- (UIColor *) colorForBoxAtIndexPath:(NSIndexPath *) indexPath;
- (NSString *) accessibilityIdentifierForBoxAtIndexPath:(NSIndexPath *) indexPath;

- (void) updateContentInsetsCollectionView:(UICollectionView *) collectionView;

@end

@implementation CalCollectionViewController

@synthesize logoCollectionView = _logoCollectionView;
@synthesize logoNames = _logoNames;
@synthesize boxesCollectionView = _boxesCollectionView;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
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

- (UIColor *) colorForBoxAtIndexPath:(NSIndexPath *) indexPath {
  NSInteger item = indexPath.item;
  switch ((ColoredBoxesSections)indexPath.section) {
    case kSectionRed: { return [UIColor colorWithR:255 - (5 * item) g:0 b:0]; }

    case kSectionBlue: { return [UIColor colorWithR:0 g:0 b:255 - (5 * item)]; }

    case kSectionGreen:  { return [UIColor colorWithR:0 g:255 - (5 * item) b:0]; }

    case kSectionOrange: {
      return [UIColor colorWithR:255
                               g:MIN(128 - (5 * item), 255)
                               b:5 * item];
    }

    case kSectionPurple: {
      return [UIColor colorWithR:MIN(128 - (5 * item), 255)
                               g:0
                               b:MIN(128 - (5 * item), 255)];
    }

    case kSectionBlack: {
      return [UIColor colorWithR:255 - (5 * item)
                               g:255 - (5 * item)
                               b:255 - (5 * item)];
    }
    default: { return [UIColor yellowColor]; }
  }
}

- (NSString *) accessibilityIdentifierForBoxAtIndexPath:(NSIndexPath *) indexPath {
  NSInteger item = indexPath.item;
  switch ((ColoredBoxesSections)indexPath.section) {
    case kSectionRed: { return [NSString stringWithFormat:@"red %@", @(item)]; }

    case kSectionBlue: { return [NSString stringWithFormat:@"blue %@", @(item)]; }

    case kSectionGreen:  { return [NSString stringWithFormat:@"green %@", @(item)]; }

    case kSectionOrange: { return [NSString stringWithFormat:@"orange %@", @(item)]; }

    case kSectionPurple: { return [NSString stringWithFormat:@"purple %@", @(item)]; }

    case kSectionBlack: { return [NSString stringWithFormat:@"black %@", @(item)]; }
    default: { return @"Error!"; }
  }

}

#pragma mark - Orientation / Rotation

- (NSUInteger)supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
  return YES;
}

#pragma mark - Navigation

- (void) buttonTouchedBack:(id) sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateContentInsetsCollectionView:(UICollectionView *) collectionView {
  UINavigationBar *navBar = self.navigationController.navigationBar;
  CGFloat topHeight = navBar.height;
  if (![[UIApplication sharedApplication] isStatusBarHidden]) {
    CGRect frame = [[UIApplication sharedApplication] statusBarFrame];
    topHeight = topHeight + frame.size.height;
  }
  UITabBar *tabBar = self.tabBarController.tabBar;
  CGFloat bottomHeight = tabBar.height;

  collectionView.contentInset = UIEdgeInsetsMake(topHeight, 0, bottomHeight, 0);
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
  if (collectionView == _boxesCollectionView) {
    return kNumberOfSections;
  } else {
    return 1;
  }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if (collectionView == _boxesCollectionView) {
    return 24;
  } else {
    return [self.logoNames count];
  }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {

  if (collectionView == _boxesCollectionView) {
    CalBoxCell *cell =
    (CalBoxCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CalBoxCellReuseIdentifier
                                                            forIndexPath:indexPath];

    cell.colorView.backgroundColor = [self colorForBoxAtIndexPath:indexPath];
    cell.colorView.accessibilityIdentifier = [self accessibilityIdentifierForBoxAtIndexPath:indexPath];
    return cell;
  } else {

    CalLogoCell *cell =
    (CalLogoCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CalLogoCellReuseIdentifier
                                                             forIndexPath:indexPath];

    NSString *logoName = [self logoNames][indexPath.item];
    UIImage *image = [UIImage imageNamed:logoName];
    cell.imageView.image = image;
    NSString *companyName = [logoName stringByReplacingOccurrencesOfString:@"logo-"
                                                                withString:@""];

    cell.accessibilityIdentifier = companyName;
    cell.accessibilityLabel = [companyName capitalizedString];

    cell.backgroundColor = [UIColor whiteColor];

    return cell;
  }
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  if (collectionView == _boxesCollectionView) {
    return CGSizeMake(44, 44);
  } else {
    return CGSizeMake(60, 60);
  }
}

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section {
  return CGSizeZero;
}

- (CGSize) collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
  return CGSizeZero;
}

- (UIEdgeInsets) collectionView:(UICollectionView *)collectionView
                         layout:(UICollectionViewLayout *)collectionViewLayout
         insetForSectionAtIndex:(NSInteger)section {
  if (collectionView == _boxesCollectionView) {
    return UIEdgeInsetsMake(4, 0, 4, 0);
  } else {
    return UIEdgeInsetsMake(8, 8, 8, 8);
  }
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {

  return 0.0;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
  if (collectionView == _boxesCollectionView) {
    return 0;
  } else {
    return 4;
  }
}

#pragma mark - <UICollectionViewDelegate>

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];


  self.view.accessibilityIdentifier = @"collection views page";
  self.view.accessibilityLabel =
  NSLocalizedString(@"Collection views", @"A view with collections.");


  self.logoCollectionView.accessibilityIdentifier = @"logo gallery";
  self.logoCollectionView.accessibilityLabel =
  NSLocalizedString(@"Logo gallery", @"A collection of corporate logos");

  [self.logoCollectionView registerClass:[CalLogoCell class]
              forCellWithReuseIdentifier:CalLogoCellReuseIdentifier];

  self.boxesCollectionView.accessibilityIdentifier = @"color gallery";
  self.boxesCollectionView.accessibilityLabel =
  NSLocalizedString(@"Color gallery", @"A collection of colored boxes");

  [self.boxesCollectionView registerClass:[CalBoxCell class]
               forCellWithReuseIdentifier:CalBoxCellReuseIdentifier];
}

- (void) viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];
  [self updateContentInsetsCollectionView:self.boxesCollectionView];
}

- (void) viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  self.navigationItem.title = NSLocalizedString(@"Collections",
  @"Title of navigation bar for page with collection views");

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

  [self updateContentInsetsCollectionView:self.boxesCollectionView];
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
