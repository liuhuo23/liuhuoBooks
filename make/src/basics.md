# 基础入门

Make 的用途、安装与第一个 Makefile。
## 安装 Make

### Linux
- **Ubuntu/Debian**: `sudo apt update && sudo apt install make`
- **CentOS/RHEL**: `sudo yum install make` (或使用 `dnf` 代替 `yum`)
- **Arch Linux**: `sudo pacman -S make`

### macOS
- 使用 Homebrew: `brew install make`
- 或通过 Xcode 命令行工具: `xcode-select --install`

### Windows
- 使用 Chocolatey: `choco install make`
- 或通过 MinGW-w64: 下载并安装 MinGW，然后使用 `mingw32-make` 命令

安装完成后，可以通过 `make --version` 验证安装是否成功。
