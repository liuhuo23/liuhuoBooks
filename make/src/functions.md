# 函数

常用内建函数与用法示例。

## 常用内建函数

### $(subst from,to,text)
替换 text 中的 from 为 to。

示例：
```makefile
$(subst .c,.o,foo.c bar.c)
# 输出: foo.o bar.o
```

### $(patsubst pattern,replacement,text)
对 text 中匹配 pattern 的部分进行替换。

示例：
```makefile
$(patsubst %.c,%.o,foo.c bar.c)
# 输出: foo.o bar.o
```

### $(wildcard pattern)
展开通配符 pattern，返回匹配的文件列表。

示例：
```makefile
$(wildcard *.c)
# 输出: foo.c bar.c (假设目录中有这些文件)
```

### $(dir names)
返回 names 中每个文件名的目录部分。

示例：
```makefile
$(dir src/foo.c hacks)
# 输出: src/ ./
```

### $(notdir names)
返回 names 中每个文件名的非目录部分。

示例：
```makefile
$(notdir src/foo.c hacks)
# 输出: foo.c hacks
```

### $(foreach var,list,text)
对 list 中的每个元素，将其赋值给 var，然后展开 text。

示例：
```makefile
$(foreach file,foo.c bar.c baz.c, $(file).o)
# 输出: foo.c.o bar.c.o baz.c.o
```

### $(call variable,param,param,...)
调用用户定义的函数。

示例：
```makefile
reverse = $(2) $(1)
all: ; @echo $(call reverse,foo,bar)
# 输出: bar foo
```

### $(shell command)
执行 shell 命令并返回其输出。

示例：
```makefile
$(shell ls *.c)
# 输出: foo.c bar.c (假设目录中有这些文件)
```

### $(origin variable)
返回变量的来源。

示例：
```makefile
$(origin CC)
# 输出: default (如果未定义)
```

### $(flavor variable)
返回变量的类型：recursive 或 simple。

示例：
```makefile
$(flavor CC)
# 输出: recursive (默认情况下)
```

### $(value variable)
返回变量的原始值，不进行展开。

示例：
```makefile
FOO = $(BAR)
BAR = hello
$(value FOO)
# 输出: $(BAR)
```

### $(eval text)
将 text 作为 Makefile 语法进行解析。

示例：
```makefile
$(eval define myrule
target: prereq
 command
endef)
```

### $(error text)
产生错误并停止执行。

示例：
```makefile
$(error This is an error)
```

### $(warning text)
产生警告但继续执行。

示例：
```makefile
$(warning This is a warning)
```

### $(info text)
打印信息。

示例：
```makefile
$(info This is info)
```

这些是 Makefile 中一些常用的内建函数及其用法示例。更多详细信息请参考 GNU Make 手册。
