pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__test.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__test.adb");

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E156 : Short_Integer; pragma Import (Ada, E156, "system__os_lib_E");
   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E183 : Short_Integer; pragma Import (Ada, E183, "system__fat_flt_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "system__fat_llf_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exception_table_E");
   E048 : Short_Integer; pragma Import (Ada, E048, "ada__containers_E");
   E053 : Short_Integer; pragma Import (Ada, E053, "ada__io_exceptions_E");
   E069 : Short_Integer; pragma Import (Ada, E069, "ada__numerics_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__tags_E");
   E052 : Short_Integer; pragma Import (Ada, E052, "ada__streams_E");
   E045 : Short_Integer; pragma Import (Ada, E045, "interfaces__c_E");
   E169 : Short_Integer; pragma Import (Ada, E169, "interfaces__c__strings_E");
   E025 : Short_Integer; pragma Import (Ada, E025, "system__exceptions_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "system__finalization_root_E");
   E050 : Short_Integer; pragma Import (Ada, E050, "ada__finalization_E");
   E142 : Short_Integer; pragma Import (Ada, E142, "system__storage_pools_E");
   E138 : Short_Integer; pragma Import (Ada, E138, "system__finalization_masters_E");
   E161 : Short_Integer; pragma Import (Ada, E161, "system__storage_pools__subpools_E");
   E006 : Short_Integer; pragma Import (Ada, E006, "ada__calendar_E");
   E144 : Short_Integer; pragma Import (Ada, E144, "system__pool_global_E");
   E159 : Short_Integer; pragma Import (Ada, E159, "system__file_control_block_E");
   E154 : Short_Integer; pragma Import (Ada, E154, "system__file_io_E");
   E077 : Short_Integer; pragma Import (Ada, E077, "system__random_seed_E");
   E017 : Short_Integer; pragma Import (Ada, E017, "system__secondary_stack_E");
   E122 : Short_Integer; pragma Import (Ada, E122, "system__tasking__initialization_E");
   E150 : Short_Integer; pragma Import (Ada, E150, "ada__text_io_E");
   E130 : Short_Integer; pragma Import (Ada, E130, "system__tasking__protected_objects_E");
   E134 : Short_Integer; pragma Import (Ada, E134, "system__tasking__protected_objects__entries_E");
   E128 : Short_Integer; pragma Import (Ada, E128, "system__tasking__queuing_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "gnatcoll__gmp__integers_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "libquantum_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E176 := E176 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "libquantum__finalize_spec");
      begin
         F1;
      end;
      E167 := E167 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "gnatcoll__gmp__integers__finalize_spec");
      begin
         F2;
      end;
      E134 := E134 - 1;
      declare
         procedure F3;
         pragma Import (Ada, F3, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F3;
      end;
      E150 := E150 - 1;
      declare
         procedure F4;
         pragma Import (Ada, F4, "ada__text_io__finalize_spec");
      begin
         F4;
      end;
      E138 := E138 - 1;
      E161 := E161 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "system__file_io__finalize_body");
      begin
         E154 := E154 - 1;
         F5;
      end;
      declare
         procedure F6;
         pragma Import (Ada, F6, "system__file_control_block__finalize_spec");
      begin
         E159 := E159 - 1;
         F6;
      end;
      E144 := E144 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "system__pool_global__finalize_spec");
      begin
         F7;
      end;
      declare
         procedure F8;
         pragma Import (Ada, F8, "system__storage_pools__subpools__finalize_spec");
      begin
         F8;
      end;
      declare
         procedure F9;
         pragma Import (Ada, F9, "system__finalization_masters__finalize_spec");
      begin
         F9;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");
   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Install_Handler;
      pragma Import (C, Install_Handler, "__gnat_install_handler");

      Handler_Installed : Integer;
      pragma Import (C, Handler_Installed, "__gnat_handler_installed");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (False, False, False, True, True, False, False, True, 
           False, False, True, True, True, True, False, False, 
           True, False, False, True, True, False, True, True, 
           False, True, True, True, True, False, False, True, 
           False, True, False, False, True, False, True, False, 
           False, True, False, False, False, True, False, False, 
           False, True, False, False, False, False, False, False, 
           False, False, True, True, True, False, False, True, 
           False, False, True, False, True, False, False, True, 
           True, True, False, True, False, False, False, False, 
           False, False, False, False, False, False),
         Count => (0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
         Unknown => (False, False, False, False, False, False, False, False, False, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Flt'Elab_Spec;
      E183 := E183 + 1;
      System.Fat_Llf'Elab_Spec;
      E179 := E179 + 1;
      System.Exception_Table'Elab_Body;
      E023 := E023 + 1;
      Ada.Containers'Elab_Spec;
      E048 := E048 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E053 := E053 + 1;
      Ada.Numerics'Elab_Spec;
      E069 := E069 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E052 := E052 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E025 := E025 + 1;
      System.Finalization_Root'Elab_Spec;
      E068 := E068 + 1;
      Ada.Finalization'Elab_Spec;
      E050 := E050 + 1;
      System.Storage_Pools'Elab_Spec;
      E142 := E142 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E006 := E006 + 1;
      System.Pool_Global'Elab_Spec;
      E144 := E144 + 1;
      System.File_Control_Block'Elab_Spec;
      E159 := E159 + 1;
      System.Random_Seed'Elab_Body;
      E077 := E077 + 1;
      System.File_Io'Elab_Body;
      E154 := E154 + 1;
      E161 := E161 + 1;
      System.Finalization_Masters'Elab_Body;
      E138 := E138 + 1;
      E169 := E169 + 1;
      E045 := E045 + 1;
      Ada.Tags'Elab_Body;
      E055 := E055 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Os_Lib'Elab_Body;
      E156 := E156 + 1;
      System.Secondary_Stack'Elab_Body;
      E017 := E017 + 1;
      System.Tasking.Initialization'Elab_Body;
      E122 := E122 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E150 := E150 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E130 := E130 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E134 := E134 + 1;
      System.Tasking.Queuing'Elab_Body;
      E128 := E128 + 1;
      GNATCOLL.GMP.INTEGERS'ELAB_SPEC;
      E167 := E167 + 1;
      libquantum'elab_spec;
      libquantum'elab_body;
      E176 := E176 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_test");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /users/fausap/ADA-PRJS/ada-quantum/obj/libquantum.o
   --   /users/fausap/ADA-PRJS/ada-quantum/obj/test.o
   --   -L/users/fausap/ADA-PRJS/ada-quantum/obj/
   --   -L/users/fausap/ADA-PRJS/ada-quantum/obj/
   --   -L/usr/local/gnat/lib/gnatcoll/static/
   --   -L/usr/local/gnat/lib/gnat_util/static/
   --   -L/usr/local/gnat/lib/gcc/x86_64-apple-darwin12.5.0/4.7.4/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
--  END Object file/option list   

end ada_main;
