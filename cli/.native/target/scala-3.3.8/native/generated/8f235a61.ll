declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [1 x ptr] [ ptr @"_SM20java.io.SerializableG4type" ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [25 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 25, i32 2, [25 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 117, i16 116, i16 105, i16 108, i16 46, i16 109, i16 97, i16 116, i16 99, i16 104, i16 105, i16 110, i16 103, i16 46, i16 82, i16 101, i16 103, i16 101, i16 120 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 25, i32 1990785466 }
@"_SM7__constG1-3" = private unnamed_addr constant [3 x i32] [ i32 16, i32 24, i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [1 x { i32, ptr }] [ { i32, ptr } { i32 -2147483621, ptr null } ]
@"_SM11scala.None$G8instance" = external global { ptr, ptr }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare i1 @"_SM23java.util.regex.MatcherD4findzEO"(ptr)
@"_SM10scala.SomeG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [4 x ptr] }
@"_SM20java.io.SerializableG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }

declare i1 @"_SM23java.util.regex.MatcherD7matcheszEO"(ptr)
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM23java.util.regex.PatternD7patternL16java.lang.StringEO"(ptr)

declare nonnull dereferenceable(48) ptr @"_SM23java.util.regex.PatternD7matcherL22java.lang.CharSequenceL23java.util.regex.MatcherEO"(ptr, ptr)

declare dereferenceable_or_null(40) ptr @"_SM23java.util.regex.MatcherD5groupL16java.lang.StringEO"(ptr)

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr) noinline

declare ptr @"scalanative_GC_alloc_small"(ptr, i64)
@"_SM25scala.util.matching.RegexG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 895, i32 1, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 32, i32 895, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM25scala.util.matching.RegexD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }

define i1 @"_SM25scala.util.matching.RegexD10runMatcherL23java.util.regex.MatcherzEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000001 = call i1 @"_SM23java.util.regex.MatcherD7matcheszEO"(ptr dereferenceable_or_null(48) %_2)
  ret i1 %_3000001
}

define nonnull dereferenceable(16) ptr @"_SM25scala.util.matching.RegexD11findFirstInL22java.lang.CharSequenceL12scala.OptionEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_12000004 = icmp ne ptr %_1, null
  br i1 %_12000004, label %_12000002.0, label %_12000003.0
_12000002.0:
  %_12000005 = getelementptr { { ptr, ptr }, ptr, ptr }, { { ptr, ptr }, ptr, ptr }* %_1, i32 0, i32 1
  %_4000001 = load atomic ptr, ptr %_12000005 unordered, align 8
  %_3000001 = call dereferenceable_or_null(48) ptr @"_SM23java.util.regex.PatternD7matcherL22java.lang.CharSequenceL23java.util.regex.MatcherEO"(ptr dereferenceable_or_null(40) %_4000001, ptr dereferenceable_or_null(16) %_2)
  %_3000002 = call i1 @"_SM23java.util.regex.MatcherD4findzEO"(ptr dereferenceable_or_null(48) %_3000001)
  br i1 %_3000002, label %_5000000.0, label %_6000000.0
_5000000.0:
  %_5000002 = call dereferenceable_or_null(40) ptr @"_SM23java.util.regex.MatcherD5groupL16java.lang.StringEO"(ptr dereferenceable_or_null(48) %_3000001)
  %_5000003 = call dereferenceable_or_null(24) ptr @"scalanative_GC_alloc_small"(ptr @"_SM10scala.SomeG4type", i64 24)
  %_12000007 = getelementptr { { ptr, ptr }, ptr }, { { ptr, ptr }, ptr }* %_5000003, i32 0, i32 1
  store atomic ptr %_5000002, ptr%_12000007 unordered, align 8
  br label %_12000000.0
_6000000.0:
  br label %_12000000.0
_12000000.0:
  %_12000001 = phi ptr [@"_SM11scala.None$G8instance", %_6000000.0], [%_5000003, %_5000000.0]
  call void @"scalanative_GC_yield"()
  ret ptr %_12000001
_12000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define dereferenceable_or_null(40) ptr @"_SM25scala.util.matching.RegexD5regexL16java.lang.StringEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_3000004 = icmp ne ptr %_1, null
  br i1 %_3000004, label %_3000002.0, label %_3000003.0
_3000002.0:
  %_3000005 = getelementptr { { ptr, ptr }, ptr, ptr }, { { ptr, ptr }, ptr, ptr }* %_1, i32 0, i32 1
  %_3000001 = load atomic ptr, ptr %_3000005 unordered, align 8
  %_2000001 = call dereferenceable_or_null(40) ptr @"_SM23java.util.regex.PatternD7patternL16java.lang.StringEO"(ptr dereferenceable_or_null(40) %_3000001)
  ret ptr %_2000001
_3000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define i1 @"_SM25scala.util.matching.RegexD7matchesL22java.lang.CharSequencezEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_4000004 = icmp ne ptr %_1, null
  br i1 %_4000004, label %_4000002.0, label %_4000003.0
_4000002.0:
  %_4000005 = getelementptr { { ptr, ptr }, ptr, ptr }, { { ptr, ptr }, ptr, ptr }* %_1, i32 0, i32 1
  %_4000001 = load atomic ptr, ptr %_4000005 unordered, align 8
  %_3000001 = call dereferenceable_or_null(48) ptr @"_SM23java.util.regex.PatternD7matcherL22java.lang.CharSequenceL23java.util.regex.MatcherEO"(ptr dereferenceable_or_null(40) %_4000001, ptr dereferenceable_or_null(16) %_2)
  %_3000002 = call i1 @"_SM25scala.util.matching.RegexD10runMatcherL23java.util.regex.MatcherzEO"(ptr dereferenceable_or_null(32) %_1, ptr dereferenceable_or_null(48) %_3000001)
  call void @"scalanative_GC_yield"()
  ret i1 %_3000002
_4000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define dereferenceable_or_null(40) ptr @"_SM25scala.util.matching.RegexD8toStringL16java.lang.StringEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000004 = icmp ne ptr %_1, null
  br i1 %_2000004, label %_2000002.0, label %_2000003.0
_2000002.0:
  %_2000001 = call dereferenceable_or_null(40) ptr @"_SM25scala.util.matching.RegexD5regexL16java.lang.StringEO"(ptr dereferenceable_or_null(32) %_1)
  ret ptr %_2000001
_2000003.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}