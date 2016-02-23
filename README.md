使用步骤:
1.将 YJYYWaterFlow文件夹 拖入项目

2.导入头文件 #import "YJYYWaterFlowLayout.h"

3.实例化YJYYWaterFlowLayout 并在实例化UICollectionView时传入我们这里自定义的布局 代码如下
 YJYYWaterFlowLayout * flowLayout = [[YJYYWaterFlowLayout alloc]init];
    
    //设置item的高度 这句话必须实现
    flowLayout.itemHeight = ^(NSInteger index, CGFloat itemWidth){
        //取出商品信息
        YJYYShop * shop = self.shops[index];
        return itemWidth * shop.h / shop.w;
    };
4.如需改变布局的属性 行间距/列间距/四周边距等可参考如下代码或者demo:
      //设置item的行间距
    flowLayout.rowMargin = ^{
        return 30.0;
    };
    
    //设置item的列间距
    flowLayout.columMargin = ^{
        return 40.0;
    };
    
    
    //设置四周间距
    flowLayout.edgeInsets = ^{
        return UIEdgeInsetsMake(20, 40, 60, 20);
    };
5.如果有什么问题希望您能issue我 QQ:794708907

