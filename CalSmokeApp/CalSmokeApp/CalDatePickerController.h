#import "CalDatePickerView.h"


@interface CalDatePickerController : UIViewController
<CalDatePickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *buttonTime;
- (IBAction)buttonTouchedTime:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonDateAndTime;
- (IBAction)buttonTouchedDateAndTime:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonDate;
- (IBAction)buttonTouchedDate:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *buttonCountdown;
- (IBAction)buttonTouchedCountdown:(id)sender;

@end
