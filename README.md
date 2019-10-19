# Homework
我在作业中构造了一个无法完全转换成SSA的程序test.c,并在LLVM框架下使用Clang生成转换后的test2.ll文件。test.c代码如下：
```C
#include<stdio.h>
int* foo()
{
    int a;
    int b;
    int c = 1;
    int* ptr;
    ptr = &a;
    if (c > 0){
        a = 1;
        b = 1;
    }else{
        a = 2;
        b = 2;
    }
    a = a + 2;
    b = b + 2;
    return ptr;
}
```
上述test.c文件中我们定义了两个整型变量a、b，从代码可以看出二者不同之处仅在于：对a进行了取地址操作，并且将该地址存入指针ptr。其余操作均相同。随后使用以下命令对源文件进行转换：
```
clang -O0 -emit-llvm test.c -S -o test.ll
```
但是生成的test.ll我们可以很明显地看出，alloca指令定义的%a，%b经过了多次赋值操作，这是LLVM中的一种特有现象：虚拟寄存器是SSA形式，而内存则并非SSA形式。在查阅资料的过程中了解到，这个阶段的test.ll还需要经过mem2reg pass把前端默认输出的IR转化为SSA形式，优化最终结果为test2.ll，代码如下：
```
define dso_local i32* @foo() #0 {
entry:
  %a = alloca i32, align 4
  %cmp = icmp sgt i32 1, 0
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  store i32 1, i32* %a, align 4
  br label %if.end

if.else:                                          ; preds = %entry
  store i32 2, i32* %a, align 4
  br label %if.end

if.end:                                           ; preds = %if.else, %if.then
  %b.0 = phi i32 [ 1, %if.then ], [ 2, %if.else ]
  %0 = load i32, i32* %a, align 4
  %add = add nsw i32 %0, 2
  store i32 %add, i32* %a, align 4
  %add1 = add nsw i32 %b.0, 2
  ret i32* %a
}
```
由于源代码中对变量a进行了取地址操作，所以：
* a为address-taken类型变量
* b为top-level类型变量
而test2.ll中我们可以看到，a变量赋值后内存位置不变，但是b变量在if.end块中出现了%b.0形式，说明b变量赋值后内存位置发生变化，LLVM对变量b做了SSA。
