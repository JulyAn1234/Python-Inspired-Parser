target triple = "x86_64-pc-linux-gnu"

@.str.int = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str.double = private unnamed_addr constant [4 x i8] c"%lf\00", align 1
@.str.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
	@__const.main.nombre6 = private unnamed_addr constant <{[6 x i8], [94 x i8]}> <{[6 x i8] c"Julian", [94 x i8] zeroinitializer }>, align 16
	@.str.23 = private unnamed_addr constant [29 x i8] c"Mi primer loop infinito JAJA\00", align 1
	@.str.26 = private unnamed_addr constant [11 x i8] c"ESTÁ VIVO\00", align 1
	@.str.30 = private unnamed_addr constant [8 x i8] c", MIRA:\00", align 1
	@.str.32 = private unnamed_addr constant [29 x i8] c"La suma de los números es: \00", align 1
	@.str.36 = private unnamed_addr constant [38 x i8] c"La suma truncada de los números es: \00", align 1
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
	store i32 2, i32* %2, align 4
	store i8 1, i8* %8, align 1
	store i32 1, i32* %1, align 4
	%9 = bitcast [100 x i8]* %6 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %9, i8* align 16 getelementptr inbounds (<{[6 x i8], [94 x i8]}>, <{[6 x i8], [94 x i8]}>* @__const.main.nombre6, i32 0, i32 0, i32 0), i64 100, i1 false)
	store double 2.0, double* %3, align 8
	store double 2.0, double* %3, align 8
	%10 = getelementptr inbounds [100 x i8], [100 x i8]* %6, i64 0, i64 0
	%11 = getelementptr inbounds [100 x i8], [100 x i8]* %7, i64 0, i64 0
	%12 = call i8* @strcpy(i8* noundef %11, i8* noundef %10)
	%13 = load i32, i32* %1, align 4
	%14 = load double, double* %3, align 8
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	%15 = sitofp i32 %13 to double
	%16 = fsub double %15, %14
	%17 = load double, double* %3, align 8
	;Expresion flotante abajofloatfloathay espacios???
	%18 = fdiv double %17, 2.4
	;Expresion flotante abajofloatfloathay espacios???
	%19 = fsub double %16, %18
	%20 = load i32, i32* %1, align 4
	%21 = sdiv i32 321, %20
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	%22 = sitofp i32 %21 to double
	%23 = fmul double %22, 123.2
	;Expresion flotante abajofloatfloathay espacios???
	%24 = fdiv double %23, 3.5
	;Expresion flotante abajointfloathay espacios???
	; Llegue a type1 == int
	; Convertí a double una constante
	%25 = fmul double 123.0, %24
	;Expresion flotante abajofloatfloathay espacios???
	%26 = fdiv double %25, 1.0
	;Expresion flotante abajofloatfloathay espacios???
	%27 = fadd double %19, %26
	store double %27, double* %4, align 8
	store double %27, double* %4, align 8
	%28 = load i32, i32* %1, align 4
	store i32 %28, i32* %5, align 4
	%29 = icmp sgt i32 1, 2
	br i1 %29, label %30, label %33
30:
	%31 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.23, i64 0, i64 0))
	%32 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	br label %33
33:
	%34 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([11 x i8], [11 x i8]* @.str.26, i64 0, i64 0))
	%35 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%36 = getelementptr inbounds [100 x i8], [100 x i8]* %7, i64 0, i64 0
	%37 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.str, i64 0, i64 0), i8* noundef %36 )
	%38 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str.30, i64 0, i64 0))
	%39 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%40 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.32, i64 0, i64 0))
	%41 = load double, double* %4, align 8
	%42 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([4 x i8], [4 x i8]* @.str.double, i64 0, i64 0), double noundef %41 )
	%43 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	%44 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([38 x i8], [38 x i8]* @.str.36, i64 0, i64 0))
	%45 = load i32, i32* %5, align 4
	%46 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.int, i64 0, i64 0), i32 noundef %45 )
	%47 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	ret i32 0
}
declare i8* @strcpy(i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
