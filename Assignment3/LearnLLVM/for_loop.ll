; ModuleID = './for_loop.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [42 x i8] c"Enter a number to check if it is a prime\0A\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str2 = private unnamed_addr constant [18 x i8] c"%d is not prime.\0A\00", align 1
@.str3 = private unnamed_addr constant [14 x i8] c"%d is prime.\0A\00", align 1

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
  %1 = alloca i32, align 4
  %n = alloca i32, align 4
  %c = alloca i32, align 4
  store i32 0, i32* %1
  store i32 2, i32* %c, align 4
  %2 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([42 x i8]* @.str, i32 0, i32 0))
  %3 = call i32 (i8*, ...)* @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8]* @.str1, i32 0, i32 0), i32* %n)
  store i32 2, i32* %c, align 4
  br label %4

; <label>:4                                       ; preds = %18, %0
  %5 = load i32* %c, align 4
  %6 = load i32* %n, align 4
  %7 = sub nsw i32 %6, 1
  %8 = icmp sle i32 %5, %7
  br i1 %8, label %9, label %21

; <label>:9                                       ; preds = %4
  %10 = load i32* %n, align 4
  %11 = load i32* %c, align 4
  %12 = srem i32 %10, %11
  %13 = icmp eq i32 %12, 0
  br i1 %13, label %14, label %17

; <label>:14                                      ; preds = %9
  %15 = load i32* %n, align 4
  %16 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([18 x i8]* @.str2, i32 0, i32 0), i32 %15)
  br label %21

; <label>:17                                      ; preds = %9
  br label %18

; <label>:18                                      ; preds = %17
  %19 = load i32* %c, align 4
  %20 = add nsw i32 %19, 1
  store i32 %20, i32* %c, align 4
  br label %4

; <label>:21                                      ; preds = %14, %4
  %22 = load i32* %c, align 4
  %23 = load i32* %n, align 4
  %24 = icmp eq i32 %22, %23
  br i1 %24, label %25, label %28

; <label>:25                                      ; preds = %21
  %26 = load i32* %n, align 4
  %27 = call i32 (i8*, ...)* @printf(i8* getelementptr inbounds ([14 x i8]* @.str3, i32 0, i32 0), i32 %26)
  br label %28

; <label>:28                                      ; preds = %25, %21
  ret i32 0
}

declare i32 @printf(i8*, ...) #1

declare i32 @__isoc99_scanf(i8*, ...) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = metadata !{metadata !"Ubuntu clang version 3.5.0-4ubuntu2~trusty2 (tags/RELEASE_350/final) (based on LLVM 3.5.0)"}
