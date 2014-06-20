//
//  ProducerViewController.h
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 19/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ProducerViewController : NSViewController

@property (strong) NSString *paletteId;

@property (strong) NSString *name;
@property (strong) NSArray *colors;

@property (strong) IBOutlet NSTextField *txtPaletteId;
@property (strong) IBOutlet NSButton *btnGo;

- (IBAction)goButonPressed:(id)sender;

@end
