$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$HexoCli = Join-Path $ProjectRoot "node_modules\hexo\bin\hexo"

$NodeCommand = Get-Command node -ErrorAction SilentlyContinue
if ($NodeCommand) {
  $Node = $NodeCommand.Source
} else {
  $BundledNode = Join-Path $env:USERPROFILE ".cache\codex-runtimes\codex-primary-runtime\dependencies\node\bin\node.exe"
  if (Test-Path $BundledNode) {
    $Node = $BundledNode
  } else {
    Write-Error "未找到 Node.js。请先安装 Node.js 22+，或把 node.exe 加入 PATH。"
  }
}

if (-not (Test-Path $HexoCli)) {
  Write-Error "未找到 Hexo 依赖。请先运行 npm install；如果当前机器没有 npm，可在 Codex 环境中安装依赖。"
}

Set-Location $ProjectRoot
& $Node $HexoCli server -p 4000 -i 127.0.0.1
