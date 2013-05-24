//
//  ApiKeyViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/24/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "ApiKeyViewController.h"

@interface ApiKeyViewController ()
@property (nonatomic, strong) NSString *currentKey;
@end

@implementation ApiKeyViewController

- (id)init
{
    self = [super initWithRoot:[[self class] createRootElement]];
    if (self) {
        // Custom initialization
    }
    return self;
}

+ (QRootElement *)createRootElement
{
    QRootElement *root = [[QRootElement alloc] init];
    root.grouped = YES;
    
    return root;
}

- (void)updateQuickDialogView {
    // Hack to Update table
    self.quickDialogTableView.root = self.root;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIBarButtonItem *btn2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = btn2;
    
    self.root.title = self.title = @"Enter API Key";
    
    self.currentKey = [AppController shared].apiKey;
    
    QEntryElement *keyEntry = [[QEntryElement alloc] initWithTitle:@"key" Value:self.currentKey Placeholder:@"api key"];
    keyEntry.controllerAction = @"changedKey:";
    
    QSection *section1 = [[QSection alloc] initWithTitle:@""];
    [section1 addElement:keyEntry];
    [self.root addSection:section1];
    
    QButtonElement *btn = [[QButtonElement alloc] initWithTitle:@"Save"];
    btn.onSelected = ^{
        [self saveApiKey];
    };
    
    QSection *section2 = [[QSection alloc] initWithTitle:@""];
    [section2 addElement:btn];
    [self.root addSection:section2];
    
    [self updateQuickDialogView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)changedKey:(QEntryElement *)element {
    self.currentKey = element.textValue;
}

- (void)saveApiKey {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (self.currentKey.length == 0) return;
    
    [AppController shared].apiKey = self.currentKey;
    [[AppController shared] saveApiKey];
    
    [self done];
}

- (void)done {
    [self.delegate presentedViewControllerDidDone:self];
}

- (void)cancel {
    [self.delegate presentedViewControllerDidCancel:self];
}

@end
