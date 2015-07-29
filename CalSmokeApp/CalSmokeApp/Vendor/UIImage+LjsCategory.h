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

#import <Foundation/Foundation.h>

/**
 UIImage on UIImage_LjsCategory category.
 */
@interface UIImage (UIImage_LjsCategory)

/** @name Task Section */
- (UIImage *) imageByReszingWithSize:(CGSize) aSize;

/**
 http://tinyurl.com/lnstbuq
 http://tinyurl.com/mu7hqgz
 attributions to: Jake Gundersen and Jeremy Fox
 */
+ (UIImage *) imageByBlurringSnapshotFromView:(UIView *) aView inRect:(CGRect) aFrame blur:(CGFloat) aBlur;
- (UIImage *) imageByBlurringWithBlur:(CGFloat) aBlur;
+ (UIImage *) imageWithColor:(UIColor *) aColor size:(CGSize) aSize;
+ (UIImage *) imageByBlendingTop:(UIImage *) aTop bottom:(UIImage *) aBottom;

/*
 CGRect frame = alertPanel.frame;
 UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
 UIView *toBlur = topController.view;
 UIImage *blurred = [self getBlurredImageFromView:toBlur inRect:frame blur:0.9f];
 UIColor *color = [UIColor colorWithR:243 g:247 b:246 a:0.8f];
 UIImage *white = [self imageWithColor:color size:frame.size cornerRadius:0];
 UIImage *blended = [self blendWithTop:white bottom:blurred];
 
 alertPanel.backgroundColor =   [UIColor colorWithPatternImage:blended];

 */

+ (UIImage *) imageByBlendingBlurredSnapshotFromView:(UIView *) aView
                                              inRect:(CGRect) aFrame
                                                blur:(CGFloat) aBlur
                                          blendColor:(UIColor *) aBlendColor;

+ (UIImage *) imageByBlendingBlurredSnapshotFromTopViewInRect:(CGRect) aFrame
                                                         blur:(CGFloat) aBlur
                                                   blendColor:(UIColor *) aBlendColor;


@end
