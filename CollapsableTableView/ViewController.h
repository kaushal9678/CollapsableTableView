//
//  ViewController.h
//  CollapsableTableView
//
//  Created by Kaushlendra . on 5/26/15.
//  Copyright (c) 2015 Healthians.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Location.h"
#import "SectionView.h"
@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,SectionView>
{NSMutableIndexSet *expandedSections;
    Location *locations;
}
@property (nonatomic, assign) NSInteger openSectionIndex;
@property (nonatomic, strong) NSMutableArray *sectionInfoArray;
@property (nonatomic, strong) NSArray *categoryList;
@end

