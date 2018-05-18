//
//  ViewController.m
//  FFHeros
//
//  Created by Zhu Delun on 2018/5/18.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ViewController.h"
#import "ffNavigationController.h"
#import "ffFetchCharactersApi.h"
#import "ffFetchCharacterInfoApi.h"
#import "UIView+WebImage.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *previewImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.previewImageView.contentMode = UIViewContentModeScaleAspectFit;

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

- (IBAction)actionTapLoadImage:(id)sender
{
    weakify(self);
    [self.previewImageView ff_setImageWithUrl:@"https://ss0.bdstatic.com/94oJfD_bAAcT8t7mm9GUKT-xh_/timg?image&quality=100&size=b4000_4000&sec=1526563845&di=63328738db77d5105fa16f054ed04853&src=http://img.mp.itc.cn/upload/20170613/abc11a2410c44a20bba8fe71a5004329_th.jpg"
                                afterComplete:^(UIImage *image)
     {
         strongify(self);
         self.previewImageView.image = image;
     }];
}

@end
