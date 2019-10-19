; ModuleID = 'test.ll'
source_filename = "test.c"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.15.0"

; Function Attrs: noinline nounwind uwtable
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

attributes #0 = { noinline nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "min-legal-vector-width"="0" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 10, i32 15]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 7, !"PIC Level", i32 2}
!3 = !{!"Apple clang version 11.0.0 (clang-1100.0.33.8)"}