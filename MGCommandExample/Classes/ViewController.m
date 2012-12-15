#import "ViewController.h"
#import "Objection.h"
#import "MGAsyncCommand.h"
#import "MGSequentialCommandGroup.h"
#import "PrintCommand.h"
#import "DelayCommand.h"

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

	[self clearOutput];
	_startButton.enabled = NO;

	[self startCommandExecution];
}

- (void)startCommandExecution
{
	id <MGAsyncCommand> commandGroup = [self createCommandGroup];

	commandGroup.callback = ^
	{
		[self finishExecution];
	};

	[commandGroup execute];
}

- (id <MGAsyncCommand>)createCommandGroup
{
	MGCommandGroup *commandGroup = [[MGCommandGroup alloc] init];
	[commandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[commandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[commandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];

	MGSequentialCommandGroup *mainCommandGroup = [[MGSequentialCommandGroup alloc] init];
	[mainCommandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[mainCommandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[mainCommandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[mainCommandGroup addCommand:[[PrintCommand alloc] initWithMessage:@"concurrent {"]];
	[mainCommandGroup addCommand:commandGroup];
	[mainCommandGroup addCommand:[[PrintCommand alloc] initWithMessage:@"}"]];
	[mainCommandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[mainCommandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[mainCommandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[mainCommandGroup addCommand:[[PrintCommand alloc] initWithMessage:@"Finished"]];

	return mainCommandGroup;
}

- (void)finishExecution
{
	[_activityIndicator stopAnimating];
	_activityIndicator.hidden = YES;

	_startButton.enabled = YES;
}

- (void)addOutput:(NSString *)output
{
	if ([_outputLabel.text isEqualToString:@""])
	{
		_outputLabel.text = output;
	}
	else
	{
		_outputLabel.text = [NSString stringWithFormat:@"%@\n%@", _outputLabel.text, output];
	}

	[_outputLabel sizeToFit];
}

- (void)clearOutput
{
	_outputLabel.text = @"";
}

@end