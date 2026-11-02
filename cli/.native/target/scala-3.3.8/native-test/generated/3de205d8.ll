declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [2 x ptr] [ ptr @"_SM20java.io.SerializableG4type", ptr @"_SM15scala.Function1G4type" ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [34 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 34, i32 2, [34 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 114, i16 117, i16 110, i16 116, i16 105, i16 109, i16 101, i16 46, i16 102, i16 117, i16 110, i16 99, i16 116, i16 105, i16 111, i16 110, i16 46, i16 74, i16 80, i16 114, i16 111, i16 99, i16 101, i16 100, i16 117, i16 114, i16 101, i16 49 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 34, i32 232275600 }
@"_SM7__constG1-3" = private unnamed_addr constant [2 x ptr] [ ptr @"_SM20java.io.SerializableG4type", ptr @"_SM15scala.Function2G4type" ]
@"_SM7__constG1-4" = private unnamed_addr constant { ptr, ptr, i32, i32, [34 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 34, i32 2, [34 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 114, i16 117, i16 110, i16 116, i16 105, i16 109, i16 101, i16 46, i16 102, i16 117, i16 110, i16 99, i16 116, i16 105, i16 111, i16 110, i16 46, i16 74, i16 80, i16 114, i16 111, i16 99, i16 101, i16 100, i16 117, i16 114, i16 101, i16 50 ] }
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-4", i32 0, i32 34, i32 232275601 }
@"_SM36scala.scalanative.runtime.BoxedUnit$G8instance" = external global { ptr, ptr }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM15scala.Function1G4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM15scala.Function2G4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM20java.io.SerializableG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr) noinline

declare void @"_SM23java.util.Map$$Lambda$3D9applyVoidL16java.lang.ObjectL16java.lang.ObjectuEO"(ptr, ptr, ptr)
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }
@"_SM34scala.runtime.function.JProcedure1G4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147479776, i32 2, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }
@"_SM34scala.runtime.function.JProcedure2G4type" = hidden global { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 -2147482752, i32 2, ptr @"_SM7__constG1-3", ptr @"_SM7__constG1-5" }

define dereferenceable_or_null(16) ptr @"_SM34scala.runtime.function.JProcedure1D5applyL16java.lang.ObjectL16java.lang.ObjectEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000006 = icmp ne ptr %_1, null
  br i1 %_3000006, label %_3000004.0, label %_3000005.0
_3000004.0:
  %_3000007 = load ptr, ptr %_1
  %_3000008 = getelementptr { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [0 x ptr] }, { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [0 x ptr] }* %_3000007, i32 0, i32 4
  %_3000009 = load i32, ptr %_3000008
  %_3000010 = getelementptr { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [0 x ptr] }, { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [0 x ptr] }* %_3000007, i32 0, i32 5
  %_3000011 = load ptr, ptr %_3000010
  %_3000012 = and i32 -2147479776, %_3000009
  %_3000013 = getelementptr { i32, ptr }, { i32, ptr }* %_3000011, i32 %_3000012, i32 1
  %_3000014 = load ptr, ptr %_3000013
  %_3000015 = getelementptr ptr, ptr %_3000014, i32 0
  %_3000002 = load ptr, ptr %_3000015
  call void %_3000002(ptr dereferenceable_or_null(16) %_1, ptr dereferenceable_or_null(16) %_2)
  ret ptr @"_SM36scala.scalanative.runtime.BoxedUnit$G8instance"
_3000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}

define dereferenceable_or_null(16) ptr @"_SM34scala.runtime.function.JProcedure2D5applyL16java.lang.ObjectL16java.lang.ObjectL16java.lang.ObjectEO"(ptr %_1, ptr %_2, ptr %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_4000006 = icmp ne ptr %_1, null
  br i1 %_4000006, label %_4000004.0, label %_4000005.0
_4000004.0:
  call void @"_SM23java.util.Map$$Lambda$3D9applyVoidL16java.lang.ObjectL16java.lang.ObjectuEO"(ptr dereferenceable_or_null(16) %_1, ptr dereferenceable_or_null(16) %_2, ptr dereferenceable_or_null(16) %_3)
  ret ptr @"_SM36scala.scalanative.runtime.BoxedUnit$G8instance"
_4000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}