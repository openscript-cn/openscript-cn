#!/bin/bash

# 提示：脚本来源
echo -e "\n\033[1;32m★★★ 脚本来源/Script source ★★★\033[0m"
echo -e "\033[1;34m\033[0m\033[1;36mhttps://github.com/openscript-cn/openscript-cn\033[0m\n" 

# 获取系统版本
OS_VERSION=$(rpm -E %{rhel})

# 删除原有的 repo 文件
echo "删除原有的 repo 文件..."
rm -f /etc/yum.repos.d/*.repo

# 根据系统版本来设置不同的镜像源
echo "创建新的 repo 配置文件..."

if [ "$OS_VERSION" -eq 7 ]; then
    # 对于 CentOS 7 设置阿里云的镜像源
    cat <<EOL > /etc/yum.repos.d/CentOS-Base.repo
[BaseOS]
name=CentOS-\$releasever - BaseOS - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/os/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
enabled=1

[AppStream]
name=CentOS-\$releasever - AppStream - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
enabled=1

[extras]
name=CentOS-\$releasever - Extras - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/extras/\$basearch/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-7
enabled=1
EOL
elif [ "$OS_VERSION" -eq 8 ]; then
    # 对于 CentOS 8 设置阿里云的镜像源
    cat <<EOL > /etc/yum.repos.d/CentOS-Base.repo
[BaseOS]
name=CentOS-\$releasever - BaseOS - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/BaseOS/\$basearch/os/
gpgcheck=1
gpgkey=http://mirrors.aliyun.com/centos/RPM-GPG-KEY-CentOS-8
enabled=1

[AppStream]
name=CentOS-\$releasever - AppStream - mirrors.aliyun.com
baseurl=http://mirrors.aliyun.com/centos/\$releasever/updates/\$basearch/
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
else
    # 对于其他版本的系统，可以在这里添加适当的镜像源配置
    echo "不支持的系统版本，无法配置镜像源。"
    exit 1
fi

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
