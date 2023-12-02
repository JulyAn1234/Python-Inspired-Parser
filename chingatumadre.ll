target triple = "x86_64-pc-linux-gnu"

@.str.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str.str = private unnamed_addr constant [3 x i8] c"%s\00", align 1
	@__const.main.lenguaje2 = private unnamed_addr constant <{[4 x i8], [96 x i8]}> <{[4 x i8] c"Java", [96 x i8] zeroinitializer }>, align 16
	@__const.main.nombre1 = private unnamed_addr constant <{[3 x i8], [97 x i8]}> <{[3 x i8] c"Leo", [97 x i8] zeroinitializer }>, align 16
	@.str.5 = private unnamed_addr constant [3 x i8] c", \00", align 1
	@.str.8 = private unnamed_addr constant [12 x i8] c" vale verga\00", align 1
define dso_local noundef i32 @main() #0 {
0:
	%1 = alloca [100 x i8], align 16
	%2 = alloca [100 x i8], align 16
	%3 = bitcast [100 x i8]* %2 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %3, i8* align 16 getelementptr inbounds (<{[4 x i8], [96 x i8]}>, <{[4 x i8], [96 x i8]}>* @__const.main.lenguaje2, i32 0, i32 0, i32 0), i64 100, i1 false)
	%4 = bitcast [100 x i8]* %1 to i8*
	call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %4, i8* align 16 getelementptr inbounds (<{[3 x i8], [97 x i8]}>, <{[3 x i8], [97 x i8]}>* @__const.main.nombre1, i32 0, i32 0, i32 0), i64 100, i1 false)
	%5 = getelementptr inbounds [100 x i8], [100 x i8]* %1, i64 0, i64 0
	%6 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.str, i64 0, i64 0), i8* noundef %5 )
	%7 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.5, i64 0, i64 0))
	%8 = getelementptr inbounds [100 x i8], [100 x i8]* %2, i64 0, i64 0
	%9 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str.str, i64 0, i64 0), i8* noundef %8 )
	%10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([12 x i8], [12 x i8]* @.str.8, i64 0, i64 0))
	%11 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ([2 x i8], [2 x i8]* @.str.nl, i64 0, i64 0))
	ret i32 0
}
declare i32 @printf(i8* noundef, ...)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg)
