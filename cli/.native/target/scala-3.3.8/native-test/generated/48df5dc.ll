declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [39 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 39, i32 2, [39 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 109, i16 101, i16 109, i16 111, i16 114, i16 121, i16 46, i16 80, i16 111, i16 105, i16 110, i16 116, i16 101, i16 114, i16 66, i16 117, i16 102, i16 102, i16 101, i16 114, i16 36 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 39, i32 -1981236581 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [0 x { i32, ptr }] [  ]
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, i32, i32, [33 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 33, i32 2, [33 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 109, i16 101, i16 109, i16 111, i16 114, i16 121, i16 46, i16 83, i16 97, i16 102, i16 101, i16 90, i16 111, i16 110, i16 101 ] }
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-5", i32 0, i32 33, i32 1096948621 }
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare dereferenceable_or_null(64) ptr @"_SM43scala.scalanative.javalibintf.PointerBufferD15wrapPointerByteL16java.lang.ObjectiL19java.nio.ByteBufferEo"(ptr, i32) inlinehint

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }
@"_SM39scala.scalanative.memory.PointerBuffer$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 33, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 16, i32 33, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM39scala.scalanative.memory.PointerBuffer$G8instance" = hidden global { ptr, ptr } { ptr @"_SM39scala.scalanative.memory.PointerBuffer$G4type", ptr null }
@"_SM33scala.scalanative.memory.SafeZoneG4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147482240, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-6" }

define dereferenceable_or_null(64) ptr @"_SM39scala.scalanative.memory.PointerBuffer$D4wrapL28scala.scalanative.unsafe.PtriL19java.nio.ByteBufferEO"(ptr %_1, ptr %_2, i32 %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_4000001 = call dereferenceable_or_null(64) ptr @"_SM43scala.scalanative.javalibintf.PointerBufferD15wrapPointerByteL16java.lang.ObjectiL19java.nio.ByteBufferEo"(ptr dereferenceable_or_null(24) %_2, i32 %_3)
  ret ptr %_4000001
}

define void @"_SM39scala.scalanative.memory.PointerBuffer$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}