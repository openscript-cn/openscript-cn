#!/bin/bash
# 提示：脚本来源
echo -e "\n\033[1;32m★★★ 脚本来源/Script source ★★★\033[0m"
echo -e "\033[1;34m\033[0m\033[1;36mhttps://github.com/openscript-cn/openscript-cn\033[0m\n" 
# 删除原有的 repo 文件
echo "删除原有的 repo 文件..."
rm -f /etc/yum.repos.d/*.repo

# 创建新的 repo 配置文件
echo "创建新的 repo 配置文件..."
cat <<EOL > /etc/yum.repos.d/CentOS-Base.repo
[BaseOS]
name=CentOS-\$releasever - BaseOS - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/BaseOS/\$basearch/os/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-8
enabled=1

[AppStream]
name=CentOS-\$releasever - AppStream - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/AppStream/\$basearch/os/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-8
enabled=1

[extras]
name=CentOS-\$releasever - Extras - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-8
enabled=1
EOL

# 清理 yum 缓存
echo "清理 yum 缓存..."
yum clean all

# 更新 yum 源
echo "更新 yum 源..."
yum makecache

# 执行系统更新
echo "开始更新系统..."
yum -y update

echo "脚本执行完成。"
