//
//  LoadGoodsViewController2.m
//  GoodMore
//
//  Created by comdosoft on 15/7/8.
//  Copyright (c) 2015年 comdosoft. All rights reserved.
//

#import "LoadGoodsViewController2.h"
#import "Constants.h"
#import "MBProgressHUD.h"
#import "NetWorkInterface.h"
#import "AddCollectionViewCell.h"
#import "ImageCollectionViewCell.h"
@interface LoadGoodsViewController2 ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    UITextField *_num;
    UICollectionView *_collectionView;
    NSMutableArray *_imageArray;
    NSMutableArray *_imgUrlArray;
    UIImageView *_bigImageView;
}
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *pageLabel;
@property(nonatomic,strong)UITextField *stopTextField;


@end


@implementation LoadGoodsViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
   
        self.title=@"卸货";
    
    _imageArray=[[NSMutableArray alloc]initWithCapacity:0];
    _imgUrlArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    //_imageArray=[[NSMutableArray alloc]initWithObjects:@"to.png", @"to.png",@"to.png",nil];
    [self initAndLayoutUI];
}
-(void)initAndLayoutUI
{
    CGFloat leftSpace=30;
    CGFloat topSpace=20;
    CGFloat bottomSpace=30;
    
    CGFloat Vspace=10;
    //    UILabel *goodsWeight=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace, 100, 30)];
    //
    //    switch (_index) {
    //        case 1:
    //            goodsWeight.text=@"装货重量:";
    //            break;
    //        case 2:
    //            goodsWeight.text=@"卸货重量:";
    //            break;
    //
    //        default:
    //            break;
    //    }
    //
    //    goodsWeight.textColor=[UIColor blackColor];
    //    [self.view addSubview:goodsWeight];
    //
    UIView *line4=[[UIView alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 1)];
    line4.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line4];
    _stopTextField=[[UITextField alloc]initWithFrame:CGRectMake(leftSpace, topSpace, (kScreenWidth-leftSpace*2)*0.8, 30)];
    _stopTextField.placeholder=@"请输入滞港费";
    _stopTextField.delegate=self;
    
    
    
    
    //    _num.backgroundColor=kColor(232, 232, 232, 1);
    [self.view addSubview:_stopTextField];
    UIView *line3=[[UIView alloc]initWithFrame:CGRectMake(0, topSpace+35, kScreenWidth, 1)];
    line3.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line3];
    _num=[[UITextField alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+Vspace, (kScreenWidth-leftSpace*2)*0.8, 30)];
    _num.placeholder=@"请输入装货重量";
    _num.delegate=self;
    
//    _num.contentVerticalAlignment=UIControlContentHorizontalAlignmentCenter;
//    
//    _num.clearButtonMode=UITextFieldViewModeWhileEditing;
//    _num.leftViewMode=UITextFieldViewModeAlways;
//    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 30)];
//    _num.leftView=view;
    
    
//    _num.backgroundColor=kColor(232, 232, 232, 1);
    [self.view addSubview:_num];
    
//    UILabel *unit=[[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth-leftSpace-(kScreenWidth-leftSpace*2)*0.2, topSpace+30+Vspace, (kScreenWidth-leftSpace*2)*0.2, 30)];
//    unit.text=@"吨";
//    unit.textAlignment=NSTextAlignmentCenter;
//    unit.textColor=[UIColor blackColor];
//    [self.view addSubview:unit];
    
    UIView *line1=[[UIView alloc]initWithFrame:CGRectMake(0, topSpace+30+Vspace+35, kScreenWidth, 1)];
    line1.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line1];
    
    UILabel *proof=[[UILabel alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+Vspace+30+Vspace+Vspace, 80, 30)];
    proof.text=@"凭证:";
    proof.textColor=[UIColor blackColor];
    [self.view addSubview:proof];
    
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing=5;
    flowLayout.itemSize=CGSizeMake(60, 60);
    flowLayout.minimumInteritemSpacing=5;
    //UICollectionView *collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+Vspace+30+Vspace+Vspace+30, kScreenWidth-leftSpace*2, 100)];
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(leftSpace, topSpace+30+Vspace+30+Vspace+Vspace+30, kScreenWidth-leftSpace*2, (kScreenHeight-(topSpace+30+Vspace+30+Vspace+Vspace+30))-(kScreenHeight-(kScreenHeight-bottomSpace-40-64-60))) collectionViewLayout:flowLayout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    //[_collectionView registerNib:[UINib nibWithNibName:@"AddCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"add"];
    [_collectionView registerClass:[AddCollectionViewCell class] forCellWithReuseIdentifier:@"add"];
    [_collectionView registerClass:[ImageCollectionViewCell class] forCellWithReuseIdentifier:@"image"];
    
    [self.view addSubview:_collectionView];
    
    UIView *line2=[[UIView alloc]initWithFrame:CGRectMake(leftSpace, kScreenHeight-bottomSpace-80-64-10, kScreenWidth-leftSpace*2, 1)];
    line2.backgroundColor=kColor(201, 201, 201, 1);
    [self.view addSubview:line2];
    //kScreenHeight-bottomSpace-40
    UIButton *commit=[UIButton buttonWithType:UIButtonTypeCustom];
    commit.frame=CGRectMake(leftSpace*2, kScreenHeight-bottomSpace-80-64, kScreenWidth-leftSpace*4, 40);
    [commit setTitle:@"确认" forState:UIControlStateNormal];
    [commit addTarget:self action:@selector(commitInfo:) forControlEvents:UIControlEventTouchUpInside];
    [commit setBackgroundColor:kMainColor];
    commit.layer.cornerRadius=4;
    commit.layer.masksToBounds=YES;
    [self.view addSubview:commit];
    
}
#pragma mark action
-(IBAction)tapImage:(id)sender
{
    NSLog(@"-------点击图片--");
    [_bigImageView removeFromSuperview];
}
//添加图片
-(void)addImv:(UIButton*)add
{
    [self.view endEditing:YES];
    
    if (_imageArray.count==0)
    {
        [self showImageOption1];
    }else
    {
        [self showImageOption2];
    }
    
}
//提交信息
-(void)commitInfo:(UIButton*)sender
{
    switch (_index) {
        case 1:
            [self upInGoods];
            break;
        case 2:
            [self upOutGoods];
            break;
            
        default:
            break;
    }
    
}
//装货
-(void)upInGoods
{
    //    if ([_num.text isEqualToString:@""])
    //    {
    //        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    //        hud.customView = [[UIImageView alloc] init];
    //        hud.mode = MBProgressHUDModeCustomView;
    //        [hud hide:YES afterDelay:1.f];
    //        hud.labelText = @"重量不能为空";
    //
    //    }
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"提交中...";
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *loginId=[userDefault objectForKey:@"loginId"];
    
    NSString *string=@"";
    for (int i=0; i<_imgUrlArray.count; i++)
    {
        NSString *value = [NSString stringWithFormat:@"%@",_imgUrlArray[i]];
        if (i==0)
        {
            string = [string stringByAppendingString:value];
            
        }
        else {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"|%@",value]];
        }
        
    }
    
    [NetWorkInterface upInAccountWithID:_shipRelationID inAccount:[_num.text intValue] loginId:[loginId intValue] imgUrlList:string finished:^(BOOL success, NSData *response) {
        
        NSLog(@"提交装货信息---%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"提交成功";
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
        
    }];
    
}
//卸货
-(void)upOutGoods
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"提交中...";
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *loginId=[userDefault objectForKey:@"loginId"];
    
    NSString *string=@"";
    
    for (int i=0; i<_imgUrlArray.count; i++)
    {
        
        NSString *value = [NSString stringWithFormat:@"%@",_imgUrlArray[i]];
        if (i==0)
        {
            string = [string stringByAppendingString:value];
            
        }
        else {
            string = [string stringByAppendingString:[NSString stringWithFormat:@"|%@",value]];
        }
        
    }
    
    [NetWorkInterface upOutAccountWithID:_shipRelationID inAccount:[_num.text intValue] loginId:[loginId intValue] imgUrlList:string finished:^(BOOL success, NSData *response) {
        
        
        NSLog(@"提交卸货信息---%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"提交成功";
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
        
    }];
    
}
//上传图片
- (void)uploadPictureWithImage:(UIImage *)image
{
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText=@"上传中...";
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *loginId=[userDefault objectForKey:@"loginId"];
    
    [NetWorkInterface uploadSingleImageWithImage:image loginId:loginId finished:^(BOOL success, NSData *response) {
        NSLog(@"上传一张图片---%@",[[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        hud.customView = [[UIImageView alloc] init];
        hud.mode = MBProgressHUDModeCustomView;
        [hud hide:YES afterDelay:0.5f];
        if (success) {
            id object = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:nil];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *errorCode = [NSString stringWithFormat:@"%@",[object objectForKey:@"code"]];
                if ([errorCode intValue] == RequestFail) {
                    //返回错误代码
                    hud.labelText = [NSString stringWithFormat:@"%@",[object objectForKey:@"message"]];
                }
                else if ([errorCode intValue] == RequestSuccess) {
                    hud.labelText = @"上传成功";
                    
                    //上传成功后再把图片显示
                    [_imageArray addObject:image];
                    [self parseImageUploadInfo:object];
                    [_collectionView reloadData];
                }
            }
            else {
                //返回错误数据
                hud.labelText = kServiceReturnWrong;
            }
        }
        else {
            hud.labelText = kNetworkFailed;
        }
        
    }];
}
-(void)parseImageUploadInfo:(NSDictionary*)dic
{
    if (![dic objectForKey:@"result"] || ![[dic objectForKey:@"result"] isKindOfClass:[NSDictionary class]]) {
        return;
    }
    NSDictionary *result=[dic objectForKey:@"result"];
    NSNumber *ID=[result objectForKey:@"id"];
    [_imgUrlArray addObject:ID];
}

#pragma mark  上传图片
- (void)showImageOption1
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@""
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"拍照上传",nil];
    sheet.tag=1111;
    [sheet showInView:self.view];
}
- (void)showImageOption2
{
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@""
                                                     delegate:self
                                            cancelButtonTitle:@"取消"
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:@"拍照上传",@"删除",nil];
    sheet.tag=2222;
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag)
    {
        case 1111:
        {
            NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
            //    if (buttonIndex==0)
            //    {
            //        //相册
            //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            //    }else if (buttonIndex==1)
            //    {
            //        //拍照
            //        sourceType = UIImagePickerControllerSourceTypeCamera;
            //    }
            if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
                buttonIndex != actionSheet.cancelButtonIndex) {
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = self;
                imagePickerController.allowsEditing = YES;
                imagePickerController.sourceType = sourceType;
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
            
        }
            break;
        case 2222:
        {
            NSLog(@"---------2222222222222");
        }
            break;
            
        default:
            break;
    }
    NSInteger sourceType = UIImagePickerControllerSourceTypeCamera;
    //    if (buttonIndex==0)
    //    {
    //        //相册
    //        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    }else if (buttonIndex==1)
    //    {
    //        //拍照
    //        sourceType = UIImagePickerControllerSourceTypeCamera;
    //    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType] &&
        buttonIndex != actionSheet.cancelButtonIndex) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}
#pragma mark --UIImagePickerDelegate--
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"照片信息: %@",info);
    //调接口上传图片
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *editImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self uploadPictureWithImage:editImage];
    
}
#pragma mark collectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_imageArray.count==0)
    {
        return 1;
    }else
    {
        return _imageArray.count + 1;
    }
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_imageArray.count==0)
    {
        AddCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"add" forIndexPath:indexPath];
        
        [cell.addButton addTarget:self action:@selector(addImv:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
        
    }else
    {
        if (indexPath.row==_imageArray.count)
        {
            AddCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"add" forIndexPath:indexPath];
            
            [cell.addButton addTarget:self action:@selector(addImv:) forControlEvents:UIControlEventTouchUpInside];
            
            return cell;
            
        }else
        {
            ImageCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"image" forIndexPath:indexPath];
            cell.imv.image=_imageArray[indexPath.row];
            
            return cell;
        }
        
        
        
    }
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell=(ImageCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [self showBigImageWithImage:cell.imv.image index:indexPath.row];
}
//显示大图
-(void)showBigImageWithImage:(UIImage*)image index:(NSInteger)index
{
    _backView=[[UIView alloc]initWithFrame:self.view.frame];
    _backView.backgroundColor=[UIColor blackColor];
    
    UIScrollView *scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(20, 140, kScreenWidth-40, kScreenHeight-280)];
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    scrollView.showsHorizontalScrollIndicator=NO;
    [UIView animateWithDuration:0.1 animations:^{
        scrollView.contentOffset=CGPointMake((kScreenWidth-40)*index, kScreenHeight-280);
    }];
    
    scrollView.contentSize=CGSizeMake((self.view.bounds.size.width-40)*9, 0);
    for (int i=0; i<_imageArray.count; i++)
    {
        UIImageView *imaV=[[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-40)*i, 0, kScreenWidth-40, kScreenHeight-280)];
        imaV.image=[_imageArray objectAtIndex:i];
        [scrollView addSubview:imaV];
        
    }
    [_backView addSubview:scrollView];
    [self.view addSubview:_backView];
    
    self.pageLabel=[[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth-80)/2, kScreenHeight-20-80, 80, 20)];
    
    self.pageLabel.text=[NSString stringWithFormat:@"%ld/%ld",index+1,_imageArray.count];
    self.pageLabel.textColor=[UIColor whiteColor];
    self.pageLabel.textAlignment=NSTextAlignmentCenter;
    [_backView addSubview:self.pageLabel];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    _backView.userInteractionEnabled=YES;
    [_backView addGestureRecognizer:tap];
    
    
}
-(void)tap:(UITapGestureRecognizer*)tap
{
    [_backView removeFromSuperview];
}
#pragma mark UIScrollView
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger m = scrollView.contentOffset.x/(self.view.bounds.size.width-40);
    self.pageLabel.text=[NSString stringWithFormat:@"%ld/%ld",m+1,_imageArray.count];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_stopTextField resignFirstResponder];

    [_num resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
