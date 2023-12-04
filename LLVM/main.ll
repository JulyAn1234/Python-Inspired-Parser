; ModuleID = 'main.cpp'
source_filename = "main.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i32, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, i8*, %struct._IO_marker*, %struct._IO_FILE*, i32, i32, i64, i16, i8, [1 x i8], i8*, i64, %struct._IO_codecvt*, %struct._IO_wide_data*, %struct._IO_FILE*, i8*, i64, i32, [20 x i8] }
%struct._IO_marker = type opaque
%struct._IO_codecvt = type opaque
%struct._IO_wide_data = type opaque

@.str = private unnamed_addr constant [19 x i8] c"Enter an integer: \00", align 1
@.str.1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.2 = private unnamed_addr constant [28 x i8] c"You entered an integer: %d\0A\00", align 1
@.str.3 = private unnamed_addr constant [28 x i8] c"Invalid input for integer.\0A\00", align 1
@.str.4 = private unnamed_addr constant [17 x i8] c"Enter a double: \00", align 1
@.str.5 = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.6 = private unnamed_addr constant [27 x i8] c"You entered a double: %lf\0A\00", align 1
@.str.7 = private unnamed_addr constant [27 x i8] c"Invalid input for double.\0A\00", align 1
@.str.8 = private unnamed_addr constant [17 x i8] c"Enter a string: \00", align 1
@stdin = external global %struct._IO_FILE*, align 8
@.str.9 = private unnamed_addr constant [26 x i8] c"You entered a string: %s\0A\00", align 1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca double, align 8
  %4 = alloca [100 x i8], align 16
  store i32 0, i32* %1, align 4
  %5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0))
  %6 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i64 0, i64 0), i32* noundef %2)
  %7 = icmp eq i32 %6, 1
  br i1 %7, label %8, label %11

8:                                                ; preds = %0
  %9 = load i32, i32* %2, align 4
  %10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.2, i64 0, i64 0), i32 noundef %9)
  br label %18

11:                                               ; preds = %0
  %12 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([28 x i8], [28 x i8]* @.str.3, i64 0, i64 0))
  br label %13

13:                                               ; preds = %16, %11
  %14 = call i32 @getchar()
  %15 = icmp ne i32 %14, 10
  br i1 %15, label %16, label %17

16:                                               ; preds = %13
  br label %13, !llvm.loop !6

17:                                               ; preds = %13
  br label %18

18:                                               ; preds = %17, %8
  %19 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.4, i64 0, i64 0))
  %20 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.5, i64 0, i64 0), double* noundef %3)
  %21 = icmp eq i32 %20, 1
  br i1 %21, label %22, label %25

22:                                               ; preds = %18
  %23 = load double, double* %3, align 8
  %24 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.6, i64 0, i64 0), double noundef %23)
  br label %32

25:                                               ; preds = %18
  %26 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([27 x i8], [27 x i8]* @.str.7, i64 0, i64 0))
  br label %27

27:                                               ; preds = %30, %25
  %28 = call i32 @getchar()
  %29 = icmp ne i32 %28, 10
  br i1 %29, label %30, label %31

30:                                               ; preds = %27
  br label %27, !llvm.loop !8

31:                                               ; preds = %27
  br label %32

32:                                               ; preds = %31, %22
  %33 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.8, i64 0, i64 0))
  %34 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  %35 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8
  %36 = call i8* @fgets(i8* noundef %34, i32 noundef 100, %struct._IO_FILE* noundef %35)
  %37 = icmp ne i8* %36, null
  br i1 %37, label %38, label %59

38:                                               ; preds = %32
  %39 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  %40 = load i8, i8* %39, align 16
  %41 = sext i8 %40 to i32
  %42 = icmp ne i32 %41, 0
  br i1 %42, label %43, label %56

43:                                               ; preds = %38
  %44 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  %45 = call i64 @strlen(i8* noundef %44) #3
  %46 = sub i64 %45, 1
  %47 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 %46
  %48 = load i8, i8* %47, align 1
  %49 = sext i8 %48 to i32
  %50 = icmp eq i32 %49, 10
  br i1 %50, label %51, label %56

51:                                               ; preds = %43
  %52 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  %53 = call i64 @strlen(i8* noundef %52) #3
  %54 = sub i64 %53, 1
  %55 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 %54
  store i8 0, i8* %55, align 1
  br label %56

56:                                               ; preds = %51, %43, %38
  %57 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  %58 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.9, i64 0, i64 0), i8* noundef %57)
  br label %59

59:                                               ; preds = %56, %32
  ret i32 0
}

declare i32 @printf(i8* noundef, ...) #1

declare i32 @__isoc99_scanf(i8* noundef, ...) #1

declare i32 @getchar() #1

declare i8* @fgets(i8* noundef, i32 noundef, %struct._IO_FILE* noundef) #1

; Function Attrs: nounwind readonly willreturn
declare i64 @strlen(i8* noundef) #2

attributes #0 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { nounwind readonly willreturn "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind readonly willreturn }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
!6 = distinct !{!6, !7}
!7 = !{!"llvm.loop.mustprogress"}
!8 = distinct !{!8, !7}
