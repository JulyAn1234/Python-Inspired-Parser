; ModuleID = 'main.cpp'
source_filename = "main.cpp"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

        @__const.main.bb5 = private unnamed_addr constant <{[0 x i8], [100 x i8]}> <{[0 x i8] c"", [100 x i8] zeroinitializer }>, align 16
define dso_local noundef i32 @main() #0 {
0:
        %1 = alloca double, align 8
        %2 = alloca i32, align 4
        %3 = alloca i8, align 1
        %4 = alloca i8, align 1
        %5 = alloca [100 x i8], align 16
        %6 = alloca [100 x i8], align 16
        %7 = alloca i32, align 4
        %8 = alloca i32, align 4
        %9 = alloca i32, align 4
        %10 = alloca i32, align 4
        store double 2.0, double* %1, align 8
        store double 2.0, double* %1, align 8
        store i8 1, i8* %4, align 1
        %11 = bitcast [100 x i8]* %5 to i8*
        call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %11, i8* align 16 getelementptr inbounds (<{[0 x i8], [100 x i8]}>, <{[0 x i8], [100 x i8]}>* @__const.main.bb5, i32 0, i32 0, i32 0), i64 100, i1 false)
        %12 = getelementptr inbounds [100 x i8], [100 x i8]* %5, i64 0, i64 0
        %13 = getelementptr inbounds [100 x i8], [100 x i8]* %6, i64 0, i64 0
        %14 = call i8* @strcpy(i8* noundef %13, i8* noundef %12)
        store i32 100, i32* %7, align 4
        %15 = load i32, i32* %7, align 4
        %16 = load i32, i32* %7, align 4
        %17 = load i32, i32* %8, align 4
        %18 = load i32, i32* %8, align 4
        %19 = load i32, i32* %2, align 4
        %20 = load i32, i32* %2, align 4
        %21 = mul nsw i32 %18, %20
        %22 = add nsw i32 %16, %21
        %23 = load i32, i32* %9, align 4
        %24 = load i32, i32* %9, align 4
        %25 = load i32, i32* %10, align 4
        %26 = load i32, i32* %10, align 4
        %27 = sub nsw i32 %24, %26
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        ; Convertí a double una constante
        ;consant to constant
        %28 = fdiv double 12321.2, 123.0
        ;consant to constant
        %29 = mul nsw i32 12, 123
        %30 = sdiv i32 %29, 12
        ;consant to constant
        %31 = add nsw i32 1, 2
        %32 = mul nsw i32 %30, %31
        %33 = add nsw i32 123, %32
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        %34 = sitofp i32 %33 to double
        %35 = fmul double %28, %34
        ;consant to constant
        %36 = mul nsw i32 2, 2
        %37 = add nsw i32 3, %36
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        %38 = sitofp i32 %37 to double
        %39 = fsub double %35, %38
        ;Expresion flotante abajointfloathay espacios???
        ; Llegue a type1 == int
        %40 = sitofp i32 %27 to double
        %41 = fadd double %40, %39
        ;Expresion flotante abajointfloathay espacios???
        ; Llegue a type1 == int
        %42 = sitofp i32 %22 to double
        %43 = fdiv double %42, %41
        ;consant to constant
        %44 = mul nsw i32 2, 121
        ;consant to constant
        %45 = add nsw i32 523, 12
        %46 = sdiv i32 %44, %45
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        %47 = sitofp i32 %46 to double
        %48 = fdiv double %43, %47
        %49 = fptosi double %48 to i32
        store i32 %49, i32* %10, align 4
        ret i32 0
}
declare i8* @strcpy(i8* noundef, i8* noundef)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 7, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"Ubuntu clang version 14.0.0-1ubuntu1.1"}
