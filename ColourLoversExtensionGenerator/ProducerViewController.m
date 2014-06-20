//
//  ProducerViewController.m
//  ColourLoversExtensionGenerator
//
//  Created by Cem Olcay on 19/06/14.
//  Copyright (c) 2014 questamobile. All rights reserved.
//

#import "ProducerViewController.h"

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
    NSString *url = [NSString stringWithFormat:@"http://www.colourlovers.com/api/palette/%@?format=json", self.txtPaletteId.stringValue];

    [self freeze];
    [self json:url success:^(id object) {
        [self unfreeze];

        self.colors = [[object firstObject] objectForKey:@"colors"];
        self.name = [[object firstObject] objectForKey:@"title"];
        
        [self make];
    } error:^(NSError *error) {
        NSLog(@"error: %@", error.description);
        [self unfreeze];
    }];
}


- (void)make {
    [self.view setFrame:NSRectFromCGRect(CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, 100))];
    
    float x = 20;
    float pad = 3;
    float w = 25;
    for (int i = 0; i < self.colors.count; i++) {
        [self.view addSubview:[self viewWithHEX:[self.colors objectAtIndex:i] X:x+((w+pad)*i)]];
    }
}


- (NSView *)viewWithHEX:(NSString *)hex X:(CGFloat)x{
    NSView *v = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(x, 20, 25, 25))];
    
    CALayer *viewLayer = [CALayer layer];
    [viewLayer setBackgroundColor:[self colorWithHexString:[NSString stringWithFormat:@"#%@", hex]].CGColor];
    [v setWantsLayer:YES];
    [v setLayer:viewLayer];
    
    return v;
}


- (void)freeze {
    [self.btnGo setEnabled:NO];
    [self.txtPaletteId setEnabled:NO];
}

- (void)unfreeze {
    [self.btnGo setEnabled:YES];
    [self.txtPaletteId setEnabled:YES];
}


- (void)json:(NSString *)url success:(void(^)(id))success error:(void(^)(NSError*))error {
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
       if (connectionError)
           error (connectionError);
        
        NSError *jsonError;
        id result = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
        
        if (jsonError)
            error (jsonError);
        
        success (result);
    }];
}


- (NSColor *)colorWithHexString:(NSString *)str {
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x = strtol(cStr+1, NULL, 16);
    return [self colorWithHex:x];
}

- (NSColor *)colorWithHex:(UInt32)col {
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [NSColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}


@end
