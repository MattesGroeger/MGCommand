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

	// create sequential auto start group once
	_autoStartQueue = [MGSequentialCommandGroup autoStartGroup];
	_autoStartQueue.callback = ^
	{
		[self queueFinished];
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

	_activityIndicator.hidden = NO;
	[_activityIndicator startAnimating];
	[self updateEnqueuedItemsLabel];
}

- (void)queueFinished
{
	_activityIndicator.hidden = YES;
	[_activityIndicator stopAnimating];
	_enqueuedItemsLabel.text = @"Done! Touch again...";
}

// this method gets called for every finished command
- (void)onUpdate
{
	_commandCount++;

	_outputLabel.text = [NSString stringWithFormat:@"%d", _commandCount];
	[self updateEnqueuedItemsLabel];
}

- (void)updateEnqueuedItemsLabel
{
	_enqueuedItemsLabel.text = [NSString stringWithFormat:@"%d commands queued", _autoStartQueue.commands.count];
}

@end