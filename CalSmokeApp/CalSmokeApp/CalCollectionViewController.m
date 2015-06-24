//  Created by Ignacio Delgado on 17/2/15.
#import "CalCollectionViewController.h"
#import "XamCollectionViewCell.h"

static NSString * const reuseIdentifier = @"Cell";
static const NSInteger kCollectionViewNumItems = 5;

#pragma mark - CollectionView Datasource

@interface XamCollectionViewDataSource : NSObject <UICollectionViewDataSource>
@end

@implementation XamCollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return kCollectionViewNumItems;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  XamCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
  cell.backgroundColor = [UIColor whiteColor];
  [cell setText:[NSString stringWithFormat:@"Cell number %@", @(indexPath.item + 1)]];
  [cell setAccessibilityIdentifier:[NSString stringWithFormat:@"cell %@", @(indexPath.item + 1)]];
  return cell;
}

@end

#pragma mark - CollectionView Controller

@interface CalCollectionViewController ()
@property(nonatomic, strong) XamCollectionViewDataSource *dataSource;
@end

@implementation CalCollectionViewController

- (instancetype) init {
  self = [super initWithCollectionViewLayout:[UICollectionViewFlowLayout new]];
  if (self){
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
      self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];

    if ([self respondsToSelector:@selector(collectionViewLayout)]) {
      ((UICollectionViewFlowLayout *)self.collectionViewLayout).minimumLineSpacing = 1.f;
    }
    self.dataSource = [XamCollectionViewDataSource new];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.view setAccessibilityIdentifier:@"second page"];

  self.collectionView.dataSource = self.dataSource;
  [self.collectionView registerClass:[XamCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
}

- (void)viewWillLayoutSubviews {
  [super viewWillLayoutSubviews];

  if ([self respondsToSelector:@selector(collectionViewLayout)]) {
    ((UICollectionViewFlowLayout *)self.collectionViewLayout).itemSize = CGSizeMake(CGRectGetWidth(self.view.bounds), floorf(CGRectGetHeight(self.view.bounds)/(kCollectionViewNumItems - 1)));
  }
}

@end
