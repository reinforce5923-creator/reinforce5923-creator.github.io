param(
  [Parameter(ValueFromRemainingArguments = $true)]
  [string[]]$MessageParts
)

$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

function Write-Step {
  param([string]$Text)
  Write-Host ""
  Write-Host "==> $Text" -ForegroundColor Cyan
}

function Find-Tool {
  param(
    [string]$Name,
    [string[]]$Candidates
  )

  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if ($cmd) {
    return $cmd.Source
  }

  foreach ($candidate in $Candidates) {
    if (Test-Path -LiteralPath $candidate) {
      return $candidate
    }
  }

  throw "找不到 $Name。请确认它已经安装。"
}

function Get-RepoFullName {
  param([string]$RemoteUrl)

  if ($RemoteUrl -match 'github\.com[:/](?<owner>[^/]+)/(?<repo>[^/]+?)(\.git)?$') {
    return "$($Matches.owner)/$($Matches.repo)"
  }

  throw "无法从 origin 地址识别 GitHub 仓库：$RemoteUrl"
}

function Get-SiteUrl {
  $config = Join-Path $root "_config.yml"
  $urlPattern = '^url:\s*(.+)$'
  $line = Get-Content -LiteralPath $config -Encoding UTF8 | Where-Object { $_ -match $urlPattern } | Select-Object -First 1
  if ($line -match $urlPattern) {
    return $Matches[1].Trim().TrimEnd("/")
  }
  return "https://reinforce5923-creator.github.io"
}

$root = Split-Path -Parent $PSScriptRoot
Set-Location -LiteralPath $root

$git = Find-Tool "git" @(
  "C:\Program Files\Git\cmd\git.exe",
  "C:\Users\12595\.cache\codex-runtimes\codex-primary-runtime\dependencies\native\git\cmd\git.exe"
)
$npm = Find-Tool "npm" @(
  "C:\Program Files\nodejs\npm.cmd"
)
$gh = Get-Command "gh" -ErrorAction SilentlyContinue
if ($gh) {
  $gh = $gh.Source
} elseif (Test-Path -LiteralPath "C:\Program Files\GitHub CLI\gh.exe") {
  $gh = "C:\Program Files\GitHub CLI\gh.exe"
} else {
  $gh = $null
}

$env:Path = "C:\Program Files\nodejs;C:\Program Files\GitHub CLI;C:\Program Files\Git\cmd;" + $env:Path
$env:GIT_TERMINAL_PROMPT = "0"

Write-Host "博客一键发布脚本" -ForegroundColor Green
Write-Host "项目目录：$root"

Write-Step "1. 本地构建检查"
& $npm run build
if ($LASTEXITCODE -ne 0) {
  throw "构建失败。请先修复上面的报错，再重新运行 publish-blog.bat。"
}

Write-Step "2. 检查本地修改"
$porcelain = & $git status --porcelain
if (-not $porcelain) {
  Write-Host "没有检测到需要发布的新修改。网站不需要更新。" -ForegroundColor Yellow
  exit 0
}

Write-Host "将要发布这些改动："
& $git status --short

Write-Step "3. 添加并提交"
& $git add .
if ($LASTEXITCODE -ne 0) {
  throw "git add 失败。"
}

$commitMessage = ($MessageParts -join " ").Trim()
if (-not $commitMessage) {
  $commitMessage = "Update blog $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
}

& $git commit -m $commitMessage
if ($LASTEXITCODE -ne 0) {
  throw "git commit 失败。"
}

Write-Step "4. 推送到 GitHub"
& $git push
if ($LASTEXITCODE -ne 0) {
  throw "git push 失败。请检查 GitHub 登录状态或网络。"
}

Write-Step "5. 等待 GitHub Actions 自动部署"
$remoteUrl = & $git remote get-url origin
$repo = Get-RepoFullName $remoteUrl
$headSha = (& $git rev-parse HEAD).Trim()
$shortSha = (& $git rev-parse --short HEAD).Trim()
$siteUrl = Get-SiteUrl

if ($gh) {
  $foundRun = $false
  for ($i = 1; $i -le 40; $i++) {
    Start-Sleep -Seconds 6
    $json = & $gh run list --repo $repo --limit 10 --json databaseId,headSha,status,conclusion,workflowName,url,displayTitle 2>$null
    if ($LASTEXITCODE -ne 0 -or -not $json) {
      Write-Host "暂时读不到 Actions 状态，继续等待..."
      continue
    }

    $runs = $json | ConvertFrom-Json
    $run = $runs | Where-Object { $_.headSha -eq $headSha } | Select-Object -First 1
    if (-not $run) {
      Write-Host "还没看到本次部署任务，继续等待..."
      continue
    }

    $foundRun = $true
    Write-Host "Actions 状态：$($run.status) / $($run.conclusion)"

    if ($run.status -eq "completed") {
      if ($run.conclusion -eq "success") {
        Write-Host "GitHub Actions 已成功。" -ForegroundColor Green
        break
      }

      Write-Host "GitHub Actions 失败。请打开下面链接看红叉原因：" -ForegroundColor Red
      Write-Host $run.url
      exit 1
    }

    if ($i -eq 40) {
      Write-Host "等待超时，但代码已经推送。请稍后打开 Actions 页面查看：" -ForegroundColor Yellow
      Write-Host "https://github.com/$repo/actions"
    }
  }

  if (-not $foundRun) {
    Write-Host "没有找到本次 Actions 记录，但代码已经推送。请打开 Actions 页面确认：" -ForegroundColor Yellow
    Write-Host "https://github.com/$repo/actions"
  }
} else {
  Write-Host "没有找到 GitHub CLI，已跳过自动等待 Actions。" -ForegroundColor Yellow
  Write-Host "请手动打开：https://github.com/$repo/actions"
}

Write-Step "6. 验证公网首页"
$verifyUrl = "$siteUrl/?v=$shortSha"
try {
  $response = Invoke-WebRequest -Uri $verifyUrl -UseBasicParsing -TimeoutSec 30 -Headers @{ "Cache-Control" = "no-cache" }
  if ($response.StatusCode -eq 200) {
    Write-Host "公网首页可以访问：$siteUrl/" -ForegroundColor Green
    Write-Host "如果浏览器还显示旧内容，请按 Ctrl + F5 强制刷新。"
  } else {
    Write-Host "公网首页返回状态码：$($response.StatusCode)" -ForegroundColor Yellow
  }
} catch {
  Write-Host "公网验证暂时失败，但代码已经推送。稍等 1-3 分钟后再打开：" -ForegroundColor Yellow
  Write-Host "$siteUrl/"
}

Write-Host ""
Write-Host "发布流程结束。" -ForegroundColor Green
Write-Host "博客地址：$siteUrl/"

