declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [36 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 36, i32 2, [36 x i16] [ i16 106, i16 97, i16 118, i16 97, i16 46, i16 110, i16 105, i16 111, i16 46, i16 102, i16 105, i16 108, i16 101, i16 46, i16 115, i16 112, i16 105, i16 46, i16 70, i16 105, i16 108, i16 101, i16 83, i16 121, i16 115, i16 116, i16 101, i16 109, i16 80, i16 114, i16 111, i16 118, i16 105, i16 100, i16 101, i16 114 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 36, i32 -2033825398 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [0 x { i32, ptr }] [  ]
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare dereferenceable_or_null(16) ptr @"_SM20java.nio.file.Files$D14newByteChannelL18java.nio.file.PathLAL24java.nio.file.OpenOption_L37java.nio.channels.SeekableByteChannelEO"(ptr, ptr, ptr)
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwOutOfBoundsiinEO"(ptr, i32, i32)

declare i1 @"_SM26scala.collection.ArrayOps$D17isEmpty$extensionL16java.lang.ObjectzEO"(ptr, ptr) inlinehint
@"_SM38scala.scalanative.runtime.ObjectArray$G8instance" = external global { ptr, ptr }
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }

declare dereferenceable_or_null(24) ptr @"_SM13scala.Predef$D11refArrayOpsLAL16java.lang.Object_L16java.lang.ObjectEO"(ptr, ptr) inlinehint

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint
@"_SM30java.nio.channels.FileChannel$G8instance" = external global { ptr, ptr }

declare dereferenceable_or_null(16) ptr @"_SM26scala.collection.ArrayOps$D21$colon$plus$extensionL16java.lang.ObjectL16java.lang.ObjectL22scala.reflect.ClassTagL16java.lang.ObjectEO"(ptr, ptr, ptr, ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint

declare dereferenceable_or_null(24) ptr @"_SM38scala.scalanative.runtime.ObjectArray$D5allociL37scala.scalanative.runtime.ObjectArrayEO"(ptr, i32) inlinehint
@"_SM13scala.Predef$G8instance" = external global { ptr, ptr }

declare ptr @"_SM34scala.scalanative.runtime.package$D14throwClassCastR_R_nEO"(ptr, ptr, ptr) noinline

declare dereferenceable_or_null(48) ptr @"_SM20java.nio.file.Files$G4load"()
@"_SM24java.nio.file.OpenOptionG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }

declare dereferenceable_or_null(16) ptr @"_SM23scala.reflect.ClassTag$D5applyL15java.lang.ClassL22scala.reflect.ClassTagEO"(ptr, ptr)

declare dereferenceable_or_null(136) ptr @"_SM23scala.reflect.ClassTag$G4load"()

declare dereferenceable_or_null(24) ptr @"_SM30java.nio.channels.FileChannel$D4openL18java.nio.file.PathL13java.util.SetLAL37java.nio.file.attribute.FileAttribute_L29java.nio.channels.FileChannelEO"(ptr, ptr, ptr, ptr)
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare nonnull dereferenceable(40) ptr @"_SM27java.nio.channels.Channels$D15newOutputStreamL37java.nio.channels.WritableByteChannelL20java.io.OutputStreamEO"(ptr, ptr)
@"_SM27java.nio.channels.Channels$G8instance" = external global { ptr, ptr }
@"_SM37scala.scalanative.runtime.ObjectArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }

declare nonnull dereferenceable(40) ptr @"_SM27java.nio.channels.Channels$D14newInputStreamL37java.nio.channels.ReadableByteChannelL19java.io.InputStreamEO"(ptr, ptr)

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare dereferenceable_or_null(24) ptr @"_SM26scala.collection.ArrayOps$G4load"()

declare dereferenceable_or_null(104) ptr @"_SM33java.nio.file.StandardOpenOption$G4load"()
@"_SM36java.nio.file.spi.FileSystemProviderG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1783, i32 0, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 16, i32 1785, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }

define dereferenceable_or_null(24) ptr @"_SM36java.nio.file.spi.FileSystemProviderD14newByteChannelL18java.nio.file.PathL13java.util.SetLAL37java.nio.file.attribute.FileAttribute_L37java.nio.channels.SeekableByteChannelEO"(ptr %_1, ptr %_2, ptr %_3, ptr %_4) personality ptr @scalanative_personality {
_5000000.0:
  %_5000002 = call dereferenceable_or_null(24) ptr @"_SM30java.nio.channels.FileChannel$D4openL18java.nio.file.PathL13java.util.SetLAL37java.nio.file.attribute.FileAttribute_L29java.nio.channels.FileChannelEO"(ptr nonnull dereferenceable(16) @"_SM30java.nio.channels.FileChannel$G8instance", ptr dereferenceable_or_null(16) %_2, ptr dereferenceable_or_null(16) %_3, ptr dereferenceable_or_null(24) %_4)
  ret ptr %_5000002
}

define dereferenceable_or_null(16) ptr @"_SM36java.nio.file.spi.FileSystemProviderD14newInputStreamL18java.nio.file.PathLAL24java.nio.file.OpenOption_L19java.io.InputStreamEO"(ptr %_1, ptr %_2, ptr %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_4000003 = call dereferenceable_or_null(16) ptr @"_SM13scala.Predef$D11refArrayOpsLAL16java.lang.Object_L16java.lang.ObjectEO"(ptr nonnull dereferenceable(16) @"_SM13scala.Predef$G8instance", ptr dereferenceable_or_null(24) %_3)
  %_4000004 = call dereferenceable_or_null(24) ptr @"_SM26scala.collection.ArrayOps$G4load"()
  %_4000005 = call i1 @"_SM26scala.collection.ArrayOps$D17isEmpty$extensionL16java.lang.ObjectzEO"(ptr nonnull dereferenceable(24) %_4000004, ptr dereferenceable_or_null(16) %_4000003)
  br i1 %_4000005, label %_5000000.0, label %_6000000.0
_5000000.0:
  %_5000001 = call dereferenceable_or_null(104) ptr @"_SM33java.nio.file.StandardOpenOption$G4load"()
  %_8000006 = getelementptr { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }, { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }* %_5000001, i32 0, i32 9
  %_7000001 = load atomic ptr, ptr %_8000006 unordered, align 8
  %_5000003 = call dereferenceable_or_null(24) ptr @"_SM38scala.scalanative.runtime.ObjectArray$D5allociL37scala.scalanative.runtime.ObjectArrayEO"(ptr @"_SM38scala.scalanative.runtime.ObjectArray$G8instance", i32 1)
  %_8000010 = getelementptr { ptr, ptr, i32, i32 }, { ptr, ptr, i32, i32 }* %_5000003, i32 0, i32 2
  %_8000009 = load atomic i32, ptr %_8000010 unordered, align 4
  %_8000013 = icmp sge i32 0, 0
  %_8000014 = icmp slt i32 0, %_8000009
  %_8000015 = and i1 %_8000013, %_8000014
  br i1 %_8000015, label %_8000011.0, label %_8000012.0
_8000011.0:
  %_8000016 = getelementptr { { ptr, ptr, i32, i32 }, [0 x ptr] }, { { ptr, ptr, i32, i32 }, [0 x ptr] }* %_5000003, i32 0, i32 1, i32 0
  store atomic ptr %_7000001, ptr%_8000016 unordered, align 8
  br label %_8000000.0
_6000000.0:
  br label %_8000000.0
_8000000.0:
  %_8000001 = phi ptr [%_3, %_6000000.0], [%_5000003, %_8000011.0]
  %_8000002 = call dereferenceable_or_null(48) ptr @"_SM20java.nio.file.Files$G4load"()
  %_8000003 = call dereferenceable_or_null(16) ptr @"_SM20java.nio.file.Files$D14newByteChannelL18java.nio.file.PathLAL24java.nio.file.OpenOption_L37java.nio.channels.SeekableByteChannelEO"(ptr nonnull dereferenceable(48) %_8000002, ptr dereferenceable_or_null(16) %_2, ptr dereferenceable_or_null(24) %_8000001)
  %_8000005 = call dereferenceable_or_null(16) ptr @"_SM27java.nio.channels.Channels$D14newInputStreamL37java.nio.channels.ReadableByteChannelL19java.io.InputStreamEO"(ptr nonnull dereferenceable(16) @"_SM27java.nio.channels.Channels$G8instance", ptr dereferenceable_or_null(16) %_8000003)
  call void @"scalanative_GC_yield"()
  ret ptr %_8000005
_8000012.0:
  %_8000018 = phi i32 [0, %_5000000.0]
  %_8000019 = phi i32 [%_8000009, %_5000000.0]
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwOutOfBoundsiinEO"(ptr null, i32 %_8000018, i32 %_8000019)
  unreachable
}

define dereferenceable_or_null(16) ptr @"_SM36java.nio.file.spi.FileSystemProviderD15newOutputStreamL18java.nio.file.PathLAL24java.nio.file.OpenOption_L20java.io.OutputStreamEO"(ptr %_1, ptr %_2, ptr %_3) personality ptr @scalanative_personality {
_4000000.0:
  %_4000003 = call dereferenceable_or_null(16) ptr @"_SM13scala.Predef$D11refArrayOpsLAL16java.lang.Object_L16java.lang.ObjectEO"(ptr nonnull dereferenceable(16) @"_SM13scala.Predef$G8instance", ptr dereferenceable_or_null(24) %_3)
  %_4000004 = call dereferenceable_or_null(24) ptr @"_SM26scala.collection.ArrayOps$G4load"()
  %_4000005 = call i1 @"_SM26scala.collection.ArrayOps$D17isEmpty$extensionL16java.lang.ObjectzEO"(ptr nonnull dereferenceable(24) %_4000004, ptr dereferenceable_or_null(16) %_4000003)
  br i1 %_4000005, label %_5000000.0, label %_6000000.0
_5000000.0:
  %_5000001 = call dereferenceable_or_null(104) ptr @"_SM33java.nio.file.StandardOpenOption$G4load"()
  %_11000002 = getelementptr { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }, { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }* %_5000001, i32 0, i32 5
  %_7000001 = load atomic ptr, ptr %_11000002 unordered, align 8
  %_11000003 = getelementptr { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }, { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }* %_5000001, i32 0, i32 6
  %_8000001 = load atomic ptr, ptr %_11000003 unordered, align 8
  %_11000004 = getelementptr { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }, { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }* %_5000001, i32 0, i32 7
  %_9000001 = load atomic ptr, ptr %_11000004 unordered, align 8
  %_5000003 = call dereferenceable_or_null(24) ptr @"_SM38scala.scalanative.runtime.ObjectArray$D5allociL37scala.scalanative.runtime.ObjectArrayEO"(ptr @"_SM38scala.scalanative.runtime.ObjectArray$G8instance", i32 3)
  %_11000008 = getelementptr { ptr, ptr, i32, i32 }, { ptr, ptr, i32, i32 }* %_5000003, i32 0, i32 2
  %_11000007 = load atomic i32, ptr %_11000008 unordered, align 4
  %_11000011 = icmp sge i32 0, 0
  %_11000012 = icmp slt i32 0, %_11000007
  %_11000013 = and i1 %_11000011, %_11000012
  br i1 %_11000013, label %_11000009.0, label %_11000010.0
_11000009.0:
  %_11000014 = getelementptr { { ptr, ptr, i32, i32 }, [0 x ptr] }, { { ptr, ptr, i32, i32 }, [0 x ptr] }* %_5000003, i32 0, i32 1, i32 0
  store atomic ptr %_7000001, ptr%_11000014 unordered, align 8
  %_11000017 = getelementptr { ptr, ptr, i32, i32 }, { ptr, ptr, i32, i32 }* %_5000003, i32 0, i32 2
  %_11000016 = load atomic i32, ptr %_11000017 unordered, align 4
  %_11000019 = icmp sge i32 1, 0
  %_11000020 = icmp slt i32 1, %_11000016
  %_11000021 = and i1 %_11000019, %_11000020
  br i1 %_11000021, label %_11000018.0, label %_11000010.0
_11000018.0:
  %_11000022 = getelementptr { { ptr, ptr, i32, i32 }, [0 x ptr] }, { { ptr, ptr, i32, i32 }, [0 x ptr] }* %_5000003, i32 0, i32 1, i32 1
  store atomic ptr %_8000001, ptr%_11000022 unordered, align 8
  %_11000025 = getelementptr { ptr, ptr, i32, i32 }, { ptr, ptr, i32, i32 }* %_5000003, i32 0, i32 2
  %_11000024 = load atomic i32, ptr %_11000025 unordered, align 4
  %_11000027 = icmp sge i32 2, 0
  %_11000028 = icmp slt i32 2, %_11000024
  %_11000029 = and i1 %_11000027, %_11000028
  br i1 %_11000029, label %_11000026.0, label %_11000010.0
_11000026.0:
  %_11000030 = getelementptr { { ptr, ptr, i32, i32 }, [0 x ptr] }, { { ptr, ptr, i32, i32 }, [0 x ptr] }* %_5000003, i32 0, i32 1, i32 2
  store atomic ptr %_9000001, ptr%_11000030 unordered, align 8
  br label %_10000000.0
_6000000.0:
  %_6000001 = call dereferenceable_or_null(16) ptr @"_SM13scala.Predef$D11refArrayOpsLAL16java.lang.Object_L16java.lang.ObjectEO"(ptr nonnull dereferenceable(16) @"_SM13scala.Predef$G8instance", ptr dereferenceable_or_null(24) %_3)
  %_6000002 = call dereferenceable_or_null(104) ptr @"_SM33java.nio.file.StandardOpenOption$G4load"()
  %_11000031 = getelementptr { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }, { { ptr, ptr }, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr, ptr }* %_6000002, i32 0, i32 7
  %_11000001 = load atomic ptr, ptr %_11000031 unordered, align 8
  %_6000003 = call dereferenceable_or_null(136) ptr @"_SM23scala.reflect.ClassTag$G4load"()
  %_6000004 = call dereferenceable_or_null(16) ptr @"_SM23scala.reflect.ClassTag$D5applyL15java.lang.ClassL22scala.reflect.ClassTagEO"(ptr nonnull dereferenceable(136) %_6000003, ptr @"_SM24java.nio.file.OpenOptionG4type")
  %_6000005 = call dereferenceable_or_null(16) ptr @"_SM26scala.collection.ArrayOps$D21$colon$plus$extensionL16java.lang.ObjectL16java.lang.ObjectL22scala.reflect.ClassTagL16java.lang.ObjectEO"(ptr nonnull dereferenceable(24) %_4000004, ptr dereferenceable_or_null(16) %_6000001, ptr dereferenceable_or_null(32) %_11000001, ptr dereferenceable_or_null(16) %_6000004)
  %_11000035 = icmp eq ptr %_6000005, null
  br i1 %_11000035, label %_11000033.0, label %_11000032.0
_11000032.0:
  %_11000036 = load ptr, ptr %_6000005
  %_11000037 = icmp eq ptr %_11000036, @"_SM37scala.scalanative.runtime.ObjectArrayG4type"
  br i1 %_11000037, label %_11000033.0, label %_11000034.0
_11000033.0:
  br label %_10000000.0
_10000000.0:
  %_10000001 = phi ptr [%_6000005, %_11000033.0], [%_5000003, %_11000026.0]
  %_10000002 = call dereferenceable_or_null(48) ptr @"_SM20java.nio.file.Files$G4load"()
  %_10000003 = call dereferenceable_or_null(16) ptr @"_SM20java.nio.file.Files$D14newByteChannelL18java.nio.file.PathLAL24java.nio.file.OpenOption_L37java.nio.channels.SeekableByteChannelEO"(ptr nonnull dereferenceable(48) %_10000002, ptr dereferenceable_or_null(16) %_2, ptr dereferenceable_or_null(24) %_10000001)
  %_10000005 = call dereferenceable_or_null(16) ptr @"_SM27java.nio.channels.Channels$D15newOutputStreamL37java.nio.channels.WritableByteChannelL20java.io.OutputStreamEO"(ptr nonnull dereferenceable(16) @"_SM27java.nio.channels.Channels$G8instance", ptr dereferenceable_or_null(16) %_10000003)
  call void @"scalanative_GC_yield"()
  ret ptr %_10000005
_11000034.0:
  %_11000039 = phi ptr [%_6000005, %_11000032.0]
  %_11000040 = phi ptr [@"_SM37scala.scalanative.runtime.ObjectArrayG4type", %_11000032.0]
  %_11000041 = load ptr, ptr %_11000039
  call ptr @"_SM34scala.scalanative.runtime.package$D14throwClassCastR_R_nEO"(ptr null, ptr %_11000041, ptr %_11000040)
  unreachable
_11000010.0:
  %_11000043 = phi i32 [0, %_5000000.0], [1, %_11000009.0], [2, %_11000018.0]
  %_11000044 = phi i32 [%_11000007, %_5000000.0], [%_11000016, %_11000009.0], [%_11000024, %_11000018.0]
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwOutOfBoundsiinEO"(ptr null, i32 %_11000043, i32 %_11000044)
  unreachable
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}