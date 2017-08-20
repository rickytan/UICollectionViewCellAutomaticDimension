//
//  RTViewController.m
//  UICollectionViewCellAutomaticDimension
//
//  Created by rickytan on 08/20/2017.
//  Copyright (c) 2017 rickytan. All rights reserved.
//

#import <UICollectionViewCellAutomaticDimension/UICollectionView+RTAutosizing.h>
#import "RTViewController.h"

@interface MyTextCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation MyTextCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [[UILabel alloc] initWithFrame:self.contentView.bounds];
        self.textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.backgroundColor = [UIColor blueColor];
        self.textLabel.font = [UIFont systemFontOfSize:16.f];
        [self.contentView addSubview:self.textLabel];


        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_textLabel]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_textLabel)]];
        [NSLayoutConstraint activateConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_textLabel]|"
                                                                                        options:0
                                                                                        metrics:nil
                                                                                          views:NSDictionaryOfVariableBindings(_textLabel)]];
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
}

@end

@interface RTViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray <NSString *> *strings;
@end

@implementation RTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[MyTextCell class]
            forCellWithReuseIdentifier:@"TextCell"];
    
    NSString *const text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    self.strings = [text componentsSeparatedByString:@" "];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.strings.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [collectionView rt_sizeForItemAtIndexPath:indexPath
                                           cellClass:[MyTextCell class]
                                          setupBlock:^(MyTextCell *cell) {
                                              UILabel *label = cell.textLabel;
                                              label.text = self.strings[indexPath.item];
                                           }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TextCell"
                                                                 forIndexPath:indexPath];
    UILabel *label = cell.textLabel;
    label.text = self.strings[indexPath.item];

    return cell;
}

@end
