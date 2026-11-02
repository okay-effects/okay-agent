declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [43 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 43, i32 2, [43 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 106, i16 97, i16 118, i16 97, i16 108, i16 105, i16 98, i16 105, i16 110, i16 116, i16 102, i16 46, i16 80, i16 111, i16 105, i16 110, i16 116, i16 101, i16 114, i16 66, i16 117, i16 102, i16 102, i16 101, i16 114 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 43, i32 -790081712 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [0 x { i32, ptr }] [  ]
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, i32, i32, [44 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 44, i32 2, [44 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 106, i16 97, i16 118, i16 97, i16 108, i16 105, i16 98, i16 105, i16 110, i16 116, i16 102, i16 46, i16 80, i16 111, i16 105, i16 110, i16 116, i16 101, i16 114, i16 66, i16 117, i16 102, i16 102, i16 101, i16 114, i16 36 ] }
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-5", i32 0, i32 44, i32 1277270740 }
@"_SM7__constG1-7" = private unnamed_addr constant { ptr, ptr, i32, i32, [36 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 36, i32 2, [36 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 106, i16 97, i16 118, i16 97, i16 108, i16 105, i16 98, i16 105, i16 110, i16 116, i16 102, i16 46, i16 83, i16 116, i16 114, i16 105, i16 110, i16 103 ] }
@"_SM7__constG1-8" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-7", i32 0, i32 36, i32 -128059138 }
@"_SM7__constG1-9" = private unnamed_addr constant { ptr, ptr, i32, i32, [37 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 37, i32 2, [37 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 106, i16 97, i16 118, i16 97, i16 108, i16 105, i16 98, i16 105, i16 110, i16 116, i16 102, i16 46, i16 83, i16 116, i16 114, i16 105, i16 110, i16 103, i16 36 ] }
@"_SM7__constG2-10" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-9", i32 0, i32 37, i32 325134054 }

declare ptr @"_SM34scala.scalanative.runtime.package$D14throwClassCastR_R_nEO"(ptr, ptr, ptr) noinline
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM28scala.scalanative.unsafe.PtrG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM20java.nio.ByteBuffer$G8instance" = external global { ptr, ptr }

declare dereferenceable_or_null(56) ptr @"_SM24java.nio.charset.CharsetD6decodeL19java.nio.ByteBufferL19java.nio.CharBufferEO"(ptr, ptr)

declare dereferenceable_or_null(64) ptr @"_SM20java.nio.ByteBuffer$D15wrapPointerByteL28scala.scalanative.unsafe.PtriL19java.nio.ByteBufferEO"(ptr, ptr, i32)

declare i32 @"_SM19java.nio.CharBufferD6lengthiEO"(ptr)
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare void @"scalanative_GC_yield"()

declare dereferenceable_or_null(24) ptr @"_SM19java.nio.CharBufferD5arrayLAc_EO"(ptr) inlinehint

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint

declare ptr @"scalanative_GC_alloc_small"(ptr, i64)
@"_SM43scala.scalanative.javalibintf.PointerBufferG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 2204, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 16, i32 2204, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM44scala.scalanative.javalibintf.PointerBuffer$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1974, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-6" }, i32 16, i32 1974, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM44scala.scalanative.javalibintf.PointerBuffer$G8instance" = hidden global { ptr, ptr } { ptr @"_SM44scala.scalanative.javalibintf.PointerBuffer$G4type", ptr null }
@"_SM36scala.scalanative.javalibintf.StringG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 689, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-8" }, i32 16, i32 689, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM37scala.scalanative.javalibintf.String$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1698, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG2-10" }, i32 16, i32 1698, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM37scala.scalanative.javalibintf.String$G8instance" = hidden global { ptr, ptr } { ptr @"_SM37scala.scalanative.javalibintf.String$G4type", ptr null }

define dereferenceable_or_null(64) ptr @"_SM43scala.scalanative.javalibintf.PointerBufferD15wrapPointerByteL16java.lang.ObjectiL19java.nio.ByteBufferEo"(ptr %_1, i32 %_2) inlinehint personality ptr @scalanative_personality {
_3000000.0:
  %_3000002 = call dereferenceable_or_null(64) ptr @"_SM44scala.scalanative.javalibintf.PointerBuffer$D15wrapPointerByteL16java.lang.ObjectiL19java.nio.ByteBufferEO"(ptr nonnull dereferenceable(16) @"_SM44scala.scalanative.javalibintf.PointerBuffer$G8instance", ptr dereferenceable_or_null(16) %_1, i32 %_2)
  ret ptr %_3000002
}

define dereferenceable_or_null(64) ptr @"_SM44scala.scalanative.javalibintf.PointerBuffer$D15wrapPointerByteL16java.lang.ObjectiL19java.nio.ByteBufferEO"(ptr %_1, ptr %_2, i32 %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_4000007 = icmp eq ptr %_2, null
  br i1 %_4000007, label %_4000005.0, label %_4000004.0
_4000004.0:
  %_4000008 = load ptr, ptr %_2
  %_4000009 = icmp eq ptr %_4000008, @"_SM28scala.scalanative.unsafe.PtrG4type"
  br i1 %_4000009, label %_4000005.0, label %_4000006.0
_4000005.0:
  %_4000003 = call dereferenceable_or_null(64) ptr @"_SM20java.nio.ByteBuffer$D15wrapPointerByteL28scala.scalanative.unsafe.PtriL19java.nio.ByteBufferEO"(ptr nonnull dereferenceable(16) @"_SM20java.nio.ByteBuffer$G8instance", ptr dereferenceable_or_null(24) %_2, i32 %_3)
  call void @"scalanative_GC_yield"()
  ret ptr %_4000003
_4000006.0:
  %_4000011 = phi ptr [%_2, %_4000004.0]
  %_4000012 = phi ptr [@"_SM28scala.scalanative.unsafe.PtrG4type", %_4000004.0]
  %_4000013 = load ptr, ptr %_4000011
  call ptr @"_SM34scala.scalanative.runtime.package$D14throwClassCastR_R_nEO"(ptr null, ptr %_4000013, ptr %_4000012)
  unreachable
}

define void @"_SM44scala.scalanative.javalibintf.PointerBuffer$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}

define dereferenceable_or_null(40) ptr @"_SM36scala.scalanative.javalibintf.StringD14fromByteBufferL19java.nio.ByteBufferL24java.nio.charset.CharsetL16java.lang.StringEo"(ptr %_1, ptr %_2) inlinehint personality ptr @scalanative_personality {
_3000000.0:
  %_3000002 = call dereferenceable_or_null(40) ptr @"_SM37scala.scalanative.javalibintf.String$D14fromByteBufferL19java.nio.ByteBufferL24java.nio.charset.CharsetL16java.lang.StringEO"(ptr nonnull dereferenceable(16) @"_SM37scala.scalanative.javalibintf.String$G8instance", ptr dereferenceable_or_null(64) %_1, ptr dereferenceable_or_null(56) %_2)
  ret ptr %_3000002
}

define nonnull dereferenceable(40) ptr @"_SM37scala.scalanative.javalibintf.String$D14fromByteBufferL19java.nio.ByteBufferL24java.nio.charset.CharsetL16java.lang.StringEO"(ptr %_1, ptr %_2, ptr %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_5000001 = call dereferenceable_or_null(56) ptr @"_SM24java.nio.charset.CharsetD6decodeL19java.nio.ByteBufferL19java.nio.CharBufferEO"(ptr dereferenceable_or_null(56) %_3, ptr dereferenceable_or_null(64) %_2)
  %_5000002 = call dereferenceable_or_null(24) ptr @"_SM19java.nio.CharBufferD5arrayLAc_EO"(ptr dereferenceable_or_null(56) %_5000001)
  %_5000003 = call i32 @"_SM19java.nio.CharBufferD6lengthiEO"(ptr dereferenceable_or_null(56) %_5000001)
  %_4000002 = call dereferenceable_or_null(40) ptr @"scalanative_GC_alloc_small"(ptr @"_SM16java.lang.StringG4type", i64 40)
  %_5000005 = getelementptr { { ptr, ptr }, ptr, i32, i32, i32 }, { { ptr, ptr }, ptr, i32, i32, i32 }* %_4000002, i32 0, i32 1
  store atomic ptr %_5000002, ptr%_5000005 unordered, align 8
  %_5000007 = getelementptr { { ptr, ptr }, ptr, i32, i32, i32 }, { { ptr, ptr }, ptr, i32, i32, i32 }* %_4000002, i32 0, i32 3
  store atomic i32 %_5000003, ptr%_5000007 unordered, align 4
  call void @"scalanative_GC_yield"()
  ret ptr %_4000002
}

define void @"_SM37scala.scalanative.javalibintf.String$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}