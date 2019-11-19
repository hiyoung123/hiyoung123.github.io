---
title: hexo博客功能记录
top: false
cover: false
toc: true
mathjax: true
tags:
  - Hexo
abbrlink: 7b350200
date: 2019-11-15 17:35:48
password:
summary:
categories:
---

## 外部插件
* url汉语拼音
* rss
* 代码高亮
* 豆瓣爬虫
* 搜索
* emoj表情（没用）
* 动漫人物（没用）

## 基本功能
* 添加关于、分类、标签、友链等菜单
* 同一友链卡片的样式
* 添加底部统计文章字数
* 添加媒体菜单以及子菜单
* 添加评论功能
* 优化了url
* 修改主题背景颜色
* 添加打赏二维码
* 添加音乐播放
* 绑定域名需要添加cname文件
* 添加去水印脚本
* 添加交换友链卡片
* 添加google和baidu统计　完成，但没有开启baidu主动推送，麻烦、
* 添加雪花效果(未实现)

## godweiyang
* 添加简历（未实现）
* 添加404页面
* 解决代码和数学冲突
* 在文章中添加网易云音乐
* 添加动态标签栏（未实现）
* 使用cloudflare貌似可以做到域名重定向（没有实现）

## licardo
* 可托管至coding或者码云
* 修改字体(未实现)https://licardo.cn/posts/16590/

## sitoi
* 图床cdn:https://sitoi.cn/posts/39161.html完成

## sunhwee洪卫
* 添加天气插件(未实现)
* 添加pv等统计(未实现)
* 添加快捷导航百度接口等信息(未实现)
* seo优化(未实现)https://sunhwee.com/posts/6e8839eb.html
* 部署到github和coding可加速访问速度
* cdn优化 :目前只对logo和头像进行了cdn优化
* 图片优化: 只进行了cdn优化，没有压缩
* 图片懒加载 : 修改为只对文章图片懒加载
* 修改为只对文章的引用资源进行CDN。
* 代码压缩，图片压缩(没有实现)
* 每个菜单的首图样式（是统一的首页背景hiyoung标题，还是每个菜单不一样的标题一样的背景，还是每个菜单不一样的背景不一样的标题)选择了同一背景不同标题，描述是否同一后续决定
* 首图描述动态改变(未添加)https://github.com/shw2018/hexo-blog-fly/blob/master/themes/matery/layout/_partial/bg-cover-content.ejs
* 文章卡片长短不一（新版本已经没有该问题，老版本有）
* 优化url，中文改成编码后的url.

## bug
* 解决部分菜单页面，标题不显示中文
* 添加www访问网站时，出现404: 需要在coding部署设置中，绑定一下wwww的域名，同时需要申请证书，如果申请失败的话，在域名解析处将境外的解析记录关掉，然后再去申请。申请成功后再打开境外的记录。
* 卜算子区分www和不带www的域名，导致访问数无法同步。可能需要重定向
* gitalk评论无法使用，配置中repo写错了
* markdown流程图需要安装如下插件：
  hexo-filter-sequence
  hexo-filter-mermaid-diagrams：需要配置_config和footer,ejs，配置成功后可以显示
  hexo-filter-flowchart
  讲解博客：https://blog.csdn.net/Olivia_Vang/article/details/92987859
