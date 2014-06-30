//
//  ProducerViewController.m
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 19/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "ProducerViewController.h"
#import "AppDelegate.h"
#import "Colour.h"

@interface ProducerViewController ()

@end

@implementation ProducerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (IBAction)goButonPressed:(id)sender {
    if (self.txtPaletteId.stringValue.length <= 0)
        return;
    
    self.palette = [[Palette alloc] initWithPaletteId:self.txtPaletteId.stringValue completed:^{
        [self make];
    }];
}

- (void)make {
    [self.txtPaletteId setHidden:YES];
    [self.btnGo setHidden:YES];
    
    CGFloat padding = 10;
    CGFloat butH = 20;
    CGFloat vH = 80;
    CGFloat h = padding * (4 + (self.palette.colours.count-1)) + 2*butH + self.palette.colours.count*vH;
    
    [self setHeight:h];
    self.resultView = [[NSView alloc] initWithFrame:self.view.frame];
    
    for (int i = 0; i < self.palette.colours.count; i++) {
        [self.resultView addSubview:[self viewWithColour:[self.palette.colours objectAtIndex:i] tag:i]];
    }
    
    NSButton *get = [[NSButton alloc] initWithFrame:NSMakeRect(10, 0, self.view.frame.size.width-40, butH)];
    [get setTitle:@"copy to clipboard"];
    [get setTarget:self];
    [get setAction:@selector(copyPressed:)];
    [self.resultView addSubview:get];
    
    NSButton *reset = [[NSButton alloc] initWithFrame:NSMakeRect(10, 0, get.frame.size.width, get.frame.size.height)];
    [reset setTitle:@"reset"];
    [reset setTarget:self];
    [reset setAction:@selector(resetPressed:)];
    [self.resultView addSubview:reset];
    
    
    CGFloat y = 0;
    for (int i = (int)self.resultView.subviews.count - 1; i >= 0; i--) {
        NSView *v = [self.resultView.subviews objectAtIndex:i];
        CGFloat height = v.frame.size.height;
        [self set:v y:y];
        y += height + padding;
    }
    
    
    [self.view addSubview:self.resultView];
}

- (NSView *)viewWithColour:(Colour *)colour tag:(NSInteger)tag{
    [colour setName:[NSString stringWithFormat:@"colour%ld", (long)tag]];
    
    NSView *v = [[NSView alloc] initWithFrame:NSMakeRect(0, 0, self.view.frame.size.width - 20, 80)];
    CGFloat w = v.frame.size.width;
    
    NSView *c = [[NSView alloc] initWithFrame:NSMakeRect(5, 30, 45, 45)];
    CALayer *layer = [CALayer layer];
    [layer setBackgroundColor:colour.color.CGColor];
    [layer setBorderWidth:1];
    [layer setBorderColor:[[NSColor lightGrayColor] CGColor]];
    [c setLayer:layer];
    [c setWantsLayer:YES];
    [v addSubview:c];
    
    NSTextField *hash = [[NSTextField alloc] initWithFrame:NSMakeRect(55, 55, w-60, 20)];
    [hash setBackgroundColor:[NSColor clearColor]];
    [hash setTextColor:[NSColor blackColor]];
    [hash setStringValue:colour.hexWithHashtag];
    [hash setEditable:NO];
    [v addSubview:hash];
    
    NSTextField *rgb = [[NSTextField alloc] initWithFrame:NSMakeRect(55, 30, w-60, 20)];
    [rgb setBackgroundColor:[NSColor clearColor]];
    [rgb setTextColor:[NSColor blackColor]];
    [rgb setStringValue:[NSString stringWithFormat:@"(%0.f, %0.f, %0.f)", colour.r, colour.g, colour.b]];
    [rgb setEditable:NO];
    [v addSubview:rgb];
    
    NSTextField *name = [[NSTextField alloc] initWithFrame:NSMakeRect(5, 5, w-10, 20)];
    [name setBackgroundColor:[NSColor clearColor]];
    [name setTextColor:[NSColor blackColor]];
    [name setStringValue:colour.name];
    [name setEditable:YES];
    [name setDelegate:self];
    [name setTag:tag];
    [v addSubview:name];
    
    return v;
}

- (void)set:(NSView *)view y:(CGFloat)y{
    [view setFrame:NSMakeRect(view.frame.origin.x, y, view.frame.size.width, view.frame.size.height)];
}


- (void)copyPressed:(id)sender {
    [self copyToClipboard:[self.palette generateClass:ExtensionClassUIColor andLanguage:LanguageSwift]];
}

- (void)resetPressed:(id)sender {
    [self.resultView removeFromSuperview];
    [self setHeight:60];
    
    [self.txtPaletteId setHidden:NO];
    [self.btnGo setHidden:NO];
    
    [self.txtPaletteId setStringValue:@""];
    
    self.palette = nil;
}


- (void)copyToClipboard:(NSString *)string {
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    NSArray *types = [NSArray arrayWithObjects:NSStringPboardType, nil];
    [pb declareTypes:types owner:self];
    [pb setString:string forType:NSStringPboardType];
}


- (void)setHeight:(CGFloat)h {
    [self.view setFrame:NSMakeRect(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, h)];
    [[((AppDelegate*)[NSApp delegate]) popUp] setContentSize:CGSizeMake(self.view.frame.size.width, h)];
}

- (CGFloat)height {
    return self.view.frame.size.height;
}

- (CGFloat)iosYToOsxY: (CGFloat)y heightForY:(CGFloat)h {
    return [self height] - (y + h);
}

#pragma mark - NSTextFieldDelegate

- (void)controlTextDidChange:(NSNotification *)notification {
    NSTextField *textField = [notification object];
    [textField setStringValue:[textField.stringValue stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NSInteger tag = [textField tag];
    
    Colour *c = [self.palette.colours objectAtIndex:tag];
    [c setName:[textField stringValue]];
}

@end


