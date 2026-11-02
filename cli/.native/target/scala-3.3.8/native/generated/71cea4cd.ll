declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [21 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 21, i32 2, [21 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 100, i16 101, i16 114, i16 105, i16 118, i16 105, i16 110, i16 103, i16 46, i16 77, i16 105, i16 114, i16 114, i16 111, i16 114 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 21, i32 598796865 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x ptr] [ ptr @"_SM21scala.deriving.MirrorG4type" ]
@"_SM7__constG1-4" = private unnamed_addr constant { ptr, ptr, i32, i32, [29 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 29, i32 2, [29 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 100, i16 101, i16 114, i16 105, i16 118, i16 105, i16 110, i16 103, i16 46, i16 77, i16 105, i16 114, i16 114, i16 111, i16 114, i16 36, i16 80, i16 114, i16 111, i16 100, i16 117, i16 99, i16 116 ] }
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-4", i32 0, i32 29, i32 -1829253780 }
@"_SM7__constG1-6" = private unnamed_addr constant [2 x ptr] [ ptr @"_SM21scala.deriving.MirrorG4type", ptr @"_SM29scala.deriving.Mirror$ProductG4type" ]
@"_SM7__constG1-7" = private unnamed_addr constant { ptr, ptr, i32, i32, [31 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 31, i32 2, [31 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 100, i16 101, i16 114, i16 105, i16 118, i16 105, i16 110, i16 103, i16 46, i16 77, i16 105, i16 114, i16 114, i16 111, i16 114, i16 36, i16 83, i16 105, i16 110, i16 103, i16 108, i16 101, i16 116, i16 111, i16 110 ] }
@"_SM7__constG1-8" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-7", i32 0, i32 31, i32 -1713943224 }
@"_SM7__constG1-9" = private unnamed_addr constant { ptr, ptr, i32, i32, [25 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 25, i32 2, [25 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 100, i16 101, i16 114, i16 105, i16 118, i16 105, i16 110, i16 103, i16 46, i16 77, i16 105, i16 114, i16 114, i16 111, i16 114, i16 36, i16 83, i16 117, i16 109 ] }
@"_SM7__constG2-10" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-9", i32 0, i32 25, i32 -1328446136 }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }
@"_SM21scala.deriving.MirrorG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147483485, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }
@"_SM29scala.deriving.Mirror$ProductG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147483390, i32 1, ptr @"_SM7__constG1-3", ptr @"_SM7__constG1-5" }
@"_SM31scala.deriving.Mirror$SingletonG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147483484, i32 2, ptr @"_SM7__constG1-6", ptr @"_SM7__constG1-8" }
@"_SM25scala.deriving.Mirror$SumG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147483071, i32 1, ptr @"_SM7__constG1-3", ptr @"_SM7__constG2-10" }
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}