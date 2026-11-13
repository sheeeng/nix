#!/usr/bin/env bash
input=$(cat)
j() { echo "$input" | jq --raw-output "$1 // empty"; }
model=$(j '.model.display_name')
dir=$(j '.workspace.current_dir // .cwd')
used=$(j '.context_window.used_percentage')
cost=$(j '.cost.total_cost_usd')
dur_ms=$(j '.cost.total_duration_ms')
added=$(j '.cost.total_lines_added')
removed=$(j '.cost.total_lines_removed')

esc=$'\033'
sep=$'\xee\x82\xb0'
cap_l=$'\xee\x82\xb6'
cap_r=$'\xee\x82\xb4'
i_cloud=$'\xef\x83\x82'
i_folder=$'\xef\x81\xbb'
i_branch=$'\xee\x82\xa0'
i_chip=$'\xef\x8b\x9b'
i_db=$'\xef\x87\x80'
i_hourglass=$'\xef\x89\x92'
i_pencil=$'\xef\x81\x80'

crust="13;16;23"
red="217;87;87"
peach="255;143;64"
yellow="255;180;84"
green="170;217;76"
sapphire="89;194;255"
lavender="153;173;191"

out=""
prev=""
add() {
  local bg="$1" text="$2"
  if [ -n "$prev" ]; then
    out+="${esc}[38;2;${prev};48;2;${bg}m${sep}"
  else
    out+="${esc}[38;2;${bg}m${cap_l}"
  fi
  out+="${esc}[48;2;${bg};38;2;${crust}m ${text} "
  prev="$bg"
}

if [ -n "$dir" ]; then
  p="${dir/#$HOME/~}"
  IFS='/' read -r -a parts <<< "${p#/}"
  n=${#parts[@]}
  if [ "$n" -gt 3 ]; then
    p="…/${parts[n - 3]}/${parts[n - 2]}/${parts[n - 1]}"
  fi
  last="${p##*/}"
  head="${p%"$last"}"
  add "$peach" "${i_folder} ${head}${esc}[1m${last}${esc}[22m"

  g() { git --no-optional-locks -C "$dir" "$@" 2> /dev/null; }
  b=$(g symbolic-ref --short HEAD || g rev-parse --short HEAD || true)
  if [ -n "$b" ]; then
    porcelain=$(g status --porcelain)
    staged=$(echo "$porcelain" | grep --count '^[MADRC]' || true)
    unstaged=$(echo "$porcelain" | grep --count '^.[MD]' || true)
    untracked=$(echo "$porcelain" | grep --count '^??' || true)
    ahead=$(g rev-list --count '@{u}..HEAD' || echo 0)
    behind=$(g rev-list --count 'HEAD..@{u}' || echo 0)
    st=""
    if [ "${behind:-0}" -gt 0 ]; then st+=" ⇣${behind}"; fi
    if [ "${ahead:-0}" -gt 0 ]; then st+=" ⇡${ahead}"; fi
    if [ "${staged:-0}" -gt 0 ]; then st+=" +${staged}"; fi
    if [ "${unstaged:-0}" -gt 0 ]; then st+=" !${unstaged}"; fi
    if [ "${untracked:-0}" -gt 0 ]; then st+=" ?${untracked}"; fi
    add "$yellow" "${i_branch} ${b}${st}"
  fi
fi

if [ -n "$model" ]; then
  add "$green" "${i_chip} ${model}"
fi

if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  bg="$sapphire"
  if [ "$pct" -ge 50 ]; then bg="$peach"; fi
  if [ "$pct" -ge 80 ]; then bg="$red"; fi
  add "$bg" "${i_db} ${pct}%"
fi

if [ -n "$cost" ]; then
  s="\$$(printf '%.2f' "$cost")"
  if [ -n "$dur_ms" ]; then
    m=$((${dur_ms%.*} / 60000))
    if [ "$m" -ge 60 ]; then
      s+=" ${i_hourglass} $((m / 60))h$((m % 60))m"
    else
      s+=" ${i_hourglass} ${m}m"
    fi
  fi
  if [ "${added:-0}" -gt 0 ] || [ "${removed:-0}" -gt 0 ]; then
    s+=" ${i_pencil} +${added:-0} -${removed:-0}"
  fi
  add "$lavender" "$s"
fi

az_profile="${AZURE_CONFIG_DIR:-$HOME/.azure}/azureProfile.json"
if [ -r "$az_profile" ]; then
  az_sub=$(sed '1s/^\xEF\xBB\xBF//' "$az_profile" \
    | jq --raw-output '.subscriptions[]? | select(.isDefault) | .name' 2> /dev/null \
    || true)
  if [ -n "$az_sub" ]; then add "$red" "${i_cloud} ${az_sub}"; fi
fi

out+="${esc}[0m${esc}[38;2;${prev}m${cap_r}${esc}[0m"
printf '%s' "$out"
