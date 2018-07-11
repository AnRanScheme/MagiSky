目前个人原因比较闲想写个app来联系一下自己的架构技能:
  - 使用MVVM的设计模式  完成代码 代替传统的MVC力求,可以符合MVVM的设计模式
  - 使用单元测试,因为传统的MVC设计模式不是很容易测试,使用ViewModel以后,可以很容易的将测试的部分理出来
  - 使用Swift来写这款简单的app意义就是练习怎么优雅的使用Swift
  - 使用第三方库RXSwift,更加的符合MVVM的设计模式
---

在这个系列里，来理解并掌握MVVM的编程思想。并且，在这个过程中，我还会引入RxCocoa、单元测试，以及UI测试等内容，尽可能还原一个比较真实的App独立开发场景。

作为整个系列的开始，我们先了解一下这个App的大体构成，并用MVC的方式勾勒出一个轮廓。这样，我们就会很自然的从一些熟悉的场景，过渡到MVVM了。

## 整理项目目录

首先，还是创建一个*Single View Application*，这不过这次，记得把*Include Unit Tests*和*Include UI Tests*选上，在稍后的内容里，我们会涉及到单元测试以及UI测试的内容.
![这是列子](https://github.com/AnRanScheme/MagiSky/raw/master/MagiSky/Gif-Pic/屏幕快照 2018-07-11 下午5.12.35.png)
以上是项目的架构
![Untitled.gif](https://github.com/AnRanScheme/MagiSky/raw/master/MagiSky/Gif-Pic/Untitled.gif)

这是项目运行的git



