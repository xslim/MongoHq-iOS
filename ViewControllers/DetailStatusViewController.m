//
//  DetailStatusViewController.m
//  MongoHq
//
//  Created by Taras Kalapun on 5/21/13.
//  Copyright (c) 2013 Kalapun. All rights reserved.
//

#import "DetailStatusViewController.h"
#import "MGScrollView.h"
#import "MGTableBoxStyled.h"
#import "MGLineStyled.h"

@interface DetailStatusViewController ()

@end

@implementation DetailStatusViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    
    MGScrollView *scroller = [MGScrollView scrollerWithSize:self.view.frame.size];
    [self.view addSubview:scroller];
    
    MGTableBoxStyled *section = MGTableBoxStyled.box;
    [scroller.boxes addObject:section];
    
    section.backgroundColor = [UIColor redColor];
    
    CGSize rowSize = (CGSize){304, 40};

    MGLineStyled *header = [MGLineStyled lineWithMultilineLeft:self.item.name right:nil width:rowSize.width minHeight:rowSize.height];
    header.leftPadding = header.rightPadding = 16;
    [section.topLines addObject:header];
    
    [section.topLines addObject:[MGLineStyled lineWithMultilineLeft:self.item.itemDescription right:nil width:rowSize.width minHeight:rowSize.height]];
    [section.topLines addObject:[MGLineStyled lineWithLeft:@"time" multilineRight:self.item.timestamp.description width:rowSize.width minHeight:rowSize.height]];
    
    
    [section.topLines addObject:[MGLineStyled lineWithLeft:@"event" multilineRight:self.item.eventMessage width:rowSize.width minHeight:rowSize.height]];
    

    
    [scroller layout];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
