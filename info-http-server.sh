#!/bin/bash

# Pobierz nazwę kontenera (hostname)
CONTAINER_NAME=$(cat /etc/hostname)

# Inicjalizacja zmiennej dla licznika odwiedzin
VISITS=0

# Funkcja do generowania losowych liczb
generate_random_number() {
    echo $((RANDOM))
}

# Funkcja do pobierania informacji o systemie
get_system_info() {
    echo "<ul>
        <li><strong>Uptime:</strong> $(uptime -p)</li>
        <li><strong>Load Average:</strong> $(awk '{print $1, $2, $3}' /proc/loadavg)</li>
        <li><strong>Free Memory:</strong> $(free -m | awk '/Mem:/ {print $4}') MB</li>
    </ul>"
}

PORT=8081  # Zmieniony port

while true; do
    # Oczekiwanie na połączenie i obsługa
    RESPONSE=$( 
        VISITS=$((VISITS + 1))
        RANDOM_NUMBER=$(generate_random_number)
        SYSTEM_INFO=$(get_system_info)
        DATE_NOW=$(date)

        cat <<EOF
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: $(echo -e "<html>
    <body>
        <h1>System Info and Random Number Server</h1>
        <p><strong>Date:</strong> $DATE_NOW</p>
        <p><strong>Container Name:</strong> $CONTAINER_NAME</p>
        <p><strong>Visits:</strong> $VISITS</p>
        <p><strong>Random Number:</strong> $RANDOM_NUMBER</p>
        <h2>System Info:</h2>
        $SYSTEM_INFO
    </body>
</html>" | wc -c)

<html>
    <body>
        <h1>System Info and Random Number Server</h1>
        <p><strong>Date:</strong> $DATE_NOW</p>
        <p><strong>Container Name:</strong> $CONTAINER_NAME</p>
        <p><strong>Visits:</strong> $VISITS</p>
        <p><strong>Random Number:</strong> $RANDOM_NUMBER</p>
        <h2>System Info:</h2>
        $SYSTEM_INFO
    </body>
</html>
EOF
    )

    # Serwowanie odpowiedzi
    echo -e "$RESPONSE" | nc -l -p $PORT -q 1
done
