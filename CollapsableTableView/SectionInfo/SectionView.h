//
//  SectionView.h
//  CustomTableTest
//
//  Created by Punit Sindhwani on 7/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol SectionView;

@interface SectionView : UIView

@property (nonatomic, retain) UILabel *sectionTitle;
@property (nonatomic, retain) UIButton *discButton;
@property (nonatomic, assign) NSInteger section;
@property (nonatomic, weak) id<SectionView> delegate;


- (id)initWithFrame:(CGRect)frame WithTitle: (NSString *) title Section:(NSInteger)sectionNumber delegate: (id <SectionView>) delegate;
- (void) discButtonPressed : (id) sender;
- (void) toggleButtonPressed : (BOOL) flag;

@end

@protocol SectionView <NSObject>

@optional
- (void) sectionClosed : (NSInteger) section;
- (void) sectionOpened : (NSInteger) section;

@end