//
//  ViewController.m
//  CollapsableTableView
//
//  Created by Kaushlendra . on 5/26/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import "ViewController.h"
#import "ALCustomColoredAccessory.h"
#import "SVProgressHUD.h"
#import "AFHTTPRequestOperation.h"
#import "Post.h"
#import "Location.h"
#import "UIAlertView+AFNetworking.h"
#import "SectionInfo.h"
#import "Cities.h"
@interface ViewController ()
{
    NSMutableArray *arrayCity;
    NSMutableArray *arraySubCity;

}
@property (weak, nonatomic) IBOutlet UITableView *tableView_;

@end

@implementation ViewController
@synthesize tableView_;
@synthesize categoryList = _categoryList;
@synthesize openSectionIndex;
@synthesize sectionInfoArray;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    arrayCity=[[NSMutableArray alloc]init];
    arraySubCity=[[NSMutableArray alloc]init];
     [self fetchCities:nil];
    tableView_.sectionHeaderHeight = 45;
    tableView_.sectionFooterHeight = 0;
    self.openSectionIndex = NSNotFound;
    tableView_.dataSource=self;
    tableView_.delegate=self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
   
   
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    self.sectionInfoArray = nil;
}
#pragma mark Webservice Call

-(void)fetchCities:(id)sender{
    
    [SVProgressHUD showSuccessWithStatus:@"Please wait..." maskType:SVProgressHUDMaskTypeGradient];
    NSMutableDictionary *dictParams=[NSMutableDictionary dictionaryWithObjectsAndKeys:@"location",@"webserviceType", nil];
    NSURLSessionTask*taskNew=[Post globalTimeLinePost:dictParams relativeURl:@"Location/gettinglocation" withBlock:^(NSArray *posts1, NSError *error) {
        if (!error) {
            [arrayCity removeAllObjects];
            [arraySubCity removeAllObjects];
            
            for (NSDictionary *dict in posts1) {
                
                Location *location=[[Location alloc]initWithAttributes:dict];
                [arrayCity addObject:location];
            }
            self.categoryList=arrayCity;
           
            
            if ((self.sectionInfoArray == nil)|| ([self.sectionInfoArray count] != [self numberOfSectionsInTableView:tableView_])) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                
                for (Location *cat in self.categoryList) {
                    SectionInfo *section = [[SectionInfo alloc] init];
                    section.category = cat;
                    section.open = NO;
                    
                    NSNumber *defaultHeight = [NSNumber numberWithInt:44];
                    NSInteger count = [[section.category cities] count];
                    for (NSInteger i= 0; i<count; i++) {
                        [section insertObject:defaultHeight inRowHeightsAtIndex:i];
                    }
                    
                    [array addObject:section];
                }
                sectionInfoArray = array;
            }
            
            [SVProgressHUD dismiss];
            [tableView_ reloadData];
        }
        
    }];
    
    
    [UIAlertView showAlertViewForTaskWithErrorOnCompletion:taskNew delegate:nil];
    // [self.refreshControl setRefreshingWithStateOfTask:task];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.categoryList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SectionInfo *array = [sectionInfoArray objectAtIndex:section];
    NSInteger rows = [[array.category cities] count];
    return (array.open) ? rows : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Location *category = (Location *)[self.categoryList objectAtIndex:indexPath.section];

    NSDictionary * dict=[category.cities objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@",[dict valueForKey:@"city_name"]];
    return cell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    SectionInfo *array = [self.sectionInfoArray objectAtIndex:indexPath.section];
    return [[array objectInRowHeightsAtIndex:indexPath.row] floatValue];
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionInfo *array  = [self.sectionInfoArray objectAtIndex:section];
    if (!array.sectionView)
    {
        NSString *title = array.category.city_name;
        array.sectionView = [[SectionView alloc] initWithFrame:CGRectMake(15, 0, tableView_.bounds.size.width, 45) WithTitle:title Section:section delegate:self];
    }
    return array.sectionView;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) sectionClosed : (NSInteger) section{
    /*
     Create an array of the index paths of the rows in the section that was closed, then delete those rows from the table view.
     */
    SectionInfo *sectionInfo = [self.sectionInfoArray objectAtIndex:section];
    
    sectionInfo.open = NO;
    NSInteger countOfRowsToDelete = [tableView_ numberOfRowsInSection:section];
    
    if (countOfRowsToDelete > 0) {
        NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        }
        [tableView_ deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
    }
    self.openSectionIndex = NSNotFound;
}

- (void) sectionOpened : (NSInteger) section
{
    SectionInfo *array = [self.sectionInfoArray objectAtIndex:section];
    
    array.open = YES;
    NSInteger count = [array.category.cities count];
    NSMutableArray *indexPathToInsert = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i<count;i++)
    {
        [indexPathToInsert addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSInteger previousOpenIndex = self.openSectionIndex;
    
    if (previousOpenIndex != NSNotFound)
    {
        SectionInfo *sectionArray = [self.sectionInfoArray objectAtIndex:previousOpenIndex];
        sectionArray.open = NO;
        NSInteger counts = [sectionArray.category.cities count];
        [sectionArray.sectionView toggleButtonPressed:FALSE];
        for (NSInteger i = 0; i<counts; i++)
        {
            [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:previousOpenIndex]];
        }
    }
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    if (previousOpenIndex == NSNotFound || section < previousOpenIndex)
    {
        insertAnimation = UITableViewRowAnimationTop;
        deleteAnimation = UITableViewRowAnimationBottom;
    }
    else
    {
        insertAnimation = UITableViewRowAnimationBottom;
        deleteAnimation = UITableViewRowAnimationTop;
    }
    
    [tableView_ beginUpdates];
    [tableView_ insertRowsAtIndexPaths:indexPathToInsert withRowAnimation:insertAnimation];
    [tableView_ deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:deleteAnimation];
    [tableView_ endUpdates];
    self.openSectionIndex = section;
    
}

@end
