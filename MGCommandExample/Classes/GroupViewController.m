/*
 * Copyright (c) 2012 Mattes Groeger
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "GroupViewController.h"
#import "MGAsyncCommand.h"
#import "MGSequentialCommandGroup.h"
#import "PrintCommand.h"
#import "DelayCommand.h"
#import "MGAsyncBlockCommand.h"

@implementation GroupViewController

- (void)viewDidLoad
{
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(onPrint:)
												 name:@"print"
											   object:nil];

	_activityIndicator.hidden = YES;
	_outputLabel.text = @"";
	[_startButton addTarget:self action:@selector(onStartButton) forControlEvents:UIControlEventTouchUpInside];

	[[self tabBarController].tabBar.items[0] setTitle:@"Command Groups"];
	[[self tabBarController].tabBar.items[1] setTitle:@"Auto Start Group"];
	[[self tabBarController].tabBar.items[2] setTitle:@"Block Command"];

	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
	[_outputLabel sizeToFit];
}

- (void)viewDidUnload
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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

	commandGroup.completeHandler = ^
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

	MGSequentialCommandGroup *sequence = [[MGSequentialCommandGroup alloc] init];

	[sequence addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[sequence addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[sequence addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[sequence addCommand:[[PrintCommand alloc] initWithMessage:@"concurrent {"]];

	[sequence addCommand:commandGroup];

	[sequence addCommand:[[PrintCommand alloc] initWithMessage:@"}"]];
	[sequence addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[sequence addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
	[sequence addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];

	[sequence addCommand:[MGAsyncBlockCommand create:^(MGCommandCompleteHandler complete) {
        [self addOutput:@"Finished"];
        complete();
    }]];

	return sequence;
}

- (void)finishExecution
{
	[_activityIndicator stopAnimating];
	_activityIndicator.hidden = YES;

	_startButton.enabled = YES;
}

- (void)onPrint:(NSNotification *)notification
{
	[self addOutput:notification.userInfo[@"text"]];
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