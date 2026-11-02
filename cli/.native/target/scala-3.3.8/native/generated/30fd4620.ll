declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [33 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 33, i32 2, [33 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 99, i16 111, i16 110, i16 99, i16 117, i16 114, i16 114, i16 101, i16 110, i16 116, i16 46, i16 69, i16 120, i16 101, i16 99, i16 117, i16 116, i16 105, i16 111, i16 110, i16 67, i16 111, i16 110, i16 116, i16 101, i16 120, i16 116 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 33, i32 1192064582 }
@"_SM7__constG1-3" = private unnamed_addr constant [2 x ptr] [ ptr @"_SM29java.util.concurrent.ExecutorG4type", ptr @"_SM33scala.concurrent.ExecutionContextG4type" ]
@"_SM7__constG1-4" = private unnamed_addr constant { ptr, ptr, i32, i32, [41 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 41, i32 2, [41 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 99, i16 111, i16 110, i16 99, i16 117, i16 114, i16 114, i16 101, i16 110, i16 116, i16 46, i16 69, i16 120, i16 101, i16 99, i16 117, i16 116, i16 105, i16 111, i16 110, i16 67, i16 111, i16 110, i16 116, i16 101, i16 120, i16 116, i16 69, i16 120, i16 101, i16 99, i16 117, i16 116, i16 111, i16 114 ] }
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-4", i32 0, i32 41, i32 2106469689 }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM29java.util.concurrent.ExecutorG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }
@"_SM33scala.concurrent.ExecutionContextG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147483167, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }
@"_SM41scala.concurrent.ExecutionContextExecutorG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147483452, i32 2, ptr @"_SM7__constG1-3", ptr @"_SM7__constG1-5" }

define void @"_SM33scala.concurrent.ExecutionContextD6$init$uEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}