---
title: 最全Hexo博客搭建教程以及优化
top: true
cover: false
toc: true
mathjax: true
tags:
  - Hexo
  - 博客
categories:
  - 网站搭建与优化
abbrlink: 4dbbde95
date: 2019-11-16 11:50:59
password:
summary:
excerpt: 最全Hexo博客搭建教程以及优化 使用Hexo+Github搭建一个免费的个人博客，本文略长，大佬请自行选择阅读。
---
> 使用Hexo+Github搭建一个免费的个人博客，本文略长，大佬请自行选择阅读。

##  前言

一边上班一边搭建博客，忙了大概有一周左右的时间，终于把博客都调好了。我使用的是`Hexo`框架，主题是闪烁之狐之狐的[hexo-theme-matery](https://github.com/blinkfox/hexo-theme-matery/blob/develop/README_CN.md)，本文介绍的也是该主题的配置，大家如果喜欢可以去下载使用。

本文除了介绍了`matery`主题的一些基础配置之外，也介绍了一些我个人和在其他大佬处看到的功能定制。只要你懂得操作软件，懂得键盘打字，那么就可以通过本教程搭建一个完全`免费`的个人博客。如果你是技术大佬，那么更可以通过修改源码去定制更好的功能。本文也记录了一些我搭建过程中遇到的坑，希望可以帮你在搭建过程中少走一些弯路，同时如果你也遇到一些本文没有记载的*bug*，也请你给我留言，让我们一起学习解决，多谢。

## 第一部分：准备

### 1.Hexo介绍

[Hexo](https://hexo.io/zh-cn/)是一款快速、简洁且高效的基于`Node.js`的静态博客框架，四大特性：

* 超快速度：`Node.js` 所带来的超快生成速度，让上百个页面在几秒内瞬间完成渲染。
* 支持Markdown：`Hexo` 支持 `GitHub Flavored Markdown` 的所有功能，甚至可以整合 `Octopress` 的大多数插件。
* 一键部署：只需一条指令即可部署到 `GitHub Pages`, `Heroku`或其他平台。
* 插件和可扩展性：强大的 `API` 带来无限的可能，与数种模板引擎`（EJS，Pug，Nunjucks）`和工具`（Babel，PostCSS，Less/Sass）`轻易集成。

这使得很多非编程人员可以很轻松，很自由的定制博客。废话不多说，开始进入搭建环境把。

### 2.安装Node环境

####  Linux

直接命令行输入：

```bash
sudo apt-get install nodejs
sudo apt-get install npm
```

或者到[官网](http://nodejs.cn/download/)下载：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_download_nodejs_1.png)

下载完成后解压到指定文件夹，然后配置环境变量（目的是为了在终端可以任意位置使用它）：

首先打开`~/.bashrc`文件

```bash
vim ~/.bashrc
```

在文件的最下端填写如下代码

```bash
export PATH=${PATH}:$HOME/node-v12.13.0-linux-x64/bin/
```

因为我下载的是`64`位`12.13.0`版本，并且放到了根目录`home`下，你可以根据自己的需求进行更改上面的路径。保存退出后，执行命令让修改生效。

```bash
source ~/.bashrc
```

然后在终端输入`npm -v`和`node -v`验证是否安装配置成功

```bash
$npm -v
6.13.0

$node -v
v12.13.0
```

#### Windows

下载稳定版或者最新版都可以[Node.js](http://nodejs.cn/download/)，安装选项全部默认，一路点击`Next`。最后安装好之后，按`Win+R`打开命令提示符，输入`node -v`和`npm -v`，如果出现版本号，那么就安装成功了。

####  npm加速

一般国内通过`npm`下载东西会比较慢，所以需要添加阿里的源进行加速。

```bash
npm config set registry https://registry.npm.taobao.org
```

### 3.安装Git

为了把本地的网页文件上传到`Github`上面去，我们需要用到分布式版本控制工具 `git`。关于`git`和`Github`这里就不多介绍了。同样分为两个版本：

####  Linux

在Linux平台比较方便，直接使用命令就可以安装：

```bash
sudo apt-get install git
```

安装完成后即可享用。

####  Windows

需要去官网下载[Git]( https://git-scm.com/download/win )，下载完成后按照向导安装即可。

> 注意：在安装的最后一步添加路径时选择 Use Git from the Windows Command Prompt 。这是把Git添加到了环境变量中，以便可以在cmd中使用。而本人推荐使用下载附带的git bash进行操作，比较方便。

对于git的讲解和使用，大家可以自行到网上查找。`Hexo`搭建的过程中，已经封装好一个git命令，可以直接使用`hexo`的命令将生成的静态网站代码同步到`github`的仓库里。但是如果想要自己同步源码的话，那么就需要掌握一下git命令了。在这里我只列举一下常用的命令：

```bash
git init #初始化一个git库，生成.git文件夹，里面保存的是该git库的记录和配置
git remote add origin 远程仓库地址 #将本地仓库和远程仓库链接起来
git pull #同步代码
git status #检查本地仓库修改状态
git add 文件名 或者 git add .  #将本地修改的文件加入缓存
git commit 文件名 -m "描述" 或者 git commit . -m "描述"  #提交缓存，并描述该提交
git push -u origin code 
# 将本地的提交推送到远程仓库.-u是代表输入账号密码，如果你已经配置了git的公钥，那么可直接push.
```

### 4.注册Github

`Git`安装完成之后就可以去[Github]( https://github.com/ )上注册账号并创建仓库， 用来存放我们的网站了。

>  Github是基于 Git 做版本控制的代码托管平台，同时也是全球最大的代（同）码（性）托（交）管（友）网站。 

创建完账户之后新建一个项目仓库`New repository`，如下所示 

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_github_new_rep.png)

接着输入仓库名，后面一定要加`.github.io`后缀，README初始化也要勾上。 如下图配置（因为我的已经存在相同的仓库，所以报错）

> 要创建一个和你用户名相同的仓库，后面加.github.io，只有这样将来要部署到GitHub page的时候，才会被识别，也就是http://xxxx.github.io，其中xxx就是你注册`GitHub`的用户名 

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_github_creat_rep.png)

然后项目就建成了，点击`Settings`，向下拉到最后有个`GitHub Pages`，点击`Choose a theme`选择一个主题。然后等一会儿，再回到`GitHub Pages`，点击新出来的链接，就会进入到`github page`的界面。看到这个界面就说明`Github`的`page`已经可以使用了，接下来我们进入`Hexo`的搭建。



## 第二部分：搭建

### 1.安装Hexo

首先创建一个文件夹，名字自取如`YoungBlog`，用来存放自己的博客文件，然后`cd`到这个文件夹下（或者在这个文件夹下直接右键`git bash`打开）。在该目录下输入如下命令安装`Hexo`：

```bash
npm install -g hexo-cli
```

接下来初始化一下`hexo`,即初始化我们的网站，

```bash
hexo init
```

> 初始化要求必须是空的目录下进行。

接着输入`npm install`安装必备的组件。

初始化完成后会在目下生成几个文件和文件夹，这些就是我们需要编写的网站源码了：

* `node_modules:` 依赖包，npm安装的一些插件存放的文件夹。
* `public：`存放生成的页面，网站正式展示的内容。
* `scaffolds：`生成文章和页面的一些模板。
* `source：`用来存放你的文章和数据。
* `themes：`主题存放文件夹。
* `_config.yml:` 博客的配置文件，非主题的配置。
* `db.json`：博客的版本信息等。
* `package.json`和`package-lock.json`：依赖包和版本信息。

这样本地的网站配置也弄好啦，输入`hexo g`生成静态网页，然后输入`hexo s`打开本地服务器，然后浏览器打开[http://localhost:4000](http://localhost:4000)就可以看到我们的博客啦，效果如下：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_web_1.png)

这里介绍一下`Hexo`常用的几个命令：

```bash
hexo clean #清除db和public文件下的内容，或可写成hexo cl
hexo g #根据源码生成静态文件
hexo s #开启本地的server，这样可在本地通过localhost:4000访问博客。或可写成hexo server
hexo d #部署网站的静态文件到配置好的托管网站，如Github或者Coding，配置在_config中的Deploy。
#后续如果安装了一些插件，可能导致缩写无法使用，所以hexo d也可以写成hexo deploy。
```

看完展示后，可以按`ctrl+c`关闭本地服务器。

### 2.部署到Github

首先要安装一个插件，用于`Hexo`部署代码的。

```bash
npm i hexo-deployer-git
```

安装完成之后，在`_config.yml`配置文件中加入如下代码，这样我们在使用`hexo d`的时候就可以直接部署到`Github`上了，如果你想部署到其他平台（支持`Git`），也可以添加到这里。

```bash
deploy:
  type: git
  repository: https://github.com/hiyoung123/hiyoung123.github.io
  branch: master
```

> 如果不了解git那么请先自行百度学习一下git的相关配置。

`Git`分为无密推送和需要输入账户密码推送。无密码推送就是需要在本地生成公钥，然后添加到代码托管平台如`Github`，这样在推送时候就不需要输入账户密码了。而反之的话，每次推送就会要求你输入账户密码。下面说一下无密推送的配置过程。

首先打开`Git bash`，输入如下内容：

```bash
git config --global user.name "你的用户名"
git config --global user.email "你的邮箱"
```

用户名和邮箱根据你注册`github`的信息自行修改。

然后生成密钥SSH key：

```bash
ssh-keygen -t rsa -C "你的邮箱"
```

这个时候它会告诉你已经生成了`.ssh`的文件夹。在你的电脑中找到这个文件夹。或者`git bash`中输入

```bash
cat ~/.ssh/id_rsa.pub
```

打开[github](http://github.com/)，在头像下面点击`settings`，再点击`SSH and GPG keys`，新建一个`SSH`，名字随便取一个都可以，把你的`id_rsa.pub`里面的信息复制进去。

这样你的电脑就跟`Github`建立起的安全联系，以后推送代码就不需要输入密码了。

> 注意：这里使用hexo d推送代码，推送的是编译完成的静态文件，也就是上面说的public文件夹下的代码，而不是网站的源代码。

### 3.写文章、发布文章

输入`hexo new post "article title"`，新建一篇文章。

然后打开`\source\_posts`的目录，可以发现下面多了一个文件夹和一个`.md`文件，一个用来存放你的图片等数据，另一个就是你的文章文件啦。

编写完markdown文件后，根目录下输入`hexo g`生成静态网页，然后输入`hexo s`可以本地预览效果，最后输入`hexo d`上传到`github`上。这时打开你的`github.io`主页就能看到发布的文章啦。

### 4.绑定个人域名

现在默认的域名还是`xxx.github.io`，是不是很没有牌面？想不想也像我一样弄一个专属域名呢，首先你得购买一个域名，xx云都能买，看你个人喜好了。

以我的阿里云为例，如下图所示，添加两条解析记录：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_add_domin.png)

我添加的是A记录，也就是需要添加`IP`地址的，你部署到`Github`的`IP`可以通过`ping xxx.github.io`获得。当然也可以添加`CNAME`记录，记录值填写`xxx.github.io`即可。

解析域名完成后，需要在`Github`上加入你的域名。打开你的`github`博客项目，点击`settings`，拉到下面`Custom domain`处，填上你自己的域名，保存完成后如下图：

![](https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_add_domin_github.png)

> 注意：如果下面的Enforce HTTPS 没有点击的话请勾选上。这个作用是使你的网络请求以更安全的HTTPS方式请求。

这时候你的项目根目录应该会出现一个名为`CNAME`的文件了，如果没有的话，打开你本地博客`/source`目录，新建`CNAME`文件，注意没有后缀。然后在里面写上你的域名，保存。因为每次推送代码的时候，都会把`Github`自动生成的`CNAME`文件删除掉，导致每次推送后域名和`Github`就失去了联系，我们在`source/`下自己创建一个`CNAME`文件，这样就可以永久保存了。

### 5.备份博客源文件

这次我们提交到`Github`上的是博客的源代码，这样我们就可以在不同电脑上进行操作了。

首先在`github`博客仓库下新建一个分支`code`，然后`git clone`到本地，把`.git`文件夹拿出来，放在博客根目录下（也可以博客根目录下执行`git init` , 然后 `git remote add origin 远端仓库地址的方式`）。然后`git checkout code`切换到`code`分支，然后`git add .`，然后`git commit -m "xxx"`，最后`git push origin code`提交就行了。



## 第三部分：定制

这部分主要讲解一下主题的功能定制，除了基本的功能定制外，还有我参考各个大佬们的功能，有些我虽然没有加在我的博客上，但是也列在了此处。所以先在此处感谢一下各位大佬的博客文章。

[闪烁之狐的原版定制](https://github.com/blinkfox/hexo-theme-matery) | [Godweiyang](https://godweiyang.com/2018/04/13/hexo-blog/) | [洪卫](https://sunhwee.com/posts/6e8839eb.html) | [Sky03](https://blog.sky03.cn/2019/42790.html)

### 1.更换主题

下载主题，解压到博客目录下的`themes`目录，修改根目录下的 `_config.yml` 的 `theme` 的值：`theme: hexo-theme-matery`

### 2.设置文章模板

`Hexo`的页面是包括一个`md`文件和`ejs`文件结合而成的，`md`文件中的内容是页面配置，基本信息，和显示的内容。而`ejs`文件就是`js`逻辑代码了。

我们在`scaffolds/post.md`中设置文章的默认模板，这样以后创建文章的时候，这些信息就默认添加上了，不同文章你也可以修改这些信息。

```bash
---
title: {{ title }}
date: {{ date }}
top: false
cover: false
password:
toc: true
mathjax: true
summary:
tags:
categories:
---
```

### 3.添加404页面

原来的主题没有404页面，所以我们自己添加一个。首先在`/source/`目录下新建一个`404.md`，内容如下：

```bash
---
title: 404
date: 2019-07-19 16:41:10
type: "404"
layout: "404"
description: "你来到了没有知识的荒原 :("
---
```

然后在`/themes/matery/layout/`目录下新建一个`404.ejs`文件，内容如下：

```bash
<style type="text/css">
    /* don't remove. */
    .about-cover {
        height: 75vh;
    }
</style>
<div class="bg-cover pd-header about-cover">
    <div class="container">
        <div class="row">
            <div class="col s10 offset-s1 m8 offset-m2 l8 offset-l2">
                <div class="brand">
                    <div class="title center-align">
                        404
                    </div>
                    <div class="description center-align">
                        <%= page.description %>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    // 每天切换 banner 图.  Switch banner image every day.
    $('.bg-cover').css('background-image', 'url(/medias/banner/' + new Date().getDay() + '.jpg)');
</script>
```

### 4.添加二级菜单

因为我使用的是最新版的主题代码，所以二级菜单可以直接在主题的配置文件`_config.yml`中配置，而不需要自己添加代码。如果你是老版本的主题，那么你可以参考上述两位大佬的博客进行添加代码。

```bash
  # 二级菜单写法如下
  Medias:
    icon: fas fa-list
    children:
      - name: Books
        url: /books
        icon: fas fa-book
      - name: Musics
        url: /musics
        icon: fas fa-music
      - name: Movies
        url: /movies
        icon: fas fa-film
      - name: Galleries
        url: /galleries
        icon: fas fa-image
```

这样我们就可以在导航栏中看见媒体的图标以及二级图标了，不过由于我们没有创建对应的页面，所以无法看见内容。这里只举例说一下`musics`页面的创建。

先使用命令创建`musics`对应的`md`文件

```bash
hexo new page "musics"
```

这样就在`source`目录下生成一个`musics`目录了，里面包含一个`index.md`就是`musics`页面的配置文件了。我们填入对应`layout`的`ejs`文件

```bash
---
title: musics
date: 2019-11-14 23:41:25
type: "musics"
layout: "musics"
---
```

然后在主题的`layout`目录下创建`ejs`文件，并写入如下内容：

```bash
<%- partial('_partial/bg-cover') %>

<main class="content">
    <div id="contact" class="container chip-container">
                <div class="card">
                    <div class="card-content" style="text-align: center">
                            <h3 style="margin: 5px 0 5px 5px;">如果你有好的内容推荐，欢迎在下面留言！</h3>
                        </div>
                </div>
                <div class="card">
                    <% if (theme.gitalk && theme.gitalk.enable) { %>
                        <%- partial('_partial/gitalk') %>
                        <% } %>

                        <% if (theme.gitment.enable) { %>
                        <%- partial('_partial/gitment') %>
                        <% } %>

                        <% if (theme.disqus.enable) { %>
                        <%- partial('_partial/disqus') %>
                        <% } %>

                        <% if (theme.livere && theme.livere.enable) { %>
                        <%- partial('_partial/livere') %>
                        <% } %>

                        <% if (theme.valine && theme.valine.enable) { %>
                        <%- partial('_partial/valine') %>
                        <% } %>
                </div>
        </div>
</main>

```

这样一个页面就创建好了，具体内容可自行修改，其他页面也是如此创建的。

> 这里有一个bug，就是二级菜单不显示中文，解决方法请见Debug部分。

### 5.图片添加水印

为了防止别人抄袭你文章，可以把所有的图片都加上水印，方法很简单。首先在博客根目录下新建一个`watermark.py`，代码如下：

```python
# -*- coding: utf-8 -*-
import sys
import glob
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

def watermark(post_name):
    if post_name == 'all':
        post_name = '*'
    dir_name = 'source/_posts/' + post_name + '/*'
    for files in glob.glob(dir_name):
        im = Image.open(files)
        if len(im.getbands()) < 3:
            im = im.convert('RGB')
            print(files)
        font = ImageFont.truetype('STSONG.TTF', max(30, int(im.size[1] / 20)))
        draw = ImageDraw.Draw(im)
        draw.text((im.size[0] / 2, im.size[1] / 2),
                  u'@hiyoung', fill=(0, 0, 0), font=font)
        im.save(files)

if __name__ == '__main__':
    if len(sys.argv) == 2:
        watermark(sys.argv[1])
    else:
        print('[usage] <input>')

```

字体也放根目录下，自己找字体。然后每次写完一篇文章可以运行`python3 watermark.py postname`添加水印，如果第一次运行要给所有文章添加水印，可以运行`python3 watermark.py all`。

> 这个代码的逻辑就是从文章目录下拿到图片，添加水印。这个前提是要文章的图片放在source/_posts/下，所以如果在文章中直接引用了其他地方的图片链接，那么这个脚本不会去给那个图片加水印了。

### 6.动态标签栏

这个功能我没有添加，只是简单的一段代码，在`theme/matery/layout/layout.ejs`下添加如下代码：

```javascript
<script type="text/javascript"> var OriginTitile = document.title, st; document.addEventListener("visibilitychange", function () { document.hidden ? (document.title = "Σ(っ °Д °;)っ喔哟，崩溃啦！", clearTimeout(st)) : (document.title = "φ(゜▽゜*)♪咦，又好了！", st = setTimeout(function () { document.title = OriginTitile }, 3e3)) }) </script>
```

### 7.添加豆瓣插件

我的二级菜单书单和电影都是通过豆瓣插件来添加内容的。

首先安装插件：

```bash
npm install hexo-douban --save
```

将下面的配置写入博客的 `_config.yml` 文件里：

```bash
douban:
  user: #填写你的豆瓣id，打开豆瓣，登入账户，然后在右上角点击 ”个人主页“，url的后面就是id。
  builtin: true
  book:
    title: '我的无味书屋！'
    quote: '沉醉于知识的hiyoung.'
  movie:
    title: '电影推荐'
    quote: '沉醉于电影的hiyoung.'
  #game:　不想要的内容可注释掉
  #  title: 'This is my game title'
  #  quote: 'This is my game quote'
  timeout: 10000

```

然后创建对应的页面，在页面的`ejs`文件中添加如下代码：

```javascript
<%- partial('_partial/bg-cover') %>
<style>
    .hexo-douban-picture img {
        width: 100%;
        }
</style>

<main class="content">
    <div id="contact" class="container chip-container">
            <div class="card">
                    <div class="card-content" style="padding: 30px">
                            <h1 style="margin: 10px 0 10px 0px;">
                                        <div class="tag-title center-align">
                                        <i class="fas fa-book"></i>&nbsp;&nbsp;<%- page.title %>
                    </div>
                                </h1>
                                <%- page.content %>
                        </div>
                </div>
                <div class="card">
                    <div class="card-content" style="text-align: center">
                            <h3 style="margin: 5px 0 5px 5px;">如果你有好的内容推荐，欢迎在下面留言！</h3>
                        </div>
                </div>
                <div class="card">
                    <% if (theme.gitalk && theme.gitalk.enable) { %>
                        <%- partial('_partial/gitalk') %>
                        <% } %>

                        <% if (theme.gitment.enable) { %>
                        <%- partial('_partial/gitment') %>
                        <% } %>

                        <% if (theme.disqus.enable) { %>
                        <%- partial('_partial/disqus') %>
                        <% } %>

                        <% if (theme.livere && theme.livere.enable) { %>
                        <%- partial('_partial/livere') %>
                        <% } %>

                        <% if (theme.valine && theme.valine.enable) { %>
                        <%- partial('_partial/valine') %>
                        <% } %>
                </div>
        </div>
</main>

```

在你的博客文件夹内找到这个文件夹 `/node_modules/hexo-douban/lib` ，这个文件夹内找到以下三个文件： `books-generator.js` 、`games-generator.js` 、`movies-generator.js`

将每个文件内最下面的：

```javascript
layout: ['page', 'post']
```

改为：

```javascript
layout: ['page', 'books']
```

`books`是对应的呈现内容的`ejs`文件名。这样我们的豆瓣内容就设置完成了，可以进行编译部署了。

> 通常大家都喜欢用 `hexo d` 来作为 `hexo deploy` 命令的简化，但是当安装了 `hexo douban` 之后，就不能用 `hexo d` 了，因为 `hexo douban` 跟 `hexo deploy` 的前缀都是 `hexo d` ，你以后执行的 `hexo d` 将不再是 Hexo 页面的生成，而是豆瓣页面的生成。
>
> 这里也说一下这个插件的逻辑，该插件通过你设置的豆瓣id，去爬取豆瓣信息。将爬取到的信息返回给对应的layout，然后进行展示。

### 8.统一友链卡片样式

我不喜欢原版的友链显示，所以统一了颜色，打开`themes/matery/layout/friends.ejs`文件，找到如下代码并修改：

```javascript
                            <!--修改frends卡片，统一样式 -->
                            <!--<div class="card frind-card<%- ((i % 10) +1) %>"> 修改前-->
                            <div class="card frind-card1">
```

它的样式颜色也在该文件中，各位可自行修改。

### 9.添加交换友链卡片

在`/source/friends/index.md`文件中添加要交互的信息：

```bash
# 友链交换
想要交换友链的大佬，欢迎在留言板留言，留言格式：
* **名称：**Hiyoung
* **地址：**https://hiyoungai.com/
* **简介：**宠辱不惊，看庭前花开花落；去留无意，望天空云卷云舒。
* **头像：**https://cdn.jsdelivr.net/gh/hiyoung123/cdn/img/avatar.jpg
```

然后在`friends.ejs`文件中的如下位置添加代码：

```javascript
        <div class="card">
            <div class="card-content">
                <div class="card-content article-card-content">
                    <div id="articleContent" data-aos="fade-up">
                        <%- page.content %>
                    </div>
                </div>
            </div>
        </div>
        <div class="card">

            <% if (theme.gitalk && theme.gitalk.enable) { %>
```

### 10.修改各菜单首图样式

修改各个页面的首图为本页面标题，而不是统一的网站标题。

打开`layout/_partial/bg-cover-content.ejs`文件，找到如下代码：

```javascript
            <div class="title center-align">
                <% if (config.subtitle && config.subtitle.length > 0) { %>
                <%= config.subtitle %>
                <% } else { %>
                subtitle
                <% } %>
            </div>
```

修改为：

```javascript
            <div class="title center-align">
                <!-- <% if (config.subtitle && config.subtitle.length > 0) { %>
                    <%= config.subtitle %>
                <% } else { %>
                    subtitle
                <% } %> -->
                <% if (is_archive()) { %>
                    <%= __('archives') %>
                <% } else if (is_category()) { %>
                    <%= __('categories') %>
                <% } else if (is_tag()) { %>
                    <%= __('tag') %>
                <% } else if (page.title && page.title.length > 0) { %>
                    <%= __(page.title) %>
                <% } else { %>
                    <%= config.subtitle%>
                <% } %>
            </div>
```

### 11.在文章中添加网易云音乐

首先打开网易云网页版，找到想听的歌曲，然后点击生成外链，复制`html`代码。粘贴到文章里就行了，为了美观，设置一下居中，具体代码如下：

```bash
<div align="middle">这里粘贴刚刚复制的代码</div>
```

### 12.建站时间、卜算子计数、全站文字统计

新版本中已经集成了该功能，可以直接在主题的配置文件`_config.yml`中进行配置：

首先需要安装插件：

```bash
npm i --save hexo-wordcount
```

然后在`_config.yml`配置：

```bash
wordCount:
  enable: false # 将这个值设置为 true 即可.
  postWordCount: true
  min2read: true
  totalCount: true #需要添加这个字段，原版没有　全站文字统计配置
```

建站时间配置：

```bash
# Website start time.
# 站点运行开始时间.
time:
  enable: true
  year: 2019 # 年份
  month: 11 # 月份
  date: 12 # 日期
  hour: 00 # 小时
  minute: 00 # 分钟
  second: 00 # 秒
```

### 13.关于页面添加简历

修改`/themes/matery/layout/about.ejs`，找到`<div class="card">`标签，然后找到它对应的`</div>`标签，接在后面新增一个card，语句如下：

```bash
<div class="card"> <div class="card-content"> <div class="card-content article-card-content"> <div class="title center-align" data-aos="zoom-in-up"> <i class="fa fa-address-book"></i>&nbsp;&nbsp;<%- __('myCV') %> </div> <div id="articleContent" data-aos="fade-up"> <%- page.content %> </div> </div> </div> </div>
```

这样就会多出一张card，然后可以在`/source/about/index.md`下面写上你的简历了，当然这里的位置随你自己设置，你也可以把简历作为第一个card。

### 14.添加评论插件

主题已经自带了`gitalk`插件了，所以你只需要去`github`官网配置好就行了。

首先打开[github](https://github.com/settings/applications/new)申请一个应用，要填四个东西：

```bash
Application name //应用名称，随便填 
Homepage URL //填自己的博客地址 
Application description //应用描述，随便填 
Authorization callback URL //填自己的博客地址
```

然后点击注册，会出现两个字符串`Client ID`和`Client Secret`，这个要复制出来。

然后去主题的配置文件`_config.yml`下修改`gitalk`那里：

```bash
gitalk: enable: true 
  owner: 你的github用户名  
  repo: 你的github用户名.github.io 
  oauth: 
    clientId: 粘贴刚刚注册完显示的字符串 
    clientSecret: 粘贴刚刚注册完显示的字符串 
  admin: 你的github用户名
```

以后写文章的时候，只要在文章页面登陆过`github`，就会自动创建评论框，**记得每次写完文章后打开博客文章页面一下**。

### 15.添加RSS插件

```bash
npm install hexo-generator-feed --save
```

在` Hexo `根目录下的 `_config.yml` 文件中，新增以下的配置项：

```bash
feed:
  type: atom
  path: atom.xml
  limit: 20
  hub:
  content:
  content_limit: 140
  content_limit_delim: ' '
  order_by: -date
```

执行 `hexo clean && hexo g` 重新生成博客文件，然后在 `public` 文件夹中即可看到 `atom.xml` 文件，说明你已经安装成功了。

### 16.添加搜索插件

```bash
npm install hexo-generator-search --save
```

在根目录下的 `_config.yml` 文件中，新增以下的配置项：

```bash
search:
  path: search.xml
  field: post
```

### 17.添加代码高亮插件

```bash
npm i -S hexo-prism-plugin
```

然后，修改根目录下 `_config.yml` 文件中 `highlight.enable` 的值为 `false`，并新增 `prism` 插件相关的配置，主要配置如下：

```bash
highlight:
  enable: false

prism_plugin:
  mode: 'preprocess'    # realtime/preprocess
  theme: 'tomorrow'
  line_number: false    # default false
  custom_css:
```

### 18.修改打赏功能

在主题文件的 `source/medias/reward` 文件中，你可以替换成你的的微信和支付宝的打赏二维码图片。

### 19.修改页脚

页脚信息可能需要做定制化修改，而且它不便于做成配置信息，所以可能需要你自己去再修改和加工。修改的地方在主题文件的 `/layout/_partial/footer.ejs` 文件中，包括站点、使用的主题、访问量等。

### 20.修改社交链接

在主题的 `_config.yml` 文件中，默认支持 `QQ`、`GitHub` 和邮箱等的配置，你可以在主题文件的 `/layout/_partial/social-link.ejs` 文件中，新增、修改你需要的社交链接地址，增加链接可参考如下代码：

```bash
<% if (theme.socialLink.github) { %>
    <a href="<%= theme.socialLink.github %>" class="tooltipped" target="_blank" data-tooltip="访问我的GitHub" data-position="top" data-delay="50">
        <i class="fab fa-github"></i>
    </a>
<% } %>
```

其中，社交图标（如：`fa-github`）你可以在 [Font Awesome](https://fontawesome.com/icons) 中搜索找到。以下是常用社交图标的标识，供你参考：

* Facebook: `fab fa-facebook`
* Twitter: `fab fa-twitter`
* Google-plus: `fab fa-google-plus`
* Linkedin: `fab fa-linkedin`
* Tumblr: `fab fa-tumblr`
* Medium: `fab fa-medium`
* Slack: `fab fa-slack`
* Sina Weibo: `fab fa-weibo`
* Wechat: `fab fa-weixin`
* QQ: `fab fa-qq`
* Zhihu: `fab fa-zhihu`

###  21.添加聊天功能

前往 [DaoVoice](http://www.daovoice.io/) 官网注册并且获取 `app_id`，并将 `app_id` 填入主题的 `_config.yml` 文件中。

前往 [Tidio](https://www.tidio.com/) 官网注册并且获取 `Public Key`，并将 `Public Key` 填入主题的 `_config.yml` 文件中。



##  第四部分：优化

### 1.URL优化

使用插件优化`url`，插件`hexo-abbrlink`实现了这个功能，它将原来的`URL`地址重新进行了进制转换和再编码。

安装`hexo-abbrlink`：

```bash
npm install hexo-abbrlink --save
```

配置博客根目录下的`_config.yml`文件。

### 2.CDN优化

用法：

```bash
https://cdn.jsdelivr.net/gh/你的用户名/你的仓库名@发布的版本号/文件路径
```

如本文的图片：

```bash
https://cdn.jsdelivr.net/gh/hiyoung123/CDN/img/img_hexo_github_new_rep.png
```

### 3.压缩代码

首先安装插件：

```bash
npm install hexo-neat --save
```

在根目录配置文件 `_config.yml` 末尾加入以下配置：

```bash
#hexo-neat 优化提速插件（去掉HTML、css、js的blank字符）
neat_enable: true
neat_html:
  enable: true
  exclude:
    - '**/*.md'
neat_css:
  enable: true
  exclude:
    - '**/*.min.css'
neat_js:
  enable: true
  mangle: true
  output:
  compress:
  exclude:
    - '**/*.min.js'
    - '**/**/instantpage.js'
    - '**/matery.js'
```

### 4.双部署到Coding

`Github` & `Coding Pages` 双部署,对国内,国外用户进行分流访问,以提升网站的访问速度.
`Github Pages` 的部署前面已经说了,这里就讲一讲 `Coding Pages` 如何部署.其实与 `Github Pages` 也类似,先到`coding`官网注册,创建一个与用户名同名的仓库,添加仓库地址到配置文件中,在根目录`_config.yml`对应地方添加如下:

```bash
deploy:
  - type: git
    repo:
      github: https://github.com/hiyoung123/hiyoung123.github.io
      coding: https://e.coding.net/hiyoung123/hiyoung123.coding.me.git
    branch: master
```

### 5.图片懒加载

安装插件：

```bash
npm install hexo-lazyload-image --save
```

然后在根目录配置文件末尾加入以下代码

```bash
lazyload:
  enable: true 
  onlypost: false  # 是否只对文章的图片做懒加载
  loadingImg: # eg ./images/loading.gif
```

但是一般情况下懒加载和gallery插件会发生冲突，结果可能就是点开图片，左翻右翻都是loading image。`matery`主题的解决方案是：修改 `/themes/matery/source/js` 中的 `matery.js`文件

在第108行加上：

```javascript
$(document).find('img[data-original]').each(function(){
    $(this).parent().attr("href", $(this).attr("data-original"));
});
```

做完这步之后，还有点小Bug，首页的logo点击会直接打开logo图，而不是跳到首页。

伪解决方案：打开 `/themes/matery/layout/_partial/header.ejs`文件，

在`img`和`span`的两个头加个`div`：

```javascript
<div class="brand-logo">
    <a href="<%- url_for() %>" class="waves-effect waves-light">
        <div>
            <% if (theme.logo !== undefined && theme.logo.length > 0) { %>
            <img src="<%= theme.logo %>" class="logo-img" alt="LOGO">
            <% } %>
            <span class="logo-span"><%- config.title %></span>
        </div>
    </a>
</div>
```

其实第一次加载后本地都是有缓存的，如果每次都把loading显示出来就不那么好看。所以我们需要对插件进行魔改，让图片稍微提前加载，避开加载动画。

打开 `Hexo根目录`>`node_modules` > `hexo-lazyload-image` > `lib` > `simple-lazyload.js` 文件第9行修改为：

```javascript
&& rect.top <= (window.innerHeight +240 || document.documentElement.clientHeight +240)
```

作用：提前240个像素加载图片；当然这个值也可以根据自己情况修改。



## 第五部分：Debug

### 1.解决部分菜单页面，标签栏不显示中文标题

首先需要去`/themes/matery/languages/`下，修改`default.yml`和`zh-CN.yml`添加对应的文字信息。

接着在`mobile-nav.ejs`和`navigation.ejs`中添加如下代码：

```javascript
        menuMap.set("Medias", "媒体");
        menuMap.set("Books", "书单");
        menuMap.set("Musics", "音乐");
        menuMap.set("Videos", "视频");
        menuMap.set("Galleries", "相册");
```

找到下面的代码：

```javascript
<span><%- childrenLink.name %></span>
```

修改为：

```javascript
<%- (config.language === 'zh-CN' && menuMap.has(childrenLink.name)) ? menuMap.get(childrenLink.name) : childrenLink.name %>
```

并在`head.ejs`文件中修改：

```javascript
    var title = page.title;

    // tags, categories, about pages title
    if (title == 'tags') {
        title = __('tags');
    } else if (title == 'categories') {
        title = __('categories');
    } else if (title == 'about') {
        title = __('about');
    } else if (title == 'contact') {
        title = __('contact');
    } else if (title == 'friends') {
        title = __('friends');
    } else if (title == 'musics') {
        title = __('musics');
    } else if (title == 'galleries') {
        title = __('galleries');
    }
```

###  2.部署在coding中，使用www.访问域名时，出现404．

需要在coding部署设置中，绑定一下`www`的域名，同时需要申请证书。

### 3.在coding中认证失败

如果申请失败的话，在域名解析处将境外的解析记录关掉，然后再去申请。申请成功后再打开境外的记录。

### 4.使用neat插件压缩代码，导致鼠标点击特效消失

在压缩代码插件配置中修改为如下代码：

```bash
neat_js:
  enable: true
  mangle: true
  output:
  compress:
  exclude:
    - '**/*.min.js'
    - '**/**/instantpage.js'
    - '**/matery.js'
    - '**/clicklove.js'  #防止影响点击特效
```

5.卜算子区分www和不带www的域名，导致访问数无法同步。

卜算子按照域名进行统计，带www和不带www的属于两个域名。可能需要重定向解决。

使用cloudflare貌似可以做到域名重定向。

## 更新

### hexo 升级

1. 打开 package.json，修改 dependencies 项：

   ```xml
     "hexo": "^5.0.0",
   ```

2. 执行更新

   ```bash
   npm update
   ```

### 更换butterfly主题

1. clone 项目到 themes 目录

   ```bash
   git clone -b master https://github.com/jerryc127/hexo-theme-butterfly.git themes/hexo-theme-butterfly
   ```

2. 安装对应插件

   ```bash
   npm install hexo-renderer-pug hexo-renderer-stylus
   ```

3. 修改_config.yml文件

   ```
    theme: hexo-theme-butterfly
   ```

4. 执行构建等命令

   ```bash
   hexo clean & hexo g & hexo s
   ```

### 异常

1. prettyUrls is not a function

   ``````bash
   npm cache clean --force
   delete node_modules folder
   delete package-lock.json file
   npm install
   hexo clean; hexo g
   ``````

   

## 鸣谢

再次感谢下面几位大佬的博客：

[闪烁之狐的原版定制](https://github.com/blinkfox/hexo-theme-matery) | [Godweiyang](https://godweiyang.com/2018/04/13/hexo-blog/) | [洪卫](https://sunhwee.com/posts/6e8839eb.html) | [Sky03](https://blog.sky03.cn/2019/42790.html)