#!/bin/bash
function progressbar() {
  width="$1"
  pct="$2"

  filled_blocks=$((pct * width / 100))
  empty_blocks=$((width - filled_blocks))
  bar=""
  [ "$filled_blocks" -gt 0 ] && printf -v fill "%${filled_blocks}s" && bar="${fill// /#}"
  [ "$empty_blocks" -gt 0 ] && printf -v pad "%${empty_blocks}s" && bar="${bar}${pad// /.}"
  echo "$bar"
}

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
cw_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

five_pct_bar=""
[ -n "$five_pct" ] && five_pct_bar=$(progressbar 10 $five_pct)
week_pct_bar=""
[ -n "$week_pct" ] && week_pct_bar=$(progressbar 10 $week_pct)
cw_pct_bar=""
[ -n "$cw_pct" ] && cw_pct_bar=$(progressbar 10 $cw_pct)

statusline="▶ "
statusline+="Model: ${model:-?} (${effort:-?})"
statusline+=" ▶ "
statusline+="CtxWin: ${cw_pct:-?}% [${cw_pct_bar:-??????????}]"
statusline+=" ▶ "
statusline+="Limit[5h]: ${five_pct:-?}% [${five_pct_bar:-??????????}] "
statusline+=" ▶ "
statusline+="Limit[1w]: ${week_pct:-?}% [${week_pct_bar:-??????????}]"

printf '%s' "$statusline"
