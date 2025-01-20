#!/bin/bash
# 提示：脚本来源
echo -e "\n\033[1;32m★★★ 脚本来源/Script source ★★★\033[0m"
echo -e "\033[1;34m\033[0m\033[1;36mhttps://github.com/openscript-cn/openscript-cn\033[0m\n" 
# 判断系统类型，适配不同的防火墙命令
if [ -f /etc/redhat-release ]; then
    # CentOS / RHEL 系列使用 firewall-cmd
    firewall_cmd="firewall-cmd"
    firewall_reload="firewall-cmd --reload"
elif [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
    # Ubuntu / Debian 系列使用 ufw
    firewall_cmd="ufw"
    firewall_reload="ufw reload"
else
    echo "不支持的系统类型，请使用 CentOS 或 Ubuntu/Debian 系统"
    exit 1
fi

# 选择操作提示
echo "请选择操作:"
echo "1. 开启端口"
echo "2. 关闭端口"
echo "3. 列出当前已开放的端口"
read -p "请输入选项 (1/2/3): " action  # 用户输入选项

# 输入端口号（仅当用户选择开启或关闭端口时需要输入）
if [[ "$action" == "1" ]] || [[ "$action" == "2" ]]; then
    read -p "请输入端口号: " port  # 用户输入端口号
fi

# 确认操作并执行相应的命令
if [[ "$action" == "1" ]]; then
    echo "正在开启端口 $port ..."
    if [[ "$firewall_cmd" == "firewall-cmd" ]]; then
        # CentOS / RHEL 系列
        sudo firewall-cmd --zone=public --add-port=$port/tcp --permanent
    elif [[ "$firewall_cmd" == "ufw" ]]; then
        # Ubuntu / Debian 系列
        sudo ufw allow $port/tcp
    fi
elif [[ "$action" == "2" ]]; then
    echo "正在关闭端口 $port ..."
    if [[ "$firewall_cmd" == "firewall-cmd" ]]; then
        # CentOS / RHEL 系列
        sudo firewall-cmd --zone=public --remove-port=$port/tcp --permanent
    elif [[ "$firewall_cmd" == "ufw" ]]; then
        # Ubuntu / Debian 系列
        sudo ufw deny $port/tcp
    fi
elif [[ "$action" == "3" ]]; then
    echo "正在列出当前已开放的端口 ..."
    if [[ "$firewall_cmd" == "firewall-cmd" ]]; then
        # CentOS / RHEL 系列
        sudo firewall-cmd --zone=public --list-ports
    elif [[ "$firewall_cmd" == "ufw" ]]; then
        # Ubuntu / Debian 系列
        sudo ufw status | grep 'ALLOW' | awk '{print $2}'
    fi
else
    # 如果输入的选项无效，输出错误信息并退出
    echo "无效的选项，请选择 1、2 或 3。"
    exit 1
fi

# 如果选择了开启或关闭端口，重新加载防火墙规则
if [[ "$action" == "1" ]] || [[ "$action" == "2" ]]; then
    echo "重新加载防火墙规则 ..."
    sudo $firewall_reload
    echo "操作完成。"
fi

# 如果选择了列出开放的端口，输出美化后的端口列表
if [[ "$action" == "3" ]]; then
    echo -e "\n当前开放的端口列表："
    # 根据不同系统输出已开放端口
    if [[ "$firewall_cmd" == "firewall-cmd" ]]; then
        ports=$(sudo firewall-cmd --zone=public --list-ports)
        if [[ -z "$ports" ]]; then
            echo "没有开放的端口。"  # 如果没有开放端口，输出此信息
        else
            # 输出每个端口并排序
            echo "$ports" | tr ' ' '\n' | awk '{print "端口: " $1}' | sort
        fi
    elif [[ "$firewall_cmd" == "ufw" ]]; then
        sudo ufw status | grep 'ALLOW' | awk '{print "端口: " $2}' | sort
    fi
fi
