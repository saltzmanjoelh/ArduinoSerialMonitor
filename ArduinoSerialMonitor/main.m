//
//  main.m
//  ArduinoSerialMonitor
//
//  Created by Joel Saltzman on 4/15/13.
//  Copyright (c) 2013 joelsaltzman.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMAppDelegate.h"


int main(int argc, const char * argv[])
{

    @autoreleasepool {
        SMAppDelegate *delegate = [SMAppDelegate new];
        [delegate setupForPort:@"/dev/cu.usbserial-A6008euA"];
        delegate.serialPort.baudRate = @9600;
        [[NSRunLoop currentRunLoop] run];
        
    }
    return 0;
}

