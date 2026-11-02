declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [4 x ptr] [ ptr @"_SM17java.io.CloseableG4type", ptr @"_SM38java.nio.channels.InterruptibleChannelG4type", ptr @"_SM23java.lang.AutoCloseableG4type", ptr @"_SM25java.nio.channels.ChannelG4type" ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [50 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 50, i32 2, [50 x i16] [ i16 106, i16 97, i16 118, i16 97, i16 46, i16 110, i16 105, i16 111, i16 46, i16 99, i16 104, i16 97, i16 110, i16 110, i16 101, i16 108, i16 115, i16 46, i16 115, i16 112, i16 105, i16 46, i16 65, i16 98, i16 115, i16 116, i16 114, i16 97, i16 99, i16 116, i16 73, i16 110, i16 116, i16 101, i16 114, i16 114, i16 117, i16 112, i16 116, i16 105, i16 98, i16 108, i16 101, i16 67, i16 104, i16 97, i16 110, i16 110, i16 101, i16 108 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 50, i32 1890665130 }
@"_SM7__constG1-3" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [8 x { i32, ptr }] [ { i32, ptr } { i32 -2147483480, ptr null }, { i32, ptr } { i32 -2147483543, ptr null }, { i32, ptr } { i32 -2147483454, ptr null }, { i32, ptr } { i32 0, ptr null }, { i32, ptr } { i32 -2147483548, ptr null }, { i32, ptr } { i32 0, ptr null }, { i32, ptr } { i32 0, ptr null }, { i32, ptr } { i32 0, ptr null } ]
@"_SM38java.nio.channels.InterruptibleChannelG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare ptr @"scalanative_throw"(ptr)
@"_SM17java.io.CloseableG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }
@"_SM23java.lang.AutoCloseableG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM36scala.scalanative.runtime.BoxedUnit$G8instance" = external global { ptr, ptr }

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint
@"_SM25java.nio.channels.ChannelG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }

declare void @"_SM33scala.scalanative.runtime.packageD11exitMonitorL16java.lang.ObjectuEo"(ptr) inlinehint

declare void @"_SM33java.nio.channels.FileChannelImplD16implCloseChanneluEO"(ptr)

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare void @"_SM33scala.scalanative.runtime.packageD12enterMonitorL16java.lang.ObjectuEo"(ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint

declare ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr) noinline
@"_SM50java.nio.channels.spi.AbstractInterruptibleChannelG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 767, i32 4, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 24, i32 769, ptr @"_SM7__constG1-3", i32 7, ptr @"_SM7__constG1-4", ptr @"_SM16java.lang.ObjectG4type", [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }

define void @"_SM50java.nio.channels.spi.AbstractInterruptibleChannelD5closeuEO"(ptr %_1) personality ptr @scalanative_personality {
_2.0:
  call void @"_SM33scala.scalanative.runtime.packageD12enterMonitorL16java.lang.ObjectuEo"(ptr dereferenceable_or_null(24) %_1)
  br label %_3.0
_3.0:
  %_33 = icmp ne ptr %_1, null
  br i1 %_33, label %_30.0, label %_31.0
_30.0:
  %_35 = getelementptr { { ptr, ptr }, i1 }, { { ptr, ptr }, i1 }* %_1, i32 0, i32 1
  %_36 = load atomic i8, ptr %_35 unordered, align 1
  %_12 = trunc i8 %_36 to i1
  %_14 = xor i1 true, %_12
  br i1 %_14, label %_7.0, label %_8.0
_7.0:
  %_44 = getelementptr { { ptr, ptr }, i1 }, { { ptr, ptr }, i1 }* %_1, i32 0, i32 1
  %_45 = zext i1 true to i8
  store atomic i8 %_45, ptr%_44 unordered, align 1
  invoke void @"_SM33java.nio.channels.FileChannelImplD16implCloseChanneluEO"(ptr dereferenceable_or_null(24) %_1) to label %_7.1 unwind label %_53.landingpad
_7.1:
  br label %_9.0
_8.0:
  br label %_9.0
_9.0:
  %_10 = phi ptr [@"_SM36scala.scalanative.runtime.BoxedUnit$G8instance", %_8.0], [@"_SM36scala.scalanative.runtime.BoxedUnit$G8instance", %_7.1]
  br label %_24.0
_4.0:
  %_22 = phi ptr [%_19, %_51.0], [%_17, %_49.0], [%_15, %_41.0], [%_13, %_39.0], [%_11, %_29.0]
  br label %_26.0
_24.0:
  call void @"_SM33scala.scalanative.runtime.packageD11exitMonitorL16java.lang.ObjectuEo"(ptr dereferenceable_or_null(24) %_1)
  br label %_5.0
_26.0:
  call void @"_SM33scala.scalanative.runtime.packageD11exitMonitorL16java.lang.ObjectuEo"(ptr dereferenceable_or_null(24) %_1)
  %_59 = icmp ne ptr %_22, null
  br i1 %_59, label %_57.0, label %_58.0
_57.0:
  call ptr @"scalanative_throw"(ptr dereferenceable_or_null(88) %_22)
  unreachable
_5.0:
  %_21 = phi ptr [%_10, %_24.0]
  call void @"scalanative_GC_yield"()
  ret void
_31.0:
  invoke ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null) to label %_31.1 unwind label %_62.landingpad
_31.1:
  unreachable
_58.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
_29.0:
  %_11 = phi ptr [%_32, %_32.landingpad.succ], [%_62, %_62.landingpad.succ], [%_34, %_34.landingpad.succ], [%_37, %_37.landingpad.succ], [%_38, %_38.landingpad.succ]
  br label %_4.0
_39.0:
  %_13 = phi ptr [%_40, %_40.landingpad.succ]
  br label %_4.0
_41.0:
  %_15 = phi ptr [%_43, %_43.landingpad.succ], [%_46, %_46.landingpad.succ], [%_47, %_47.landingpad.succ]
  br label %_4.0
_49.0:
  %_17 = phi ptr [%_50, %_50.landingpad.succ]
  br label %_4.0
_51.0:
  %_19 = phi ptr [%_53, %_53.landingpad.succ]
  br label %_4.0
_32.landingpad:
  %_72 = landingpad { ptr, i32 } catch ptr null
  %_73 = extractvalue { ptr, i32 } %_72, 0
  br label %_32.landingpad.succ
_32.landingpad.succ:
  %_32 = call ptr @scalanative_catch(ptr %_73)
  br label %_29.0
_34.landingpad:
  %_78 = landingpad { ptr, i32 } catch ptr null
  %_79 = extractvalue { ptr, i32 } %_78, 0
  br label %_34.landingpad.succ
_34.landingpad.succ:
  %_34 = call ptr @scalanative_catch(ptr %_79)
  br label %_29.0
_37.landingpad:
  %_84 = landingpad { ptr, i32 } catch ptr null
  %_85 = extractvalue { ptr, i32 } %_84, 0
  br label %_37.landingpad.succ
_37.landingpad.succ:
  %_37 = call ptr @scalanative_catch(ptr %_85)
  br label %_29.0
_38.landingpad:
  %_90 = landingpad { ptr, i32 } catch ptr null
  %_91 = extractvalue { ptr, i32 } %_90, 0
  br label %_38.landingpad.succ
_38.landingpad.succ:
  %_38 = call ptr @scalanative_catch(ptr %_91)
  br label %_29.0
_40.landingpad:
  %_96 = landingpad { ptr, i32 } catch ptr null
  %_97 = extractvalue { ptr, i32 } %_96, 0
  br label %_40.landingpad.succ
_40.landingpad.succ:
  %_40 = call ptr @scalanative_catch(ptr %_97)
  br label %_39.0
_43.landingpad:
  %_102 = landingpad { ptr, i32 } catch ptr null
  %_103 = extractvalue { ptr, i32 } %_102, 0
  br label %_43.landingpad.succ
_43.landingpad.succ:
  %_43 = call ptr @scalanative_catch(ptr %_103)
  br label %_41.0
_46.landingpad:
  %_108 = landingpad { ptr, i32 } catch ptr null
  %_109 = extractvalue { ptr, i32 } %_108, 0
  br label %_46.landingpad.succ
_46.landingpad.succ:
  %_46 = call ptr @scalanative_catch(ptr %_109)
  br label %_41.0
_47.landingpad:
  %_114 = landingpad { ptr, i32 } catch ptr null
  %_115 = extractvalue { ptr, i32 } %_114, 0
  br label %_47.landingpad.succ
_47.landingpad.succ:
  %_47 = call ptr @scalanative_catch(ptr %_115)
  br label %_41.0
_50.landingpad:
  %_120 = landingpad { ptr, i32 } catch ptr null
  %_121 = extractvalue { ptr, i32 } %_120, 0
  br label %_50.landingpad.succ
_50.landingpad.succ:
  %_50 = call ptr @scalanative_catch(ptr %_121)
  br label %_49.0
_53.landingpad:
  %_126 = landingpad { ptr, i32 } catch ptr null
  %_127 = extractvalue { ptr, i32 } %_126, 0
  br label %_53.landingpad.succ
_53.landingpad.succ:
  %_53 = call ptr @scalanative_catch(ptr %_127)
  br label %_51.0
_62.landingpad:
  %_132 = landingpad { ptr, i32 } catch ptr null
  %_133 = extractvalue { ptr, i32 } %_132, 0
  br label %_62.landingpad.succ
_62.landingpad.succ:
  %_62 = call ptr @scalanative_catch(ptr %_133)
  br label %_29.0
}

define i1 @"_SM50java.nio.channels.spi.AbstractInterruptibleChannelD6isOpenzEO"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  %_2000006 = icmp ne ptr %_1, null
  br i1 %_2000006, label %_2000004.0, label %_2000005.0
_2000004.0:
  %_2000007 = getelementptr { { ptr, ptr }, i1 }, { { ptr, ptr }, i1 }* %_1, i32 0, i32 1
  %_2000008 = load atomic i8, ptr %_2000007 unordered, align 1
  %_2000001 = trunc i8 %_2000008 to i1
  %_2000003 = xor i1 %_2000001, true
  ret i1 %_2000003
_2000005.0:
  call ptr @"_SM34scala.scalanative.runtime.package$D16throwNullPointernEO"(ptr null)
  unreachable
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}