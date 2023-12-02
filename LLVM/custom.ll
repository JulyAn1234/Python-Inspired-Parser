target triple = "x86_64-pc-linux-gnu"

@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.int = private unnamed_addr constant [3 x i8] c"%d\00", align 1
        @.str.31 = private unnamed_addr constant [12 x i8] c"It's alive!\00", align 1
define dso_local noundef i32 @main() #0 {
0:
        %1 = alloca i32, align 4
        %2 = alloca i32, align 4
        %3 = alloca i32, align 4
        %4 = alloca i32, align 4
        %5 = alloca i32, align 4
        %6 = alloca i8, align 1
        store i8 1, i8* %6, align 1
        store i32 100, i32* %1, align 4
        store i32 200, i32* %2, align 4
        store i32 300, i32* %3, align 4
        store i32 400, i32* %4, align 4
        store i32 500, i32* %5, align 4
        %7 = load i32, i32* %1, align 4
        %8 = load i32, i32* %2, align 4
        %9 = load i32, i32* %3, align 4
        %10 = mul nsw i32 %8, %9
        %11 = add nsw i32 %7, %10
        %12 = load i32, i32* %4, align 4
        %13 = load i32, i32* %5, align 4
        %14 = sub nsw i32 %12, %13
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        ; Convertí a double una constante
        ;consant to constant
        %15 = fdiv double 12321.2, 123.0
        ;consant to constant
        %16 = mul nsw i32 12, 123
        %17 = sdiv i32 %16, 12
        ;consant to constant
        %18 = add nsw i32 1, 2
        %19 = mul nsw i32 %17, %18
        %20 = add nsw i32 123, %19
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        %21 = sitofp i32 %20 to double
        %22 = fmul double %15, %21
        ;consant to constant
        %23 = mul nsw i32 2, 2
        %24 = add nsw i32 3, %23
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        %25 = sitofp i32 %24 to double
        %26 = fsub double %22, %25
        ;Expresion flotante abajointfloathay espacios???
        ; Llegue a type1 == int
        %27 = sitofp i32 %14 to double
        %28 = fadd double %27, %26
        ;Expresion flotante abajointfloathay espacios???
        ; Llegue a type1 == int
        %29 = sitofp i32 %11 to double
        %30 = fdiv double %29, %28
        ;consant to constant
        %31 = mul nsw i32 2, 121
        ;consant to constant
        %32 = add nsw i32 523, 12
        %33 = sdiv i32 %31, %32
        ;Expresion flotante abajofloatinthay espacios???
        ; Llegue a type2 == int
        %34 = sitofp i32 %33 to double
        %35 = fdiv double %30, %34
        %36 = fptosi double %35 to i32
        store i32 %36, i32* %5, align 4
        %37 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.31, i64 0, i64 0))
        %38 = load i8, i8* %6, align 1
        %39 = trunc i8 %38 to i1
        %40 = zext i1 %39 to i32
        %41 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.int, i64 0, i64 0), i32 noundef %40 )
        %42 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
        ret i32 0
}
declare i32 @printf(i8* noundef, ...)