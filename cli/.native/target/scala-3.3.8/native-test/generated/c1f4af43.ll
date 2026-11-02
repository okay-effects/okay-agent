declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [1 x ptr] [ ptr @"_SM20java.io.SerializableG4type" ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [41 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 41, i32 2, [41 x i16] [ i16 106, i16 97, i16 118, i16 97, i16 46, i16 117, i16 116, i16 105, i16 108, i16 46, i16 99, i16 111, i16 110, i16 99, i16 117, i16 114, i16 114, i16 101, i16 110, i16 116, i16 46, i16 97, i16 116, i16 111, i16 109, i16 105, i16 99, i16 46, i16 65, i16 116, i16 111, i16 109, i16 105, i16 99, i16 73, i16 110, i16 116, i16 101, i16 103, i16 101, i16 114 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 41, i32 682798119 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [1 x { i32, ptr }] [ { i32, ptr } { i32 -2147483621, ptr null } ]
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, i32, i32, [38 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 38, i32 2, [38 x i16] [ i16 106, i16 97, i16 118, i16 97, i16 46, i16 117, i16 116, i16 105, i16 108, i16 46, i16 99, i16 111, i16 110, i16 99, i16 117, i16 114, i16 114, i16 101, i16 110, i16 116, i16 46, i16 97, i16 116, i16 111, i16 109, i16 105, i16 99, i16 46, i16 65, i16 116, i16 111, i16 109, i16 105, i16 99, i16 76, i16 111, i16 110, i16 103 ] }
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-5", i32 0, i32 38, i32 -968709069 }
@"_SM7__constG1-7" = private unnamed_addr constant { ptr, ptr, i32, i32, [43 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 43, i32 2, [43 x i16] [ i16 106, i16 97, i16 118, i16 97, i16 46, i16 117, i16 116, i16 105, i16 108, i16 46, i16 99, i16 111, i16 110, i16 99, i16 117, i16 114, i16 114, i16 101, i16 110, i16 116, i16 46, i16 97, i16 116, i16 111, i16 109, i16 105, i16 99, i16 46, i16 65, i16 116, i16 111, i16 109, i16 105, i16 99, i16 82, i16 101, i16 102, i16 101, i16 114, i16 101, i16 110, i16 99, i16 101 ] }
@"_SM7__constG1-8" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-7", i32 0, i32 43, i32 1916359668 }
@"_SM7__constG1-9" = private unnamed_addr constant [2 x i32] [ i32 16, i32 -1 ]
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM16java.lang.NumberG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [7 x ptr] }

declare dereferenceable_or_null(24) ptr @"_SM27scala.runtime.BoxesRunTime$D12boxToIntegeriL17java.lang.IntegerEO"(ptr, i32) inlinehint
@"_SM20java.io.SerializableG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }

declare dereferenceable_or_null(24) ptr @"_SM27scala.runtime.BoxesRunTime$D9boxToLongjL14java.lang.LongEO"(ptr, i64) inlinehint

declare i64 @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$D14load$extensionL28scala.scalanative.unsafe.PtrjEO"(ptr, ptr)

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint
@"_SM43scala.scalanative.libc.stdatomic$AtomicInt$G8instance" = external global { ptr, ptr }

declare i32 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D18exchange$extensionL28scala.scalanative.unsafe.PtriiEO"(ptr, ptr, i32)

declare dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr, ptr) inlinehint

declare i32 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D18fetchAdd$extensionL28scala.scalanative.unsafe.PtriiEO"(ptr, ptr, i32)

declare void @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D15store$extensionL28scala.scalanative.unsafe.PtriuEO"(ptr, ptr, i32)

declare i1 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D31compareExchangeStrong$extensionL28scala.scalanative.unsafe.PtriizEO"(ptr, ptr, i32, i32)

declare dereferenceable_or_null(40) ptr @"_SM17java.lang.IntegerD8toStringL16java.lang.StringEO"(ptr) inlinehint

declare dereferenceable_or_null(24) ptr @"_SM20scala.DummyImplicit$G4load"()

declare dereferenceable_or_null(40) ptr @"_SM14java.lang.LongD8toStringL16java.lang.StringEO"(ptr) inlinehint
@"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$G8instance" = external global { ptr, ptr }

declare i32 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D14load$extensionL28scala.scalanative.unsafe.PtriEO"(ptr, ptr)
@"_SM43scala.scalanative.libc.stdatomic$AtomicRef$G8instance" = external global { ptr, ptr }

declare i1 @"_SM43scala.scalanative.libc.stdatomic$AtomicRef$D31compareExchangeStrong$extensionL28scala.scalanative.unsafe.PtrL16java.lang.ObjectL16java.lang.ObjectL19scala.DummyImplicitzEO"(ptr, ptr, ptr, ptr, ptr)

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.StringD7valueOfL16java.lang.ObjectL16java.lang.StringEo"(ptr) inlinehint
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare i64 @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$D18exchange$extensionL28scala.scalanative.unsafe.PtrjjEO"(ptr, ptr, i64)

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr) noinline

declare i64 @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$D18fetchAdd$extensionL28scala.scalanative.unsafe.PtrjjEO"(ptr, ptr, i64)
@"_SM41java.util.concurrent.atomic.AtomicIntegerG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [7 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 203, i32 1, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 24, i32 203, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.NumberG4type", ptr null, [7 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM41java.util.concurrent.atomic.AtomicIntegerD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO", ptr @"_SM41java.util.concurrent.atomic.AtomicIntegerD11doubleValuedEO", ptr @"_SM41java.util.concurrent.atomic.AtomicIntegerD8intValueiEO", ptr @"_SM41java.util.concurrent.atomic.AtomicIntegerD9longValuejEO", ptr @"_SM41java.util.concurrent.atomic.AtomicIntegerD10floatValuefEO" ] }
@"_SM38java.util.concurrent.atomic.AtomicLongG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [7 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 185, i32 1, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-6" }, i32 24, i32 185, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.NumberG4type", ptr null, [7 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM38java.util.concurrent.atomic.AtomicLongD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO", ptr @"_SM38java.util.concurrent.atomic.AtomicLongD11doubleValuedEO", ptr @"_SM38java.util.concurrent.atomic.AtomicLongD8intValueiEO", ptr @"_SM38java.util.concurrent.atomic.AtomicLongD9longValuejEO", ptr @"_SM38java.util.concurrent.atomic.AtomicLongD10floatValuefEO" ] }
@"_SM43java.util.concurrent.atomic.AtomicReferenceG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 659, i32 1, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-8" }, i32 24, i32 662, ptr @"_SM7__constG1-9", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM43java.util.concurrent.atomic.AtomicReferenceD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }

define float @"_SM41java.util.concurrent.atomic.AtomicIntegerD10floatValuefEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000006 = icmp ne ptr %_1, null
  br i1 %_2000006, label %_2000004.0, label %_2000005.0
_2000004.0:
  %_2000001 = call i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD3getiEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = sitofp i32 %_2000001 to float
  ret float %_2000003
_2000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define double @"_SM41java.util.concurrent.atomic.AtomicIntegerD11doubleValuedEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000006 = icmp ne ptr %_1, null
  br i1 %_2000006, label %_2000004.0, label %_2000005.0
_2000004.0:
  %_2000001 = call i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD3getiEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = sitofp i32 %_2000001 to double
  ret double %_2000003
_2000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i1 @"_SM41java.util.concurrent.atomic.AtomicIntegerD13compareAndSetiizEO"(ptr %_1, i32 %_2, i32 %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_4000007 = icmp ne ptr %_1, null
  br i1 %_4000007, label %_4000005.0, label %_4000006.0
_4000005.0:
  %_4000008 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  %_4000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_4000008)
  %_4000004 = call i1 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D31compareExchangeStrong$extensionL28scala.scalanative.unsafe.PtriizEO"(ptr nonnull dereferenceable(16) @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$G8instance", ptr dereferenceable_or_null(24) %_4000003, i32 %_2, i32 %_3)
  call void @"scalanative_GC_yield"()
  ret i1 %_4000004
_4000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD15incrementAndGetiEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000004 = icmp ne ptr %_1, null
  br i1 %_2000004, label %_2000002.0, label %_2000003.0
_2000002.0:
  %_2000001 = call i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD9addAndGetiiEO"(ptr dereferenceable_or_null(24) %_1, i32 1)
  ret i32 %_2000001
_2000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD3getiEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000007 = icmp ne ptr %_1, null
  br i1 %_2000007, label %_2000005.0, label %_2000006.0
_2000005.0:
  %_2000008 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  %_2000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_2000008)
  %_2000004 = call i32 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D14load$extensionL28scala.scalanative.unsafe.PtriEO"(ptr nonnull dereferenceable(16) @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$G8instance", ptr dereferenceable_or_null(24) %_2000003)
  call void @"scalanative_GC_yield"()
  ret i32 %_2000004
_2000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define void @"_SM41java.util.concurrent.atomic.AtomicIntegerD3setiuEO"(ptr %_1, i32 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000007 = icmp ne ptr %_1, null
  br i1 %_3000007, label %_3000005.0, label %_3000006.0
_3000005.0:
  %_3000008 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  %_3000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_3000008)
  call void @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D15store$extensionL28scala.scalanative.unsafe.PtriuEO"(ptr nonnull dereferenceable(16) @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$G8instance", ptr dereferenceable_or_null(24) %_3000003, i32 %_2)
  call void @"scalanative_GC_yield"()
  ret void
_3000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD8intValueiEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000004 = icmp ne ptr %_1, null
  br i1 %_2000004, label %_2000002.0, label %_2000003.0
_2000002.0:
  %_2000001 = call i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD3getiEO"(ptr dereferenceable_or_null(24) %_1)
  ret i32 %_2000001
_2000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define dereferenceable_or_null(40) ptr @"_SM41java.util.concurrent.atomic.AtomicIntegerD8toStringL16java.lang.StringEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000007 = icmp ne ptr %_1, null
  br i1 %_2000007, label %_2000005.0, label %_2000006.0
_2000005.0:
  %_2000001 = call i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD3getiEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = call dereferenceable_or_null(24) ptr @"_SM27scala.runtime.BoxesRunTime$D12boxToIntegeriL17java.lang.IntegerEO"(ptr null, i32 %_2000001)
  %_2000004 = call dereferenceable_or_null(40) ptr @"_SM17java.lang.IntegerD8toStringL16java.lang.StringEO"(ptr nonnull dereferenceable(24) %_2000003)
  call void @"scalanative_GC_yield"()
  ret ptr %_2000004
_2000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD9addAndGetiiEO"(ptr %_1, i32 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000009 = icmp ne ptr %_1, null
  br i1 %_3000009, label %_3000007.0, label %_3000008.0
_3000007.0:
  %_3000010 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  %_3000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_3000010)
  %_3000004 = call i32 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D18fetchAdd$extensionL28scala.scalanative.unsafe.PtriiEO"(ptr nonnull dereferenceable(16) @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$G8instance", ptr dereferenceable_or_null(24) %_3000003, i32 %_2)
  %_3000006 = add i32 %_3000004, %_2
  call void @"scalanative_GC_yield"()
  ret i32 %_3000006
_3000008.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD9getAndAddiiEO"(ptr %_1, i32 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000007 = icmp ne ptr %_1, null
  br i1 %_3000007, label %_3000005.0, label %_3000006.0
_3000005.0:
  %_3000008 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  %_3000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_3000008)
  %_3000004 = call i32 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D18fetchAdd$extensionL28scala.scalanative.unsafe.PtriiEO"(ptr nonnull dereferenceable(16) @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$G8instance", ptr dereferenceable_or_null(24) %_3000003, i32 %_2)
  call void @"scalanative_GC_yield"()
  ret i32 %_3000004
_3000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD9getAndSetiiEO"(ptr %_1, i32 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000007 = icmp ne ptr %_1, null
  br i1 %_3000007, label %_3000005.0, label %_3000006.0
_3000005.0:
  %_3000008 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  %_3000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_3000008)
  %_3000004 = call i32 @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$D18exchange$extensionL28scala.scalanative.unsafe.PtriiEO"(ptr nonnull dereferenceable(16) @"_SM43scala.scalanative.libc.stdatomic$AtomicInt$G8instance", ptr dereferenceable_or_null(24) %_3000003, i32 %_2)
  call void @"scalanative_GC_yield"()
  ret i32 %_3000004
_3000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i64 @"_SM41java.util.concurrent.atomic.AtomicIntegerD9longValuejEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000006 = icmp ne ptr %_1, null
  br i1 %_2000006, label %_2000004.0, label %_2000005.0
_2000004.0:
  %_2000001 = call i32 @"_SM41java.util.concurrent.atomic.AtomicIntegerD3getiEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = sext i32 %_2000001 to i64
  ret i64 %_2000003
_2000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define void @"_SM41java.util.concurrent.atomic.AtomicIntegerRE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_3000004 = icmp ne ptr %_1, null
  br i1 %_3000004, label %_3000002.0, label %_3000003.0
_3000002.0:
  %_3000006 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  store atomic i32 0, ptr%_3000006 unordered, align 4
  ret void
_3000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define void @"_SM41java.util.concurrent.atomic.AtomicIntegerRiE"(ptr %_1, i32 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000004 = icmp ne ptr %_1, null
  br i1 %_3000004, label %_3000002.0, label %_3000003.0
_3000002.0:
  %_3000006 = getelementptr { { ptr, ptr }, i32 }, { { ptr, ptr }, i32 }* %_1, i32 0, i32 1
  store atomic i32 %_2, ptr%_3000006 unordered, align 4
  ret void
_3000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define float @"_SM38java.util.concurrent.atomic.AtomicLongD10floatValuefEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000006 = icmp ne ptr %_1, null
  br i1 %_2000006, label %_2000004.0, label %_2000005.0
_2000004.0:
  %_2000001 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = sitofp i64 %_2000001 to float
  ret float %_2000003
_2000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define double @"_SM38java.util.concurrent.atomic.AtomicLongD11doubleValuedEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000006 = icmp ne ptr %_1, null
  br i1 %_2000006, label %_2000004.0, label %_2000005.0
_2000004.0:
  %_2000001 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = sitofp i64 %_2000001 to double
  ret double %_2000003
_2000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i64 @"_SM38java.util.concurrent.atomic.AtomicLongD15getAndIncrementjEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000004 = icmp ne ptr %_1, null
  br i1 %_2000004, label %_2000002.0, label %_2000003.0
_2000002.0:
  %_2000001 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD9getAndAddjjEO"(ptr dereferenceable_or_null(24) %_1, i64 1)
  ret i64 %_2000001
_2000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000007 = icmp ne ptr %_1, null
  br i1 %_2000007, label %_2000005.0, label %_2000006.0
_2000005.0:
  %_2000008 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_1, i32 0, i32 1
  %_2000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_2000008)
  %_2000004 = call i64 @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$D14load$extensionL28scala.scalanative.unsafe.PtrjEO"(ptr nonnull dereferenceable(16) @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$G8instance", ptr dereferenceable_or_null(24) %_2000003)
  call void @"scalanative_GC_yield"()
  ret i64 %_2000004
_2000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i32 @"_SM38java.util.concurrent.atomic.AtomicLongD8intValueiEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000006 = icmp ne ptr %_1, null
  br i1 %_2000006, label %_2000004.0, label %_2000005.0
_2000004.0:
  %_2000001 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = trunc i64 %_2000001 to i32
  ret i32 %_2000003
_2000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define dereferenceable_or_null(40) ptr @"_SM38java.util.concurrent.atomic.AtomicLongD8toStringL16java.lang.StringEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000007 = icmp ne ptr %_1, null
  br i1 %_2000007, label %_2000005.0, label %_2000006.0
_2000005.0:
  %_2000001 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000003 = call dereferenceable_or_null(24) ptr @"_SM27scala.runtime.BoxesRunTime$D9boxToLongjL14java.lang.LongEO"(ptr null, i64 %_2000001)
  %_2000004 = call dereferenceable_or_null(40) ptr @"_SM14java.lang.LongD8toStringL16java.lang.StringEO"(ptr nonnull dereferenceable(24) %_2000003)
  call void @"scalanative_GC_yield"()
  ret ptr %_2000004
_2000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i64 @"_SM38java.util.concurrent.atomic.AtomicLongD9getAndAddjjEO"(ptr %_1, i64 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000007 = icmp ne ptr %_1, null
  br i1 %_3000007, label %_3000005.0, label %_3000006.0
_3000005.0:
  %_3000008 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_1, i32 0, i32 1
  %_3000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_3000008)
  %_3000004 = call i64 @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$D18fetchAdd$extensionL28scala.scalanative.unsafe.PtrjjEO"(ptr nonnull dereferenceable(16) @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$G8instance", ptr dereferenceable_or_null(24) %_3000003, i64 %_2)
  call void @"scalanative_GC_yield"()
  ret i64 %_3000004
_3000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i64 @"_SM38java.util.concurrent.atomic.AtomicLongD9getAndSetjjEO"(ptr %_1, i64 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000007 = icmp ne ptr %_1, null
  br i1 %_3000007, label %_3000005.0, label %_3000006.0
_3000005.0:
  %_3000008 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_1, i32 0, i32 1
  %_3000003 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_3000008)
  %_3000004 = call i64 @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$D18exchange$extensionL28scala.scalanative.unsafe.PtrjjEO"(ptr nonnull dereferenceable(16) @"_SM48scala.scalanative.libc.stdatomic$AtomicLongLong$G8instance", ptr dereferenceable_or_null(24) %_3000003, i64 %_2)
  call void @"scalanative_GC_yield"()
  ret i64 %_3000004
_3000006.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i64 @"_SM38java.util.concurrent.atomic.AtomicLongD9longValuejEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000004 = icmp ne ptr %_1, null
  br i1 %_2000004, label %_2000002.0, label %_2000003.0
_2000002.0:
  %_2000001 = call i64 @"_SM38java.util.concurrent.atomic.AtomicLongD3getjEO"(ptr dereferenceable_or_null(24) %_1)
  ret i64 %_2000001
_2000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define void @"_SM38java.util.concurrent.atomic.AtomicLongRjE"(ptr %_1, i64 %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000004 = icmp ne ptr %_1, null
  br i1 %_3000004, label %_3000002.0, label %_3000003.0
_3000002.0:
  %_3000006 = getelementptr { { ptr, ptr }, i64 }, { { ptr, ptr }, i64 }* %_1, i32 0, i32 1
  store atomic i64 %_2, ptr%_3000006 unordered, align 8
  ret void
_3000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i1 @"_SM43java.util.concurrent.atomic.AtomicReferenceD13compareAndSetL16java.lang.ObjectL16java.lang.ObjectzEO"(ptr %_1, ptr %_2, ptr %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_6000004 = icmp ne ptr %_1, null
  br i1 %_6000004, label %_6000002.0, label %_6000003.0
_6000002.0:
  %_4000002 = call dereferenceable_or_null(24) ptr @"_SM20scala.DummyImplicit$G4load"()
  %_6000005 = getelementptr { { ptr, ptr }, ptr }, { { ptr, ptr }, ptr }* %_4000002, i32 0, i32 1
  %_6000001 = load atomic ptr, ptr %_6000005 unordered, align 8
  %_6000006 = getelementptr { { ptr, ptr }, ptr }, { { ptr, ptr }, ptr }* %_1, i32 0, i32 1
  %_4000004 = call dereferenceable_or_null(24) ptr @"_SM32scala.scalanative.runtime.Boxes$D8boxToPtrR_L28scala.scalanative.unsafe.PtrEO"(ptr null, ptr %_6000006)
  %_4000005 = call i1 @"_SM43scala.scalanative.libc.stdatomic$AtomicRef$D31compareExchangeStrong$extensionL28scala.scalanative.unsafe.PtrL16java.lang.ObjectL16java.lang.ObjectL19scala.DummyImplicitzEO"(ptr nonnull dereferenceable(16) @"_SM43scala.scalanative.libc.stdatomic$AtomicRef$G8instance", ptr dereferenceable_or_null(24) %_4000004, ptr dereferenceable_or_null(16) %_2, ptr dereferenceable_or_null(16) %_3, ptr dereferenceable_or_null(16) %_6000001)
  call void @"scalanative_GC_yield"()
  ret i1 %_4000005
_6000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define dereferenceable_or_null(16) ptr @"_SM43java.util.concurrent.atomic.AtomicReferenceD3getL16java.lang.ObjectEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_3000004 = icmp ne ptr %_1, null
  br i1 %_3000004, label %_3000002.0, label %_3000003.0
_3000002.0:
  %_3000005 = getelementptr { { ptr, ptr }, ptr }, { { ptr, ptr }, ptr }* %_1, i32 0, i32 1
  %_3000001 = load atomic ptr, ptr %_3000005 seq_cst, align 8
  ret ptr %_3000001
_3000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define dereferenceable_or_null(40) ptr @"_SM43java.util.concurrent.atomic.AtomicReferenceD8toStringL16java.lang.StringEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000005 = icmp ne ptr %_1, null
  br i1 %_2000005, label %_2000003.0, label %_2000004.0
_2000003.0:
  %_2000001 = call dereferenceable_or_null(16) ptr @"_SM43java.util.concurrent.atomic.AtomicReferenceD3getL16java.lang.ObjectEO"(ptr dereferenceable_or_null(24) %_1)
  %_2000002 = call dereferenceable_or_null(40) ptr @"_SM16java.lang.StringD7valueOfL16java.lang.ObjectL16java.lang.StringEo"(ptr dereferenceable_or_null(16) %_2000001)
  ret ptr %_2000002
_2000004.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}