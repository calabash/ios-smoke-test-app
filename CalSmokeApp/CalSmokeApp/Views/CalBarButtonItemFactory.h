#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
  WtBarButtonPositionLeft = 0,
  WtBarButtonPositionRight
} WtBarButtonPosition;

@interface CalBarButtonItemFactory : NSObject

#pragma mark - Colors

+ (UIColor *) colorForDefaultBlue;

#pragma mark - Back Buttons

+ (NSString *) stringLocalizedBack;
+ (NSString *) stringLocalizedHome;
+ (NSString *) stringLocalizedMap;

- (UIBarButtonItem *) barButtonItemBackWithTarget:(id) aTarget
                                           action:(SEL) aAction;

- (UIBarButtonItem *) barButtonItemBackWithTarget:(id) aTarget
                                           action:(SEL) aAction
                                            color:(UIColor *) aColor;

- (UIBarButtonItem *) barButtonItemBackWithTarget:(id)aTarget
                                           action:(SEL)aAction
                                            color:(UIColor *)aColor
                                        titleFont:(UIFont *) aFont
                                   localizedTitle:(NSString *) aLocalizedTile;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)aTitle
                                 titleColor:(UIColor *)aTitleColor
                                       font:(UIFont *)aFont
                                     target:(id)aTarget
                                     action:(SEL)aAction
                                accessLabel:(NSString *)aAccessLabel
                                   accessId:(NSString *)aAccessId
                                   position:(WtBarButtonPosition)aPosition;

@end
