Introduction
===

This little library provides a very simple and lightweight way for executing queued commands. `Commands` can be executed sequentially or concurrently. This is done by `CommandGroups` which in itself are `Commands`. This way `Commands` and `CommandGroups` can be nested at any depth. This can be used for scripted code execution like in game tutorials for example (tbd: reference tutorial script).

Installation
===

Tbd: Cocoapods

Usage
===

Implementing commands
---

Asynchronous commands
---

Executing several commands at once
---

Executing commands sequentially
---

Example
===

You can find an example application in the `MGCommandsExample` subfolder. Run the app in the simulator and start the command execution. 

The configured command groups looks like this:

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