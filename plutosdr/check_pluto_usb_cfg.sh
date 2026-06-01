#!/bin/bash

CFG="/osmobts/fork_osmo-trx_soapy/Transceiver52M/test1.cfg"

echo "[INFO] Starting Pluto config cleanup..."

# ---------------------------
# 1. Check file
# ---------------------------
if [ ! -f "$CFG" ]; then
    echo "[ERROR] CFG not found: $CFG"
    exit 1
fi

echo "[INFO] CFG found"

# ---------------------------
# 2. Check if uri exists at all
# ---------------------------
if ! grep -q "uri=ip:" "$CFG"; then
    echo "[INFO] No uri=ip found - nothing to do"
    exit 0
fi

echo "[INFO] Removing uri=ip from RF line(s)"

# ---------------------------
# 3. Remove uri=ip=... safely
# ---------------------------
sed -i -E 's/,?uri=ip:[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+//g' "$CFG"

# ---------------------------
# 4. Verification
# ---------------------------
if grep -q "uri=ip:" "$CFG"; then
    echo "[ERROR] Removal failed"
    exit 1
fi

echo "[INFO] Cleanup successful"
