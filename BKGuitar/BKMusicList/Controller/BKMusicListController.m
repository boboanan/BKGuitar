//
//  BKMusicListController.m
//  BKGuitar
//
//  Created by 锄禾日当午 on 15/8/29.
//  Copyright (c) 2015年 B&K. All rights reserved.
//

#import "BKMusicListController.h"
#import "UPStackMenu.h"
#import <UzysAssetsPickerController.h>
#import "MBProgressHUD+MJ.h"
#import "BKTool.h"
#import "BKImageShowController.h"
#import "BKNavigationController.h"

@interface BKMusicListController ()<UPStackMenuDelegate,UzysAssetsPickerControllerDelegate,UIAlertViewDelegate>{
    UIView *contentView;
    UPStackMenu *stack;
    BOOL isDelete;
}

@property (nonatomic, strong) NSMutableArray *images;
@property (nonatomic, strong)NSMutableArray *names;
@end

@implementation BKMusicListController
-(NSMutableArray *)names
{
    if(_names == nil){
        _names = [NSMutableArray array];
        //获取plist目录
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
        NSString *newPath = [caches stringByAppendingPathComponent:@"pic.plist"];
        //获取plist中的存储图片名的字典
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:newPath];
        
        if(arr){
            _names = arr;
        }
    }
    return _names;
}

-(NSMutableArray *)images
{
    if(!_images){
       //获取plist目录
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
        NSString *newPath = [caches stringByAppendingPathComponent:@"pic.plist"];
        //获取plist中的存储图片名的字典
        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:newPath];
        
        _images = [NSMutableArray array];
        if(!arr){//不存在缓存图片时，直接返回
            return _images;
        }
        for(int i = 0; i < arr.count; i++){
            //存在时获得图片
            NSString *file = [caches stringByAppendingPathComponent:arr[i]];
            
            NSData *data = [NSData dataWithContentsOfFile:file];
            
            UIImage *image = [UIImage imageWithData:data];
            
            [_images addObject:image];
        }
    }
    return _images;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNav];
    
    [self setAddBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//设置导航栏
-(void)setNav
{
    
    self.navigationItem.title = @"我的吉他谱";

}

//设置添加按钮
-(void)setAddBtn{
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [contentView setBackgroundColor:BKColorBlue];
    [contentView.layer setCornerRadius:20];
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross"]];
    [icon setContentMode:UIViewContentModeScaleAspectFit];
    [icon setFrame:CGRectInset(contentView.frame, 10, 10)];
    [contentView addSubview:icon];
    
    stack = [[UPStackMenu alloc] initWithContentView:contentView];
    stack.center = CGPointMake(self.view.frame.size.width /2, self.view.frame.size.height-20);
    stack.delegate = self;
    
    UPStackMenuItem *squareItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"cross_blue"] highlightedImage:nil title:@"添加"];
    UPStackMenuItem *circleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"circle"] highlightedImage:nil title:@"删除"];
    UPStackMenuItem *triangleItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"triangle"] highlightedImage:nil title:@"Triangle"];
    UPStackMenuItem *crossItem = [[UPStackMenuItem alloc] initWithImage:[UIImage imageNamed:@"square"] highlightedImage:nil title:@"Cross"];
    NSMutableArray *items = [[NSMutableArray alloc] initWithObjects:squareItem, circleItem, triangleItem, crossItem, nil];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:BKColorBlue];
    }];
    
    
    [stack setAnimationType:UPStackMenuAnimationType_progressive];
    [stack setStackPosition:UPStackMenuStackPosition_up];
    [stack setOpenAnimationDuration:.4];
    [stack setCloseAnimationDuration:.4];
    [items enumerateObjectsUsingBlock:^(UPStackMenuItem *item, NSUInteger idx, BOOL *stop) {
        [item setLabelPosition:UPStackMenuItemLabelPosition_right];
        [item setLabelPosition:UPStackMenuItemLabelPosition_left];
    }];

    
    
    [stack addItems:items];
    [[UIApplication sharedApplication].keyWindow addSubview:stack];
    //    [self.view addSubview:stack];
    [self setStackIconClosed:YES];
}



- (void)setStackIconClosed:(BOOL)closed
{
    UIImageView *icon = [[contentView subviews] objectAtIndex:0];
    float angle = closed ? 0 : (M_PI * (135) / 180.0);
    [UIView animateWithDuration:0.3 animations:^{
        [icon.layer setAffineTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
}


#pragma mark - UPStackMenuDelegate

- (void)stackMenuWillOpen:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:NO];
}

- (void)stackMenuWillClose:(UPStackMenu *)menu
{
    if([[contentView subviews] count] == 0)
        return;
    
    [self setStackIconClosed:YES];
}

- (void)stackMenu:(UPStackMenu *)menu didTouchItem:(UPStackMenuItem *)item atIndex:(NSUInteger)index
{
    if(index == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"添加吉他谱谱" message:@"请输入名字" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.alertViewStyle=UIAlertViewStylePlainTextInput; //设置窗口内容样式
        UITextField *textField= [alert textFieldAtIndex:0]; //取得文本框
        textField.text=@""; //设置文本框内容
        [alert show];
        //设置picker样式
  
    }else if(index == 1){
        isDelete = !isDelete;
        if(isDelete){
            [MBProgressHUD showSuccess:@"删除模式"];
        }else{
            [MBProgressHUD showError:@"取消删除模式 "];
        }
    }
}

//#pragma mark 窗口的代理方法，用户保存数据
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //当点击了第二个按钮（OK）
    if (buttonIndex==1) {
        UITextField *textField= [alertView textFieldAtIndex:0];
        [self.names addObject:textField.text];
        
        UzysAppearanceConfig *appearanceConfig = [[UzysAppearanceConfig alloc] init];
        appearanceConfig.finishSelectionButtonColor = BKColorBlue;
        appearanceConfig.assetsGroupSelectedImageName = @"checker";
        [UzysAssetsPickerController setUpAppearanceConfig:appearanceConfig];
        
        UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
        picker.delegate = self;
        
        picker.maximumNumberOfSelectionVideo = 0;
        picker.maximumNumberOfSelectionPhoto = 1;
        
        
        [self presentViewController:picker animated:YES completion:^{
            
        }];
    }
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.imageView.image = self.images[indexPath.row];
    cell.textLabel.text = self.names[indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if(isDelete){
            NSFileManager* fileManager=[NSFileManager defaultManager];
            NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
    
            NSString *newPath = [caches stringByAppendingPathComponent:@"pic.plist"];
            //获取plist中的存储图片名的字典
            NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:newPath];
    
            NSString *file = [caches stringByAppendingPathComponent:arr[indexPath.row]];
    
    
            if (!arr[indexPath.row]) {
                return ;
            }
            //移去删除的图片，并重新写入plist
            [arr removeObjectAtIndex:indexPath.row];
            [arr writeToFile:newPath atomically:YES];
            [self.images removeObjectAtIndex:indexPath.row];
            BOOL result=[[NSFileManager defaultManager] fileExistsAtPath:file];
            if (!result) {
                return ;
            }else {
                BOOL blDele= [fileManager removeItemAtPath:file error:nil];
                if (blDele) {
                    [MBProgressHUD showSuccess:@"删除成功"];
                }else {
                    [MBProgressHUD showError:@"删除失败"];
                }
                
            }
     
        [self.tableView reloadData];
    }else{
        NSArray *images = @[self.images[indexPath.row]];
        BKImageShowController *imageShowController = [BKImageShowController controllerInitWithImagesArray:images index:0];
        BKNavigationController *nav = [[BKNavigationController alloc] initWithRootViewController:imageShowController];
        [self presentViewController:nav animated:YES completion:^{
            
        }];
    }

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        //删除数据
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
        
//        //删除图片
//        NSFileManager* fileManager=[NSFileManager defaultManager];
//        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
//        
//        NSString *newPath = [caches stringByAppendingPathComponent:@"pic.plist"];
//        //获取plist中的存储图片名的字典
//        NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:newPath];
//        
//        NSString *file = [caches stringByAppendingPathComponent:arr[indexPath.row]];
//        
//        
//        if (!arr[indexPath.row]) {
//            return ;
//        }
//        //移去删除的图片，并重新写入plist
//        [arr removeObjectAtIndex:indexPath.row];
//        [arr writeToFile:newPath atomically:YES];
//        [self.images removeObjectAtIndex:indexPath.row];
//        BOOL result=[[NSFileManager defaultManager] fileExistsAtPath:file];
//        if (!result) {
//            return ;
//        }else {
//            BOOL blDele= [fileManager removeItemAtPath:file error:nil];
//            if (blDele) {
//                [MBProgressHUD showSuccess:@"删除成功"];
//            }else {
//                [MBProgressHUD showError:@"删除失败"];
//            }
//            
//        }
    }
}

#pragma UzysAssetsPickerControllerDelegate
- (void)uzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    __weak typeof(self) weakSelf = self;
    if([[assets[0] valueForProperty:@"ALAssetPropertyType"] isEqualToString:@"ALAssetTypePhoto"]) //Photo
    {
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            ALAsset *representation = obj;
            
            UIImage *img = [UIImage imageWithCGImage:representation.defaultRepresentation.fullResolutionImage
                                               scale:representation.defaultRepresentation.scale
                                         orientation:(UIImageOrientation)representation.defaultRepresentation.orientation];
            [weakSelf.images addObject:img];

//            [self saveImage:img Name:representation.defaultRepresentation.filename];
            [self saveImage:img Name:self.names.lastObject];
                 [self.tableView reloadData];
            *stop = YES;
        }];
        
        
    }
}

#pragma customer methods
-(void)saveImage:(UIImage *)image Name:(NSString *)name
{
    //将图片转为二进制文件
    NSData *data = UIImageJPEGRepresentation(image, 1);
    //图片写入沙盒
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) lastObject];
    
    NSString *file = [caches stringByAppendingPathComponent:name];
    
    BOOL result = [data writeToFile:file atomically:YES];
   
    if (result) {
        [MBProgressHUD showSuccess:@"success"];
    }else {
        [MBProgressHUD showError:@"error"];
    }
    
    //将图片名字存入plist
    NSString *newPath = [caches stringByAppendingPathComponent:@"pic.plist"];
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:newPath];
    if(!arr){
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        [arr addObject:name];
        [arr writeToFile:newPath atomically:YES];
    }
    [arr addObject:name];
    [arr writeToFile:newPath atomically:YES];
  

}


@end