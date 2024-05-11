#!/bin/bash

# 定义要检查的服务的IP和端口
declare -a services=("172.21.32.52 80" "172.21.32.53 80")

# 用于记录异常服务的变量
declare -a failedServices=()

# 获取当前时间
currentTime=$(date "+%Y-%m-%d %H:%M:%S")

# 生成唯一标识符
generateUniqueId() {
  local timestamp=$(date +%s)
  local randomSixDigits=$(shuf -i 100000-999999 -n 1)
}

sleep 30

uniqueId=$(generateUniqueId)


# 检查每个服务
for service in "${services[@]}"; do
  IFS=' ' read -r ip port <<< "$service"
  if ! timeout 3 bash -c "echo > /dev/tcp/$ip/$port"; then
    failedServices+=("$ip:$port;")
  fi
done

# 函数：发送告警信息
send_alert() {
  local failedServicesString="$1"
  local message="服务健康监控脚本告警: $currentTime, 错误的服务: $failedServicesString"
  curl -X POST http://xxxx:1000/msg/send \
       -H "Content-Type: application/json" \
       -d "{\"phoneNumber\":\"you phone\",\"seq\":\"$uniqueId\",\"message\":\"$message\"}"
}

# 汇总所有失败服务的信息
failedServicesString=""
if [ ${#failedServices[@]} -gt 0 ]; then
  for service in "${failedServices[@]}"; do
    failedServicesString+="$service; "
  done
  failedServicesString=${failedServicesString%"; "} # 移除最后一个分号
fi

# 将结果输出到文件
outputFile="/home/serviceHealth/hostNetworkResults.txt"
{
  if [ ${#failedServices[@]} -eq 0 ]; then
    echo -e "检查时间: $currentTime 所有服务均正常。"
  else
    echo -e "检查时间: $currentTime 以下服务响应异常： ${failedServices[@]}"
    # 发送短信告警
    send_alert "$failedServicesString"

  fi
} >> "$outputFile"
