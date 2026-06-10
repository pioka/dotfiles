#!/bin/bash

COLOR_YELLOW=$'\033[33m'
COLOR_RESET=$'\033[0m'

calc_duration() {
  local to_timestamp=$1
  local now=$(date +%s)

  echo $(( to_timestamp - now ))
}

calc_pct() {
  local part=$1
  local whole=$2

  echo $(( part * 100 / whole ))
}

fmt_duration() {
    local duration=$1

    [ "$duration" -le 0 ] && { echo "now"; return; }

    local d=$(( duration / 86400 ))
    local h=$(( (duration % 86400) / 3600 ))
    local m=$(( (duration % 3600) / 60 ))

    local output_txt=""
    [ "$d" -gt 0 ] && output_txt+="${d}d "
    [ "$h" -gt 0 ] && output_txt+="${h}h "
    [ "$m" -gt 0 ] && output_txt+="${m}m "
    output_txt="${output_txt% }"             # 末尾スペース除去
    [ -z "$output_txt" ] && output_txt="<1m" # d,h,m全部0だった時

    echo "$output_txt"
}

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
cw_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
cw_usage_pct=$(echo "$input" | jq -r '(.context_window.used_percentage // 0) | round')
five_usage_pct=$(echo "$input" | jq -r '(.rate_limits.five_hour.used_percentage // empty) | round')
five_cycle_rst=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_usage_pct=$(echo "$input" | jq -r '(.rate_limits.seven_day.used_percentage // empty) | round')
week_cycle_rst=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
pj_dir=$(echo "$input" | jq -r '.workspace.project_dir // empty')

if [ -n "$cw_size" ]; then
  cw_size_si=$(numfmt --to=si "$cw_size")
fi

if [ -n "$cw_usage_pct" ]; then
  if [ "$cw_usage_pct" -gt 75 ]; then
    cw_usage_pct_fmt="${COLOR_YELLOW}${cw_usage_pct}%${COLOR_RESET}"
  else
    cw_usage_pct_fmt="${cw_usage_pct}%"
  fi
fi

if [ -n "$five_cycle_rst" ] && [ -n "$five_usage_pct" ]; then
  five_cycle_remaining=$(calc_duration "$five_cycle_rst")
  five_cycle_pct=$(calc_pct  $(( 18000 - five_cycle_remaining )) 18000)
  five_cycle_remaining_fmt=$(fmt_duration "$five_cycle_remaining")

  if [ "$five_usage_pct" -gt "$five_cycle_pct" ]; then
    five_usage_pct_fmt="${COLOR_YELLOW}${five_usage_pct}%${COLOR_RESET}"
  else
    five_usage_pct_fmt="${five_usage_pct}%"
  fi
fi

if [ -n "$week_cycle_rst" ] && [ -n "$week_usage_pct" ]; then
  week_cycle_remaining=$(calc_duration "$week_cycle_rst")
  week_cycle_pct=$(calc_pct $(( 604800 - week_cycle_remaining )) 604800)
  week_cycle_remaining_fmt=$(fmt_duration "$week_cycle_remaining")

  if [ "$week_usage_pct" -gt "$week_cycle_pct" ]; then
    week_usage_pct_fmt="${COLOR_YELLOW}${week_usage_pct}%${COLOR_RESET}"
  else
    week_usage_pct_fmt="${week_usage_pct}%"
  fi
fi

if [ -n "$pj_dir" ]; then
  pj_dir_base=$(basename "$pj_dir")
fi

statusline=""
statusline+="🤖 ${model:-?} (${effort:-?})"
statusline+=" | "
statusline+="📁 ${pj_dir_base:-?}"
statusline+=" | "
statusline+="🧠 ${cw_usage_pct_fmt:-?%} - ${cw_size_si:-?}"
statusline+=" | "
statusline+="⌚ ${five_usage_pct_fmt:-?%} - ${five_cycle_remaining_fmt:-?}"
statusline+=" | "
statusline+="📆 ${week_usage_pct_fmt:-?%} - ${week_cycle_remaining_fmt:-?}"

printf '%s' "$statusline"
