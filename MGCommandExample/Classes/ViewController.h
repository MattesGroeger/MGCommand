#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (nonatomic) IBOutlet UIButton *startButton;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) IBOutlet UILabel *outputLabel;

- (void)addOutput:(NSString *)output;

- (void)clearOutput;

@end
