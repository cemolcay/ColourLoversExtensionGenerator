//
//  AppDelegate.m
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 19/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "AppDelegate.h"
#import "ProducerViewController.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    ProducerViewController *producer = [[ProducerViewController alloc] initWithNibName:@"ProducerViewController" bundle:nil];
    self.popUp = [[AXStatusItemPopup alloc] initWithViewController:producer image:[NSImage imageNamed:@"favicon.ico"] alternateImage:[NSImage imageNamed:@"favicon.ico"]];
}

@end
