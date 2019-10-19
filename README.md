# Homework
我在作业中构造了一个无法完全转换成SSA的程序test.c,并在LLVM框架下使用Clang生成转换后的test.ll文件，即中间表达式形式。
test.c代码如下：
    int main()
    {
        int a = 22;
        int b = 33;
        int* ptr;
        ptr = &a;
        *ptr = 44;
        while (a != 0)
        {
            b = a + 1;
            b = b - a;
            a--;
        }
    }
