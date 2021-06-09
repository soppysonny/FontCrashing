//
//  ViewController.m
//  FontCrashing
//
//  Created by zhang ming on 2021/6/9.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self asynchronouslySetFontName: @"DFWaWaSC-W5"];
    // Do any additional setup after loading the view.
}

- (void)asynchronouslySetFontName:(NSString *)fontName {
    UIFont* aFont = [UIFont fontWithName:fontName size:12.0];
    // If the font is already downloaded
    if (aFont && ([aFont.fontName compare:fontName] == NSOrderedSame || [aFont.familyName compare:fontName] == NSOrderedSame)) {
        // 已经有改字体
        return;
    }
    
    // Create a dictionary with the font's PostScript name.
    NSMutableDictionary *attrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:fontName, kCTFontNameAttribute, nil];
    
    // Create a new font descriptor reference from the attributes dictionary.
    CTFontDescriptorRef desc = CTFontDescriptorCreateWithAttributes((__bridge CFDictionaryRef)attrs);
    
    NSMutableArray *descs = [NSMutableArray arrayWithCapacity:0];
    [descs addObject:(__bridge id)desc];
    CFRelease(desc);
    
    __block BOOL errorDuringDownload = NO;
    CTFontDescriptorMatchFontDescriptorsWithProgressHandler( (__bridge CFArrayRef)descs, NULL,  ^(CTFontDescriptorMatchingState state, CFDictionaryRef progressParameter) {
        
        //NSLog( @"state %d - %@", state, progressParameter);
        
        double progressValue = [[(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingPercentage] doubleValue];
        
        if (state == kCTFontDescriptorMatchingDidBegin) {
            NSLog(@" 字体匹配成功 ");
        } else if (state == kCTFontDescriptorMatchingDidFinish) {
            
            NSLog(@" 字体 %@ 下载完成 ", fontName);
            
        } else if (state == kCTFontDescriptorMatchingWillBeginDownloading) {
            NSLog(@" 字体开始下载 ");
        } else if (state == kCTFontDescriptorMatchingDidFinishDownloading) {
            NSLog(@" 字体下载完成 ");
            
        } else if (state == kCTFontDescriptorMatchingDownloading) {
            NSLog(@" 下载进度 %.0f%% ", progressValue);
        } else if (state == kCTFontDescriptorMatchingDidFailWithError) {
            NSError *error = [(__bridge NSDictionary *)progressParameter objectForKey:(id)kCTFontDescriptorMatchingError];
                    NSString *errorMessage = @"";
                    if (error != nil) {
                        errorMessage = [error description];
                    } else {
                        errorMessage = @"ERROR MESSAGE IS NOT AVAILABLE!";
                    }
                    // Set our flag
                    errorDuringDownload = YES;
                    
                    
                    NSLog(@"Download error: %@", errorMessage);
                    
                }
                return (bool)YES;
            });
}


@end
