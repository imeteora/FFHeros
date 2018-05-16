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
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://developer.marvel.com/v1/public/characters?ts=1526468114&hash=760a64946a9cc18ed1de546914f2551f&apikey=aaee6fa40625a68298d42a9bb9dcd09d"]];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error == nil && data != nil) {
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            if ([json count]) {
                NSLog(@"result: %@", json);
            }
        }
    }] resume];

//    ffFetchCharacterInfoApi *api = [[ffFetchCharacterInfoApi alloc] init];
//    api.nameStartsWith = @"Icon";
//    api.limit = @10;
//
//    [api requestAfterComplete:^(NSDictionary * _Nonnull result) {
//
//    } ifError:^(NSError * _Nonnull error, id _Nullable result) {
//
//    }];

}

@end
