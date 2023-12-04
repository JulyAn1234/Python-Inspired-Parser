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
@.str.2 = private unnamed_addr constant [39 x i8] c"Invalid input for integer, try again: \00", align 1
@.str.3 = private unnamed_addr constant [17 x i8] c"Enter a double: \00", align 1
@.str.4 = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.5 = private unnamed_addr constant [38 x i8] c"Invalid input for double, try again: \00", align 1
@.str.6 = private unnamed_addr constant [17 x i8] c"Enter a string: \00", align 1
@stdin = external global %struct._IO_FILE*, align 8
@.str.7 = private unnamed_addr constant [26 x i8] c"You entered a string: %s\0A\00", align 1

; Function Attrs: mustprogress noinline norecurse optnone uwtable
define dso_local noundef i32 @main() #0 {
  %1 = alloca i32, align 4
  %2 = alloca i32, align 4
  %3 = alloca double, align 8
  %4 = alloca [100 x i8], align 16
  store i32 0, i32* %1, align 4
  %5 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0))
  br label %6

6:                                                ; preds = %15, %0
  %7 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.1, i64 0, i64 0), i32* noundef %2)
  %8 = icmp eq i32 %7, 0
  br i1 %8, label %9, label %16

9:                                                ; preds = %6
  %10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([39 x i8], [39 x i8]* @.str.2, i64 0, i64 0))
  br label %11

11:                                               ; preds = %14, %9
  %12 = call i32 @getchar()
  %13 = icmp ne i32 %12, 10
  br i1 %13, label %14, label %15

14:                                               ; preds = %11
  br label %11, !llvm.loop !6

15:                                               ; preds = %11
  br label %6, !llvm.loop !8

16:                                               ; preds = %6
  br label %17

17:                                               ; preds = %20, %16
  %18 = call i32 @getchar()
  %19 = icmp ne i32 %18, 10
  br i1 %19, label %20, label %21

20:                                               ; preds = %17
  br label %17, !llvm.loop !9

21:                                               ; preds = %17
  %22 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0))
  br label %23

23:                                               ; preds = %32, %21
  %24 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i64 0, i64 0), double* noundef %3)
  %25 = icmp eq i32 %24, 0
  br i1 %25, label %26, label %33

26:                                               ; preds = %23
  %27 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.5, i64 0, i64 0))
  br label %28

28:                                               ; preds = %31, %26
  %29 = call i32 @getchar()
  %30 = icmp ne i32 %29, 10
  br i1 %30, label %31, label %32

31:                                               ; preds = %28
  br label %28, !llvm.loop !10

32:                                               ; preds = %28
  br label %23, !llvm.loop !11

33:                                               ; preds = %23
  br label %34

34:                                               ; preds = %37, %33
  %35 = call i32 @getchar()
  %36 = icmp ne i32 %35, 10
  br i1 %36, label %37, label %38

37:                                               ; preds = %34
  br label %34, !llvm.loop !12

38:                                               ; preds = %34
  %39 = bitcast [100 x i8]* %4 to i8*
  call void @llvm.memset.p0i8.i64(i8* align 16 %39, i8 0, i64 100, i1 false)
  %40 = bitcast i8* %39 to <{ i8, [99 x i8] }>*
  %41 = getelementptr inbounds <{ i8, [99 x i8] }>, <{ i8, [99 x i8] }>* %40, i32 0, i32 0
  store i8 97, i8* %41, align 16
  %42 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  call void @llvm.memset.p0i8.i64(i8* align 16 %42, i8 0, i64 100, i1 false)
  %43 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.6, i64 0, i64 0))
  %44 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  %45 = load %struct._IO_FILE*, %struct._IO_FILE** @stdin, align 8
  %46 = call i8* @fgets(i8* noundef %44, i32 noundef 100, %struct._IO_FILE* noundef %45)
  %47 = icmp ne i8* %46, null
  br i1 %47, label %48, label %51

48:                                               ; preds = %38
  %49 = getelementptr inbounds [100 x i8], [100 x i8]* %4, i64 0, i64 0
  %50 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([26 x i8], [26 x i8]* @.str.7, i64 0, i64 0), i8* noundef %49)
  br label %51

51:                                               ; preds = %48, %38
  %52 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([17 x i8], [17 x i8]* @.str.3, i64 0, i64 0))
  br label %53

53:                                               ; preds = %62, %51
  %54 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.4, i64 0, i64 0), double* noundef %3)
  %55 = icmp eq i32 %54, 0
  br i1 %55, label %56, label %63

56:                                               ; preds = %53
  %57 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.5, i64 0, i64 0))
  br label %58

58:                                               ; preds = %61, %56
  %59 = call i32 @getchar()
  %60 = icmp ne i32 %59, 10
  br i1 %60, label %61, label %62

61:                                               ; preds = %58
  br label %58, !llvm.loop !13

62:                                               ; preds = %58
  br label %53, !llvm.loop !14

63:                                               ; preds = %53
  br label %64

64:                                               ; preds = %67, %63
  %65 = call i32 @getchar()
  %66 = icmp ne i32 %65, 10
  br i1 %66, label %67, label %68

67:                                               ; preds = %64
  br label %64, !llvm.loop !15

68:                                               ; preds = %64
  ret i32 0
}

declare i32 @printf(i8* noundef, ...) #1

declare i32 @__isoc99_scanf(i8* noundef, ...) #1

declare i32 @getchar() #1

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #2

declare i8* @fgets(i8* noundef, i32 noundef, %struct._IO_FILE* noundef) #1

attributes #0 = { mustprogress noinline norecurse optnone uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nounwind willreturn writeonly }

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
!9 = distinct !{!9, !7}
!10 = distinct !{!10, !7}
!11 = distinct !{!11, !7}
!12 = distinct !{!12, !7}
!13 = distinct !{!13, !7}
!14 = distinct !{!14, !7}
!15 = distinct !{!15, !7}
