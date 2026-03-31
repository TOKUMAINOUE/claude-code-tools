#!/bin/bash
input=$(cat)

# Model
model=$(echo "$input" | jq -r '.model.display_name // empty')

# Context window usage
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')

# Rate limits (Claude.ai subscription)
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Colors
R='\033[0m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
DIM='\033[2m'
MAGENTA='\033[35m'

# Color based on percentage
color_for_pct() {
    local pct=$1
    if [ "$pct" -lt 50 ]; then echo "$GREEN"
    elif [ "$pct" -lt 80 ]; then echo "$YELLOW"
    else echo "$RED"
    fi
}

# Gauge bar with color
gauge() {
    local pct=$1
    local width=10
    local filled=$(awk "BEGIN {printf \"%d\", ($pct / 100) * $width}")
    local empty=$((width - filled))
    local clr=$(color_for_pct "$pct")
    local bar="${clr}"
    for ((i=0; i<filled; i++)); do bar+="█"; done
    bar+="${DIM}"
    for ((i=0; i<empty; i++)); do bar+="░"; done
    bar+="${R}"
    echo -e "$bar"
}

# Time remaining until reset
time_remaining() {
    local reset_ts=$1
    local now=$(date +%s)
    local diff=$((reset_ts - now))
    if [ "$diff" -le 0 ]; then
        echo "reset"
        return
    fi
    local days=$((diff / 86400))
    local hours=$(( (diff % 86400) / 3600 ))
    local mins=$(( (diff % 3600) / 60 ))
    if [ "$days" -gt 0 ]; then
        echo "${days}d${hours}h${mins}m"
    elif [ "$hours" -gt 0 ]; then
        echo "${hours}h${mins}m"
    else
        echo "${mins}m"
    fi
}

# Build output
parts=()

# Model name
if [ -n "$model" ]; then
    parts+=("$(echo -e "${MAGENTA}${model}${R}")")
fi

# Context usage: show as X.XXM/1M with gauge
total_tokens=$((total_input + total_output))
if [ -n "$used_pct" ]; then
    pct_int=$(printf '%.0f' "$used_pct")
    ctx_str=$(awk "BEGIN {printf \"%.2fM\", $total_tokens/1000000}")
    parts+=("ctx $(gauge "$pct_int") $(echo -e "$(color_for_pct "$pct_int")${ctx_str}/1M${R}")")
fi

# Rate limits with gauge + reset time
if [ -n "$five_hour" ]; then
    pct_int=$(printf '%.0f' "$five_hour")
    remain=""
    if [ -n "$five_hour_reset" ]; then
        remain=" $(time_remaining "$five_hour_reset")"
    fi
    parts+=("5h $(gauge "$pct_int") $(echo -e "$(color_for_pct "$pct_int")${pct_int}%${R}${DIM} reset${remain}${R}")")
fi
if [ -n "$seven_day" ]; then
    pct_int=$(printf '%.0f' "$seven_day")
    remain=""
    if [ -n "$seven_day_reset" ]; then
        remain=" $(time_remaining "$seven_day_reset")"
    fi
    parts+=("7d $(gauge "$pct_int") $(echo -e "$(color_for_pct "$pct_int")${pct_int}%${R}${DIM} reset${remain}${R}")")
fi

# Join with separator
if [ ${#parts[@]} -gt 0 ]; then
    printf '%s' "${parts[0]}"
    for part in "${parts[@]:1}"; do
        printf ' │ %s' "$part"
    done
fi
