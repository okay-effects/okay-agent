declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [1 x ptr] [ ptr @"_SM20java.io.SerializableG4type" ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [37 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 37, i32 2, [37 x i16] [ i16 111, i16 114, i16 103, i16 46, i16 106, i16 117, i16 110, i16 105, i16 116, i16 46, i16 65, i16 115, i16 115, i16 117, i16 109, i16 112, i16 116, i16 105, i16 111, i16 110, i16 86, i16 105, i16 111, i16 108, i16 97, i16 116, i16 101, i16 100, i16 69, i16 120, i16 99, i16 101, i16 112, i16 116, i16 105, i16 111, i16 110 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 37, i32 -1313184296 }
@"_SM7__constG1-3" = private unnamed_addr constant [8 x i32] [ i32 16, i32 24, i32 32, i32 40, i32 56, i32 64, i32 72, i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [1 x { i32, ptr }] [ { i32, ptr } { i32 -2147483621, ptr null } ]
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, i32, i32, [27 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 27, i32 2, [27 x i16] [ i16 111, i16 114, i16 103, i16 46, i16 106, i16 117, i16 110, i16 105, i16 116, i16 46, i16 67, i16 111, i16 109, i16 112, i16 97, i16 114, i16 105, i16 115, i16 111, i16 110, i16 70, i16 97, i16 105, i16 108, i16 117, i16 114, i16 101 ] }
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-5", i32 0, i32 27, i32 -278382825 }
@"_SM7__constG1-7" = private unnamed_addr constant [11 x i32] [ i32 16, i32 24, i32 32, i32 40, i32 56, i32 64, i32 72, i32 88, i32 96, i32 104, i32 -1 ]

declare dereferenceable_or_null(88) ptr @"_SM19java.lang.ThrowableD16fillInStackTraceL19java.lang.ThrowableEO"(ptr)
@"_SM24java.lang.AssertionErrorG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [6 x ptr] }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM20java.io.SerializableG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM26java.lang.RuntimeExceptionG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [6 x ptr] }

declare dereferenceable_or_null(88) ptr @"_SM19java.lang.ThrowableD8getCauseL19java.lang.ThrowableEO"(ptr)

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM19java.lang.ThrowableD10getMessageL16java.lang.StringEO"(ptr)
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }

declare dereferenceable_or_null(40) ptr @"_SM19java.lang.ThrowableD8toStringL16java.lang.StringEO"(ptr)
@"_SM37org.junit.AssumptionViolatedExceptionG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [6 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 271, i32 1, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 88, i32 271, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM26java.lang.RuntimeExceptionG4type", ptr null, [6 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM19java.lang.ThrowableD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO", ptr @"_SM19java.lang.ThrowableD16fillInStackTraceL19java.lang.ThrowableEO", ptr @"_SM19java.lang.ThrowableD8getCauseL19java.lang.ThrowableEO", ptr @"_SM19java.lang.ThrowableD10getMessageL16java.lang.StringEO" ] }
@"_SM27org.junit.ComparisonFailureG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [6 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 301, i32 1, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-6" }, i32 112, i32 302, ptr @"_SM7__constG1-7", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM24java.lang.AssertionErrorG4type", ptr null, [6 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM19java.lang.ThrowableD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO", ptr @"_SM19java.lang.ThrowableD16fillInStackTraceL19java.lang.ThrowableEO", ptr @"_SM19java.lang.ThrowableD8getCauseL19java.lang.ThrowableEO", ptr @"_SM19java.lang.ThrowableD10getMessageL16java.lang.StringEO" ] }
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}