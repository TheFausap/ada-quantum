with libquantum; use libquantum;
with Interfaces; use Interfaces;
with GNATCOLL.GMP.Integers; use GNATCOLL.GMP.Integers;
with GNATCOLL.GMP.Integers.IO; use GNATCOLL.GMP.Integers.IO;
with GNATCOLL.GMP.Integers.Number_Theoretic; use GNATCOLL.GMP.Integers.Number_Theoretic;
with Ada.Containers.Vectors; use Ada.Containers;
with Ada.Finalization; use Ada.Finalization;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Task_Identification; use Ada.Task_Identification;
with GNATCOLL.GMP; use GNATCOLL.GMP;
with Ada.Calendar; use Ada.Calendar;

procedure test is
   q1,q2,q3 : quantum_reg;
begin
   q1 := quantum_new_qureg(0,2);
   q2 := quantum_new_qureg(1,1);
   q3 := quantum_vectoradd(q1,q2);
   quantum_print_qureg(q3);
end;
