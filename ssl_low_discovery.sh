#!/bin/bash

# 读取 https_check.txt 文件
input_file="/usr/local/zabbix/scripts/https_check.txt"

# 初始化 JSON 格式输出
echo '{"data":['

# 用于追踪 JSON 格式的第一项
first=true

# 逐行读取文件
while IFS=, read -r hostname port ip; do
    # 如果端口为空，默认为 443
    if [ -z "$port" ]; then
        port="443"
    fi

    # 如果 IP 地址为空，保持为空
    if [ -z "$ip" ]; then
        ip=""
    fi

    # 跳过无效行（例如：只包含空白或没有主机名的行）
    if [ -z "$hostname" ]; then
        continue
    fi

    # 如果不是第一个条目，输出逗号进行分隔
    if [ "$first" = true ]; then
        first=false
    else
        echo ","
    fi

    # 输出 JSON 格式的 LLD 数据
    echo "  {\"{#CERT.WEBSITE.HOSTNAME}\":\"$hostname\", \"{#CERT.WEBSITE.PORT}\":\"$port\", \"{#CERT.WEBSITE.IP}\":\"$ip\"}"

done < "$input_file"

# 关闭 JSON 数据数组
echo ']}'
