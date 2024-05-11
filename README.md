# Some Linux scripts

---

[服务检查检测脚本](checkTelnet.sh)

 ### Quick Start

1.  将services的值改为你要检测的地址
2.  判断您是否需要出现告警的后置操作，如果需要的话在send_alert函数中填写（默认是调用一个短信发送接口，不需要的话删掉及引用点即可）
3. 执行脚本看看吧

ps：推荐添加主机定时任务



---



[数据库备份文件And推送](mysqldumpAndPush.sh)

###  Quick Start

1. 你需要将常量的数值，改为你主机的数值
2. 执行脚本看看吧

ps：你需要由expect命令，这个脚本在连接备份机器使用的expect来操作的

