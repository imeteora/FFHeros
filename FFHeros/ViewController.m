//
//  ViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ViewController.h"
#import "ffFetchCharacterInfoApi.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnTextApiRequest:(id)sender {
    ffFetchCharacterInfoApi *api = [[ffFetchCharacterInfoApi alloc] init];
    api.nameStartsWith = @"Iron";
    api.limit = @10;

    [api requestAfterComplete:^(NSDictionary * _Nonnull result) {
        NSLog(@"OK");
    } ifError:^(NSError * _Nonnull error, id _Nullable result) {
        NSLog(@"Error");
    }];

}

@end
