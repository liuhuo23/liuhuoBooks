# 依赖与重建

伪目标、自动变量、生成文件与顺序专属依赖。
## 伪目标 (Pseudo-targets)

在 Makefile 中，伪目标是指那些不对应实际文件的目标，它们通常用于执行特定的命令或任务。例如，`clean` 目标用于删除构建过程中生成的临时文件。伪目标通过 `.PHONY` 声明，以避免与同名文件冲突。

```shell
.PHONY: clean
clean:
    rm -f *.o
```

## 自动变量 (Automatic Variables)

自动变量是 Makefile 中预定义的变量，它们在规则中自动展开为当前规则的特定值。常用的自动变量包括：

- `$@`：目标文件名。
- `$<`：第一个依赖文件名。
- `$^`：所有依赖文件名（去重）。
- `$?`：比目标更新的依赖文件名。

例如：

```shell
%.o: %.c
    gcc -c $< -o $@
```

## 生成文件 (Generated Files)

生成文件是指在构建过程中由规则创建的文件。这些文件通常不是源代码的一部分，而是编译或处理的结果。Makefile 可以自动管理这些文件的依赖关系，确保它们在需要时重新生成。

例如，一个简单的编译规则：

```shell
program: main.o utils.o
    gcc $^ -o $@

main.o: main.c
    gcc -c $< -o $@

utils.o: utils.c
    gcc -c $< -o $@
```

## 顺序专属依赖 (Order-only Prerequisites)

顺序专属依赖使用 `|` 分隔符，表示这些依赖只影响目标的构建顺序，而不检查时间戳。它们常用于确保目录存在或初始化步骤完成，而不触发不必要的重建。

例如：

```makefile
output.txt: | dir
    echo "Hello" > $@

dir:
    mkdir -p dir
```

通过这些概念，Makefile 可以更灵活地管理复杂的构建流程，确保依赖关系正确且高效。
