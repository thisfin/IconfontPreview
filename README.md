# IconfontPreview

iconfont 文件预览

__[Mac App Store](https://itunes.apple.com/cn/app/iconfontpreview/id1197961160)__

## 2.0

* 去掉 css 依赖, 直接读取 ttf 获取信息
* 程序整体重构, 架构变为 document-base
* NSTableView -> NSCollectionView
* 支持 Finder 中右键打开, 拖动文件到 icon 打开, 拖动文件到程序窗口打开, dock 根据历史打开
* 菜单栏重写, 支持快捷键
* 修正了由于没有配置权限 bookmake, 导致打开上次保存的地址时权限不足报错
* 修正了 utf-32 编码解析溢出
* [icomoon](https://icomoon.io/)
* [material-icons](https://material.io/icons/)
* without storyboard & xib

## 1.0.0

* 预览iconfont文件
* 点击拷贝unicode值
* font-awesome & iconfont 已经测试通过
* 自动保存上次打开路径
* 通过解析字体文件 ttf 和对应配置文件 css 解析做展示
* [font-awesome](http://fontawesome.io/)
* [iconfont](http://iconfont.cn/)
* without storyboard & xib

## todo

* 自建的 mainmenu 里面 open recent 记录更新
