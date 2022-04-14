=begin
本脚本用来替换游戏工程字体为本地存在的已安装字体。
效果如图，这个脚本虽然简单，但是转载还是希望保留我的#注释。
如果电脑本地预期不会安装或不存在你要实现的字体效果时，在游戏根目录下新建文件夹并命名为“Fonts”，之后把你用到的字体文件(ttf)放进去，之后同样使用以下脚本进行更换字体。
=end

def ziti
    name  = "方正基础像素"   #这个引号里的是你的字体名
    cz = Font.exist?(name)
    if cz = true
      Font.default_name = name
    end
    #RGSS3 替换游戏工程字体为本地存在的已安装字体或游戏自带字体 by:洮羱芝闇
  end