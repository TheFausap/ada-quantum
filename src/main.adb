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

procedure Main is
   q1,q2 : quantum_reg;
   width, swidth : Integer;
   x, dummy, d1,d2,d3 : Integer := 0;
   c, q, qq, x1 : Integer;
   N : Long_Long_Integer;
   q_u : Unsigned_64;
   G : Generator;
   pp : Float;
   ipow, a, b, factor, Nbig : Big_Integer;
   time_date: Ada.Calendar.Time;
   start,stop : Day_Duration;

   package Fix_IO is new Ada.Text_IO.Fixed_IO(Day_Duration);
   use Fix_IO;

begin
   N := 267; -- Number to factor
   quantum_qec_set_status(1,10);
   time_date := Ada.Calendar.Clock;
   Split(time_date,d1,d2,d3,start);
   Set(Nbig,Long(N));
   width := quantum_getwidth(Integer(N*N));
   swidth := quantum_getwidth(Integer(N));
   Reset(G);

   Ada.Text_IO.Put_Line("N =" & Long_Long_Integer'Image(N) & "," &
                          Integer'Image(width+3*swidth+2) &
                          " qubits required.");

   loop
      exit when quantum_gcd(Long_Long_Integer(N),Long_Long_Integer(x)) <= 1;
      exit when x >= 2;
      pp := Float(Random(G)) * 32767.0;
      x := Integer(pp) rem Integer(N);
      x1 := x;
   end loop;

   Ada.Text_IO.Put_Line("Random seed:" & Integer'Image(x1));
   Ada.Text_IO.Put_Line("Done 10%");

   q1 := quantum_new_qureg(0,width);
   for ix in 0 .. width-1 loop
      quantum_hadamard(ix,q1);
   end loop;

   Ada.Text_IO.Put_Line("Done 15%");
   --quantum_print_qureg(q1);

   quantum_addscratch(3*swidth+2,q1);

   quantum_exp_mod_n(Integer(N), x, width, swidth, q1);
   Ada.Text_IO.Put_Line("Done 20%");

   for ix in 0 .. 3*swidth+2-1 loop
      dummy := quantum_bmeasure(0,q1);
   end loop;

   Ada.Text_IO.Put_Line("Done 30%");

   quantum_qft(width, q1);

   --Ada.Text_IO.Put_Line("Size of amplitude:" & Count_Type'Image(cvector.Length(q1.amplitude)));

   for ix in 0 .. (width/2)-1 loop
      quantum_cnot(ix,width-ix-1,q1);
      quantum_cnot(width-ix-1,ix,q1);
      quantum_cnot(ix,width-ix-1,q1);
   end loop;

   Ada.Text_IO.Put_Line("Done 50%");

   c := quantum_measure(q1);

   if c = -1 then
      Ada.Text_IO.Put_Line("Impossible measurement!");
      time_date := Ada.Calendar.Clock;
      Split(time_date,d1,d2,d3,stop);
      Put("Completed in ");
      Put(stop-start,8,3,0);
      Put_Line(" seconds.");
      Abort_Task(Current_Task);
   end if;

   if c = 0 then
      Ada.Text_IO.Put_Line("Measured zero. Try again...");
      time_date := Ada.Calendar.Clock;
      Split(time_date,d1,d2,d3,stop);
      Put("Completed in ");
      Put(stop-start,8,3,0);
      Put_Line(" seconds.");
      Abort_Task(Current_Task);
   end if;

   q_u := Shift_Left(1,width);
   q := Integer(q_u);

   Ada.Text_IO.Put_Line("Measured" & Integer'Image(c) & " (" &
                          Float'Image(Float(c)/Float(q)) & " )");

   quantum_frac_approx(c,q,width);

   Ada.Text_IO.Put_Line("Done 70%");

   Ada.Text_IO.Put_Line("Fractional approximation is " & Integer'Image(c) &
                          " /" & Integer'Image(q) & ".");
   qq := Integer(q_u);
   if (q rem 2 = 1) and (2*q < qq) then
      Ada.Text_IO.Put_Line("Odd denominator, trying to expand by 2.");
      q := q * 2;
   end if;

   if (q rem 2 = 1) then
      Ada.Text_IO.Put_Line("Odd period, try again.");
      time_date := Ada.Calendar.Clock;
      Split(time_date,d1,d2,d3,stop);
      Put("Completed in ");
      Put(stop-start,8,3,0);
      Put_Line(" seconds.");
      Abort_Task(Current_Task);
   end if;

   Ada.Text_IO.Put_Line("Possible period is " & Integer'Image(q));

   Set(ipow,Long(x1));
   Raise_To_N(ipow,Unsigned_Long(q/2));

   Put_Line(Integer'Image(x1) & "^" & Integer'Image(q/2));

   Set(a,ipow+1);
   Set(b,ipow-1);
   --a := quantum_ipow(x1,q/2) + Long_Long_Integer(1);
   --b := quantum_ipow(x1,q/2) - Long_Long_Integer(1);

   Set(a, a rem Nbig);
   Set(b, b rem Nbig);

   --a := quantum_rem(a,N);
   --b := quantum_rem(b,N);

   Get_GCD(Nbig,a,a);
   Get_GCD(Nbig,b,b);

   Ada.Text_IO.Put_Line("Done 90%");

   --a := quantum_gcd(Long_Long_Integer(N), a);
   --b := quantum_gcd(Long_Long_Integer(N), b);

   --Ada.Text_IO.Put("a : ");
   --Put(a);
   --New_Line;
   --Ada.Text_IO.Put("b : ");
   --Put(b);
   --New_Line;

   if a > b then
      Set(factor,a);
      --factor := a;
   else
      Set(factor,b);
      --factor := b;
   end if;

   if factor < Nbig and factor > 1 then

      Ada.Text_IO.Put(Long_Long_Integer'Image(N) & " = ");
      Put(factor);
      Put(" * ");
      Put(Nbig/factor);
      Put_Line(" ");

      New_Line;
   else
      Ada.Text_IO.Put_Line("Unable to determine factors, try again.");
      time_date := Ada.Calendar.Clock;
      Split(time_date,d1,d2,d3,stop);
      Put("Completed in ");
      Put(stop-start,8,3,0);
      Put_Line(" seconds.");
      Abort_Task(Current_Task);
   end if;

   time_date := Ada.Calendar.Clock;
   Split(time_date,d1,d2,d3,stop);
   Put("Completed in ");
   Put(stop-start,8,3,0);
   Put_Line(" seconds.");
   quantum_copy_qureg(q1,q2);
   quantum_delete_qureg(q1);

end Main;

