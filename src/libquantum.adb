with Ada.Containers.Vectors;
with System; use System;
with Interfaces;
with Ada.Text_IO;
use Ada.Containers; use Interfaces;
with Ada.Numerics.Float_Random; use Ada.Numerics.Float_Random;
with Ada.Task_Identification; use Ada.Task_Identification;
with Ada.Numerics.Generic_Elementary_Functions;
with System.Address_Image;

package body libquantum is

   Main_Task : Task_ID := Current_Task;
   package FGF is new Ada.Numerics.Generic_Elementary_Functions(Float);

   function quantum_cexp(a : in Float) return Complex is
   begin
      return( (FGF.Cos(a),FGF.Sin(a)) );
   end quantum_cexp;

   function quantum_prob_inline(a : Complex) return Float is
   begin
      return(a.Re * a.Re + a.Im * a.Im);
   end quantum_prob_inline;

   function quantum_rem(a, b : in Long_Long_Integer) return Long_Long_Integer is
      r, r_div : Long_Long_Integer;
   begin
      r_div := a / b;
      r := a - b*r_div;
      return(r);
   end quantum_rem;

   function quantum_ipow(a, b : in Integer) return Long_Long_Integer is
      r : Long_Long_Integer := 1;
   begin
      Ada.Text_IO.Put_Line("Integer pow:" & Integer'Image(a) &
                             "^" & Integer'Image(b));
      for ix in 0 .. b-1 loop
         r := r * Long_Long_Integer(a);
         --Ada.Text_IO.Put_Line("partial res: " & Long_Integer'Image(r));
      end loop;
      return(r);
   end quantum_ipow;

   function quantum_gcd(u, v : in Long_Long_Integer) return Long_Long_Integer is
      l_r : Long_Long_Integer;
      l_u : Long_Long_Integer := u;
      l_v : Long_Long_Integer := v;
   begin
      while l_v /= Long_Long_Integer(0) loop
         l_r := l_u rem l_v;
         l_u := l_v;
         l_v := l_r;
      end loop;
      return(l_u);
   end quantum_gcd;

   procedure quantum_frac_approx(a, b : in out Integer; width : in Integer) is
      f : Float := Float(a) / Float(b);
      g : Float := f;
      i, num2, den1, num, den : Integer := 0;
      num1, den2 : Integer := 1;
      pp : Unsigned_64 := Shift_Left(1,width);
   begin
      loop
         i := Integer(g+0.000005);
         g := g - (Float(i) - 0.000005);
         g := 1.0/g;

         if (i * den1 + den2 > Integer(pp)) then
            exit;
         end if;

         num := i * num1 + num2;
         den := i * den1 + den2;

         num2 := num1;
         den2 := den1;
         num1 := num;
         den1 := den;

         exit when abs(Float(num)/Float(den) - f) <= 1.0/(2.0*Float(pp));
      end loop;

      a := abs(num);
      b := abs(den);
   end quantum_frac_approx;

   function quantum_getwidth(n : in Integer) return Integer is
      r : Integer := 0;
   begin
      loop
         r := r + 1;
         exit when Shift_Left(1,r) > Unsigned_64(n);
      end loop;

      return(r);
   end quantum_getwidth;

   function quantum_inverse_mod(n,c : in Integer) return Integer is
      r : Integer := 0;
   begin
      loop
         r := r + 1;
         exit when ((r*c) rem n) /= 1;
      end loop;
      return(r);
   end quantum_inverse_mod;

   function quantum_get_decoherence return Float is
   begin
      return quantum_lambda;
   end quantum_get_decoherence;

   procedure quantum_set_decoherence(l : in Float) is
   begin
      quantum_status := 1;
      quantum_lambda := l;
   end quantum_set_decoherence;

   procedure quantum_decohere(reg : in out quantum_reg) is
      G : Generator;
      prob : Uniformly_Distributed;
      u,v,s,x : Float;
      angle : Float;
      nrands : fvector.Vector;
   begin
      if quantum_status /= 0 then
         fvector.Set_Length(nrands,Count_Type(reg.width));
         for ix in 0 .. reg.width-1 loop
            loop
               Reset(G);
               prob := Random(G);
               u := 2.0 * prob - 1.0;
               prob := Random(G);
               v := 2.0 * prob - 1.0;
               s := u*u + v*v;
               exit when s < 1.0;
            end loop;

            x := u * FGF.Sqrt(-2.0 * FGF.Log(s) / s);
            x := x * FGF.Sqrt(2.0 * quantum_lambda);

            nrands(ix) := x/2.0;
         end loop;
         for ix in 0 .. reg.size-1 loop
            angle := 0.0;
            for iy in 0 .. reg.width-1 loop
               if (reg.state(ix) and Shift_Left(1,iy)) /= 0 then
                  angle := angle + nrands(iy);
               else
                  angle := angle - nrands(iy);
               end if;
            end loop;
            reg.amplitude(ix) := quantum_cexp(angle);
         end loop;
      end if;
   end quantum_decohere;

   procedure quantum_qec_set_status(stype, swidth : in Integer) is
   begin
      qec_type := stype;
      qec_width := swidth;
   end quantum_qec_set_status;

   procedure quantum_qec_get_status(ptype, pwidth : out Integer) is
   begin
      ptype := qec_type;
      pwidth := qec_width;
   end quantum_qec_get_status;

   function quantum_state_collapse(pos : in Integer; value : in Integer;
                                   reg : in quantum_reg) return quantum_reg is
      j : Integer := 0;
      size : Integer := 0;
      d : Float := 0.0;
      lpat, rpat : Unsigned_64 := 0;
      pos2 : Unsigned_64;
      out_reg : quantum_reg;
      value_b, state_b : Boolean := False;
   begin
      pos2 := Shift_Left(1,pos);
      if value /= 0 then
         value_b := True;
      end if;

      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and pos2) /= 0 then
            state_b := True;
         end if;

         if (state_b and value_b) or ((not state_b) and (not value_b)) then
            d := d + quantum_prob_inline(reg.amplitude(ix));
            size := size + 1;
         end if;
      end loop;

      out_reg.width := reg.width - 1;
      out_reg.size := size;
      cvector.Set_Length(out_reg.amplitude,Count_Type(size));
      state_vector.Set_Length(out_reg.state,Count_Type(size));

      out_reg.hashw := reg.hashw;
      out_reg.hash := reg.hash;

      j:=0;
      state_b := False;
      value_b := False;
      if value /= 0 then
         value_b := True;
      end if;
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and pos2) /= 0 then
            state_b := True;
         end if;
         if (state_b and value_b) or ((not state_b) and (not value_b)) then
            rpat := 0;
            for k in 0 .. pos-1 loop
               rpat := rpat + Shift_Left(1,k);
            end loop;
            rpat := rpat and reg.state(ix);
            for k in reverse pos+1 .. 64*8-1 loop
               lpat := lpat + Shift_Left(1,k);
            end loop;
            lpat := lpat and reg.state(ix);
            out_reg.state(j) := Shift_Right(lpat,1) or rpat;
            out_reg.amplitude(j) := reg.amplitude(ix) * (1.0/FGF.Sqrt(d),0.0);

            j := j + 1;
         end if;
      end loop;

      return(out_reg);
   end quantum_state_collapse;

   function quantum_new_matrix(cols, rows : in Integer) return quantum_matrix is
      m : quantum_matrix;
      siz : Integer := rows*cols;
      czero : Complex := (0.0,0.0);
   begin
      m.rows := rows;
      m.cols := cols;
      cvector.Set_Length(m.t,Count_Type(siz));
      for ix in 0..(rows*cols)-1 loop
         m.t(ix) := czero;
      end loop;
      return(m);
   end quantum_new_matrix;


   function quantum_hash64(key : in Unsigned_64; width : in Integer)
                           return Unsigned_32 is
      k32 : Unsigned_32;
      kk : Unsigned_32 := 16#9e370001#;
   begin
      k32 := Unsigned_32((key and 16#FFFFFFFF#) xor Shift_Right(key,32));
      k32 := k32 * kk;
      k32 := Shift_Right(k32,(32-width));
      return(k32);
   end quantum_hash64;

   procedure quantum_add_hash(a : in Unsigned_64; pos : in Integer;
                              reg : in out quantum_reg) is
      mark : Integer := 0;
      i : Unsigned_32 := 0;
      --reg : quantum_reg := l_reg;
   begin
      i := quantum_hash64(a, reg.hashw);
      --Ada.Text_IO.Put_Line("Hash value: " & Unsigned_32'Image(i));
      while (reg.hash(Natural(i)) /= 0) loop
         --Ada.Text_IO.Put_Line("Hash value: " & Unsigned_32'Image(i));
         i := i + 1;
         if (i = Shift_Left(1,reg.hashw)) then
            if (mark = 0) then
               i := 0;
               mark := 1;
            else
               Ada.Text_IO.Put_Line("HASH FULL... Aborting application");
               Abort_Task(Main_Task);
            end if;
         end if;
      end loop;
      reg.hash(Natural(i)) := pos + 1;
      --quantum_print_qureg(reg);
      --l_reg := reg;
   end quantum_add_hash;

   function quantum_get_state(a : in Unsigned_64; reg : in quantum_reg)
                              return Integer is
      i : Unsigned_32;
   begin
      i := quantum_hash64(a, reg.hashw);
      while (reg.hash(Natural(i)) /= 0) loop
         if (reg.state(reg.hash(Natural(i))-1) = a) then
            return(reg.hash(Natural(i))-1);
         end if;
         i := i + 1;
         if (i = Shift_Left(1,reg.hashw)) then
            i := 0;
         end if;
      end loop;
      return (-1);
   end quantum_get_state;

   procedure quantum_reconstruct_hash(reg : in out quantum_reg) is
      hash_size : Unsigned_64 := Shift_Left(1,reg.hashw);
      ix : Integer := 0;
      --reg : quantum_reg := l_reg;
   begin
      --Ada.Text_IO.Put_Line("Starting Hash reconstruction...");
      for ix in 0 .. Natural(hash_size)-1 loop
         reg.hash(ix) := 0;
      end loop;
      --Ada.Text_IO.Put_Line("Adding hash... with size = " & Natural'Image(reg.size));
      while (ix < reg.size) loop
         quantum_add_hash(reg.state(ix),ix,reg);
         ix := ix + 1;
      end loop;
      --Ada.Text_IO.Put_Line("Finished.");
      --l_reg := reg;
   end quantum_reconstruct_hash;

   function quantum_new_qureg(initval : Unsigned_64; width: Integer)
   return quantum_reg is
      reg : quantum_reg;
      hash_size : Unsigned_64;
   begin
      reg.width := width;
      reg.size := 1;
      reg.hashw := width + 2;
      hash_size := Shift_Left(1,reg.hashw);
      state_vector.Set_Length(Container => reg.state, Length => 1);
      cvector.Set_Length(Container => reg.amplitude, Length => 1);
      ivector.Set_Length(Container => reg.hash, Length => Count_Type(hash_size));
      reg.state(0) := initval;
      reg.amplitude(0) := (1.0,0.0);
      return(reg);
   end quantum_new_qureg;

   function quantum_new_qureg_size(n: Integer; width : Integer)
                                   return quantum_reg is
      reg : quantum_reg;
   begin
      reg.width := width;
      reg.size := n;
      reg.hashw := 0;
      reg.hash := ivector.Empty_Vector;
      reg.state := state_vector.Empty_Vector;
      cvector.Set_Length(Container => reg.amplitude, Length => Count_Type(n));
      return(reg);
   end quantum_new_qureg_size;

   function quantum_new_qureg_sparse(n : Integer; width : Integer)
                                     return quantum_reg is
      reg : quantum_reg;
   begin
      reg.width := width;
      reg.size := n;
      reg.hashw := 0;
      reg.hash := ivector.Empty_Vector;
      cvector.Set_Length(Container => reg.amplitude, Length => Count_Type(n));
      state_vector.Set_Length(Container => reg.state, Length => Count_Type(n));
      return(reg);
   end quantum_new_qureg_sparse;

   procedure quantum_destroy_hash(l_reg : in out quantum_reg) is
      reg : quantum_reg := l_reg;
   begin
      reg.hash := ivector.Empty_Vector;
      l_reg := reg;
   end quantum_destroy_hash;

   procedure quantum_delete_qureg(l_reg : in out quantum_reg) is
      reg : quantum_reg := l_reg;
   begin
      quantum_destroy_hash(reg);
      reg.amplitude := cvector.Empty_Vector;
      reg.state := state_vector.Empty_Vector;
      l_reg := reg;
   end quantum_delete_qureg;

   procedure quantum_delete_qureg_hashpreserve(l_reg : in out quantum_reg) is
      reg : quantum_reg := l_reg;
   begin
      reg.amplitude := cvector.Empty_Vector;
      reg.state := state_vector.Empty_Vector;
      l_reg := reg;
   end quantum_delete_qureg_hashpreserve;

   function quantum_bmeasure(pos : in Integer; reg : in out quantum_reg)
                             return Integer is
      result : Integer := 0;
      pa : Float := 0.0;
      r : Uniformly_Distributed;
      G : Generator;
      pos2 : Unsigned_64;
      out_reg : quantum_reg;
   begin
      pos2 := Shift_Left(1,pos);
      Reset(G);
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and pos2) = 0 then
            pa := pa + quantum_prob_inline(reg.amplitude(ix));
         end if;
      end loop;

      r := Random(G);

      if (Float(r) > pa) then
         result := 1;
      end if;

      out_reg := quantum_state_collapse(pos, result, reg);

      quantum_delete_qureg_hashpreserve(reg);

      reg := out_reg;
      return(result);

   end quantum_bmeasure;

   function quantum_measure(reg : in out quantum_reg) return Integer is
      G : Generator;
      r : Ada.Numerics.Float_Random.Uniformly_Distributed;
      r1 : Float := 0.0;
      state : Unsigned_64;
   begin
      Reset(G);
      r := Random(G);
      r1 := Float(r);
      --Ada.Text_IO.Put_Line("Calling a measure with size" & Integer'Image(reg.size));
      for ix in 0 .. reg.size-1 loop
         --Ada.Text_IO.Put_Line("Extracting prob - elem:" & Integer'Image(ix));
         r1 := r1 - quantum_prob_inline(reg.amplitude(ix));
         if (0.0 >= r1) then
            state := reg.state(ix);
            return(Integer(state));
         end if;
      end loop;

      return(-1);
   end quantum_measure;

   function quantum_bmeasure_bitpreserve(pos : in Integer;
                                         reg : in out quantum_reg)
                                         return Integer is
      result, size, j : Integer := 0;
      result_b : Boolean := False;
      pa, d : Float := 0.0;
      r : Uniformly_Distributed;
      G : Generator;
      pos2 : Unsigned_64;
      out_reg : quantum_reg;
   begin
      pos2 := Shift_Left(1,pos);
      Reset(G);
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and pos2) = 0 then
            pa := pa + quantum_prob_inline(reg.amplitude(ix));
         end if;
      end loop;

      r := Random(G);

      if (Float(r) > pa) then
         result := 1;
      end if;

      if result /= 0 then
         result_b := True;
      end if;

      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and pos2) /= 0 then
            if (not result_b) then
               reg.amplitude(ix) := (0.0,0.0);
            else
               d := d + quantum_prob_inline(reg.amplitude(ix));
               size := size + 1;
            end if;
         else
            if result_b then
               reg.amplitude(ix) := (0.0,0.0);
            else
               d := d + quantum_prob_inline(reg.amplitude(ix));
               size := size + 1;
            end if;
         end if;
      end loop;

      out_reg.size := size;
      state_vector.Set_Length(out_reg.state,Count_Type(size));
      cvector.Set_Length(out_reg.amplitude,Count_Type(size));
      out_reg.hashw := reg.hashw;
      out_reg.hash := reg.hash;
      out_reg.width := reg.width;

      j:= 0;
      for ix in 0 .. reg.size-1 loop
         if reg.amplitude(ix) /= (0.0,0.0) then
            pos2 := reg.state(ix);
            out_reg.state(j) := pos2;
            out_reg.amplitude(j) := reg.amplitude(ix) * (1.0/FGF.Sqrt(d),0.0);
            j := j + 1;
         end if;
      end loop;

      quantum_delete_qureg_hashpreserve(reg);

      reg := out_reg;
      return(result);
   end quantum_bmeasure_bitpreserve;


   procedure quantum_print_qureg(reg : in quantum_reg) is
      sval : Unsigned_64;
      sval_bool : Boolean;
      pval : Float;
   begin
      for ix in 0 .. reg.size-1 loop
         pval := quantum_prob_inline(reg.amplitude(ix));
         Ada.Text_IO.Put(" " & Float'Image(reg.amplitude(ix).Re) &
                           Float'Image(reg.amplitude(ix).Im) & "i" &
                           "|" & Unsigned_64'Image(reg.state(ix)) &
                           "> (" & Float'Image(pval));
         for iy in reverse 0 .. reg.width-1 loop
            if (iy rem 4 = 3) then
               Ada.Text_IO.Put(" ");
            end if;
            sval := Shift_Left(1,iy) and reg.state(ix);
            sval_bool := sval > 0;

            if sval_bool = False then
               sval := 0;
            else
               sval := 1;
            end if;

            Ada.Text_IO.Put(Unsigned_64'Image(sval));
         end loop;
         Ada.Text_IO.Put_Line("> )");
      end loop;
      Ada.Text_IO.New_Line;
   end quantum_print_qureg;

   procedure quantum_addscratch(bits : in Integer; l_reg : in out quantum_reg) is
      l : Unsigned_64;
      reg : quantum_reg := l_reg;
   begin
      reg.width := reg.width + bits;
      for ix in 0 .. reg.size-1 loop
         l := Shift_Left(reg.state(ix),bits);
         reg.state(ix) := l;
      end loop;
      l_reg := reg;
   end quantum_addscratch;

   procedure quantum_print_hash(reg : in quantum_reg) is
      hash_size : Unsigned_64 := Shift_Left(1,reg.hashw);
   begin
      for ix in 0 .. Natural(hash_size)-1 loop
         if (ix /= 0) then
            Ada.Text_IO.Put_Line(Integer'Image(reg.hash(ix)-1));
            Ada.Text_IO.Put_Line(Natural'Image(ix) & ":" &
                                   Integer'Image(reg.hash(ix)-1) &
                                   Unsigned_64'Image(reg.state(reg.hash(ix)-1)));
         end if;
      end loop;
   end quantum_print_hash;

   function quantum_matrix2qureg(m : qmatrix_ref; width : Integer)
                                 return quantum_reg is
      reg : quantum_reg;
      hash_s : Unsigned_64;
      hash_size, size, j : Integer := 0;
      t1 : Complex;
   begin
      if (m.all.cols /= 1) then
         Ada.Text_IO.Put_Line("Error: we need a vector, not a matrix");
         Abort_Task(Main_Task);
      end if;

      reg.width := width;

      for ix in 0 .. m.all.rows-1 loop
         if (m.all.t(ix) /= (0.0,0.0)) then
            size := size + 1;
         end if;
      end loop;

      Ada.Text_IO.Put_Line("The size is :" & Integer'Image(size));

      reg.size := size;

      reg.hashw := width + 2;
      hash_s := Shift_Left(1,reg.hashw);
      hash_size := Natural(hash_s);

      cvector.Set_Length(Container => reg.amplitude, Length => Count_Type(size));
      state_vector.Set_Length(Container => reg.state, Length => Count_Type(size));
      ivector.Set_Length(Container => reg.hash, Length => Count_Type(hash_size));

      for ix in 0 .. m.all.rows-1 loop
         if (m.all.t(ix) /= (0.0,0.0)) then
            reg.state(j) := Unsigned_64(ix);
            t1 := m.all.t(ix);
            reg.amplitude(j) := t1;
            j := j + 1;
         end if;
      end loop;
      return(reg);
   end quantum_matrix2qureg;

   procedure quantum_scalar_qureg(c : in Complex; reg : in out quantum_reg) is
   begin
      for ix in 0 .. reg.size-1 loop
         reg.amplitude(ix) := reg.amplitude(ix) * c;
      end loop;
   end quantum_scalar_qureg;

   function quantum_kronecker(reg1, reg2 : in quantum_reg) return quantum_reg is
      reg : quantum_reg;
      hsiz : Unsigned_64;
   begin
      reg.width := reg1.width + reg2.width;
      reg.size := reg1.size * reg2.size;
      reg.hashw := reg.width + 2;
      hsiz := Shift_Left(1,reg.hashw);
      cvector.Set_Length(reg.amplitude,Count_Type(reg.size));
      state_vector.Set_Length(reg.state,Count_Type(reg.size));
      ivector.Set_Length(reg.hash,Count_Type(hsiz));
      for ix in 0 .. reg1.size-1 loop
         for iy in 0 .. reg2.size-1 loop
            reg.state(ix*reg2.size+iy) := Shift_Left(reg1.state(ix),reg2.width)
              or reg2.state(iy);
            reg.amplitude(ix*reg2.size+iy) := reg1.amplitude(ix) *
              reg2.amplitude(iy);
         end loop;
      end loop;
      return(reg);
   end quantum_kronecker;

   function quantum_dot_product(reg1, reg2 : in out quantum_reg) return Complex is
      f : Complex := (0.0,0.0);
      j : Integer;
   begin
      if reg2.hashw /= 0 then
         quantum_reconstruct_hash(reg2);
      end if;

      for ix in 0 .. reg1.size-1 loop
         if reg1.state(ix) /= 0 then
            j := quantum_get_state(reg1.state(ix), reg2);
            if j > -1 then
               f := f + Conjugate(reg1.amplitude(ix))*reg2.amplitude(j);
            end if;
         else
            j := quantum_get_state(Unsigned_64(ix), reg2);
            if j > -1 then
               f := f + Conjugate(reg1.amplitude(ix))*reg2.amplitude(j);
            end if;
         end if;
         end loop;
      return(f);
   end quantum_dot_product;

   function quantum_vectoradd(reg1, reg2 : in out quantum_reg) return quantum_reg is
      reg : quantum_reg;
      addsize,k,j : Integer := 0;
      reg2state : Boolean := False;
      reg2siz : Integer;
      p1 : Unsigned_64;
      p2 : Complex;
   begin
      quantum_copy_qureg(reg1,reg);
      if reg1.hashw /= 0 or reg2.hashw /= 0 then
         quantum_reconstruct_hash(reg1);
         quantum_copy_qureg(reg1,reg);
      end if;

      for ix in 0 .. reg2.size-1 loop
         if quantum_get_state(reg2.state(ix),reg1) = -1 then
            addsize := addsize + 1;
         end if;
      end loop;

      if addsize /= 0 then
         reg.size := reg.size + addsize;
         cvector.Set_Length(reg.amplitude,Count_Type(reg.size));
         state_vector.Set_Length(reg.state,Count_Type(reg.size));
      end if;

      k := reg1.size;
      reg2siz := Integer(state_vector.Length(reg2.state));

      for ix in 0 .. reg2siz-1 loop
         if reg2.state(ix) /= 0 then
            reg2state := True;
            exit;
         end if;
      end loop;

      if not reg2state then
         for ix in 0 .. reg2.size-1 loop
            reg.amplitude(ix) := reg.amplitude(ix) + reg2.amplitude(ix);
         end loop;
      else
         for ix in 0 .. reg2.size-1 loop
            j := quantum_get_state(reg2.state(ix),reg1);
            if j >= 0 then
               reg.amplitude(j) := reg.amplitude(j) + reg2.amplitude(ix);
            else
               p1 := reg2.state(ix);
               reg.state(k) := p1;
               p2 := reg2.amplitude(ix);
               reg.amplitude(k) := p2;
               k := k + 1;
            end if;
         end loop;
      end if;
      return(reg);
   end quantum_vectoradd;

   procedure quantum_copy_qureg(src : in quantum_reg; dst : out quantum_reg) is
   begin
      dst := src;
      Ada.Text_IO.Put_Line(System.Address_Image(dst'Address));
      Ada.Text_IO.Put_Line(System.Address_Image(src'Address));
      Ada.Text_IO.Put_Line(Integer'Image(dst.size));
      Ada.Text_IO.Put_Line(Integer'Image(src.size));
   end quantum_copy_qureg;


   procedure quantum_normalize(reg : in out quantum_reg) is
      r : Float := 0.0;
   begin
      for ix in 0 .. reg.size-1 loop
         r := r + quantum_prob_inline(reg.amplitude(ix));
      end loop;
      quantum_scalar_qureg((1.0/FGF.Sqrt(r),0.0),reg);
   end quantum_normalize;

   procedure quantum_gate1(target: in Integer; m : in quantum_matrix;
                           reg : in out quantum_reg) is
      j, k, iset : Integer;
      addsize, decsize : Integer := 0;
      t, tnot, t2 : Complex := (0.0,0.0);
      limit : Float;
      done : ivector.Vector;
      iset_b : Boolean := False;
      width_size, hash_size, t1 : Unsigned_64;
   begin
      if (m.cols /= 2) or (m.rows /= 2) then
         Ada.Text_IO.Put_Line("Error in matrix dimensions. Aborting");
         Abort_Task(Main_Task);
      end if;

      if reg.hashw /= 0 then
         quantum_reconstruct_hash(reg);
         for ix in 0 .. reg.size-1 loop
            --Ada.Text_IO.Put_Line("Finding the quantum state...");
            if quantum_get_state((reg.state(ix) xor Shift_Left(1,target)),
                                 reg) = -1 then
               addsize := addsize + 1;
            end if;
         end loop;
         state_vector.Set_Length(reg.state,Count_Type(reg.size+addsize));
         cvector.Set_Length(reg.amplitude,Count_Type(reg.size+addsize));

         for ix in 0 .. addsize-1 loop
            reg.state(ix+reg.size) := 0;
            reg.amplitude(ix+reg.size) := (0.0,0.0);
         end loop;
      end if;

      ivector.Set_Length(done,Count_Type(reg.size+addsize));
      for ix in 0..(reg.size+addsize)-1 loop
         done(ix) := 0;
      end loop;

      k := reg.size;
      width_size := Shift_Left(1,reg.width);
      limit := (1.0 / Float(width_size)) * 0.0000001;

      for ix in 0 .. reg.size-1 loop
         if (done(ix) = 0) then
            iset := Natural(reg.state(ix) and Shift_Left(1,target));
            tnot := (0.0,0.0);
            j := quantum_get_state((reg.state(ix) xor Shift_Left(1,target)),
                                   reg);
            if j >= 0 then
               tnot := reg.amplitude(j);
            end if;

            t := reg.amplitude(ix);

            if (iset /= 0) then
               reg.amplitude(ix) := m.t(2) * tnot + m.t(3) * t;
            else
               reg.amplitude(ix) := m.t(0) * t + m.t(3) * tnot;
            end if;

            if (j >= 0) then
               if (iset /= 0) then
                  reg.amplitude(j) := m.t(0) * tnot + m.t(1) * t;
               else
                  reg.amplitude(j) := m.t(2) * t + m.t(3) * tnot;
               end if;
            else
               if iset /= 0 then
                  iset_b := True;
               end if;
               if (m.t(1) = (0.0,0.0)) and iset_b then
                  exit;
               end if;
               if (m.t(2) = (0.0,0.0)) and (not iset_b) then
                  exit;
               end if;
               reg.state(k) := reg.state(ix) xor Shift_Left(1,target);
               if iset_b then
                  reg.amplitude(k) := m.t(1) * t;
               else
                  reg.amplitude(k) := m.t(2) * t;
               end if;
               k := k + 1;
            end if;
            if (j >= 0) then
               done(j) := 1;
            end if;
         end if;
      end loop;
      reg.size := reg.size + addsize;

      if (reg.hashw /= 0) then
         j := 0;
         for ix in 0 .. reg.size-1 loop
            if (quantum_prob_inline(reg.amplitude(ix)) < limit) then
               j := j + 1;
               decsize := decsize + 1;
            else if (j /= 0) then
                  t1 := reg.state(ix);
                  t2 := reg.amplitude(ix);
                  reg.state(ix-j) := t1;
                  reg.amplitude(ix-j) := t2;
               end if;
            end if;
         end loop;
         if (decsize /= 0) then
            reg.size := reg.size - decsize;
            cvector.Set_Length(reg.amplitude,Count_Type(reg.size));
            state_vector.Set_Length(reg.state,Count_Type(reg.size));
         end if;
      end if;
      hash_size := Shift_Left(1,reg.hashw-1);
      if (reg.size > Natural(hash_size)) then
         Ada.Text_IO.Put_Line("Inefficient hash table (size" &
                                Integer'Image(reg.size) &
                                " vs hash" & Integer'Image(reg.hashw) & " )");
      end if;
      quantum_decohere(reg);
   end quantum_gate1;

   procedure quantum_hadamard(target : in Integer; reg : in out quantum_reg) is
      m : quantum_matrix;
      cc : Complex := (FGF.Sqrt(1.0/2.0),0.0);
   begin
      --Ada.Text_IO.Put_Line("Building Hadamard gate...");
      m := quantum_new_matrix(2,2);
      m.t(0) := cc;
      m.t(1) := cc;
      m.t(2) := cc;
      m.t(3) := -cc;
      --Ada.Text_IO.Put_Line("Calling gate construction...");
      quantum_gate1(target, m, reg);
   end quantum_hadamard;

   procedure quantum_walsh(width : in Integer; reg : in out quantum_reg) is
   begin
      for ix in 0 .. width-1 loop
         quantum_hadamard(ix,reg);
      end loop;
   end quantum_walsh;

   procedure quantum_r_x(target : in Integer; gamma : in Float;
                         reg : in out quantum_reg) is
      m : quantum_matrix;
   begin
      m := quantum_new_matrix(2,2);
      m.t(0) := (FGF.Cos(gamma/2.0),0.0);
      m.t(3) := (FGF.Cos(gamma/2.0),0.0);
      m.t(1) := (0.0,-FGF.Sin(gamma/2.0));
      m.t(2) := (0.0,-FGF.Sin(gamma/2.0));

      quantum_gate1(target, m, reg);
   end quantum_r_x;

   procedure quantum_r_y(target : in Integer; gamma : in Float;
                         reg : in out quantum_reg) is
      m : quantum_matrix;
   begin
      m := quantum_new_matrix(2,2);
      m.t(0) := (FGF.Cos(gamma/2.0),0.0);
      m.t(3) := (FGF.Cos(gamma/2.0),0.0);
      m.t(1) := (-FGF.Sin(gamma/2.0),0.0);
      m.t(2) := (-FGF.Sin(gamma/2.0),0.0);

      quantum_gate1(target, m, reg);
   end quantum_r_y;

   procedure quantum_r_z(target : in Integer; gamma : in Float;
                         reg : in out quantum_reg) is
      z : Complex := quantum_cexp(gamma/2.0);
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
            reg.amplitude(ix) := reg.amplitude(ix) * z;
         else
            reg.amplitude(ix) := reg.amplitude(ix) / z;
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_r_z;

   procedure quantum_phase_scale(target : in Integer; gamma : in Float;
                         reg : in out quantum_reg) is
      z : Complex := quantum_cexp(gamma);
   begin
      for ix in 0 .. reg.size-1 loop
         reg.amplitude(ix) := reg.amplitude(ix) * z;
      end loop;
      quantum_decohere(reg);
   end quantum_phase_scale;

   procedure quantum_phase_kick(target : in Integer; gamma : in Float;
                         reg : in out quantum_reg) is
      z : Complex := quantum_cexp(gamma);
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
            reg.amplitude(ix) := reg.amplitude(ix) * z;
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_phase_kick;

   procedure quantum_cond_phase(control: in Integer; target : in Integer;
                                reg : in out quantum_reg) is
      z1 : Unsigned_64 := Shift_Left(1,(control-target));
      z : Complex := quantum_cexp(Ada.Numerics.Pi /
                                    Float(z1));
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,control)) /= 0 then
            if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
               reg.amplitude(ix) := reg.amplitude(ix) * z;
            end if;
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_cond_phase;

   procedure quantum_cond_phase_inv(control: in Integer; target : in Integer;
                                    reg : in out quantum_reg) is
      z1 : Unsigned_64 := Shift_Left(1,(control-target));
      z : Complex := quantum_cexp(-Ada.Numerics.Pi /
                                    Float(z1));
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,control)) /= 0 then
            if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
               reg.amplitude(ix) := reg.amplitude(ix) * z;
            end if;
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_cond_phase_inv;

   procedure quantum_cond_phase_kick(control: in Integer; target : in Integer;
                                     gamma : in Float;
                                    reg : in out quantum_reg) is
      z : Complex := quantum_cexp(gamma);
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,control)) /= 0 then
            if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
               reg.amplitude(ix) := reg.amplitude(ix) * z;
            end if;
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_cond_phase_kick;

   procedure quantum_cond_phase_shift(control: in Integer; target : in Integer;
                                     gamma : in Float;
                                    reg : in out quantum_reg) is
      z : Complex := quantum_cexp(gamma/2.0);
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,control)) /= 0 then
            if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
               reg.amplitude(ix) := reg.amplitude(ix) * z;
            else
               reg.amplitude(ix) := reg.amplitude(ix) / z;
            end if;
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_cond_phase_shift;

   procedure quantum_sigma_z(target : in Integer; reg : in out quantum_reg) is
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
            reg.amplitude(ix) := reg.amplitude(ix) * (-1.0,0.0);
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_sigma_z;

   procedure quantum_sigma_y(target : in Integer; reg : in out quantum_reg) is
   begin
      for ix in 0 .. reg.size-1 loop
         reg.state(ix) := reg.state(ix) xor Shift_Left(1,target);

         if (reg.state(ix) and Shift_Left(1,target)) /= 0 then
            reg.amplitude(ix) := reg.amplitude(ix) * (0.0,1.0);
         else
            reg.amplitude(ix) := reg.amplitude(ix) * (0.0,-1.0);
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_sigma_y;

   procedure quantum_cnot_noft(control : in Integer; target : in Integer;
                          reg : in out quantum_reg) is
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,control)) /= 0 then
            reg.state(ix) := reg.state(ix) xor Shift_Left(1,target);
         end if;
      end loop;
   end quantum_cnot_noft;

   procedure quantum_qec_encode(typ : in Integer; width : in Integer;
                                reg : in out quantum_reg) is
      lambda : Float;
   begin
      lambda := quantum_get_decoherence;
      quantum_set_decoherence(0.0);
      for ix in 0 .. reg.width-1 loop
         if ix = reg.width-1 then
            quantum_set_decoherence(lambda);
         end if;
         if ix < width then
            quantum_hadamard(reg.width+ix,reg);
            quantum_hadamard(2*reg.width+ix,reg);

            quantum_cnot_noft(reg.width+ix,ix,reg);
            quantum_cnot_noft(2*reg.width+ix,ix,reg);
         else
            quantum_cnot_noft(ix,reg.width+ix,reg);
            quantum_cnot_noft(ix,2*reg.width+ix,reg);
         end if;
      end loop;
      quantum_qec_set_status(1, reg.width);

      reg.width := reg.width * 3;
   end quantum_qec_encode;

   procedure quantum_qec_decode(typ : in Integer; width : in Integer;
                                reg : in out quantum_reg) is
      a, b : Integer;
      swidth : Integer;
      lambda : Float;
   begin
      lambda := quantum_get_decoherence;
      quantum_set_decoherence(0.0);

      swidth := reg.width / 3;

      quantum_qec_set_status(0,0);

      for ix in reverse 0 .. reg.width/3-1 loop
         if ix = 0 then
            quantum_set_decoherence(lambda);
         end if;

         if ix < width then
            quantum_cnot_noft(2*swidth+ix,ix,reg);
            quantum_cnot_noft(swidth+ix,ix,reg);

            quantum_hadamard(2*swidth+ix,reg);
            quantum_hadamard(swidth+ix,reg);
         else
            quantum_cnot_noft(ix, 2*swidth+ix,reg);
            quantum_cnot_noft(ix, swidth+ix,reg);
         end if;
      end loop;

      for ix in 1 .. swidth loop
         a := quantum_bmeasure(swidth,reg);
         b := quantum_bmeasure(2*swidth-ix,reg);
         if a = 1 and b = 1 and ix-1 < width then
            quantum_sigma_z(ix-1,reg); -- Z = HXH
         end if;
      end loop;
   end quantum_qec_decode;

   function quantum_qec_counter(inc : in Integer; frequency : in Integer;
                                 reg : in out quantum_reg) return Integer is
      counter : Integer := 0;
      ff : Unsigned_64 := Shift_Left(1,30);
      freq : Integer := Integer(ff);
   begin
      if inc > 0 then
         counter := counter + inc;
      else if inc < 0 then
            counter := 0;
         end if;
      end if;

      if frequency > 0 then
         freq := frequency;
      end if;

      if counter >= freq then
         counter := 0;
         quantum_qec_decode(qec_type, qec_width, reg);
         quantum_qec_encode(qec_type, qec_width, reg);
      end if;
      return(counter);
   end quantum_qec_counter;

   procedure quantum_sigma_x_noft(target : in Integer; reg : in out quantum_reg) is
   begin
         for ix in 0 .. reg.size-1 loop
            reg.state(ix) := reg.state(ix) xor Shift_Left(1,target);
         end loop;
   end quantum_sigma_x_noft;

   procedure quantum_sigma_x_ft(target : in Integer; reg : in out quantum_reg)
   is
      tmp,tmp1 : Integer;
      lambda : Float;
   begin
      tmp := qec_type;
      qec_type := 0;

      lambda := quantum_get_decoherence;
      quantum_set_decoherence(0.0);

      quantum_sigma_x_noft(target,reg);
      quantum_sigma_x_noft(target+qec_width,reg);
      quantum_set_decoherence(lambda);
      quantum_sigma_x_noft(target+2*qec_width,reg);

      tmp1 := quantum_qec_counter(1,0,reg);

      qec_type := tmp;
   end quantum_sigma_x_ft;

   procedure quantum_sigma_x(target : in Integer; reg : in out quantum_reg) is
      qec,dummy : Integer;
   begin
      quantum_qec_get_status(qec,dummy);

      if qec /= 0 then
         quantum_sigma_x_ft(target,reg);
      else
         quantum_sigma_x_noft(target => target,
                              reg    => reg);
         quantum_decohere(reg);
      end if;
   end quantum_sigma_x;

   procedure quantum_cnot_ft(control : in Integer; target : in Integer;
                             reg : in out quantum_reg) is
      tmp, tmp1 : Integer;
      lambda : Float;
   begin
      tmp := qec_type;
      qec_type := 0;
      lambda := quantum_get_decoherence;
      quantum_set_decoherence(0.0);

      quantum_cnot_noft(control,target,reg);
      quantum_cnot_noft(control+qec_width,target+qec_width,reg);
      quantum_set_decoherence(lambda);
      quantum_cnot_noft(control+2*qec_width,target+2*qec_width,reg);

      tmp1 := quantum_qec_counter(1,0,reg);

      qec_type := tmp;

   end quantum_cnot_ft;

   procedure quantum_cnot(control : in Integer; target : in Integer;
                          reg : in out quantum_reg) is
      qec,dummy : Integer;
   begin
      quantum_qec_get_status(qec,dummy);

      if qec /= 0 then
         quantum_cnot_ft(control, target, reg);
      else
         quantum_cnot_noft(control,target => target,
                           reg    => reg);
         quantum_decohere(reg);
      end if;
   end quantum_cnot;

   procedure quantum_toffoli_noft(control1, control2, target : in Integer;
                                  reg : in out quantum_reg) is
   begin
      for ix in 0 .. reg.size-1 loop
         if (reg.state(ix) and Shift_Left(1,control1)) /= 0 then
            if (reg.state(ix) and Shift_Left(1,control2)) /= 0 then
               reg.state(ix) := reg.state(ix) xor Shift_Left(1,target);
            end if;
         end if;
      end loop;
      quantum_decohere(reg);
   end quantum_toffoli_noft;

   procedure quantum_toffoli_ft(control1, control2, target : in Integer;
                                reg : in out quantum_reg) is
      c1, c2 : Unsigned_64;
      mask : Unsigned_64;
      cc : Integer;
   begin
      mask := Shift_Left(1,target) + Shift_Left(1,target+qec_width) +
        Shift_Left(1,target+2*qec_width);

      for ix in 0 .. reg.size-1 loop
         c1 := 0;
         c2 := 0;

         if (reg.state(ix) and Shift_Left(1,control1)) /= 0 then
            c1 := 1;
         end if;

         if (reg.state(ix) and Shift_Left(1,control1+qec_width)) /= 0 then
            c1 := c1 xor 1;
         end if;

         if (reg.state(ix) and Shift_Left(1,control1+2*qec_width)) /= 0 then
            c1 := c1 xor 1;
         end if;

         if (reg.state(ix) and Shift_Left(1,control2)) /= 0 then
            c2 := 1;
         end if;

         if (reg.state(ix) and Shift_Left(1,control2+qec_width)) /= 0 then
            c2 := c2 xor 1;
         end if;

         if (reg.state(ix) and Shift_Left(1,control2+2*qec_width)) /= 0 then
            c2 := c2 xor 1;
         end if;

         if (c1 = 1) and (c2 = 1) then
            reg.state(ix) := reg.state(ix) xor mask;
         end if;
      end loop;

      quantum_decohere(reg);

      cc := quantum_qec_counter(1,0,reg);

   end quantum_toffoli_ft;

   procedure quantum_toffoli(control1, control2, target : in Integer;
                             reg : in out quantum_reg) is
      qec, dummy : Integer;
   begin
      quantum_qec_get_status(qec, dummy);

      if qec /= 0 then
         quantum_toffoli_ft(control1, control2, target, reg);
      else
         quantum_toffoli_noft(control1, control2, target, reg);
      end if;
   end quantum_toffoli;

   procedure quantum_swaptheleads_omuln_controlled(control : in Integer;
                                                   width : in Integer;
                                                   reg : in out quantum_reg) is
   begin
      for ix in 0 .. width-1 loop
         quantum_toffoli(control, width+ix, 2*width+ix+2, reg);
         quantum_toffoli(control, 2*width+ix+2, width+ix, reg);
         quantum_toffoli(control, width+ix, 2*width+ix+2, reg);
      end loop;
      --Ada.Text_IO.Put_Line("Done with swaptheleads - omuln");
   end quantum_swaptheleads_omuln_controlled;

   procedure quantum_swaptheleads(width : in Integer; reg : in out quantum_reg) is
      qec, dummy : Integer;
      pat1, pat2, l : Unsigned_64;
   begin
      quantum_qec_get_status(qec, dummy);

      if qec /= 0 then
         for ix in 0 .. width-1 loop
            quantum_cnot(ix, width+ix, reg);
            quantum_cnot(width+ix, ix, reg);
            quantum_cnot(ix, width+ix, reg);
         end loop;
      else
         for ix in 0 .. reg.size-1 loop
            pat1 := reg.state(ix) rem Shift_Left(1,width);
            pat2 := 0;
            for iy in 0 .. width-1 loop
               pat2 := pat2 + reg.state(ix) and Shift_Left(1,width+iy);
            end loop;

            l := reg.state(ix) - (pat1 + pat2);
            l := l + Shift_Left(pat1,width);
            l := l + Shift_Right(pat2,width);
            reg.state(ix) := l;
         end loop;
      end if;
   end quantum_swaptheleads;

   procedure test_sum(compare : in Integer; width : in Integer;
                      reg : in out quantum_reg) is
   begin
      if (Unsigned_64(compare) and Shift_Left(1,width-1)) /= 0 then
         quantum_cnot(2*width-1,width-1,reg);
         quantum_sigma_x(2*width-1,reg);
         quantum_cnot(2*width-1,0,reg);
      else
         quantum_sigma_x(2*width-1,reg);
         quantum_cnot(2*width-1,width-1,reg);
      end if;

      for ix in reverse 1 .. width-2 loop
         if (Unsigned_64(compare) and Shift_Left(1,ix)) /= 0 then
            quantum_toffoli(ix+1,width+ix,ix,reg);
            quantum_sigma_x(width+ix,reg);
            quantum_toffoli(ix+1,width+ix,0,reg);
         else
            quantum_sigma_x(width+ix,reg);
            quantum_toffoli(ix+1,width+ix,ix,reg);
         end if;
      end loop;

      if (Unsigned_64(compare) and 1) /= 0 then
         quantum_sigma_x(width,reg);
         quantum_toffoli(width,1,0,reg);
      end if;

      quantum_toffoli(2*width+1,0,2*width,reg);

      if (Unsigned_64(compare) and 1) /= 0 then
         quantum_toffoli(width,1,0,reg);
         quantum_sigma_x(width,reg);
      end if;

      for ix in 1 .. width-2 loop
         if (Unsigned_64(compare) and Shift_Left(1,ix)) /= 0 then
            quantum_toffoli(ix+1,width+ix,0,reg);
            quantum_sigma_x(width+ix,reg);
            quantum_toffoli(ix+1,width+ix,ix,reg);
         else
            quantum_toffoli(ix+1,width+ix,ix,reg);
            quantum_sigma_x(width+ix,reg);
         end if;
      end loop;

      if (Unsigned_64(compare) and Shift_Left(1,width-1)) /= 0 then
         quantum_cnot(2*width-1,0,reg);
         quantum_sigma_x(2*width-1,reg);
         quantum_cnot(2*width-1,width-1,reg);
      else
         quantum_cnot(2*width-1,width-1,reg);
         quantum_sigma_x(2*width-1,reg);
      end if;
   end test_sum;

   --Semi-quantum full adder
   procedure muxfa(a, b_in, c_in, c_out, xlt_l, L, total : in Integer;
                   reg : in out quantum_reg) is
   begin
      if a = 0 then -- 00
         quantum_toffoli(b_in, c_in, c_out, reg);
         quantum_cnot(b_in, c_in, reg);
      end if;

      if a = 3 then -- 11
         quantum_toffoli(L,c_in,c_out,reg);
         quantum_cnot(L,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_cnot(b_in,c_in,reg);
      end if;

      if a = 1 then -- 01
         quantum_toffoli(L,xlt_l,b_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,b_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_cnot(b_in,c_in,reg);
      end if;

      if a = 2 then -- 10
         quantum_sigma_x(xlt_l, reg);
         quantum_toffoli(L,xlt_l,b_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,b_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_cnot(b_in,c_in,reg);
         quantum_sigma_x(xlt_l,reg);
      end if;
   end muxfa;

   procedure muxfa_inv(a, b_in, c_in, c_out, xlt_l, L, total : in Integer;
                       reg : in out quantum_reg) is
   begin
      if a = 0 then -- a = 00
         quantum_cnot(b_in,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
      end if;

      if a = 3 then -- a = 11
         quantum_cnot(b_in,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_cnot(L,c_in,reg);
         quantum_toffoli(L,c_in,c_out,reg);
      end if;

      if a = 1 then -- a = 01
         quantum_cnot(b_in,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,b_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,b_in,reg);
      end if;

      if a = 2 then -- a = 10
         quantum_sigma_x(xlt_l, reg);
         quantum_cnot(b_in,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,c_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,b_in,reg);
         quantum_toffoli(b_in,c_in,c_out,reg);
         quantum_toffoli(L,xlt_l,b_in,reg);
         quantum_sigma_x(xlt_l,reg);
      end if;
   end muxfa_inv;

   procedure muxha(a, b_in, c_in, xlt_l, L, total : in Integer;
                   reg : in out quantum_reg) is
   begin
      if a = 0 then -- a = 00
         quantum_cnot(b_in,c_in,reg);
      end if;

      if a = 3 then -- a = 11
         quantum_cnot(L,c_in,reg);
         quantum_cnot(b_in,c_in,reg);
      end if;

      if a = 1 then -- a = 01
         quantum_toffoli(L,xlt_l,c_in,reg);
         quantum_cnot(b_in,c_in,reg);
      end if;

      if a = 2 then -- a = 10
         quantum_sigma_x(xlt_l,reg);
         quantum_toffoli(L,xlt_l,c_in,reg);
         quantum_cnot(b_in,c_in,reg);
         quantum_sigma_x(xlt_l,reg);
      end if;
   end muxha;

   procedure muxha_inv(a, b_in, c_in, xlt_l, L, total : in Integer;
                       reg : in out quantum_reg) is
   begin
      if a = 0 then -- a = 00
         quantum_cnot(b_in,c_in,reg);
      end if;

      if a = 3 then -- a = 11
         quantum_cnot(b_in,c_in,reg);
         quantum_cnot(L,c_in,reg);
      end if;

      if a = 1 then -- a = 01
         quantum_cnot(b_in,c_in,reg);
         quantum_toffoli(L,xlt_l,c_in,reg);
      end if;

      if a = 2 then -- a = 10
         quantum_sigma_x(xlt_l,reg);
         quantum_cnot(b_in,c_in,reg);
         quantum_toffoli(L,xlt_l,c_in,reg);
         quantum_sigma_x(xlt_l,reg);
      end if;
   end muxha_inv;

   procedure madd(a, a_inv, width : in Integer;
                  reg : in out quantum_reg) is
      j : Integer;
      j_u : Unsigned_64;
      total : Integer := num_regs * width+2;
   begin
      for ix in 0 .. width-1 loop
         if (Shift_Left(1,ix) and Unsigned_64(a)) /= 0 then
            j_u := Shift_Left(1,1);
            j := Integer(j_u);
         else
            j := 0;
         end if;
         if (Shift_Left(1,ix) and Unsigned_64(a_inv)) /= 0 then
            j := j + 1;
         end if;
         muxfa(j,width+ix,ix,ix+1,2*width,2*width+1,total,reg);
      end loop;
      j := 0;
      if (Shift_Left(1,width-1) and Unsigned_64(a)) /= 0 then
         j := 2;
      end if;
      if (Shift_Left(1,width-1) and Unsigned_64(a_inv)) /= 0 then
         j := j + 1;
      end if;
      muxha(j,2*width-1,width-1,2*width,2*width+1,total,reg);
   end madd;

   procedure madd_inv(a, a_inv, width : in Integer;
                  reg : in out quantum_reg) is
      j : Integer;
      j_u : Unsigned_64;
      total : Integer := num_regs * width+2;
   begin
      j := 0;
      if (Shift_Left(1,width-1) and Unsigned_64(a)) /= 0 then
         j := 2;
      end if;
      if (Shift_Left(1,width-1) and Unsigned_64(a_inv)) /= 0 then
         j := j + 1;
      end if;
      muxha_inv(j,2*width-1,width-1,2*width,2*width+1,total,reg);

      for ix in reverse 0 .. width-2 loop
         if (Shift_Left(1,ix) and Unsigned_64(a)) /= 0 then
            j_u := Shift_Left(1,1);
            j := Integer(j_u);
         else
            j := 0;
         end if;
         if (Shift_Left(1,ix) and Unsigned_64(a_inv)) /= 0 then
            j := j + 1;
         end if;
         muxfa_inv(j,width+ix,ix,ix+1,2*width,2*width+1,total,reg);
      end loop;
   end madd_inv;

   -- add a to register reg (mod N)
   procedure addn(N, a, width : in Integer; reg : in out quantum_reg) is
      t1 : Unsigned_64;
   begin
      test_sum(N-a,width => width,
               reg   => reg);
      t1 := Shift_Left(1,width);
      madd(Integer(t1)+a-N,a,width,reg);
   end addn;

   procedure addn_inv(N, a, width : in Integer; reg : in out quantum_reg) is
      t1 : Unsigned_64;
   begin
      quantum_cnot(2*width+1,2*width,reg);
      t1 := Shift_Left(1,width);
      madd_inv(Integer(t1)+a-N,a,width,reg);
   end addn_inv;

   procedure add_mod_n(N, a, width : in Integer; reg : in out quantum_reg) is
   begin
      addn(N,a,width,reg);
      addn_inv(N,a,width,reg);
   end add_mod_n;


   procedure quantum_qft(width : in Integer; reg : in out quantum_reg) is
   begin
      for ix in reverse 0 .. width-1 loop
         for iy in reverse ix+1 .. width-1 loop
            quantum_cond_phase(iy, ix, reg);
         end loop;
         quantum_hadamard(ix, reg);
      end loop;
   end quantum_qft;

   procedure quantum_qft_inv(width : in Integer; reg : in out quantum_reg) is
   begin
      for ix in 0 .. width-1 loop
         quantum_hadamard(ix, reg);
         for iy in ix+1 .. width-1 loop
            quantum_cond_phase(iy, ix, reg);
         end loop;
      end loop;
   end quantum_qft_inv;

   procedure emul(a, l, width : in Integer; reg : in out quantum_reg) is
   begin
      for ix in reverse 0 .. width-1 loop
         quantum_toffoli(2*width+2,l,width+ix,reg);
      end loop;
   end emul;

   procedure muln(n, a, ctl, width : in Integer; reg : in out quantum_reg) is
      L : Integer := 2*width+1;
      pp : Unsigned_64;
   begin
      Ada.Text_IO.Put_Line("Starting muln with width :" & Integer'Image(width));
      quantum_toffoli(ctl,2*width+2,L,reg);
      emul(a rem n, L, width, reg);
      quantum_toffoli(ctl,2*width+2,L,reg);

      for ix in 1..width-1 loop
         Ada.Text_IO.Put_Line("Muln loop n." & Integer'Image(ix));
         pp := Shift_Left(1,ix);
         quantum_toffoli(ctl,2*width+2+ix,L,reg);
         add_mod_n(N,(Integer(pp)*a) rem n, width, reg);
         quantum_toffoli(ctl,2*width+2+ix,L,reg);
      end loop;
      Ada.Text_IO.Put_Line("Done with muln");
   end muln;

   procedure muln_inv(n, a, ctl, width : in Integer; reg : in out quantum_reg) is
      L : Integer := 2*width+1;
      a1 : Integer := 0;
      pp : Unsigned_64;
   begin
      a1 := quantum_inverse_mod(n,a);
      Ada.Text_IO.Put_Line("Starting muln_inv with:" & Integer'Image(width));
      for ix in reverse 1 .. width-1 loop
         Ada.Text_IO.Put_Line("Muln_inv loop n." & Integer'Image(ix));
         pp := Shift_Left(1,ix);
         quantum_toffoli(ctl,2*width+2+ix,L,reg);
         add_mod_n(n,n-(Integer(pp)*a1) rem n, width, reg);
         quantum_toffoli(ctl,2*width+2+ix,L,reg);
      end loop;
      --Ada.Text_IO.Put_Line("Done with muln_inv in reverse loop");
      quantum_toffoli(ctl,2*width+2,L,reg);
      emul(a1 rem n, L, width, reg);
      quantum_toffoli(ctl,2*width+2,L,reg);
      Ada.Text_IO.Put_Line("Done with muln_inv");
   end muln_inv;

   procedure mul_mod_n(n, a, ctl, width : in Integer; reg : in out quantum_reg)
   is
   begin
      muln(n,a,ctl,width,reg);
      quantum_swaptheleads_omuln_controlled(ctl, width, reg);
      muln_inv(n,a,ctl,width,reg);
   end mul_mod_n;


   procedure quantum_exp_mod_n(n, x, width_input, width : in Integer;
                               reg : in out quantum_reg) is
      f : Integer;
   begin
      quantum_sigma_x(2*width+2,reg);
      Ada.Text_IO.Put_Line("Evaluating exp mod n with input width:" &
                             Integer'Image(width_input));
      for ix in 1..width_input loop
         Ada.Text_IO.Put_Line("exp mod n loop n." & Integer'Image(ix));
         f := x rem n;
         for iy in 1..ix-1 loop
            f := f * f;
            f := f rem n;
         end loop;
         mul_mod_n(N,f,3*width+1+ix, width, reg);
      end loop;
   end quantum_exp_mod_n;

end libquantum;
