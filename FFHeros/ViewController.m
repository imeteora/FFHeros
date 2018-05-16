//
//  ViewController.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/15.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ViewController.h"
#import "ffFetchCharactersApi.h"
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
    ffFetchCharactersApi *api = [[ffFetchCharactersApi alloc] init];
    api.nameStartsWith = @"Iron";
    api.limit = @10;

    [api requestAfterComplete:^(ffCharacterDataContainerModel * _Nonnull result) {
        NSLog(@"OK\n%@", [result description]);
    } ifError:^(NSError * _Nonnull error, id _Nullable result) {
        NSLog(@"Error");
    }];

}

- (IBAction)btnTestCharacterUseId:(id)sender {
    ffFetchCharacterInfoApi *api = [[ffFetchCharacterInfoApi alloc] init];
    [api requestWithCharacterId:@"1011334" afterComplete:^(ffCharacterDataContainerModel *result) {
        NSLog(@"OK\n%@", [result description]);
    } ifError:^(NSError *error, id o) {
        NSLog(@"Error");
    }];
}

@end
