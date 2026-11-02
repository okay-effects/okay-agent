declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [35 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 35, i32 2, [35 x i16] [ i16 109, i16 117, i16 110, i16 105, i16 116, i16 46, i16 105, i16 110, i16 116, i16 101, i16 114, i16 110, i16 97, i16 108, i16 46, i16 105, i16 111, i16 46, i16 80, i16 108, i16 97, i16 116, i16 102, i16 111, i16 114, i16 109, i16 73, i16 79, i16 36, i16 70, i16 105, i16 108, i16 101, i16 115, i16 36 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 35, i32 -577002300 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [0 x { i32, ptr }] [  ]
@"_SM7__constG1-5" = private unnamed_addr constant { ptr, ptr, i32, i32, [34 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 34, i32 2, [34 x i16] [ i16 109, i16 117, i16 110, i16 105, i16 116, i16 46, i16 105, i16 110, i16 116, i16 101, i16 114, i16 110, i16 97, i16 108, i16 46, i16 105, i16 111, i16 46, i16 80, i16 108, i16 97, i16 116, i16 102, i16 111, i16 114, i16 109, i16 73, i16 79, i16 36, i16 80, i16 97, i16 116, i16 104, i16 36 ] }
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-5", i32 0, i32 34, i32 -1533629048 }
@"_SM7__constG1-7" = private unnamed_addr constant { ptr, ptr, i32, i32, [35 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 35, i32 2, [35 x i16] [ i16 109, i16 117, i16 110, i16 105, i16 116, i16 46, i16 105, i16 110, i16 116, i16 101, i16 114, i16 110, i16 97, i16 108, i16 46, i16 105, i16 111, i16 46, i16 80, i16 108, i16 97, i16 116, i16 102, i16 111, i16 114, i16 109, i16 73, i16 79, i16 36, i16 80, i16 97, i16 116, i16 104, i16 115, i16 36 ] }
@"_SM7__constG1-8" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-7", i32 0, i32 35, i32 -297857747 }
@"_SM7__constG1-9" = private unnamed_addr constant { ptr, ptr, i32, i32, [8 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 8, i32 2, [8 x i16] [ i16 117, i16 115, i16 101, i16 114, i16 46, i16 100, i16 105, i16 114 ] }
@"_SM7__constG2-10" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-9", i32 0, i32 8, i32 -267617302 }

declare dereferenceable_or_null(16) ptr @"_SM19java.nio.file.FilesD12readAllLinesL18java.nio.file.PathL14java.util.ListEo"(ptr) inlinehint

declare dereferenceable_or_null(16) ptr @"_SM28scala.collection.AbstractMapD5applyL16java.lang.ObjectL16java.lang.ObjectEO"(ptr, ptr)

declare ptr @"_SM34scala.scalanative.runtime.package$D14throwClassCastR_R_nEO"(ptr, ptr, ptr) noinline
@"_SM18scala.sys.package$G8instance" = external global { ptr, ptr }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare i1 @"_SM19java.nio.file.FilesD6existsL18java.nio.file.PathLAL24java.nio.file.LinkOption_zEo"(ptr, ptr) inlinehint
@"_SM38scala.scalanative.runtime.ObjectArray$G8instance" = external global { ptr, ptr }
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [8 x ptr] }
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] }

declare nonnull dereferenceable(16) ptr @"_SM18scala.sys.package$D5propsL26scala.sys.SystemPropertiesEO"(ptr)

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint

declare dereferenceable_or_null(24) ptr @"_SM38scala.scalanative.runtime.ObjectArray$D5allociL37scala.scalanative.runtime.ObjectArrayEO"(ptr, i32) inlinehint

declare dereferenceable_or_null(16) ptr @"_SM19java.nio.file.PathsD3getL16java.lang.StringLAL16java.lang.String_L18java.nio.file.PathEo"(ptr, ptr) inlinehint
@"_SM35munit.internal.io.PlatformIO$Files$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1613, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 16, i32 1613, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM35munit.internal.io.PlatformIO$Files$G8instance" = hidden global { ptr, ptr } { ptr @"_SM35munit.internal.io.PlatformIO$Files$G4type", ptr null }
@"_SM34munit.internal.io.PlatformIO$Path$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1683, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-6" }, i32 16, i32 1683, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM34munit.internal.io.PlatformIO$Path$G8instance" = hidden global { ptr, ptr } { ptr @"_SM34munit.internal.io.PlatformIO$Path$G4type", ptr null }
@"_SM35munit.internal.io.PlatformIO$Paths$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1534, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-8" }, i32 16, i32 1534, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", ptr null, [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM35munit.internal.io.PlatformIO$Paths$G8instance" = hidden global { ptr, ptr } { ptr @"_SM35munit.internal.io.PlatformIO$Paths$G4type", ptr null }

define dereferenceable_or_null(16) ptr @"_SM35munit.internal.io.PlatformIO$Files$D12readAllLinesL18java.nio.file.PathL14java.util.ListEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000001 = call dereferenceable_or_null(16) ptr @"_SM19java.nio.file.FilesD12readAllLinesL18java.nio.file.PathL14java.util.ListEo"(ptr dereferenceable_or_null(16) %_2)
  ret ptr %_3000001
}

define i1 @"_SM35munit.internal.io.PlatformIO$Files$D6existsL18java.nio.file.PathzEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000002 = call dereferenceable_or_null(24) ptr @"_SM38scala.scalanative.runtime.ObjectArray$D5allociL37scala.scalanative.runtime.ObjectArrayEO"(ptr @"_SM38scala.scalanative.runtime.ObjectArray$G8instance", i32 0)
  %_3000003 = call i1 @"_SM19java.nio.file.FilesD6existsL18java.nio.file.PathLAL24java.nio.file.LinkOption_zEo"(ptr dereferenceable_or_null(16) %_2, ptr nonnull dereferenceable(24) %_3000002)
  ret i1 %_3000003
}

define void @"_SM35munit.internal.io.PlatformIO$Files$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}

define dereferenceable_or_null(16) ptr @"_SM34munit.internal.io.PlatformIO$Path$D16workingDirectoryL18java.nio.file.PathEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000003 = call dereferenceable_or_null(16) ptr @"_SM18scala.sys.package$D5propsL26scala.sys.SystemPropertiesEO"(ptr nonnull dereferenceable(16) @"_SM18scala.sys.package$G8instance")
  %_2000006 = call dereferenceable_or_null(16) ptr @"_SM28scala.collection.AbstractMapD5applyL16java.lang.ObjectL16java.lang.ObjectEO"(ptr dereferenceable_or_null(16) %_2000003, ptr @"_SM7__constG2-10")
  %_2000012 = icmp eq ptr %_2000006, null
  br i1 %_2000012, label %_2000010.0, label %_2000009.0
_2000009.0:
  %_2000013 = load ptr, ptr %_2000006
  %_2000014 = icmp eq ptr %_2000013, @"_SM16java.lang.StringG4type"
  br i1 %_2000014, label %_2000010.0, label %_2000011.0
_2000010.0:
  %_2000008 = call dereferenceable_or_null(16) ptr @"_SM35munit.internal.io.PlatformIO$Paths$D3getL16java.lang.StringL18java.nio.file.PathEO"(ptr nonnull dereferenceable(16) @"_SM35munit.internal.io.PlatformIO$Paths$G8instance", ptr dereferenceable_or_null(40) %_2000006)
  call void @"scalanative_GC_yield"()
  ret ptr %_2000008
_2000011.0:
  %_2000016 = phi ptr [%_2000006, %_2000009.0]
  %_2000017 = phi ptr [@"_SM16java.lang.StringG4type", %_2000009.0]
  %_2000018 = load ptr, ptr %_2000016
  call ptr @"_SM34scala.scalanative.runtime.package$D14throwClassCastR_R_nEO"(ptr null, ptr %_2000018, ptr %_2000017)
  unreachable
}

define void @"_SM34munit.internal.io.PlatformIO$Path$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}

define dereferenceable_or_null(16) ptr @"_SM35munit.internal.io.PlatformIO$Paths$D3getL16java.lang.StringL18java.nio.file.PathEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  %_3000002 = call dereferenceable_or_null(24) ptr @"_SM38scala.scalanative.runtime.ObjectArray$D5allociL37scala.scalanative.runtime.ObjectArrayEO"(ptr @"_SM38scala.scalanative.runtime.ObjectArray$G8instance", i32 0)
  %_3000003 = call dereferenceable_or_null(16) ptr @"_SM19java.nio.file.PathsD3getL16java.lang.StringLAL16java.lang.String_L18java.nio.file.PathEo"(ptr dereferenceable_or_null(40) %_2, ptr nonnull dereferenceable(24) %_3000002)
  ret ptr %_3000003
}

define void @"_SM35munit.internal.io.PlatformIO$Paths$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}