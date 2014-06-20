ColourLoversExtensionGenerator
==============================

a status bar app for generating UIColor extension class form colourlovers.com palettes.

![alt tag](https://raw.githubusercontent.com/cemolcay/ColourLoversExtensionGenerator/master/ss1.png)

first get the palette id from palette url <br>
  http://www.colourlovers.com/palette/3394794/Melba_Toast <br>
where id is 3394749 <br>
than press GO.

![alt tag](https://raw.githubusercontent.com/cemolcay/ColourLoversExtensionGenerator/master/ss2.png)

palette is loaded
you can copy the extension to your clipboard and you get the extension

```objective-c
@interface NSColor (MelbaToast)
+ (NSColor *)colour0;
+ (NSColor *)colour1;
+ (NSColor *)colour2;
+ (NSColor *)colour3;
+ (NSColor *)colour4;

@end

@implementation NSColor (MelbaToast)
+ (NSColor *)colour0 {
	return [self colorWithRed:246/255.0 green:237/255.0 blue:196/255.0 alpha:1];
}

+ (NSColor *)colour1 {
	return [self colorWithRed:225/255.0 green:208/255.0 blue:163/255.0 alpha:1];
}

+ (NSColor *)colour2 {
	return [self colorWithRed:228/255.0 green:191/255.0 blue:153/255.0 alpha:1];
}

+ (NSColor *)colour3 {
	return [self colorWithRed:202/255.0 green:142/255.0 blue:119/255.0 alpha:1];
}

+ (NSColor *)colour4 {
	return [self colorWithRed:132/255.0 green:68/255.0 blue:72/255.0 alpha:1];
}

@end
```

thats all !
