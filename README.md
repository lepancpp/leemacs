# leemacs —— 我的 Emacs 配置

一份**自包含、可移植**的 `.emacs.d`，目标 **Emacs 30.2**。
第三方包都已随仓库携带（`site-lisp/extensions/`、`elpa/`），连同编译产物
（`eln-cache/`、`tree-sitter/*.so`）一起提交，clone 到同架构机器即可直接用。

---

## 一、安装

```bash
# 1. clone
git clone git@github.com:lepancpp/leemacs.git

# 2. 安装 Emacs 30.2（本机用 snap，apt 自带版本太老）
sudo snap install emacs --classic

# 3. 软链接（${DIR} 换成本仓库路径）
ln -sf ${DIR}/leemacs/emacs   ~/.emacs
ln -sf ${DIR}/leemacs/emacs.d ~/.emacs.d
```

## 二、系统依赖（C/C++ 必装）

```bash
sudo apt install -y clangd clang-format cmake
```

- `clangd` —— LSP 服务器（补全/跳转/诊断），本机为 14 版。
- `clang-format` —— 格式化（Google 风格）。
- tree-sitter 语法（`c` / `cpp`）**已随仓库提交**；换到别的平台/架构时重建：
  `M-x treesit-install-language-grammar RET cpp RET`（需要 `g++`、`git`、`make`）。

## 三、这套配置做了哪些现代化（升级记录）

- **已移除**：`go-mode`、`neotree`（含其包与缓存）。
- **从 Emacs 29.3 → 30.2**：替换了 `eln-cache`（旧的 29.3 删除、提交 30.2）。
- **yasnippet 升级到 0.14.3** + `yasnippet-snippets`。
  > 旧的 yasnippet 0.6.1 依赖 Emacs 30 已删除的 `assoc` 库，会导致启动崩溃。
  > 个人代码片段默认目录：`~/.emacs.d/snippets`。
- **C++ 编辑器全面更新**：`tree-sitter` + `eglot` + `clangd` + `company` + `clang-format`。

## 四、C++ 使用提醒 ⭐

1. **每个项目根目录需要 `compile_commands.json`**，clangd 才能正确解析头文件/编译参数：
   ```bash
   cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 -S . -B build
   ln -sf build/compile_commands.json .
   ```
   （或用 `bear -- make` 生成，需另装 `bear`。）
2. 打开 `.c/.cc/.cpp/.cxx/.h/.hpp/.hh` 会自动进入 `c++-ts-mode` 并启动 clangd。
   `.h` 一律按 **C++** 处理。
3. clangd 启动参数（见 `site-lisp/cc/pemacs-cc-edit.el`）：
   `--background-index --clang-tidy --header-insertion=never`
   `--completion-style=detailed --query-driver=…`
   （`--query-driver` 让 clangd 找得到 gcc 的 libstdc++ 系统头文件。）
4. 若 grammar 缺失，会自动回退到经典 `cc-mode` + `google-c-style`。

## 五、快捷键速查

### C/C++（在 c/c++ 缓冲区内）
| 按键 | 功能 |
|------|------|
| `C-c i` | clang-format 格式化**选区** |
| `C-c u` | clang-format 格式化**整个缓冲区** |
| `C-c o` | 头文件 ↔ 源文件切换（`ff-find-other-file`） |
| `C-c r` | 重命名符号（`eglot-rename`） |
| `C-c a` | 代码动作 / 快速修复（`eglot-code-actions`） |
| `M-.` / `M-,` | 跳到定义 / 跳回（eglot + xref） |
| `M-?` | 查找引用 |

> 函数签名/文档会通过 eldoc 自动显示在回显区；诊断由 flymake 给出
> （`M-x flymake-goto-next-error` 跳到下一个错误）。

### 通用
| 按键 | 功能 |
|------|------|
| `C-x C-b` | ibuffer（缓冲区列表） |
| `C-c y` / `C-c c` | 复制当前行 |
| `C-c l` | 选中整行 |
| `C-c w` / `C-c t` | whitespace 显示 / 切换选项 |
| `M-↑` / `M-↓` | 上/下移动当前行 |
| `RET` | 换行并自动缩进 |
| `M-x magit-status` | Git 操作（magit） |

## 六、目录结构

```
emacs                       顶层 init（软链到 ~/.emacs）
emacs.d/
├── site-lisp/              主配置 pemacs-*.el
│   ├── pemacs-init.el      入口：先 bootstrap package.el，再按模块加载
│   ├── pemacs-completing.el  yasnippet / company / autopair / 模板
│   ├── cc/pemacs-cc-edit.el  ★ C/C++ 编辑器（tree-sitter+eglot+clangd）
│   └── extensions/         vendored 第三方包
├── elpa/                   ELPA 包（magit、company、yasnippet 0.14.3 等）
├── eln-cache/              30.2 原生编译缓存（已提交）
├── tree-sitter/            C/C++ 语法 .so（已提交，linux x86-64）
└── snippets/               个人代码片段
```

## 七、故障排查

| 现象 | 处理 |
|------|------|
| C++ 报 `'xxx' file not found` / `std` 未定义 | 检查项目是否有 `compile_commands.json`；clangd 参数里的 `--query-driver` 是否匹配你的编译器路径 |
| 补全/跳转无效 | `which clangd` 确认已安装；`M-x eglot` 手动连接看报错 |
| `clang-format` 不生效 | 确认 `clang-format` 在 PATH；风格变量是 `clang-format-style`（buffer-local，已用 `setq-default` 设为 google） |
| 换机器后语法高亮异常 | `M-x treesit-install-language-grammar` 重建 c/cpp 语法 |
| 启动报错 | `emacs --batch -l ~/.emacs` 看具体报错信息 |
