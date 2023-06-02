## 数据库字典表定义
本文档包含数据库**非国标**字段名定义, 可单独使用或者作为前后缀组合使用  
若有国标强制要求则使用国标标准  
以拉丁字母排序列表  
可参考 [常用单词字典表](./dict.md)

### 定义

- address 住址
> 个人住址，家庭住址，单位住址

- age 年龄
> int4字段类型

- auth 鉴权，认证

- atime 访问时间戳
> timestamp字段类型

- ctime 创建时间戳
> timestamp字段类型

- detail 详情
> 区分 info

- Firm Social unified credit code 企业统一信用代码
> 缩写 fsucc

- gender 性别
> int2
> 不使用sex

- idcard 身份证

- idcno 身份证号 
> varchar(50)

- info 信息
> information的缩写  
> 区分 detail

- memo 备注
> remark 表示评论，note 表示记事
> text

- mobile 手机号码
> 座机使用 phone
> varchar(255)

- msg 消息
> text

- mtime 修改时间戳
> timestamp字段类型

- permit 权限，许可

- position （工作）职位；（地理）位置
> 可缩写为 pos

- phone 座机电话
> 移动电话使用 mobile
> varchar(50)

- realname 用户真实姓名
> 用户帐号名可以用 username

- remark 评论
> “备注”使用缩写 memo

- rights 权限，权利

- title 头衔
> 职位头衔（经理、主管），学术（博士、教授）
> varchar(50)

- userid 用户账户识别号
> 字段类型可 int4, uuid

- username 用户名
> 用于前端显示登录名
> varchar(50)

- userinfo 用户信息
> 用户扩展信息

