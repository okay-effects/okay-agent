declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [48 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 48, i32 2, [48 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 106, i16 97, i16 118, i16 97, i16 108, i16 105, i16 98, i16 46, i16 105, i16 111, i16 46, i16 65, i16 116, i16 111, i16 109, i16 105, i16 99, i16 79, i16 98, i16 106, i16 101, i16 99, i16 116, i16 72, i16 97, i16 110, i16 100, i16 108, i16 101, i16 36 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 48, i32 -1041997970 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [0 x { i32, ptr }] [  ]
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, i32, i32, [42 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 42, i32 2, [42 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 115, i16 99, i16 97, i16 108, i16 97, i16 110, i16 97, i16 116, i16 105, i16 118, i16 101, i16 46, i16 106, i16 97, i16 118, i16 97, i16 108, i16 105, i16 98, i16 46, i16 105, i16 111, i16 46, i16 79, i16 98, i16 106, i16 101, i16 99, i16 116, i16 72, i16 97, i16 110, i16 100, i16 108, i16 101, i16 36 ] }
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-5", i32 0, i32 42, i32 248999129 }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"__modules" = external global [644 x ptr]
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }

declare i64 @"_SM38java.util.concurrent.atomic.AtomicLongD9getAndSetjjEO"(ptr, i64)
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint

declare ptr @"__scalanative_loadModule"(ptr, ptr, i64, ptr)
@"_SM38java.util.concurrent.atomic.AtomicLongG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [7 x ptr] }

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr) noinline

declare i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr)

declare ptr @"scalanative_GC_alloc_small"(ptr, i64)

declare i32 @"close"(i32)
@"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 796, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 16, i32 796, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$G8instance" = hidden global { ptr, ptr } { ptr @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$G4type", ptr null }
@"_SM42scala.scalanative.javalib.io.ObjectHandle$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 50, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-6" }, i32 24, i32 50, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }

define i64 @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$D13get$extensionL38java.util.concurrent.atomic.AtomicLongjEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000001 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr dereferenceable_or_null(24) %_2)
  ret i64 %_3000001
}

define void @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$D15close$extensionL38java.util.concurrent.atomic.AtomicLonguEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000006 = icmp ne ptr %_1, null
  br i1 %_3000006, label %_3000004.0, label %_3000005.0
_3000004.0:
  %_3000001 = call dereferenceable_or_null(24) ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$G4load"()
  %_3000002 = call i64 @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$D17release$extensionL38java.util.concurrent.atomic.AtomicLongjEO"(ptr dereferenceable_or_null(16) %_1, ptr dereferenceable_or_null(24) %_2)
  call void @"_SM42scala.scalanative.javalib.io.ObjectHandle$D15close$extensionjuEO"(ptr nonnull dereferenceable(24) %_3000001, i64 %_3000002)
  call void @"scalanative_GC_yield"()
  ret void
_3000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i64 @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$D17release$extensionL38java.util.concurrent.atomic.AtomicLongjEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000001 = call dereferenceable_or_null(24) ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$G4load"()
  %_4000002 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_3000001, i32 0, i32 1
  %_4000001 = load atomic i64, ptr %_4000002 unordered, align 8
  %_3000002 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD9getAndSetjjEO"(ptr dereferenceable_or_null(24) %_2, i64 %_4000001)
  call void @"scalanative_GC_yield"()
  ret i64 %_3000002
}

define dereferenceable_or_null(24) ptr @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$D5applyiL38java.util.concurrent.atomic.AtomicLongEO"(ptr %_1, i32 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000006 = icmp ne ptr %_1, null
  br i1 %_3000006, label %_3000004.0, label %_3000005.0
_3000004.0:
  %_3000001 = call dereferenceable_or_null(24) ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$G4load"()
  %_3000002 = call i64 @"_SM42scala.scalanative.javalib.io.ObjectHandle$D5applyijEO"(ptr nonnull dereferenceable(24) %_3000001, i32 %_2)
  %_3000003 = call dereferenceable_or_null(24) ptr @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$D5applyjL38java.util.concurrent.atomic.AtomicLongEO"(ptr dereferenceable_or_null(16) %_1, i64 %_3000002)
  call void @"scalanative_GC_yield"()
  ret ptr %_3000003
_3000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define nonnull dereferenceable(24) ptr @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$D5applyjL38java.util.concurrent.atomic.AtomicLongEO"(ptr %_1, i64 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000002 = call dereferenceable_or_null(24) ptr @"scalanative_GC_alloc_small"(ptr @"_SM38java.util.concurrent.atomic.AtomicLongG4type", i64 24)
  %_3000005 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_3000002, i32 0, i32 1
  store atomic i64 %_2, ptr%_3000005 unordered, align 8
  ret ptr %_3000002
}

define void @"_SM48scala.scalanative.javalib.io.AtomicObjectHandle$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}

define i32 @"_SM42scala.scalanative.javalib.io.ObjectHandle$D15asInt$extensionjiEO"(ptr %_1, i64 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000002 = trunc i64 %_2 to i32
  ret i32 %_3000002
}

define void @"_SM42scala.scalanative.javalib.io.ObjectHandle$D15close$extensionjuEO"(ptr %_1, i64 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_8000003 = icmp ne ptr %_1, null
  br i1 %_8000003, label %_8000001.0, label %_8000002.0
_8000001.0:
  %_3000001 = call i1 @"_SM42scala.scalanative.javalib.io.ObjectHandle$D15valid$extensionjzEO"(ptr dereferenceable_or_null(24) %_1, i64 %_2)
  br i1 %_3000001, label %_4000000.0, label %_5000000.0
_4000000.0:
  br label %_6000000.0
_6000000.0:
  %_6000002 = call i32 @"_SM42scala.scalanative.javalib.io.ObjectHandle$D15asInt$extensionjiEO"(ptr dereferenceable_or_null(24) %_1, i64 %_2)
  %_6000003 = call i32 @"close"(i32 %_6000002)
  br label %_7000000.0
_7000000.0:
  br label %_8000000.0
_5000000.0:
  br label %_8000000.0
_8000000.0:
  call void @"scalanative_GC_yield"()
  ret void
_8000002.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i1 @"_SM42scala.scalanative.javalib.io.ObjectHandle$D15valid$extensionjzEO"(ptr %_1, i64 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000001 = call dereferenceable_or_null(24) ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$G4load"()
  %_4000002 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_3000001, i32 0, i32 1
  %_4000001 = load atomic i64, ptr %_4000002 unordered, align 8
  %_3000003 = icmp ne i64 %_2, %_4000001
  call void @"scalanative_GC_yield"()
  ret i1 %_3000003
}

define i64 @"_SM42scala.scalanative.javalib.io.ObjectHandle$D5applyijEO"(ptr %_1, i32 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000002 = sext i32 %_2 to i64
  ret i64 %_3000002
}

define dereferenceable_or_null(24) ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$G4load"() personality ptr @scalanative_personality {
_1.0:
  %_4 = getelementptr ptr, ptr @"__modules", i32 6
  %_5 = call ptr @"__scalanative_loadModule"(ptr %_4, ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$G4type", i64 24, ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$RE")
  ret ptr %_5
}

define void @"_SM42scala.scalanative.javalib.io.ObjectHandle$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000001 = call dereferenceable_or_null(24) ptr @"_SM42scala.scalanative.javalib.io.ObjectHandle$G4load"()
  br label %_4000000.0
_4000000.0:
  %_4000001 = call i64 @"_SM42scala.scalanative.javalib.io.ObjectHandle$D5applyijEO"(ptr nonnull dereferenceable(24) %_2000001, i32 -1)
  br label %_5000000.0
_5000000.0:
  %_5000003 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_2000001, i32 0, i32 1
  store atomic i64 %_4000001, ptr%_5000003 unordered, align 8
  call void @"scalanative_GC_yield"()
  ret void
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}