# 进阶主题

条件判断、二次展开、函数式技巧等。

## 条件判断

Makefiles 支持条件判断，用于根据变量值或条件执行不同的规则。常用的条件判断包括 `ifeq`、`ifneq`、`ifdef` 和 `ifndef`。

### 示例：使用 ifeq 和 ifneq

```makefile
CC = gcc
DEBUG = yes

ifeq ($(DEBUG), yes)
    CFLAGS = -g -O0
else
    CFLAGS = -O2
endif

all: program

program: main.c
    $(CC) $(CFLAGS) -o program main.c
```

在这个例子中，如果 `DEBUG` 设置为 `yes`，则使用调试标志；否则使用优化标志。

### 示例：使用 ifdef 和 ifndef

```makefile
ifdef OPTIMIZE
    CFLAGS += -O3
endif

ifndef DEBUG
    CFLAGS += -DNDEBUG
endif

program: main.c
    gcc $(CFLAGS) -o program main.c
```

这里，如果定义了 `OPTIMIZE`，则添加优化标志；如果未定义 `DEBUG`，则添加 `NDEBUG` 宏。

## 二次展开

二次展开（Secondary Expansion）允许在规则的依赖列表中使用变量，这些变量在规则解析时会被再次展开。这通过 `.SECONDEXPANSION:` 启用。

### 示例：二次展开

```makefile
.SECONDEXPANSION:

objects = foo.o bar.o

foo.o: $$(foo_deps)
bar.o: $$(bar_deps)

foo_deps = foo.c foo.h
bar_deps = bar.c bar.h

%.o: %.c
    gcc -c $< -o $@
```

在这个例子中，`$$(foo_deps)` 在二次展开时会被替换为 `foo_deps` 的值，即 `foo.c foo.h`。

## 函数式技巧

Makefiles 提供了内置函数，如 `$(call)`、`$(eval)`、`$(foreach)` 等，用于更复杂的操作。

### 示例：使用 $(call)

```makefile
define compile
gcc -c $(1) -o $(2)
endef

all: foo.o bar.o

foo.o: foo.c
    $(call compile,foo.c,foo.o)

bar.o: bar.c
    $(call compile,bar.c,bar.o)
```

这里定义了一个 `compile` 函数，使用 `$(call)` 调用它来编译文件。

### 示例：使用 $(eval)

```makefile
define create_rule
$(1): $(2)
    gcc -c $$< -o $$@
endef

$(eval $(call create_rule,foo.o,foo.c))
$(eval $(call create_rule,bar.o,bar.c))

all: foo.o bar.o
```

`$(eval)` 用于在运行时创建新的 Makefile 规则。

### 示例：使用 $(foreach)

```makefile
sources = foo.c bar.c baz.c
objects = $(foreach src,$(sources),$(src:.c=.o))

all: $(objects)

%.o: %.c
    gcc -c $< -o $@
```

`$(foreach)` 用于对列表中的每个元素应用操作，生成对象文件列表。
