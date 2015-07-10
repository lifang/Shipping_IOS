//
//  TransportingTableViewCell.m
//  GoodMore
//
//  Created by comdosoft on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "TransportingTableViewCell.h"
#import "Constants.h"

@implementation TransportingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initAndLayoutUI];
    }
    return self;
}
- (void)initAndLayoutUI {
    
    
    _toimageview = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/2-1, 10, 13, 29)];
    [self.contentView addSubview:_toimageview];
    _toimageview.image = kImageName(@"toimage");
    
    
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.frame = CGRectMake(kScreenWidth/2+80, 50, kScreenWidth/2-100, 90);
    _detailLabel.numberOfLines = 0;
    
    _detailLabel.backgroundColor = [UIColor clearColor];
    _detailLabel.font = [UIFont systemFontOfSize:12.f];
    [self.contentView addSubview:_detailLabel];
    
    _modifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _modifyButton.frame = CGRectMake(kScreenWidth/2+80, 140, 60, 30);
    _modifyButton.backgroundColor = kColor(3, 184, 242, 1);
//    [_modifyButton setImage:kImageName(@"people") forState:UIControlStateNormal];
    [_modifyButton setTitle:@"修改" forState:UIControlStateNormal];
    [_modifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.contentView addSubview:_modifyButton];
    _modifyButton.layer.cornerRadius = 4.0;

    _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectButton.frame = CGRectMake(kScreenWidth/2-62.5, 50, 133, 133);
//    [_selectButton setBackgroundImage:kImageName(@"imageHeight2") forState:UIControlStateNormal];
    
    [self.contentView addSubview:_selectButton];


}
@end
