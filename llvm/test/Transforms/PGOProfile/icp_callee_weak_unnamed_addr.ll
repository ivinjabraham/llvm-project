; RUN: opt < %s -passes=pgo-icall-prom -icp-samplepgo -icp-allow-decls -S | FileCheck %s

; Ensure that ICP does not promote weak definitions with unnamed_addr
; since the linker may select another definition without unnamed_addr

; CHECK: define weak void @WrongSymbol() unnamed_addr
define weak void @WrongSymbol() unnamed_addr {
  ret void
}

; CHECK: declare void @RightSymbol() unnamed_addr
declare void @RightSymbol() unnamed_addr

; CHECK-LABEL: define void @caller(ptr %fp) {
; CHECK-NEXT: call void %fp()
; CHECK-NEXT: ret void
; CHECK-NEXT: }
define void @caller(ptr %fp) {
  call void %fp(), !prof !0
  ret void
}

!0 = !{!"VP", i32 0, i64 1000, i64 6010974106627529467, i64 1000}
