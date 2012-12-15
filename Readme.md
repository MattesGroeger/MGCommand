Introduction
===

This library provides a lightweight solution for executing `Commands`. They can be executed sequentially or concurrently with `CommandGroups`. Because groups are `Commands` as well, they can be nested into each other. This can be used for scripted code execution like in game tutorials for example (tbd: reference tutorial script).

Installation
===

Tbd: Cocoapods

Usage
===

There are two command types: synchronous (`MGCommand`) and asynchronous (`MGAsyncCommand`). Commands can then be executed all at once (`MGCommandGroup`) or one after the other (`MGSequentialCommandGroup`).

Synchronous command
---

A synchronous command needs to implement the `MGCommand` protocol. The `execute` method should contain the command logic. Here is a simple print command example:

```objective-c
@interface PrintCommand : NSObject <MGCommand>
{
	NSString *_message;
}

- (id)initWithMessage:(NSString *)message;

@end

@implementation PrintCommand

- (id)initWithMessage:(NSString *)message
{
	self = [super init];

	if (self)
	{
		_message = message;
	}

	return self;
}

- (void)execute
{
	NSLog(_message);
}

@end
```

Asynchronous command
---

Sometimes your command may need some more execution time. In that case you may want to use the `MGAsyncCommand`. This command will not finish until a callback method has been called. This callback method will be set by the parent `CommandGroup` before execution (see next paragraph). The following command example finishes after a given delay:

```objective-c
@interface DelayCommand : NSObject <MGAsyncCommand>
{
	NSTimeInterval _delayInSeconds;
}

@property (nonatomic, strong) CommandCallback callback;

- (id)initWithDelayInSeconds:(NSTimeInterval)aDelayInSeconds;

@end

@implementation DelayCommand

- (id)initWithDelayInSeconds:(NSTimeInterval)aDelayInSeconds
{
	self = [super init];

	if (self)
	{
		_delayInSeconds = aDelayInSeconds;
	}

	return self;
}

- (void)execute
{
	[self performSelector:@selector(finishAfterDelay)
			   withObject:nil
			   afterDelay:_delayInSeconds];
}

- (void)finishAfterDelay
{
	_callback();
}

@end
```

Executing several commands at once
---

Commands can be added to command groups (`MGCommandGroup`) which will then execute all commands. The command group itself implements the `MGAsyncCommand` protocol. It will finish it's own execution when all added commands have finished their own execution.

```objective-c
MGCommandGroup *commandGroup = [[MGCommandGroup alloc] init];

[commandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
[commandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];
[commandGroup addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];

commandGroup.callback = ^
{
	NSLog(@"execution finished");
};

[commandGroup execute];
```

Before calling the execute method on the command group, you can set a callback block. It will be executed when the command group execution finished. Note that the callbacks for added asynchronous commands will be automatically set by the group.

Executing commands sequentially
---

In case you want to have your commands being executed one after the other you can use the `MGSequentialCommandGroup`. The order you add the commands determines their execution order.

Example
===

You can find an example application in the `MGCommandsExample` subfolder. Run the app in the simulator and start the command execution. 

The configured command groups looks like this (pseudo code):

	sequential
	{
		DelayCommand(1)
		DelayCommand(1)
		DelayCommand(1)
		PrintCommand("concurrent {")
		
		concurrent
		{
			DelayCommand(1)
			DelayCommand(1)
			DelayCommand(1)
		}
		
		PrintCommand("}")
		DelayCommand(1)
		DelayCommand(1)
		DelayCommand(1)
		PrintCommand("Finished")
	}
