---
name: powershell-quoting
description: >
  PowerShell 引号转义规则与最佳实践。当 Codex 需要在 Windows/PowerShell 环境中编写命令时使用。
  适用场景：(1) 拼接或传递带空格的参数给外部 exe (2) 嵌套引号调用 cmd /c 或其他 shell
  (3) 在 PowerShell 字符串中嵌入变量或表达式 (4) 将 JSON/复杂字符串传给外部程序
  (5) 在 Start-Process / Invoke-Expression 中传递参数。
  此为故障排除技能：当 Codex 之前在此类场景中出过错,或检测到正在编写可能出错的引号代码时触发。
---

## PowerShell 引号核心规则
### 引号行为速查
| 写法 | 行为 | 示例 |
|------|------|------|
| `'literal'` | 单引号——纯字面量,不解析任何东西 | `'$name is $(x+1)'` -> 保持原样 |
| `"expand"` | 双引号——解析 `$var` 和 `$(expr)` | `"$name is $($x+1)"` -> 展开变量 |
| `` ` `` | 反引号——PowerShell 转义符(不是反斜杠) | `` `n `` 换行,`` `t `` 制表符,`` `" `` 双引号 |
### 常见错误场景与正确写法
#### 1. 给外部命令传递带空格的参数
```powershell
# 错误: 引号被 PowerShell 吃掉
cmd /c echo "hello world"
# 正确: 用两对引号嵌套
cmd /c echo """hello world"""
# 更推荐: 用 Start-Process + splatting
Start-Process cmd -ArgumentList @("/c", "echo", "hello world")
# 或用 --% (stop-parsing token), 之后所有字符保持原样
cmd /c --% echo "hello world"
```
#### 2. 拼接命令字符串
```powershell
# 错误: 双引号里的 $ 会被展开
$name = "world"; cmd /c "echo hello $name"
# 正确: 单引号保持字面, 或用 splatting
$name = "world"
Start-Process cmd -ArgumentList @("/c", "echo", "hello $name")
```
#### 3. JSON/complex 字符串传给外部程序
```powershell
# 错误: 双引号互相打架
curl -H "Content-Type: application/json" -d "{""key"": ""value""}"
# 正确: 用 here-string(最清晰)
$json = @'
{"key": "value"}
'@
curl -H "Content-Type: application/json" -d $json
# 或用单引号包围 JSON 再内部转义
curl -H 'Content-Type: application/json' -d '{\`"key\`": \`"value\`"}'
```
#### 4. Start-Process 传参
```powershell
# 正确: 用数组 splatting(每个参数独立)
Start-Process powershell -ArgumentList @(
    "-NoProfile",
    "-Command",
    "Write-Host hello"
)
```
### 安全检查清单
1. **当前是 PowerShell 环境?** - 反引号是转义符,不是反斜杠
2. **参数里有空格?** - 必须额外包装引号或用 splatting
3. **调外部 exe?** - 优先用 `Start-Process -ArgumentList @(...)` splatting
4. **字符串里含 `$`?** - 确定是要展开还是保持字面
5. **需要在 `cmd /c` 里套引号?** - 记得三层嵌套或用 `--%`
6. **需要传 JSON?** - 用 here-string `@'...'@`