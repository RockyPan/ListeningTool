//
//  AppDelegate.m
//  ListeningTool
//
//  Created by PanKyle on 14/12/2.
//  Copyright (c) 2014年 TGD. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic, copy) NSString * filename;

@end

NSMutableArray * _data;
unsigned int _index;
NSSound * _player;
NSTimer * _timer;
BOOL _display;

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (void)initStatus {
    _display = FALSE;
    self.labelText.stringValue = @"";
    self.textInput.stringValue = @"";
    self.labelProcess.stringValue = [NSString stringWithFormat:@"%d/%lu", _index, (unsigned long)_data.count];
    [self.btnPaly setEnabled:TRUE];
    [self.btnPrevious setEnabled:(_index != 1)];
    [self.btnNext setEnabled:(_index != _data.count)];
    [self.btnDisplay setEnabled:TRUE];
    self.btnDisplay.stringValue = _display ? @"隐藏" : @"显示";
}

- (void)openMP3File:(NSURL *)mp3Filename {
    [self.window setTitle:[NSString stringWithFormat:@"Listen Tool - %@", mp3Filename.lastPathComponent]];
    NSURL * lrcFilename = [mp3Filename.URLByDeletingPathExtension URLByAppendingPathExtension:@"lrc"];
    NSLog(@"%@", mp3Filename);
    NSLog(@"%@", lrcFilename);
    
    [self loadLrc:lrcFilename];
    
    
    
    _player = [[NSSound alloc] initWithContentsOfURL:mp3Filename byReference:YES];
    
    _index = 1;
    [self initStatus];
    
    [_player play];
    [_player pause];

}

- (void)loadLrc:(NSURL*)lrcFilename {
    NSError * error = nil;
    NSString * strContent = [NSString stringWithContentsOfURL:lrcFilename encoding:NSASCIIStringEncoding error:&error];
    
    //PK 分行
    NSArray * content = [strContent componentsSeparatedByString:@"\n"];
    
    NSLog(@"%@", content);

    if (NULL == _data) {
        _data = [[NSMutableArray alloc] init];
    } else {
        [_data removeAllObjects];
    }
    
    [content enumerateObjectsUsingBlock:^(NSString * item, NSUInteger idx, BOOL *stop) {
        NSDateFormatter * df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"mm:ss.SS"];
        NSDate * begin = [df dateFromString:@"00:00.00"];
        if ([item length] < 11) return;
        if (([item characterAtIndex:0] == '[') && ([item characterAtIndex:9] == ']')) {
            NSDate * date = [df dateFromString:[item substringWithRange:NSMakeRange(1,8)]];
            NSTimeInterval interval = [date timeIntervalSinceDate:begin];
            
            [_data addObject:
            @{@"time" : [NSNumber numberWithDouble:interval],
              @"subtitle" : [item substringFromIndex:10]}];
        }
    }];
    
    NSLog(@"%@", _data);
}

- (IBAction)menuOpen:(id)sender {
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    
    [panel setPrompt: @"play"];
    [panel setAllowedFileTypes:@[@"mp3"]];
    [panel setAllowsMultipleSelection:NO];
    
    [panel beginWithCompletionHandler:^(NSInteger result) {
        if (NSFileHandlingPanelOKButton == result) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self openMP3File:panel.URL];
            });
        }
    }];
    

}

- (IBAction)btnPlay:(id)sender {
    [_player pause];
    [_timer invalidate];
    [_player setCurrentTime:((NSNumber *)(_data[_index - 1][@"time"])).doubleValue];
    NSTimeInterval interval = 0;
    if (_index != _data.count) {
        interval = ((NSNumber *)(_data[_index][@"time"])).doubleValue - ((NSNumber *)(_data[_index - 1][@"time"])).doubleValue;
    } else {
        interval = _player.duration - ((NSNumber *)(_data[_index - 1][@"time"])).doubleValue;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(playDone) userInfo:nil repeats:NO];
    [_player resume];
    //[self.btnPaly setEnabled:FALSE];
}

- (IBAction)btnNext:(id)sender {
    ++_index;
    [self initStatus];
    [self btnPlay:nil];
}

- (IBAction)btnPrevious:(id)sender {
    --_index;
    [self initStatus];
    [self btnPlay:nil];
}

- (IBAction)btnDisplay:(id)sender {
    if (!_display) {
        self.labelText.stringValue = _data[_index - 1][@"subtitle"];
        _display = TRUE;
    } else {
        self.labelText.stringValue = @"";
        _display = FALSE;
    }
    self.btnDisplay.stringValue = _display ? @"隐藏" : @"显示";
}

- (void)playDone {
    [_player pause];
    //[self.btnPaly setEnabled:TRUE];
}

@end
