# MuZhi Skills — 项目约定

> 本项目为 **Skill 索引仓库**。每个 Skill 在 `repos/` 下独立成仓、独立维护 Git 仓库。
> 本仓库（muzhi-skills）只保留索引文档与全局约定，不直接包含 Skill 内容。

## 目录结构
- 主仓库根目录仅保留索引说明（`README.md`、`AGENTS.md`）与必要全局配置
- 每个 Skill 在 `repos/<skill-name>/` 下独占一个子目录，目录名即 skill 名，各自为独立 Git 仓库
- 每个 Skill 目录必须包含 `SKILL.md`（YAML frontmatter: `name` + `description`）
- 必须包含 `agents/openai.yaml`（`interface:` 嵌套格式，含 display_name、short_description、brand_color、default_prompt）
- 可包含 `scripts/`（PowerShell 脚本）

## SKILL.md 规范
- UTF-8 without BOM 编码（BOM 会导致 Codex 解析失败）
- YAML frontmatter 中字符串值加引号，含特殊字符时转义
- `description` 字段包含触发词——这是 Codex 匹配 skill 的唯一依据
- 不要在中文字符后混入控制字符（尤其是从富文本粘贴）

## agents/openai.yaml 格式
```yaml
interface:
  display_name: "名称"
  short_description: "简短描述"
  brand_color: "#HEX颜色"
  default_prompt: "Use `$skill-name` to ..."
```

## 安装方式
每个 Skill 独立成仓，安装命令指向各自仓库：

```bash
codex skills install --repo <your-github-username>/<skill-repo-name> --path .
```

> 每个 Skill 的详细安装说明见各自仓库的 README。

## 版本管理
- 所有 Skill 使用 `x.y.z` 版本号，初始 `1.0.0`
- 独立仓库在 `repos/<skill>/` 内 `git init` 初始化，变更在各自仓库内提交

## 红线
- 不改 Codex 自身的配置文件，只操作插件/会话等外围资源
- 脚本必须幂等——可安全重复运行
- 不引入外部依赖，仅用 PowerShell 内置 cmdlet
