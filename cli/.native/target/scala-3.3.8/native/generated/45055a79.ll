declare i32 @scalanative_personality(...)
declare ptr @scalanative_catch(ptr)

@"_SM7__constG1-0" = private unnamed_addr constant [1 x ptr] [ ptr @"_SM20java.io.SerializableG4type" ]
@"_SM7__constG1-1" = private unnamed_addr constant { ptr, ptr, i32, i32, [35 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 35, i32 2, [35 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 117, i16 116, i16 105, i16 108, i16 46, i16 99, i16 111, i16 110, i16 116, i16 114, i16 111, i16 108, i16 46, i16 67, i16 111, i16 110, i16 116, i16 114, i16 111, i16 108, i16 84, i16 104, i16 114, i16 111, i16 119, i16 97, i16 98, i16 108, i16 101 ] }
@"_SM7__constG1-2" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-1", i32 0, i32 35, i32 1233961656 }
@"_SM7__constG1-3" = private unnamed_addr constant [8 x i32] [ i32 16, i32 24, i32 32, i32 40, i32 56, i32 64, i32 80, i32 -1 ]
@"_SM7__constG1-4" = private unnamed_addr constant [1 x { i32, ptr }] [ { i32, ptr } { i32 -2147483621, ptr null } ]
@"_SM7__constG1-5" = private unnamed_addr constant [0 x ptr] [  ]
@"_SM7__constG1-6" = private unnamed_addr constant { ptr, ptr, i32, i32, [28 x i16] } { ptr @"_SM35scala.scalanative.runtime.CharArrayG4type", ptr null, i32 28, i32 2, [28 x i16] [ i16 115, i16 99, i16 97, i16 108, i16 97, i16 46, i16 117, i16 116, i16 105, i16 108, i16 46, i16 99, i16 111, i16 110, i16 116, i16 114, i16 111, i16 108, i16 46, i16 78, i16 111, i16 110, i16 70, i16 97, i16 116, i16 97, i16 108, i16 36 ] }
@"_SM7__constG1-7" = private unnamed_addr constant { ptr, ptr, ptr, i32, i32, i32 } { ptr @"_SM16java.lang.StringG4type", ptr null, ptr @"_SM7__constG1-6", i32 0, i32 28, i32 -1886501864 }
@"_SM7__constG1-8" = private unnamed_addr constant [1 x i32] [ i32 -1 ]
@"_SM7__constG1-9" = private unnamed_addr constant [0 x { i32, ptr }] [  ]
@"_SM21java.lang.ThreadDeathG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [5 x ptr] }
@"_SM30java.lang.InterruptedExceptionG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [5 x ptr] }
@"_SM16java.lang.StringG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM15java.lang.ClassG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }
@"_SM20java.io.SerializableG4type" = external global { ptr, ptr, i32, i32, ptr, ptr }

declare dereferenceable_or_null(88) ptr @"_SM19java.lang.ThrowableD8getCauseL19java.lang.ThrowableEO"(ptr)
@"_SM35scala.scalanative.runtime.CharArrayG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [8 x ptr] }
@"_SM19java.lang.ThrowableG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [5 x ptr] }
@"_SM16java.lang.ObjectG4type" = external global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] }

declare void @"scalanative_GC_yield"()

declare i32 @"_SM16java.lang.ObjectD8hashCodeiEO"(ptr) inlinehint

declare i1 @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO"(ptr, ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM19java.lang.ThrowableD10getMessageL16java.lang.StringEO"(ptr)

declare dereferenceable_or_null(40) ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO"(ptr) inlinehint

declare dereferenceable_or_null(40) ptr @"_SM19java.lang.ThrowableD8toStringL16java.lang.StringEO"(ptr)
@"_SM35scala.util.control.ControlThrowableG4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [5 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1923, i32 1, ptr @"_SM7__constG1-0", ptr @"_SM7__constG1-2" }, i32 88, i32 1923, ptr @"_SM7__constG1-3", i32 0, ptr @"_SM7__constG1-4", ptr @"_SM19java.lang.ThrowableG4type", [5 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM19java.lang.ThrowableD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO", ptr @"_SM19java.lang.ThrowableD8getCauseL19java.lang.ThrowableEO", ptr @"_SM19java.lang.ThrowableD10getMessageL16java.lang.StringEO" ] }
@"_SM28scala.util.control.NonFatal$G4type" = hidden global { { ptr, ptr, i32, i32, ptr, ptr }, i32, i32, ptr, i32, ptr, ptr, [3 x ptr] } { { ptr, ptr, i32, i32, ptr, ptr } { ptr @"_SM15java.lang.ClassG4type", ptr null, i32 1578, i32 0, ptr @"_SM7__constG1-5", ptr @"_SM7__constG1-7" }, i32 16, i32 1578, ptr @"_SM7__constG1-8", i32 0, ptr @"_SM7__constG1-9", ptr @"_SM16java.lang.ObjectG4type", [3 x ptr] [ ptr @"_SM16java.lang.ObjectD8hashCodeiEO", ptr @"_SM16java.lang.ObjectD8toStringL16java.lang.StringEO", ptr @"_SM16java.lang.ObjectD6equalsL16java.lang.ObjectzEO" ] }
@"_SM28scala.util.control.NonFatal$G8instance" = hidden global { ptr, ptr } { ptr @"_SM28scala.util.control.NonFatal$G4type", ptr null }

define i1 @"_SM28scala.util.control.NonFatal$D5applyL19java.lang.ThrowablezEO"(ptr %_1, ptr %_2) personality ptr @scalanative_personality {
_3000000.0:
  br label %_4000000.0
_4000000.0:
  br label %_5000000.0
_5000000.0:
  %_25000004 = icmp eq ptr %_2, null
  br i1 %_25000004, label %_25000001.0, label %_25000002.0
_25000001.0:
  br label %_25000003.0
_25000002.0:
  %_25000005 = load ptr, ptr %_2
  %_25000006 = getelementptr { ptr, ptr, i32, i32, ptr, ptr }, { ptr, ptr, i32, i32, ptr, ptr }* %_25000005, i32 0, i32 2
  %_25000007 = load i32, ptr %_25000006
  %_25000008 = icmp sle i32 1843, %_25000007
  %_25000009 = icmp sle i32 %_25000007, 1845
  %_25000010 = and i1 %_25000008, %_25000009
  br label %_25000003.0
_25000003.0:
  %_5000002 = phi i1 [%_25000010, %_25000002.0], [false, %_25000001.0]
  br i1 %_5000002, label %_6000000.0, label %_7000000.0
_6000000.0:
  br label %_8000000.0
_7000000.0:
  br label %_9000000.0
_9000000.0:
  %_25000014 = icmp eq ptr %_2, null
  br i1 %_25000014, label %_25000011.0, label %_25000012.0
_25000011.0:
  br label %_25000013.0
_25000012.0:
  %_25000015 = load ptr, ptr %_2
  %_25000016 = icmp eq ptr %_25000015, @"_SM21java.lang.ThreadDeathG4type"
  br label %_25000013.0
_25000013.0:
  %_9000002 = phi i1 [%_25000016, %_25000012.0], [false, %_25000011.0]
  br i1 %_9000002, label %_10000000.0, label %_11000000.0
_10000000.0:
  br label %_8000000.0
_11000000.0:
  br label %_12000000.0
_12000000.0:
  %_25000020 = icmp eq ptr %_2, null
  br i1 %_25000020, label %_25000017.0, label %_25000018.0
_25000017.0:
  br label %_25000019.0
_25000018.0:
  %_25000021 = load ptr, ptr %_2
  %_25000022 = icmp eq ptr %_25000021, @"_SM30java.lang.InterruptedExceptionG4type"
  br label %_25000019.0
_25000019.0:
  %_12000002 = phi i1 [%_25000022, %_25000018.0], [false, %_25000017.0]
  br i1 %_12000002, label %_13000000.0, label %_14000000.0
_13000000.0:
  br label %_8000000.0
_14000000.0:
  br label %_15000000.0
_15000000.0:
  %_25000026 = icmp eq ptr %_2, null
  br i1 %_25000026, label %_25000023.0, label %_25000024.0
_25000023.0:
  br label %_25000025.0
_25000024.0:
  %_25000027 = load ptr, ptr %_2
  %_25000028 = getelementptr { ptr, ptr, i32, i32, ptr, ptr }, { ptr, ptr, i32, i32, ptr, ptr }* %_25000027, i32 0, i32 2
  %_25000029 = load i32, ptr %_25000028
  %_25000030 = icmp sle i32 1848, %_25000029
  %_25000031 = icmp sle i32 %_25000029, 1850
  %_25000032 = and i1 %_25000030, %_25000031
  br label %_25000025.0
_25000025.0:
  %_15000002 = phi i1 [%_25000032, %_25000024.0], [false, %_25000023.0]
  br i1 %_15000002, label %_16000000.0, label %_17000000.0
_16000000.0:
  br label %_8000000.0
_17000000.0:
  br label %_18000000.0
_18000000.0:
  %_25000036 = icmp eq ptr %_2, null
  br i1 %_25000036, label %_25000033.0, label %_25000034.0
_25000033.0:
  br label %_25000035.0
_25000034.0:
  %_25000037 = load ptr, ptr %_2
  %_25000038 = icmp eq ptr %_25000037, @"_SM35scala.util.control.ControlThrowableG4type"
  br label %_25000035.0
_25000035.0:
  %_18000002 = phi i1 [%_25000038, %_25000034.0], [false, %_25000033.0]
  br i1 %_18000002, label %_19000000.0, label %_20000000.0
_19000000.0:
  br label %_8000000.0
_20000000.0:
  br label %_21000000.0
_21000000.0:
  br label %_8000000.0
_8000000.0:
  %_8000001 = phi i1 [false, %_21000000.0], [true, %_19000000.0], [true, %_16000000.0], [true, %_13000000.0], [true, %_10000000.0], [true, %_6000000.0]
  br i1 %_8000001, label %_22000000.0, label %_23000000.0
_22000000.0:
  br label %_24000000.0
_23000000.0:
  br label %_25000000.0
_25000000.0:
  br label %_24000000.0
_24000000.0:
  %_24000001 = phi i1 [true, %_25000000.0], [false, %_22000000.0]
  call void @"scalanative_GC_yield"()
  ret i1 %_24000001
}

define void @"_SM28scala.util.control.NonFatal$RE"(ptr %_1) personality ptr @scalanative_personality {
_2000000.0:
  ret void
}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!llvm.module.flags = !{!1, !2}