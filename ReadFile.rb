 #制作by：洮羱芝闇
#本脚本用于读取文件内容 遇到三次换行结束 内容用分号分割
#很奈斯
def cards_from_file
    str_nei = ''
    IO.foreach("carddate.tyc"){|block| str_nei=str_nei+block}
    mg=str_nei.split(';')
    for nr in mg
      if nr == "\n\n\n"
        break
      end 
    #p nr
    #----------分割线---------此处用于格式读取-------
    #nice！！！！！
  
    #----------分割线---------此处用于格式读取-------
    end
  end