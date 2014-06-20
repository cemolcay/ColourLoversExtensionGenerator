//
//  ProducerViewController.h
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 19/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Palette.h"

@interface ProducerViewController : NSViewController <NSTextFieldDelegate>

@property (strong) Palette *palette;

@property (strong) IBOutlet NSTextField *txtPaletteId;
@property (strong) IBOutlet NSButton *btnGo;

@property (strong) NSView *resultView;

- (IBAction)goButonPressed:(id)sender;

@end
