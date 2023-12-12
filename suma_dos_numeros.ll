target triple = "x86_64-pc-linux-gnu"

@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.int = private unnamed_addr constant [3 x i8] c"%d\00", align 1
	@.str.19 = private unnamed_addr constant [13 x i8] c"La suma es: \00", align 1
define dso_local noundef i32 @main() #0 {
0:
	%1 = alloca double, align 8
	%2 = alloca double, align 8
	%3 = alloca i32, align 4
	%4 = alloca i32, align 4
	%5 = alloca i32, align 4
	;consant to constant
	%6 = sdiv i32 6, 2
	%7 = sitofp i32 %6 to double
	store double %7, double* %1, align 8
	store double %7, double* %1, align 8
	;consant to constant
	%8 = sdiv i32 12, 3
	%9 = sitofp i32 %8 to double
	store double %9, double* %2, align 8
	store double %9, double* %2, align 8
	%10 = load double, double* %1, align 8
	%11 = load double, double* %2, align 8
	;Expresion flotante abajofloatfloathay espacios???
	%12 = fadd double %10, %11
	%13 = fptosi double %12 to i32
	store i32 %13, i32* %3, align 4
	store i32 1, i32* %4, align 4
	store i32 1, i32* %5, align 4
	br label %14
14:
	%15 = load i32, i32* %5, align 4
	%16 = icmp slt i32 %15, 10
	br i1 %16, label %17, label %23
17:
	%18 = load i32, i32* %4, align 4
	%19 = load i32, i32* %5, align 4
	%20 = mul nsw i32 %18, %19
	store i32 %20, i32* %4, align 4
	%21 = load i32, i32* %5, align 4
	%22 = add nsw i32 %21, 1
	store i32 %22, i32* %5, align 4
	br label %14
23:
	%24 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([13 x i8], [13 x i8]* @.str.19, i64 0, i64 0))
	%25 = load i32, i32* %4, align 4
	%26 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.int, i64 0, i64 0), i32 noundef %25 )
	%27 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	ret i32 0
}
declare i32 @printf(i8* noundef, ...)
