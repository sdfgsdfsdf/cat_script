#!/bin/bash


api_url="https://mempool.fractalbitcoin.io/api/v1/fees/recommended"
max_success=300
count=0


get_fee_rate() {
    fee_rate=$(curl -s $api_url | jq -r '.halfHourFee')
    echo "当前的 halfHourFee 是: $fee_rate"
}

while [ $count -lt $max_success ]; do
    get_fee_rate
    
    new_fee_rate=$(echo "scale=0; $fee_rate * 1.2" | bc)

    command="sudo yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate $new_fee_rate"
    
    output=$($command 2>&1 | tee /dev/tty)

    if [[ "$output" == *"too-long-mempool-chain"* ]]; then
        echo "错误：too-long-mempool-chain，跳过并继续"
        continue
    elif [[ "$output" == *"mint token [CAT] failed"* ]]; then
        echo "忽略错误：mint token [CAT] failed"
        continue
    elif [ $? -ne 0 ]; then
        echo "命令执行失败，跳过并继续: $output"
        continue
    else
        count=$((count + 1))
        echo "已成功执行 $count 次"
    fi

    sleep 1
done

echo "命令成功执行了 $max_success 次，脚本结束。"
