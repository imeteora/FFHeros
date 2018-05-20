//
//  ffSearchBarView.m
//  FFHeros
//
//  Created by ZhuDelun on 2018/5/20.
//  Copyright © 2018 ZhuDelun. All rights reserved.
//

#import "ffSearchBarView.h"
#import "UIView+ffExt.h"

@interface ffSearchBarView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextfield;

@end

@implementation ffSearchBarView

- (void)awakeFromNib {
    [super awakeFromNib];
    _searchTextfield.delegate = self;
    _searchTextfield.layer.cornerRadius = 15;
    _searchTextfield.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _searchTextfield.layer.borderWidth = 1.0;
    _searchTextfield.layer.masksToBounds = YES;
}


- (IBAction)onBackBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarBackButtonClicked:)]) {
        [self.delegate searchBarBackButtonClicked:self];
    }
}

- (IBAction)onFindBtnClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarFindButtonClicked:)]) {
        [self.delegate searchBarFindButtonClicked:self];
    }
}

#pragma mark - UITextViewDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {

}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}

@end
