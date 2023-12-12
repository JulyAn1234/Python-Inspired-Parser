target triple = "x86_64-pc-linux-gnu"

@.str.double = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
	@__const.main.nombre6 = private unnamed_addr constant <{[6 x i8], [94 x i8]}> <{[6 x i8] c"Julian", [94 x i8] zeroinitializer }>, align 16
	@.str.24 = private unnamed_addr constant [29 x i8] c"Mi primer loop infinito JAJA\00", align 1
	@.str.29 = private unnamed_addr constant [11 x i8] c"ESTÁ VIVO\00", align 1
	@.str.33 = private unnamed_addr constant [8 x i8] c", MIRA:\00", align 1
	@.str.35 = private unnamed_addr constant [29 x i8] c"La suma de los números es: \00", align 1
define dso_local noundef i32 @main() #0 {
0:
	%1 = alloca i32, align 4
	%2 = alloca i32, align 4
	%3 = alloca double, align 8
	%4 = alloca double, align 8
	%5 = alloca i32, align 4
	%6 = alloca [100 x i8], align 16
	%7 = alloca [100 x i8], align 16
	%8 = alloca i8, align 1
	%9 = alloca i32, align 4
	store i32 2, i32* %2, align 4
	store i8 1, i8* %8, align 1
	store i32 1, i32* %1, align 4
	%10 = bitcast [100 x i8]* %6 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %10, i8* align 16 getelementptr inbounds (<{[6 x i8], [94 x i8]}>, <{[6 x i8], [94 x i8]}>* @__const.main.nombre6, i32 0, i32 0, i32 0), i64 100, i1 false)
	store double 2.0, double* %3, align 8
	store double 2.0, double* %3, align 8
	%11 = getelementptr inbounds [100 x i8], [100 x i8]* %6, i64 0, i64 0
	%12 = getelementptr inbounds [100 x i8], [100 x i8]* %7, i64 0, i64 0
	%13 = call i8* @strcpy(i8* noundef %12, i8* noundef %11)
	%14 = load i32, i32* %1, align 4
	%15 = load double, double* %3, align 8
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	%16 = sitofp i32 %14 to double
	%17 = fsub double %16, %15
	%18 = load double, double* %3, align 8
	;Expresion flotante abajofloatfloathay espacios???
	%19 = fdiv double %18, 2.4
	;Expresion flotante abajofloatfloathay espacios???
	%20 = fsub double %17, %19
	%21 = load i32, i32* %1, align 4
	%22 = sdiv i32 321, %21
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	%23 = sitofp i32 %22 to double
	%24 = fmul double %23, 123.2
	;Expresion flotante abajofloatfloathay espacios???
	%25 = fdiv double %24, 3.5
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	; Convertí a double una constante
	%26 = fmul double 123.0, %25
	;Expresion flotante abajofloatfloathay espacios???
	%27 = fdiv double %26, 1.0
	;Expresion flotante abajofloatfloathay espacios???
	%28 = fadd double %20, %27
	store double %28, double* %4, align 8
	store double %28, double* %4, align 8
	%29 = load i32, i32* %1, align 4
	store i32 %29, i32* %5, align 4
	store i32 0, i32* %9, align 4
	%30 = load i32, i32* %9, align 4
	%31 = icmp slt i32 %30, 5
	br i1 %31, label %32, label %37
32:
	%33 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.24, i64 0, i64 0))
	%34 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%35 = load i32, i32* %9, align 4
	%36 = add nsw i32 %35, 1
	store i32 %36, i32* %9, align 4
	br label %37
37:
	%38 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.29, i64 0, i64 0))
	%39 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%40 = getelementptr inbounds [100 x i8], [100 x i8]* %7, i64 0, i64 0
	%41 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.str, i64 0, i64 0), i8* noundef %40 )
	%42 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.33, i64 0, i64 0))
	%43 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%44 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.35, i64 0, i64 0))
	%45 = load double, double* %4, align 8
	%46 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.double, i64 0, i64 0), double noundef %45 )
	%47 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	ret i32 0
}
declare i8* @strcpy(i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
