//
//  ViewController.m
//  SearchIndex
//
//  Created by 曾怡然 on 2019/8/20.
//  Copyright © 2019 曾怡然. All rights reserved.
//

#import "ViewController.h"
#import "Mymodel.h"
#import "DetailController.h"

#import <NSObject+YYModel.h>
#import <YYClassInfo.h>
#import <YYModel/YYModel.h>

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation ViewController {
    UITableView *tableView;
    NSMutableArray *models;

    UILocalizedIndexedCollation *collation;
    NSInteger sectionTitlesCount;
    NSMutableArray *newSectionsArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"嘤嘤嘤";
    
    //tableView
    tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.estimatedRowHeight = 100;
    [self.view addSubview:tableView];

    //YYModel
    NSString *dateString = [[NSBundle mainBundle] pathForResource:@"moto" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dateString];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

    
    models = [NSMutableArray new];
    for (NSDictionary *dic in dict) {
        Mymodel *model = [Mymodel yy_modelWithDictionary:dic];
        [models addObject:model];
    }
    
    //设置索引
    collation = [UILocalizedIndexedCollation currentCollation];
    sectionTitlesCount = [[collation sectionTitles] count];
    newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    for (int i = 0; i < sectionTitlesCount; i++) {
        NSMutableArray *subArr = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:subArr];
    }
    
    
    for (Mymodel *model in models) {
        NSInteger sectionNumber = [collation sectionForObject:model collationStringSelector:@selector(brand)];
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:model];
    }
    
    for (int i = 0; i < sectionTitlesCount; i++) {
        NSMutableArray *itemArrayForSection = newSectionsArray[i];
        NSArray *sortedItem = [collation sortedArrayFromArray:itemArrayForSection collationStringSelector:@selector(brand)];
        newSectionsArray[i] = sortedItem;
    }
    
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    NSString *cellIdentifier = [NSString stringWithFormat:@"cellIdentifier%ld%ld",(long)indexPath.row,(long)indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    Mymodel *model = [[newSectionsArray objectAtIndex:indexPath.section]  objectAtIndex:indexPath.row];
    cell.textLabel.text = model.brand;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Mymodel *model = [[newSectionsArray objectAtIndex:indexPath.section]  objectAtIndex:indexPath.row];
    DetailController *detail = [[DetailController alloc] init];
    detail.model = model;
    [self.navigationController pushViewController:detail animated:YES];
}

//分区数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sectionTitlesCount;
}

// 每个分区行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [newSectionsArray[section] count];
}

//设置页眉
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [collation sectionTitles][section];
}

//设置索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [collation sectionIndexTitles];
}








@end
