#!/bin/bash
progressbar() {
  width="$1"
  pct="$2"

  filled_blocks=$((pct * width / 100))
  empty_blocks=$((width - filled_blocks))
  bar=""
  [ "$filled_blocks" -gt 0 ] && printf -v fill "%${filled_blocks}s" && bar="${fill// /#}"
  [ "$empty_blocks" -gt 0 ] && printf -v pad "%${empty_blocks}s" && bar="${bar}${pad// /.}"
  echo "$bar"
}

timeremaining() {
    local to=$1
    local now=$(date +%s)
    local duration=$(( to - now ))
    [ "$duration" -le 0 ] && { echo "now"; return; }

    local d=$(( duration / 86400 ))
    local h=$(( (duration % 86400) / 3600 ))
    local m=$(( (duration % 3600) / 60 ))

    local fmt_duration=""
    [ "$d" -gt 0 ] && fmt_duration+="${d}d "
    [ "$h" -gt 0 ] && fmt_duration+="${h}h "
    [ "$m" -gt 0 ] && fmt_duration+="${m}m "
    fmt_duration="${fmt_duration% }"             # 末尾スペース除去
    [ -z "$fmt_duration" ] && fmt_duration="<1m" # 60秒未満（>0）のとき
    echo "$fmt_duration"
}

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
effort=$(echo "$input" | jq -r '.effort.level // empty')
cw_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
cw_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_rst=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
week_rst=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // empty')

[ -n "$cw_pct" ] && cw_pct_bar=$(progressbar 10 $cw_pct) || cw_pct_bar=""
[ -n "$cw_size" ] && cw_size_si=$(numfmt --to=si "$cw_size") || cw_size_si=""
[ -n "$five_pct" ] && five_pct_bar=$(progressbar 10 $five_pct) || five_pct_bar=""
[ -n "$five_rst" ] && five_rst_fmt=$(timeremaining $five_rst) || five_rst_fmt=""
[ -n "$week_pct" ] && week_pct_bar=$(progressbar 10 $week_pct) || week_pct_bar=""
[ -n "$week_rst" ] && week_rst_fmt=$(timeremaining $week_rst) || five_rst_fmt=""

statusline=""
statusline+="🤖 ${model:-?} (${effort:-?})"
statusline+=" | "
statusline+="🧠 ${cw_pct:-?}% [${cw_pct_bar:-??????????}] ${cw_size_si:-?}"
statusline+=" | "
statusline+="⌚ ${five_pct:-?}% [${five_pct_bar:-??????????}] ${five_rst_fmt:-?}"
statusline+=" | "
statusline+="📆 ${week_pct:-?}% [${week_pct_bar:-??????????}] ${week_rst_fmt:-?}"
statusline+=" | "
statusline+="📁 $(dirs)"

printf '%s' "$statusline"
