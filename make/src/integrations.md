# 与生态集成

与 C/C++、Go、Node、Python 等语言/工具链的集成示例。

## C/C++ 集成示例

以下是一个简单的 C++ 程序示例，使用 Makefile 编译和运行：

```cpp
// hello.cpp
#include <iostream>

int main() {
    std::cout << "Hello from C++!" << std::endl;
    return 0;
}
```

对应的 Makefile：

```makefile
CXX = g++
CXXFLAGS = -std=c++11 -Wall

all: hello

hello: hello.cpp
 $(CXX) $(CXXFLAGS) -o hello hello.cpp

clean:
 rm -f hello
```

运行命令：`make` 编译，`./hello` 执行。

## Go 集成示例

以下是一个简单的 Go 程序示例，使用 Makefile 构建：

```go
// hello.go
package main

import "fmt"

func main() {
    fmt.Println("Hello from Go!")
}
```

对应的 Makefile：

```makefile
GO = go
BINARY = hello

all: build

build:
 $(GO) build -o $(BINARY) hello.go

clean:
 rm -f $(BINARY)
```

运行命令：`make` 构建，`./hello` 执行。

## Node.js 集成示例

以下是一个简单的 Node.js 脚本示例，使用 Makefile 运行：

```javascript
// hello.js
console.log("Hello from Node.js!");
```

对应的 Makefile：

```makefile
NODE = node

all: run

run:
 $(NODE) hello.js

clean:
 # No cleanup needed for this example
```

运行命令：`make` 执行脚本。

## Python 集成示例

以下是一个简单的 Python 脚本示例，使用 Makefile 运行：

```python
# hello.py
print("Hello from Python!")
```

对应的 Makefile：

```makefile
PYTHON = python3

all: run

run:
 $(PYTHON) hello.py

clean:
 # No cleanup needed for this example
```

运行命令：`make` 执行脚本。
