
<autoExcuteSql load="fileInit">
    <fileInit>static/doc/db/phoneauth.sql</fileInit>
    <fileUpdate>static/doc/db/update/*.sql</fileUpdate>
    <entityInit>org.uyi.h.dao.base.dal.entity</entityInit>
    <entityAdd>org.uyi.h.dao.base.dal.entity</entityAdd>
</autoExcuteSql>

1.项目初始化时 load="fileInit"或load="entityInit"  清空建库建表
    1.1. 开发新功能在本地或服务器的数据库加了一张表，然后程序中反射生成代码，此时如果load参数没改，再次启动程序时新建的表会被删除。
    1.2. load参数改成空字符串，再次启动 （等于以前的传统模式开发，自己修改表，自己修改代码“插件”来保持同步）
2.项目迭代时 load="fileUpdate,entityAdd"
    2.1. 程序启动时fileUpdate参数会扫描update文件夹下的所有脚本文件，考虑多人协同时，各自建的更新文件必须和实体保持同步，
    格式：英文名_日期_小时
    例如：uyi_20200419_15.sql

    2.2. 程序启动时entityAdd会自动比对实体和新增的属性，自动同步到数据中。 （新增表和字段是不需要写脚本文件的）


注意： load="fileUpdate,entityAdd" 时，有以下几种情况
1. 如果有人在本地或服务器数据库新建了表和字段却没有同步到代码中去 （没写脚本，程序运行会警告字段没匹配或报错） （写了脚本就等于重复执行报错了）
    如何避免这种情况，只能本地建表和字段，再补上脚本，，放入服务器运行同步服务器的数据库
2. 如果有人在代码中加了实体或者属性，如上2.2的entityAdd去同步
3. 如果有人在代码中修改了实体或者属性，
    （没写脚本，程序会报错类型不匹配或者找不到表或列）
    如果没报错，修改属性变成了新增属性，那么数据库原来的属性还在，程序会警告原来的字段没有匹配实体属性
    （写了脚本，严格执行）
