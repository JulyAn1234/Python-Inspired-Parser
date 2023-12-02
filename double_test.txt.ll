target triple = "x86_64-pc-linux-gnu"

@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.int = private unnamed_addr constant [3 x i8] c"%d\00", align 1
	@.str.4 = private unnamed_addr constant [29 x i8] c"La suma de los números es: \00", align 1
define dso_local noundef i32 @main() #0 {
0:
	%1 = alloca i32, align 4
	%2 = alloca i32, align 4
	%3 = alloca i32, align 4
	store i32 8, i32* %1, align 4
	store i32 2, i32* %2, align 4
	%4 = load i32, i32* %1, align 4
	%5 = load i32, i32* %2, align 4
	%6 = add nsw i32 %4, %5
	store i32 %6, i32* %3, align 4
	%7 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([29 x i8], [29 x i8]* @.str.4, i64 0, i64 0))
	%8 = load i32, i32* %3, align 4
	%9 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.int, i64 0, i64 0), i32 noundef %8 )
	%10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	ret i32 0
}
declare i32 @printf(i8* noundef, ...)
