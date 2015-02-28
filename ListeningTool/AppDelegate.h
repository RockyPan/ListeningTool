//
//  AppDelegate.h
//  ListeningTool
//
//  Created by PanKyle on 14/12/2.
//  Copyright (c) 2014年 TGD. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (weak) IBOutlet NSTextField *labelText;
@property (weak) IBOutlet NSTextField *labelProcess;
@property (weak) IBOutlet NSTextField *textInput;
@property (weak) IBOutlet NSButton *btnPaly;
@property (weak) IBOutlet NSButton *btnNext;
@property (weak) IBOutlet NSButton *btnPrevious;
@property (weak) IBOutlet NSButton *btnDisplay;
@property (weak) IBOutlet NSButton *btnRewind;

- (IBAction)menuOpen:(id)sender;
- (IBAction)btnPlay:(id)sender;
- (IBAction)btnNext:(id)sender;
- (IBAction)btnPrevious:(id)sender;
- (IBAction)btnDisplay:(id)sender;
- (IBAction)btnRewind:(id)sender;

@end

