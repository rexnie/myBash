# mktags
Generate ctags and cscope.out in the sametime

http://www.cppblog.com/converse/archive/2009/08/08/92650.html

新增了几个命令行参数,可以支持做到添加和删除搜索的目录:

-n:
新增搜索目录,同样可以使用--depth=XX指定搜索深度

-d:
删除原有的搜索目录

-g:
只向配置文件中添加/删除目录,并不生成索引,也就是搜索完需要添加的文件之后,并不执行ctags/cscope命令,这对于添加/删除目录有帮助.

-s:
显示当前搜索的目录和深度,以及文件类型等参数

比如,假设现在在Linux内核目录下,依次执行如下命令:
1) mktags  -a kernel/  -g
表示搜索时需要搜索kernel目录,搜索深度未指定,因此将把该目录下面全部文件都搜索进入索引文件中,但是不执行ctags/cscope命令

2) mktags -n mm/ -g
向索引文件中添加mm目录,同样,也并不执行ctags/cscope命令

3) mktags -d mm/ -g
从索引文件中删除所有来自mm目录的文件,也并不执行ctags/cscope命令

4) 最后执行mktags
此时将根据当前索引文件来执行ctags/cscope命令.


项目地址在:
http://code.google.com/p/mktags/ 
