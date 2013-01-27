## Introduction

This library provides a lightweight solution for executing `Commands`. They can be executed sequentially or concurrently with `CommandGroups`. Because groups are `Commands` as well, they can be nested into each other. This can be used for scripted code execution. See the [MGCommandConfig](https://github.com/MattesGroeger/MGCommandConfig) project for more details.

## Installation via CocoaPods

- Install CocoaPods. See [http://cocoapods.org](http://cocoapods.org)
- Add the MGCommand reference to the Podfile:
```
    platform :ios
    	pod 'MGCommand'
    end
```

- Run `pod install` from the command line
- Open the newly created Xcode Workspace file
- Implement your commands

## Usage

There are two command types: synchronous (`MGCommand`) and asynchronous (`MGAsyncCommand`). Commands can then be executed all at once (`MGCommandGroup`) or one after the other (`MGSequentialCommandGroup`).

### Synchronous command

A synchronous command needs to implement the `MGCommand` protocol. The `execute` method should contain the command logic. Here is a simple print command example ([taken from the example project](https://github.com/MattesGroeger/MGCommand/tree/master/MGCommandExample/Classes)):

```objective-c
@interface PrintCommand : NSObject <MGCommand>
{
	NSString *_message;
}

- (id)initWithMessage:(NSString *)message;

@end
```

```objective-c
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

### Asynchronous command

Sometimes your command execution may not finish synchronously. In that case you may want to use the `MGAsyncCommand`. This command will not finish until a callback method has been called. This callback method will be set by the parent `CommandGroup` before execution ([see next paragraph](https://github.com/MattesGroeger/MGCommand/edit/master/Readme.md#executing-several-commands-at-once)). The following command finishes after a given delay ([taken from the example project](https://github.com/MattesGroeger/MGCommand/tree/master/MGCommandExample/Classes)):

```objective-c
@interface DelayCommand : NSObject <MGAsyncCommand>
{
	NSTimeInterval _delayInSeconds;
}

@property (nonatomic, strong) CommandCallback callback;

- (id)initWithDelayInSeconds:(NSTimeInterval)aDelayInSeconds;

@end
```

```objective-c
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

### Executing several commands at once

Commands can be added to command groups (`MGCommandGroup`) which will then execute all commands concurrently. The command group itself implements the `MGAsyncCommand` protocol. It will finish when all added commands have finished their execution.

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

Before calling the execute method on the command group, you can set the callback block. It will be executed when the command group execution finished. The order you add the commands determines their execution order.

Note that the callbacks for added asynchronous commands will be automatically set by the group. If you add only synchronous commands you don't need the callback as the group will finish instantly.

### Executing commands sequentially

In case you want to have your commands being executed one after the other you can use the `MGSequentialCommandGroup`. The order you add the commands determines their execution order.

### Auto start command execution

You can add commands to a `CommandGroup` or `SequentialCommandGroup` and have the `execute` method automatically called as soon as a command is added. In case all commands have been finished and you add another one, the command will be executed as well. This way you can enqueue commands that should run sequentially. Note, that the callback is called whenever there are no more commands to be executed. Depending when you add new commands, this can cause multiple calls.

```obj-c
MGCommandGroup *group = [MGSequentialCommandGroup autoStartGroup];

// adding this commands starts the execution automatically
[group addCommand:[[DelayCommand alloc] initWithDelayInSeconds:1]];

// change the autostart behavior at runtime
group.autoStart = NO;
```

## Example

You can find an example application in the [`MGCommandsExample` subfolder](https://github.com/MattesGroeger/MGCommand/tree/master/MGCommandExample/Classes). To see the exection, run the application in the simulator and press the start button. 

The configured command groups look like this (pseudo code):

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