#import <Foundation/Foundation.h>

@class CalDatePickerView;

@protocol CalDatePickerViewDelegate <NSObject>

@required
- (void) datePickerViewDoneButtonTouchedWithDate:(NSDate *) aDate;
- (void) datePickerViewCancelButtonTouched;
- (CalDatePickerView *) pickerView;


@end

@interface CalDatePickerAnimationHelper : NSObject

+ (void) configureNavbarForDateEditingWithAnimation:(BOOL)animated
                                         controller:(UIViewController<CalDatePickerViewDelegate> *) aController;

+ (void) animateDatePickerOnWithController:(UIViewController<CalDatePickerViewDelegate> *) aController
                                animations:(void (^)(void)) aAnimations
                                completion:(void (^)(BOOL finished)) aCompletion;

+ (void) animateDatePickerOffWithController:(UIViewController<CalDatePickerViewDelegate> *) aController
                                     before:(void (^)(void)) aBefore
                                 animations:(void (^)(void)) aAnimations
                                 completion:(void (^)(BOOL finished)) aCompletion;


@end

/**
 Documentation
 */
@interface CalDatePickerView : UIView

/** @name Properties */

/** @name Initializing Objects */
- (id) initWithDate:(NSDate *) aDate
           delegate:(id<CalDatePickerViewDelegate>) aDelegate
               mode:(UIDatePickerMode) aDatePickerMode;


/** @name Handling Notifications, Requests, and Events */

/** @name Utility */


@end
