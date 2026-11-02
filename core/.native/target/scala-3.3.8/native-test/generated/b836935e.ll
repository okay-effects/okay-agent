declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [37 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 37, i32 2, [37 x i16] [ i16 111, i16 114, i16 103, i16 46, i16 106, i16 117, i16 110, i16 105, i16 116, i16 46, i16 114, i16 117, i16 110, i16 110, i16 101, i16 114, i16 46, i16 110, i16 111, i16 116, i16 105, i16 102, i16 105, i16 99, i16 97, i16 116, i16 105, i16 111, i16 110, i16 46, i16 70, i16 97, i16 105, i16 108, i16 117, i16 114, i16 101 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 37, i32 1903521243 }
@"_SM7__constG1-3" = private unnamed_addr constant [3 x i32] [ i32 16, i32 24, i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [0 x { i32, ptr }] [  ]
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, i32, i32, [41 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 41, i32 2, [41 x i16] [ i16 111, i16 114, i16 103, i16 46, i16 106, i16 117, i16 110, i16 105, i16 116, i16 46, i16 114, i16 117, i16 110, i16 110, i16 101, i16 114, i16 46, i16 110, i16 111, i16 116, i16 105, i16 102, i16 105, i16 99, i16 97, i16 116, i16 105, i16 111, i16 110, i16 46, i16 82, i16 117, i16 110, i16 78, i16 111, i16 116, i16 105, i16 102, i16 105, i16 101, i16 114 ] }
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-5", i32 0, i32 41, i32 1255786786 }
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr) noinline

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }
@"_SM37org.junit.runner.notification.FailureG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1900, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 32, i32 1900, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM41org.junit.runner.notification.RunNotifierG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147478752, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-6" }

define void @"_SM37org.junit.runner.notification.FailureRL28org.junit.runner.DescriptionL19java.lang.ThrowableE"(ptr %_1, ptr %_2, ptr %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_4000005 = icmp ne ptr %_1, null
  br i1 %_4000005, label %_4000003.0, label %_4000004.0
_4000003.0:
  %_4000007 = getelementptr { { ptr, ptr }, ptr, ptr }, { { ptr, ptr }, ptr, ptr }* %_1, i32 0, i32 1
  store atomic ptr %_2, ptr%_4000007 unordered, align 8
  %_4000009 = getelementptr { { ptr, ptr }, ptr, ptr }, { { ptr, ptr }, ptr, ptr }* %_1, i32 0, i32 2
  store atomic ptr %_3, ptr%_4000009 unordered, align 8
  ret void
_4000004.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}