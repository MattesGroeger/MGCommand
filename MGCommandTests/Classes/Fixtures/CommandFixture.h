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

#import <Foundation/Foundation.h>
#import "MGAsyncCommand.h"

#ifndef COMMAND_COUNT_VAR
#define COMMAND_COUNT_VAR
NSUInteger COMMAND_CALL_COUNT;
#endif

@protocol MGCancellableCommand;

@interface AsyncTestCommand : NSObject <MGAsyncCommand>

@property (nonatomic, strong) CommandCallback callback;
@property (nonatomic) NSUInteger callCount;

@end

@interface CancellableTestCommand : NSObject <MGCancellableCommand>

@property (nonatomic, strong) CommandCallback callback;
@property (nonatomic) NSUInteger callCount;

@end

@interface TestCommand : NSObject <MGCommand>
{
	NSString *_key;
	NSString *_value;
}

@property (nonatomic) NSMutableDictionary *userInfo;
@property (nonatomic) NSUInteger callCount;

- (id)initWithKey:(NSString *)key value:(NSString *)value;

@end

@interface AsyncDirectFinishTestCommand : NSObject <MGAsyncCommand>

@property (nonatomic, strong) CommandCallback callback;
@property (nonatomic) NSUInteger callCount;

@end