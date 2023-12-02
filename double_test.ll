target triple = "x86_64-pc-linux-gnu"

@.str.int = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.double = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
	@__const.main.nombre5 = private unnamed_addr constant <{[6 x i8], [94 x i8]}> <{[6 x i8] c"Julian", [94 x i8] zeroinitializer }>, align 16
	@.str.21 = private unnamed_addr constant [11 x i8] c"ESTÁ VIVO\00", align 1
	@.str.25 = private unnamed_addr constant [8 x i8] c", MIRA:\00", align 1
	@.str.27 = private unnamed_addr constant [29 x i8] c"La suma de los números es: \00", align 1
	@.str.31 = private unnamed_addr constant [38 x i8] c"La suma truncada de los números es: \00", align 1
define dso_local noundef i32 @main() #0 {
0:
	%1 = alloca i32, align 4
	%2 = alloca double, align 8
	%3 = alloca double, align 8
	%4 = alloca i32, align 4
	%5 = alloca [100 x i8], align 16
	%6 = alloca [100 x i8], align 16
	%7 = alloca i8, align 1
	store i8 0, i8* %7, align 1
	store i32 1, i32* %1, align 4
	store double 2.0, double* %2, align 8
	store double 2.0, double* %2, align 8
	%8 = bitcast [100 x i8]* %5 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %8, i8* align 16 getelementptr inbounds (<{[6 x i8], [94 x i8]}>, <{[6 x i8], [94 x i8]}>* @__const.main.nombre5, i32 0, i32 0, i32 0), i64 100, i1 false)
	%9 = getelementptr inbounds [100 x i8], [100 x i8]* %5, i64 0, i64 0
	%10 = getelementptr inbounds [100 x i8], [100 x i8]* %6, i64 0, i64 0
	%11 = call i8* @strcpy(i8* noundef %10, i8* noundef %9)
	%12 = load i32, i32* %1, align 4
	%13 = load double, double* %2, align 8
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	%14 = sitofp i32 %12 to double
	%15 = fsub double %14, %13
	%16 = load double, double* %2, align 8
	;Expresion flotante abajofloatfloathay espacios???
	%17 = fdiv double %16, 2.4
	;Expresion flotante abajofloatfloathay espacios???
	%18 = fsub double %15, %17
	%19 = load i32, i32* %1, align 4
	%20 = sdiv i32 321, %19
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	%21 = sitofp i32 %20 to double
	%22 = fmul double %21, 123.2
	;Expresion flotante abajofloatfloathay espacios???
	%23 = fdiv double %22, 3.5
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	; Convertí a double una constante
	%24 = fmul double 123.0, %23
	;Expresion flotante abajofloatfloathay espacios???
	%25 = fdiv double %24, 1.0
	;Expresion flotante abajofloatfloathay espacios???
	%26 = fadd double %18, %25
	store double %26, double* %3, align 8
	store double %26, double* %3, align 8
	%27 = load i32, i32* %1, align 4
	store i32 %27, i32* %4, align 4
	%28 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.21, i64 0, i64 0))
	%29 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%30 = getelementptr inbounds [100 x i8], [100 x i8]* %6, i64 0, i64 0
	%31 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.str, i64 0, i64 0), i8* noundef %30 )
	%32 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.25, i64 0, i64 0))
	%33 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%34 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.27, i64 0, i64 0))
	%35 = load double, double* %3, align 8
	%36 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.double, i64 0, i64 0), double noundef %35 )
	%37 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%38 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.31, i64 0, i64 0))
	%39 = load i32, i32* %4, align 4
	%40 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.int, i64 0, i64 0), i32 noundef %39 )
	%41 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	ret i32 0
}
declare i8* @strcpy(i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
