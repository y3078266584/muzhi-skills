# MuZhi Skills — 项目约定

## 目录结构
- 每个 Skill 在根目录下独占一个子目录，目录名即 skill 名
- 必须包含 `SKILL.md`（YAML frontmatter: `name` + `description`）
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
`codex skills install --repo y3078266584/muzhi-skills --path <skill-name>`

## 红线
- 不改 Codex 自身的配置文件，只操作插件/会话等外围资源
- 脚本必须幂等——可安全重复运行
- 不引入外部依赖，仅用 PowerShell 内置 cmdlet