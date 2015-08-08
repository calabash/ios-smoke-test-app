#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "CalDatePickerView.h"
#import "UIView+Positioning.h"

@interface NSLocale (CalAdditions)

- (BOOL) localeUses24HourClock;

@end

@interface NSCalendar (CalAdditions)

+ (NSCalendar *) gregorianCalendarWithMondayAsFirstDayOfWeek;

@end

@implementation NSLocale (CalAdditions)

- (BOOL) localeUses24HourClock {
  NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
  [formatter setLocale:self];
  [formatter setDateStyle:NSDateFormatterNoStyle];
  [formatter setTimeStyle:NSDateFormatterShortStyle];
  NSString *dateString = [formatter stringFromDate:[NSDate date]];
  NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
  NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
  BOOL is24Hour = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
  return is24Hour;
}

@end

@implementation NSCalendar (CalAdditions)

+ (NSCalendar *) gregorianCalendarWithMondayAsFirstDayOfWeek {
  NSCalendar *calendar;
  calendar = [[NSCalendar alloc]
              initWithCalendarIdentifier:NSGregorianCalendar];
  // iso spec http://en.wikipedia.org/wiki/ISO_week_date#First_week
  // not respected in iOS 5.0 so we set it here
  [calendar setMinimumDaysInFirstWeek:4];
  // monday - days are 1 indexed
  [calendar setFirstWeekday:2];
  return calendar;
}

@end

#pragma mark - Animations

@implementation CalDatePickerAnimationHelper

+ (CGFloat) maxY {
  return [[UIScreen mainScreen] bounds].size.height;
}
+ (void) configureNavbarForDateEditingWithAnimation:(BOOL)animated
                                         controller:(UIViewController<CalDatePickerViewDelegate> *)aController {
  [aController.navigationItem setRightBarButtonItem:nil animated:NO];
  UIBarButtonItem *cancel = [[UIBarButtonItem alloc]
                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                             target:aController
                             action:@selector(datePickerViewCancelButtonTouched)];
  cancel.accessibilityLabel = NSLocalizedString(@"cancel date picking",
                                                @"date: ACCESSIBILITY navbar/toolbar button - touching cancels date picking, rolling back any changes.");
  [aController.navigationItem setLeftBarButtonItem:cancel animated:animated];
}


+ (void) animateDatePickerOnWithController:(UIViewController<CalDatePickerViewDelegate> *) aController
                                    animations:(void (^)(void)) aAnimations
                                    completion:(void (^)(BOOL finished)) aCompletion {
  CalDatePickerView *pickerView = [aController pickerView];
  pickerView.alpha = 0.0;
  [aController.view addSubview:pickerView];
  pickerView.y = [CalDatePickerAnimationHelper maxY];
  pickerView.alpha = 1.0;
  
  CGFloat pickerY = 64;
  if (aController.hidesBottomBarWhenPushed == YES) { pickerY += 49; }
  //if (br_is_4in_iphone()) { pickerY += 568 - 480; }
  
  __weak UIViewController *wCon = aController;
  [UIView animateWithDuration:0.4
                        delay:0.1
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     aAnimations();
                     pickerView.y = pickerY;
                   }
                   completion:^(BOOL completed) {
                     aCompletion(completed);
                     [wCon.navigationItem setRightBarButtonItem:nil animated:NO];
                     [CalDatePickerAnimationHelper configureNavbarForDateEditingWithAnimation:YES
                                                                                      controller:aController];
                   }];
}



+ (void) animateDatePickerOffWithController:(UIViewController<CalDatePickerViewDelegate> *) aController
                                         before:(void (^)(void)) aBefore
                                     animations:(void (^)(void)) aAnimations
                                     completion:(void (^)(BOOL finished)) aCompletion {
  aBefore();
  
  CGFloat targetY = [CalDatePickerAnimationHelper maxY];
  CalDatePickerView *pickerView = [aController pickerView];
  [UIView animateWithDuration:0.4
                        delay:0.1
                      options:UIViewAnimationOptionCurveEaseIn
                   animations:^{
                     pickerView.y = targetY;
                     aAnimations();
                   }
                   completion:^(BOOL completed) {
                     [aController.navigationItem setLeftBarButtonItem:nil animated:YES];
                     [pickerView removeFromSuperview];
                     aCompletion(completed);
                   }];
}

@end

#pragma mark - Date Picker View

typedef enum : NSInteger {
  kTagLabel = 3030,
  kTagToolbar,
  kTagPicker
} view_tags;

static NSString *const k_24H_time_format = @"H:mm";
static NSString *const k_12H_time_format = @"h:mm a";
static NSString *const k_24H_date_format = @"EEE d MMM yyyy";
static NSString *const k_12H_date_format = @"EEE MMM d yyyy";

@interface CalDatePickerView ()

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, weak) id<CalDatePickerViewDelegate> delegate;
@property (nonatomic, strong, readonly) UILabel *label;
@property (nonatomic, strong, readonly) UIDatePicker *picker;
@property (nonatomic, assign) UIDatePickerMode pickerMode;
@property (nonatomic, strong, readonly) UIToolbar *toolbar;

- (void) datePickerDateDidChange:(id) sender;
- (void) buttonTouchedPickerDone:(id) sender;


- (NSString *) accessibilityIdentifierForMode:(UIDatePickerMode) aMode;
- (NSString *) stringForDate:(NSDate *)aDate withMode:(UIDatePickerMode) aMode;
- (NSString *) accessibilityIdentifierForPickerWithMode:(UIDatePickerMode) aMode;

- (BOOL) setMaximumDateToNow;
- (BOOL) setMinimumDateToNow;
- (BOOL) setDateToNow;

@end

@implementation CalDatePickerView

@synthesize label = _label;
@synthesize picker = _picker;
@synthesize toolbar = _toolbar;

#pragma mark Memory Management

- (id) init {
 // [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithFrame:(CGRect)frame {
 // [self doesNotRecognizeSelector:_cmd];
  return nil;
}

- (id) initWithDate:(NSDate *) aDate
           delegate:(id<CalDatePickerViewDelegate>) aDelegate
               mode:(UIDatePickerMode) aDatePickerMode {

  CGFloat width = [[UIScreen mainScreen] bounds].size.width;
  CGFloat x = (width/2.0) - (320/2.0);
  CGRect frame = CGRectMake(x, 0, 320 , 367);
  self = [super initWithFrame:frame];
  if (self) {
    self.date = aDate;
    self.delegate = aDelegate;
    self.pickerMode = aDatePickerMode;
    
    self.accessibilityIdentifier = [self accessibilityIdentifierForMode:aDatePickerMode];
  }
  return self;
}

- (void) layoutSubviews {
  [super layoutSubviews];
  
  if ([self viewWithTag:kTagLabel] == nil) {
    [self addSubview:[self label]];
  }
  
  if ([self viewWithTag:kTagPicker] == nil) {
    [self addSubview:[self picker]];
  }
  
  if ([self viewWithTag:kTagToolbar] == nil) {
    [self addSubview:[self toolbar]];
  }
}


#pragma mark - Views

- (UILabel *) label {
  if (_label != nil) { return _label; }
  CGRect frame = CGRectMake(20, 44, 280, 24);
  UILabel *result = [[UILabel alloc] initWithFrame:frame];
  result.textAlignment = NSTextAlignmentCenter;
  result.lineBreakMode = NSLineBreakByTruncatingMiddle;
  result.font = [UIFont boldSystemFontOfSize:18];
  result.text = [self stringForDate:self.date withMode:self.pickerMode];
  result.accessibilityIdentifier = @"time";
  result.tag = kTagLabel;
  _label = result;
  return result;
}

- (UIToolbar *) toolbar {
  if (_toolbar != nil) { return _toolbar; }
  CGFloat y = 107;
  CGRect frame = CGRectMake(0, y, 320, 44);
  UIToolbar *bar = [[UIToolbar alloc] initWithFrame:frame];
  bar.barStyle =  UIBarStyleDefault;
  UIBarButtonItem *left = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                           target:nil action:nil];
  UIBarButtonItem *right = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                            target:self action:@selector(buttonTouchedPickerDone:)];
  
  right.accessibilityLabel = NSLocalizedString(@"done picking date",
                                               @"date: ACCESSIBILITY button on toolbar/navbar - touching ends date picking and saves any changes");
  
  bar.items = @[left,right];
  bar.tag = kTagToolbar;
  _toolbar = bar;
  return bar;
}


- (UIDatePicker *) picker {
  if (_picker != nil) { return _picker; }
  
  CGFloat y = 151;
  CGRect frame = CGRectMake(0, y, 320, 216);
  UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:frame];
  datePicker.date = [self.date copy];
  NSCalendar *calendar = [NSCalendar gregorianCalendarWithMondayAsFirstDayOfWeek];

  datePicker.calendar = calendar;
  datePicker.maximumDate = nil;
  datePicker.minimumDate = nil;
  
  UIDatePickerMode mode = self.pickerMode;
  datePicker.datePickerMode =  mode;
  datePicker.minuteInterval = 1;
  datePicker.accessibilityIdentifier = [self accessibilityIdentifierForPickerWithMode:mode];
  [datePicker addTarget:self action:@selector(datePickerDateDidChange:) 
       forControlEvents:UIControlEventValueChanged];
  datePicker.tag = kTagPicker;
  _picker = datePicker;
  return datePicker;
}

#pragma mark Actions 

- (void) datePickerDateDidChange:(id)sender {
  NSLog(@"date picker did change");
  NSDate *newDate = self.picker.date;
  NSString *text = [self stringForDate:newDate withMode:self.pickerMode];
  self.label.text = text;
}


- (void) buttonTouchedPickerDone:(id)sender {
  NSLog(@"picker done button touched");
  [self.delegate datePickerViewDoneButtonTouchedWithDate:self.picker.date];
   
}

- (NSString *) accessibilityIdentifierForMode:(UIDatePickerMode) aMode {
  switch (aMode) {
    case UIDatePickerModeCountDownTimer: return @"count down picker";
    case UIDatePickerModeDate: return @"date picker";
    case UIDatePickerModeDateAndTime: return @"date and time picker";
    case UIDatePickerModeTime: return @"time picker";
  }
}

- (NSString *) stringForDate:(NSDate *)aDate withMode:(UIDatePickerMode) aMode {

  NSString *fmt = nil;
  switch (aMode) {
    case UIDatePickerModeCountDownTimer: { fmt = @"unknown"; break; }
    case UIDatePickerModeDate: { fmt = [self stringForDateFormat];  break;}
    case UIDatePickerModeDateAndTime: { fmt = [self stringForDateTimeFormat]; break;}
    case UIDatePickerModeTime: { fmt = [self stringForTimeFormat]; break; }
  }

  NSDateFormatter *df = [self dateFormatterWithFormat:fmt];
  NSString *str = [df stringFromDate:aDate];
  return str;
}

- (NSString *) accessibilityIdentifierForPickerWithMode:(UIDatePickerMode) aMode {
  switch (aMode) {
    case UIDatePickerModeCountDownTimer: return @"count down";
    case UIDatePickerModeDate: return @"date";
    case UIDatePickerModeDateAndTime: return @"date and time";
    case UIDatePickerModeTime: return @"time";
  }
}

- (NSString *) stringForDateFormat {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  BOOL uses24h = [locale localeUses24HourClock];
  NSString *dateFormat = uses24h ? k_24H_date_format : k_12H_date_format;
  return [NSString stringWithFormat:@"%@", dateFormat];
}

- (NSString *) stringForDateTimeFormat {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  BOOL uses24h = [locale localeUses24HourClock];
  NSString *timeFormat = uses24h ? k_24H_time_format : k_12H_time_format;
  NSString *dateFormat = uses24h ? k_24H_date_format : k_12H_date_format;
  return [NSString stringWithFormat:@"%@ %@", dateFormat, timeFormat];
}

-  (NSString *) stringForTimeFormat {
  NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
  // 24h use %HH for  00:01, 03:01, 11:01
  // 24h use %H  for   0:01,  3:01, 11:01
  // 24h use %k  for  24:01,  3:01, 11:01
  return [locale localeUses24HourClock] ? k_24H_time_format : k_12H_time_format;
}

- (NSDateFormatter *) dateFormatterWithFormat:(NSString *) aString {
  NSDateFormatter *formatter = [NSDateFormatter new];
  [formatter setDateFormat:aString];
  formatter.locale = [NSLocale autoupdatingCurrentLocale];
  formatter.timeZone = [NSTimeZone localTimeZone];
  [formatter setCalendar:[NSCalendar autoupdatingCurrentCalendar]];
  return formatter;
}

- (BOOL) setMaximumDateToNow {
  [self.picker setMaximumDate:[NSDate date]];
  return YES;
}

- (BOOL) setMinimumDateToNow {
  [self.picker setMinimumDate:[NSDate date]];
  return YES;
}

- (BOOL) setDateToNow {
  [self.picker setDate:[NSDate date]];
  return YES;
}


@end
