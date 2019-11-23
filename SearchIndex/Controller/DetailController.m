//
//  DetailController.m
//  SearchIndex
//
//  Created by 曾怡然 on 2019/8/20.
//  Copyright © 2019 曾怡然. All rights reserved.
//

#import "DetailController.h"
#import "Detailmodel.h"

@interface DetailController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation DetailController {
    UITableView *tableView;
    NSMutableArray *demodels;
    
    UILocalizedIndexedCollation *collation;
    NSInteger sectionTitlesCount;
    NSMutableArray *newSectionsArray;
    
    NSMutableArray *sectionTitle;
    NSMutableArray *sectionConte;
    NSMutableArray *cellcontent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //tableView
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [self.view addSubview:tableView];
    
    //设置Demodel
    demodels = [NSMutableArray new];
    NSArray *arraylist = _model.models;
    for (NSString *type in arraylist) {
        Detailmodel *model = [Detailmodel new];
        model.brandtype = type;
        [demodels addObject:model];
    }
    
    //设置索引    
    collation = [UILocalizedIndexedCollation currentCollation];
    sectionTitlesCount = [[collation sectionTitles] count];
    newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (int i = 0; i < sectionTitlesCount; i++) {
        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:subArr];
    }
    
    
    for (Detailmodel *model in demodels) {
        NSInteger sectionNumber = [collation sectionForObject:model collationStringSelector:@selector(brandtype)];
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:model];
    }
    
    for (int i = 0; i < sectionTitlesCount; i++) {
        NSMutableArray *itemArrayForSection = newSectionsArray[i];
        NSArray *sortedItem = [collation sortedArrayFromArray:itemArrayForSection collationStringSelector:@selector(brandtype)];
        newSectionsArray[i] = sortedItem;
    }
    
    sectionTitle = [NSMutableArray new];
    sectionConte = [NSMutableArray new];
    [sectionTitle addObjectsFromArray:[collation sectionTitles]];
    int fly = 0;
    for (int i = newSectionsArray.count-1 ; i >= 0; i--) {
        NSArray *array = [newSectionsArray objectAtIndex:i];
        if ([array count] == 0) {
            NSLog(@"哭唧唧");
            [sectionTitle removeObjectAtIndex:i];
            fly++;
        } else {
            [sectionConte addObject:array];
        }
    }
    sectionTitlesCount -= fly;
    sectionConte = [[sectionConte reverseObjectEnumerator] allObjects];
    
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Detailmodel *model = [[sectionConte objectAtIndex:indexPath.section]  objectAtIndex:indexPath.row];
    cell.textLabel.text = model.brandtype;
    return cell;
}

//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitlesCount;
}

// 每个分区行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sectionConte[section] count];
}

//设置页眉
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sectionTitle[section];
}

//设置索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return sectionTitle;
}

@end
