with Ada.Numerics.Complex_Types;
with Ada.Containers.Vectors;
with Interfaces;
use Ada.Numerics.Complex_Types; use Interfaces;
with GNATCOLL.GMP.Integers;

package libquantum is

   package cvector is new Ada.Containers.Vectors(Natural,Complex);
   package fvector is new Ada.Containers.Vectors(Natural,Float);
   package state_vector is new Ada.Containers.Vectors(Natural,Unsigned_64);
   package ivector is new Ada.Containers.Vectors(Natural,Integer);

   use state_vector;

   type quantum_matrix is record
      rows : Integer;
      cols : Integer;
      t : cvector.Vector;
   end record;

   type quantum_reg is record
      width : Integer;
      size : Integer;
      hashw : Integer;
      hash : ivector.Vector;
      amplitude : cvector.Vector;
      state : state_vector.Vector;
   end record;

   package qvector is new Ada.Containers.Vectors(Natural,quantum_reg);

   type quantum_density_op is record
      num : Integer;
      prob : fvector.Vector;
      reg : qvector.Vector;
   end record;

   type function_access is access function (u1 : Unsigned_64; d1 : Float)
     return quantum_reg;

   type qreg_ref is access all quantum_reg;
   type qmatrix_ref is access all quantum_matrix;

   type qsolver is (QUANTUM_SOLVER_LANCZOS,
                    QUANTUM_SOLVER_LANCZOS_MODIFIED,
                    QUANTUM_SOLVER_IMAGINARY_TIME);
   type qtime is (QUANTUM_RK4_NODELETE,
                  QUANTUM_RK4_IMAGINARY);

   qec_type : Integer := 0;
   qec_width : Integer := 0;
   quantum_status : Integer := 0;
   quantum_lambda : Float := 0.0;
   num_regs : Integer := 4;

   function quantum_get_decoherence return Float;
   procedure quantum_set_decoherence(l : in Float);
   procedure quantum_decohere(reg : in out quantum_reg);

   function quantum_getwidth(n : in Integer) return Integer;
   function quantum_inverse_mod(n, c : in Integer) return Integer;
   function quantum_gcd(u, v : in Long_Long_Integer) return Long_Long_Integer;
   procedure quantum_frac_approx(a, b : in out Integer; width : in Integer);
   function quantum_ipow(a, b : in Integer) return Long_Long_Integer;
   function quantum_rem(a, b : in Long_Long_Integer) return Long_Long_Integer;

   procedure quantum_qec_get_status(ptype, pwidth : out Integer);
   procedure quantum_qec_set_status(stype, swidth : in Integer);

   function quantum_state_collapse(pos : in Integer; value : in Integer;
                                   reg : in quantum_reg) return quantum_reg;

   function quantum_new_matrix(cols, rows : in Integer) return quantum_matrix;

   function quantum_new_qureg(initval : in Unsigned_64; width : in Integer)
                              return quantum_reg;
   function quantum_new_qureg_size(n : in Integer; width : in Integer)
                                   return quantum_reg;
   function quantum_new_qureg_sparse(n : in Integer; width : in Integer)
                                     return quantum_reg;
   procedure quantum_delete_qureg(l_reg : in out quantum_reg);
   procedure quantum_print_qureg(reg : in quantum_reg);
   procedure quantum_print_hash(reg : in quantum_reg);

   procedure quantum_addscratch(bits : in Integer; l_reg : in out quantum_reg);
   procedure quantum_delete_qureg_hashpreserve(l_reg : in out quantum_reg);

   function quantum_bmeasure(pos : in Integer; reg : in out quantum_reg)
                             return Integer;
   function quantum_measure(reg : in out quantum_reg) return Integer;
   function quantum_bmeasure_bitpreserve(pos : in Integer;
                                         reg : in out quantum_reg)
     return Integer;

   function quantum_matrix2qureg(m : qmatrix_ref; width : Integer)
                                  return quantum_reg;
   procedure quantum_scalar_qureg(c : in Complex; reg : in out quantum_reg);
   function quantum_kronecker(reg1, reg2 : in quantum_reg) return quantum_reg;
   function quantum_dot_product(reg1, reg2 : in out quantum_reg) return Complex;
   function quantum_dot_product_noconj(reg1, reg2 : in out quantum_reg) return Complex;
   procedure quantum_copy_qureg(src : in quantum_reg; dst : out quantum_reg);
   function quantum_vectoradd(reg1, reg2 : in out quantum_reg) return quantum_reg;
   procedure quantum_vectoradd_inplace(reg1, reg2 : in out quantum_reg);
   procedure quantum_mvmult(y : out quantum_reg; A : in quantum_matrix;
                            x : in quantum_reg);

   procedure quantum_normalize(reg : in out quantum_reg);

   function quantum_matrix_qureg(A : in function_access; t : in Float;
                                 reg : in out quantum_reg; flags : in qtime)
                                 return quantum_reg;

   procedure quantum_gate1(target : in Integer; m : in quantum_matrix;
                           reg : in out quantum_reg);

   procedure quantum_hadamard(target : in Integer; reg : in out quantum_reg);
   procedure quantum_walsh(width: in Integer; reg : in out quantum_reg);
   procedure quantum_r_x(target : in Integer; gamma : in Float;
                         reg: in out quantum_reg);
   procedure quantum_r_y(target : in Integer; gamma : in Float;
                         reg: in out quantum_reg);
   procedure quantum_r_z(target: in Integer; gamma : in Float;
                         reg: in out quantum_reg);
   procedure quantum_phase_scale(target: in Integer; gamma : in Float;
                         reg: in out quantum_reg);
   procedure quantum_phase_kick(target: in Integer; gamma : in Float;
                                reg: in out quantum_reg);
   procedure quantum_cond_phase_inv(control: in Integer; target : in Integer;
                                    reg : in out quantum_reg);
   procedure quantum_cond_phase(control: in Integer; target : in Integer;
                                reg : in out quantum_reg);
   procedure quantum_cond_phase_kick(control: in Integer; target : in Integer;
                                     gamma : in Float;
                                     reg : in out quantum_reg);
   procedure quantum_cond_phase_shift(control: in Integer; target : in Integer;
                                      gamma : in Float;
                                      reg : in out quantum_reg);

   procedure quantum_toffoli(control1, control2, target : in Integer;
                             reg : in out quantum_reg);

   procedure quantum_cnot(control : in Integer; target : in Integer;
                          reg : in out quantum_reg);

   procedure quantum_qft(width : in Integer; reg : in out quantum_reg);
   procedure quantum_qft_inv(width : in Integer; reg : in out quantum_reg);

   procedure quantum_exp_mod_n(n, x, width_input, width : in Integer;
                               reg : in out quantum_reg);

   procedure emul(a, l, width : in Integer; reg : in out quantum_reg);
   procedure muln(n, a, ctl, width : in Integer; reg : in out quantum_reg);
   procedure muln_inv(n, a, ctl, width : in Integer; reg : in out quantum_reg);
   procedure mul_mod_n(n, a, ctl, width : in Integer; reg : in out quantum_reg);

   procedure quantum_swaptheleads_omuln_controlled(control : in Integer;
                                                   width : in Integer;
                                                   reg : in out quantum_reg);

   procedure quantum_swaptheleads(width : in Integer; reg : in out quantum_reg);

   procedure muxfa(a, b_in, c_in, c_out, xlt_l, L, total : in Integer;
                   reg : in out quantum_reg);
   procedure muxfa_inv(a, b_in, c_in, c_out, xlt_l, L, total : in Integer;
                       reg : in out quantum_reg);

   procedure muxha(a, b_in, c_in, xlt_l, L, total : in Integer;
                   reg : in out quantum_reg);
   procedure muxha_inv(a, b_in, c_in, xlt_l, L, total : in Integer;
                       reg : in out quantum_reg);

   procedure madd_inv(a, a_inv, width : in Integer;
                      reg : in out quantum_reg);

   procedure madd(a, a_inv, width : in Integer;
                  reg : in out quantum_reg);

   procedure addn(N, a, width : in Integer; reg : in out quantum_reg);

   procedure addn_inv(N, a, width : in Integer; reg : in out quantum_reg);
   procedure add_mod_n(N, a, width : in Integer; reg : in out quantum_reg);

end libquantum;
