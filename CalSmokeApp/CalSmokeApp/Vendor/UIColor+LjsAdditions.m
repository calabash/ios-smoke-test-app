// Copyright 2012 Little Joy Software. All rights reserved.
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are
// met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Neither the name of the Little Joy Software nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY LITTLE JOY SOFTWARE ''AS IS'' AND ANY
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
// PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL LITTLE JOY SOFTWARE BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
// WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE
// OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN
// IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "UIImage+LjsCategory.h"

@implementation UIColor (UIColor_LjsAdditions)

+ (UIColor *) colorWithR:(CGFloat) r g:(CGFloat) g b:(CGFloat) b a:(CGFloat) a {
  return [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a];
}

+ (UIColor *) colorWithR:(CGFloat) r g:(CGFloat) g b:(CGFloat) b {
  return [UIColor colorWithR:r g:g b:b a:1.0];
}

+ (UIColor *) colorWithImageNamed:(NSString *) aImageName {
  UIImage *image = [UIImage imageNamed:aImageName];
  return [UIColor colorWithPatternImage:image];
}


+ (UIColor *) colorByBlendingBlurredSnapshotFromView:(UIView *) aView
                                              inRect:(CGRect) aFrame
                                                blur:(CGFloat) aBlur
                                          blendColor:(UIColor *) aBlendColor {
  UIImage *image = [UIImage imageByBlendingBlurredSnapshotFromView:aView
                                                            inRect:aFrame
                                                              blur:aBlur
                                                        blendColor:aBlendColor];
  return [UIColor colorWithPatternImage:image];
}


+ (UIColor *) colorByBlendingBlurredSnapshotFromTopViewInRect:(CGRect) aFrame
                                                         blur:(CGFloat) aBlur
                                                   blendColor:(UIColor *) aBlendColor {
  UIImage *image = [UIImage imageByBlendingBlurredSnapshotFromTopViewInRect:aFrame
                                                                       blur:aBlur
                                                                 blendColor:aBlendColor];
  return [UIColor colorWithPatternImage:image];
}


@end
