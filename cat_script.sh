command="yarn cli mint -i 45ee725c2c5993b3e4d308842d87e973bf1951f5f7a804b21e4dd964ecd12d6b_0 5 --fee-rate 1300"

while true; do
    $command

    if [ $? -ne 0 ]; then
        echo "err"
        exit 1
    fi

    sleep 1
done
