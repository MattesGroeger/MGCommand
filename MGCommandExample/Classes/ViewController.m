#import "ViewController.h"
#import "Objection.h"

@implementation ViewController

objection_register_singleton(ViewController)

- (void)awakeFromObjection
{
	[self initWithNibName:@"ViewController" bundle:nil];
}

- (void)viewDidLoad
{
	_activityIndicator.hidden = YES;
	_outputLabel.text = @"";
	[_startButton addTarget:self action:@selector(onStartButton) forControlEvents:UIControlEventTouchUpInside];

	[super viewDidLoad];
}

- (void)onStartButton
{
	_activityIndicator.hidden = NO;
	[_activityIndicator startAnimating];

	_startButton.enabled = NO;
}

@end
