// Created by Ignacio Delgado on 17/2/15.
#import "XamCollectionViewCell.h"

@interface XamCollectionViewCell ()
@property(nonatomic, strong) UILabel *label;
@end

@implementation XamCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.label = [self createLabel];
    [self.contentView addSubview:self.label];
  }

  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  self.label.frame = self.contentView.bounds;
}


#pragma mark - Public methods

- (void)setText:(NSString *)text {
  self.label.text = text;
}


#pragma mark - Private methods

- (UILabel *)createLabel {
  UILabel *label = [UILabel new];
  label.font = [UIFont systemFontOfSize:20];
  label.numberOfLines = 1;
  label.textAlignment = NSTextAlignmentCenter;
  return label;
}


@end