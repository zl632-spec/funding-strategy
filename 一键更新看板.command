#!/bin/bash
set -u
update_project='/Users/apple/Documents/ChatGPT/HA/financing-dashboard'
update_here="$(cd -- "$(dirname -- "$0")" && pwd)"
update_data_root="$(dirname -- "$update_here")"
update_python=''
for update_candidate in '/Users/apple/Documents/ChatGPT/HA/.venv/bin/python' '/Users/apple/.cache/codex-runtimes/codex-primary-runtime/dependencies/python/bin/python3' '/usr/bin/python3'; do
  if [ -x "$update_candidate" ] && "$update_candidate" -c 'import openpyxl, chinese_calendar' >/dev/null 2>&1; then
    update_python="$update_candidate"
    break
  fi
done
if [ -z "$update_python" ]; then
  echo '找不到本机已有的Excel和交易日历运行环境。原看板没有变化。'
  echo '请恢复原研究目录中的 .venv 环境后再试，不需要修改两份Excel。'
  exit 1
fi
"$update_python" "$update_project/scripts/update_dashboard.py" --data-root "$update_data_root" "$@"
update_status=$?
if [ "$update_status" -eq 0 ]; then
  echo '可以打开同目录的“融资策略研究看板.html”查看。'
else
  echo '本次更新没有发布，请按上方提示检查。'
fi
if [ -t 0 ]; then
  echo ''
  read -r -p '按回车关闭此窗口……' update_close
fi
exit "$update_status"
