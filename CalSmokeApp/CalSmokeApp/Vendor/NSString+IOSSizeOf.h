#import <Foundation/Foundation.h>

/**
 https://gist.github.com/chrene/6158025
 */
@interface NSString (NSString_IOS_SizeOf)

- (CGSize) sizeOfStringWithFont:(UIFont *) aFont;
- (CGSize) sizeOfStringWithFont:(UIFont *) aFont constrainedToSize:(CGSize) aSize;
- (CGSize) sizeOfStringWithFont:(UIFont *) aFont constrainedToSize:(CGSize) aSize lineBreakMode:(NSLineBreakMode) aLineBreakMode;


- (CGSize) sizeOfStringWithFont:(UIFont *) aFont
                    minFontSize:(CGFloat) aMinSize
                 actualFontSize:(CGFloat *) aActualFontSize
                       forWidth:(CGFloat) aWidth
                  lineBreakMode:(NSLineBreakMode) aLineBreakMode;



@end
