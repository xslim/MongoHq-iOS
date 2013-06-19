//
//  FileSelectorViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 19/06/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "FileSelectorViewController.h"

@interface FileSelectorViewController ()

@end

@implementation FileSelectorViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    
    if (!self.rootPath) {
        self.rootPath = [[NSBundle mainBundle] bundlePath];
    }
    
    if (!self.fileManager) {
        self.fileManager = [NSFileManager defaultManager];
    }
    
    self.title = [self.rootPath lastPathComponent];
    
    NSError *error = nil;
    self.items = [self.fileManager contentsOfDirectoryAtPath:self.rootPath error:&error];
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    if (!self.predicate && self.ext) {
        NSString *pString = [NSString stringWithFormat:@"self ENDSWITH '.%@'", self.ext];
        self.predicate = [NSPredicate predicateWithFormat:pString];
    }
    
    if (self.predicate) {
        self.items = [self.items filteredArrayUsingPredicate:self.predicate];
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel:(id)sender
{
    if (self.delegate) {
        [self.delegate fileSelectorDidCancel:self];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    // Configure the cell...
    NSString *fileName = [self.items objectAtIndex:indexPath.row];
    cell.textLabel.text = fileName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate) {
        NSString *fileName = [self.items objectAtIndex:indexPath.row];
        NSString *filePath = [self.rootPath stringByAppendingPathComponent:fileName];
        [self.delegate fileSelector:self didSelectFile:filePath];
    }
}

@end
