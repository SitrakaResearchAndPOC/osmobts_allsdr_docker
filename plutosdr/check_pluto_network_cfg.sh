#!/bin/bash

CFG="/osmobts/fork_osmo-trx_soapy/Transceiver52M/test1.cfg"

echo "[INFO] Starting Pluto config check..."

# ---------------------------
# 0. FILE CHECK (FIRST)
# ---------------------------
if [ ! -f "$CFG" ]; then
    echo "[ERROR] CFG not found: $CFG"
    exit 1
fi

echo "[INFO] CFG found"

# ---------------------------
# 1. IP Pluto
# ---------------------------
IP="${IP_PLUTO:-}"

if [ -z "$IP" ]; then
    echo "[ERROR] IP_PLUTO not defined"
    exit 1
fi

echo "[INFO] IP_PLUTO = $IP"

# ---------------------------
# 2. IPv4 validation
# ---------------------------
if ! [[ "$IP" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]]; then
    echo "[ERROR] Invalid IPv4 format"
    exit 1
fi

IFS='.' read -r o1 o2 o3 o4 <<< "$IP"

for o in $o1 $o2 $o3 $o4; do
    if [ "$o" -lt 0 ] || [ "$o" -gt 255 ]; then
        echo "[ERROR] IPv4 out of range: $IP"
        exit 1
    fi
done

echo "[INFO] IPv4 validated"

# ---------------------------
# 3. Detect RF line
# ---------------------------
LINE=$(grep -E "^[[:space:]]*(dev-args|device_args|rf\.stream_args)" "$CFG")

if [ -z "$LINE" ]; then
    echo "[ERROR] No RF args line found"
    exit 1
fi

echo "[INFO] RF line detected:"
echo "$LINE"

# ---------------------------
# 4. Skip if already configured
# ---------------------------
if echo "$LINE" | grep -q "uri=ip:"; then
    echo "[INFO] uri=ip already present, no change"
    exit 0
fi

# ---------------------------
# 5. Patch config
# ---------------------------
echo "[INFO] Adding uri=ip:$IP"

sed -i "s|^\([[:space:]]*dev-args.*\)$|\1,uri=ip:$IP|" "$CFG"
sed -i "s|^\([[:space:]]*device_args.*\)$|\1,uri=ip:$IP|" "$CFG"
sed -i "s|^\([[:space:]]*rf\.stream_args.*\)$|\1,uri=ip:$IP|" "$CFG"

# ---------------------------
# 6. Verify
# ---------------------------
if grep -q "uri=ip:$IP" "$CFG"; then
    echo "[INFO] SUCCESS: uri added"
else
    echo "[ERROR] Patch failed"
    exit 1
fi

echo "[INFO] DONE"
