#import "AutoStartViewController.h"
#import "MGSequentialCommandGroup.h"
#import "CountCommand.h"


@implementation AutoStartViewController

- (void)viewDidLoad
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onUpdate)
												 name:@"finished"
											   object:nil];

	_activityIndicator.hidden = YES;
	_enqueuedItemsLabel.text = @"Waiting for touches...";
	
	_outputLabel.text = @"0";
	_cancelButton.hidden = YES;

	// create sequential auto start group once
    __weak AutoStartViewController *this = self;
	_autoStartQueue = [MGSequentialCommandGroup autoStartGroup];
	_autoStartQueue.callback = ^
	{
		[this queueFinished];
	};

	[super viewDidLoad];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	// we add a new command on every touch:
	[_autoStartQueue addCommand:[[CountCommand alloc] initWithDelayInSeconds:1]];

	_cancelButton.hidden = NO;
	_activityIndicator.hidden = NO;
	[_activityIndicator startAnimating];
	_enqueuedItemsLabel.text = [NSString stringWithFormat:@"%d commands queued", _autoStartQueue.commands.count];
}

- (void)queueFinished
{
	_cancelButton.hidden = YES;
	_activityIndicator.hidden = YES;
	[_activityIndicator stopAnimating];
	_enqueuedItemsLabel.text = @"Done! Touch again...";
}

// this method gets called for every finished command
- (void)onUpdate
{
	_commandCount++;

	_outputLabel.text = [NSString stringWithFormat:@"%d", _commandCount];
	_enqueuedItemsLabel.text = [NSString stringWithFormat:@"%d commands queued", _autoStartQueue.commands.count - 1];
}

- (IBAction)onCancel
{
	[_autoStartQueue cancel];
}

@end