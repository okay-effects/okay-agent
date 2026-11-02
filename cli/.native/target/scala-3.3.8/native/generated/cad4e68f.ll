declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [18 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 18, i32 2, [18 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 105, i16 111, i16 46, i16 65, i16 110, i16 115, i16 105, i16 67, i16 111, i16 108, i16 111, i16 114 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 18, i32 -1350845792 }
@"_SM7__constG1-3" = private unnamed_addr constant { ptr, ptr, i32, i32, [14 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 14, i32 2, [14 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 105, i16 111, i16 46, i16 83, i16 116, i16 100, i16 73, i16 110 ] }
@"_SM7__constG1-4" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-3", i32 0, i32 14, i32 -2136090776 }
@"_SM7__constG1-5" = private unnamed_addr constant [1 x ptr] [ ptr @"_SM14scala.io.StdInG4type" ]
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, i32, i32, [15 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 15, i32 2, [15 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 105, i16 111, i16 46, i16 83, i16 116, i16 100, i16 73, i16 110, i16 36 ] }
@"_SM7__constG1-7" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-6", i32 0, i32 15, i32 -1794304580 }
@"_SM7__constG1-8" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-9" = private unnamed_addr constant [1 x { i32, ptr }] [ { i32, ptr } { i32 -2147481056, ptr null } ]
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare dereferenceable_or_null(56) ptr @"_SM14scala.Console$D2inL22java.io.BufferedReaderEO"(ptr)
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM22java.io.BufferedReaderD8readLineL16java.lang.StringEO"(ptr)

declare dereferenceable_or_null(40) ptr @"_SM14scala.Console$G4load"()

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr) noinline

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint
@"_SM18scala.io.AnsiColorG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147479072, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }
@"_SM14scala.io.StdInG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147481056, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-4" }
@"_SM15scala.io.StdIn$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 34, i32 1, ptr @"_SM7__constG1-5", ptr @"_SM7__constG1-7" }, i32 16, i32 34, ptr @"_SM7__constG1-8", i32 0, ptr @"_SM7__constG1-9", ptr @"_SM16java.lang.ObjectG4type", [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM15scala.io.StdIn$G8instance" = hidden global { ptr, ptr } { ptr @"_SM15scala.io.StdIn$G4type", ptr null }

define void @"_SM18scala.io.AnsiColorD6$init$uEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}

define dereferenceable_or_null(40) ptr @"_SM14scala.io.StdInD8readLineL16java.lang.StringEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000001 = call dereferenceable_or_null(40) ptr @"_SM14scala.Console$G4load"()
  %_2000002 = call dereferenceable_or_null(56) ptr @"_SM14scala.Console$D2inL22java.io.BufferedReaderEO"(ptr nonnull dereferenceable(40) %_2000001)
  %_2000003 = call dereferenceable_or_null(40) ptr @"_SM22java.io.BufferedReaderD8readLineL16java.lang.StringEO"(ptr dereferenceable_or_null(56) %_2000002)
  call void @"scalanative_GC_yield"()
  ret ptr %_2000003
}

define dereferenceable_or_null(40) ptr @"_SM15scala.io.StdIn$D8readLineL16java.lang.StringEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000004 = icmp ne ptr %_1, null
  br i1 %_2000004, label %_2000002.0, label %_2000003.0
_2000002.0:
  %_2000001 = call dereferenceable_or_null(40) ptr @"_SM14scala.io.StdInD8readLineL16java.lang.StringEO"(ptr dereferenceable_or_null(16) %_1)
  ret ptr %_2000001
_2000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define void @"_SM15scala.io.StdIn$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}