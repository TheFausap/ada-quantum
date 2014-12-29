pragma Ada_95;
with System;
package ada_main is
   pragma Warnings (Off);

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2014 (20140331)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_main" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#d93015b1#;
   pragma Export (C, u00001, "mainB");
   u00002 : constant Version_32 := 16#fbff4c67#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#f1136198#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#65712768#;
   pragma Export (C, u00005, "ada__calendarB");
   u00006 : constant Version_32 := 16#e791e294#;
   pragma Export (C, u00006, "ada__calendarS");
   u00007 : constant Version_32 := 16#342acf94#;
   pragma Export (C, u00007, "ada__exceptionsB");
   u00008 : constant Version_32 := 16#c71ae72a#;
   pragma Export (C, u00008, "ada__exceptionsS");
   u00009 : constant Version_32 := 16#032105bb#;
   pragma Export (C, u00009, "ada__exceptions__last_chance_handlerB");
   u00010 : constant Version_32 := 16#2b293877#;
   pragma Export (C, u00010, "ada__exceptions__last_chance_handlerS");
   u00011 : constant Version_32 := 16#f2f2d889#;
   pragma Export (C, u00011, "systemS");
   u00012 : constant Version_32 := 16#daf76b33#;
   pragma Export (C, u00012, "system__soft_linksB");
   u00013 : constant Version_32 := 16#b82dbdbb#;
   pragma Export (C, u00013, "system__soft_linksS");
   u00014 : constant Version_32 := 16#c8ed38da#;
   pragma Export (C, u00014, "system__parametersB");
   u00015 : constant Version_32 := 16#f428403b#;
   pragma Export (C, u00015, "system__parametersS");
   u00016 : constant Version_32 := 16#c96bf39e#;
   pragma Export (C, u00016, "system__secondary_stackB");
   u00017 : constant Version_32 := 16#599317e0#;
   pragma Export (C, u00017, "system__secondary_stackS");
   u00018 : constant Version_32 := 16#39a03df9#;
   pragma Export (C, u00018, "system__storage_elementsB");
   u00019 : constant Version_32 := 16#df31928d#;
   pragma Export (C, u00019, "system__storage_elementsS");
   u00020 : constant Version_32 := 16#41837d1e#;
   pragma Export (C, u00020, "system__stack_checkingB");
   u00021 : constant Version_32 := 16#7c4db361#;
   pragma Export (C, u00021, "system__stack_checkingS");
   u00022 : constant Version_32 := 16#393398c1#;
   pragma Export (C, u00022, "system__exception_tableB");
   u00023 : constant Version_32 := 16#5cebbe9c#;
   pragma Export (C, u00023, "system__exception_tableS");
   u00024 : constant Version_32 := 16#ce4af020#;
   pragma Export (C, u00024, "system__exceptionsB");
   u00025 : constant Version_32 := 16#9a91b57f#;
   pragma Export (C, u00025, "system__exceptionsS");
   u00026 : constant Version_32 := 16#2652ec14#;
   pragma Export (C, u00026, "system__exceptions__machineS");
   u00027 : constant Version_32 := 16#b895431d#;
   pragma Export (C, u00027, "system__exceptions_debugB");
   u00028 : constant Version_32 := 16#4110c137#;
   pragma Export (C, u00028, "system__exceptions_debugS");
   u00029 : constant Version_32 := 16#570325c8#;
   pragma Export (C, u00029, "system__img_intB");
   u00030 : constant Version_32 := 16#f029384b#;
   pragma Export (C, u00030, "system__img_intS");
   u00031 : constant Version_32 := 16#ff5c7695#;
   pragma Export (C, u00031, "system__tracebackB");
   u00032 : constant Version_32 := 16#daf647d4#;
   pragma Export (C, u00032, "system__tracebackS");
   u00033 : constant Version_32 := 16#8c33a517#;
   pragma Export (C, u00033, "system__wch_conB");
   u00034 : constant Version_32 := 16#e98ffa5b#;
   pragma Export (C, u00034, "system__wch_conS");
   u00035 : constant Version_32 := 16#9721e840#;
   pragma Export (C, u00035, "system__wch_stwB");
   u00036 : constant Version_32 := 16#c49ed65a#;
   pragma Export (C, u00036, "system__wch_stwS");
   u00037 : constant Version_32 := 16#9b29844d#;
   pragma Export (C, u00037, "system__wch_cnvB");
   u00038 : constant Version_32 := 16#e63840a8#;
   pragma Export (C, u00038, "system__wch_cnvS");
   u00039 : constant Version_32 := 16#69adb1b9#;
   pragma Export (C, u00039, "interfacesS");
   u00040 : constant Version_32 := 16#ece6fdb6#;
   pragma Export (C, u00040, "system__wch_jisB");
   u00041 : constant Version_32 := 16#66485989#;
   pragma Export (C, u00041, "system__wch_jisS");
   u00042 : constant Version_32 := 16#8cb17bcd#;
   pragma Export (C, u00042, "system__traceback_entriesB");
   u00043 : constant Version_32 := 16#47e3b81b#;
   pragma Export (C, u00043, "system__traceback_entriesS");
   u00044 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00044, "interfaces__cB");
   u00045 : constant Version_32 := 16#3b563890#;
   pragma Export (C, u00045, "interfaces__cS");
   u00046 : constant Version_32 := 16#820eb304#;
   pragma Export (C, u00046, "system__os_primitivesB");
   u00047 : constant Version_32 := 16#422354a0#;
   pragma Export (C, u00047, "system__os_primitivesS");
   u00048 : constant Version_32 := 16#5e196e91#;
   pragma Export (C, u00048, "ada__containersS");
   u00049 : constant Version_32 := 16#b7ab275c#;
   pragma Export (C, u00049, "ada__finalizationB");
   u00050 : constant Version_32 := 16#19f764ca#;
   pragma Export (C, u00050, "ada__finalizationS");
   u00051 : constant Version_32 := 16#1b5643e2#;
   pragma Export (C, u00051, "ada__streamsB");
   u00052 : constant Version_32 := 16#2564c958#;
   pragma Export (C, u00052, "ada__streamsS");
   u00053 : constant Version_32 := 16#db5c917c#;
   pragma Export (C, u00053, "ada__io_exceptionsS");
   u00054 : constant Version_32 := 16#034d7998#;
   pragma Export (C, u00054, "ada__tagsB");
   u00055 : constant Version_32 := 16#ce72c228#;
   pragma Export (C, u00055, "ada__tagsS");
   u00056 : constant Version_32 := 16#c3335bfd#;
   pragma Export (C, u00056, "system__htableB");
   u00057 : constant Version_32 := 16#76306b63#;
   pragma Export (C, u00057, "system__htableS");
   u00058 : constant Version_32 := 16#089f5cd0#;
   pragma Export (C, u00058, "system__string_hashB");
   u00059 : constant Version_32 := 16#d46e001d#;
   pragma Export (C, u00059, "system__string_hashS");
   u00060 : constant Version_32 := 16#a3f44a26#;
   pragma Export (C, u00060, "system__unsigned_typesS");
   u00061 : constant Version_32 := 16#1e25d3f1#;
   pragma Export (C, u00061, "system__val_lluB");
   u00062 : constant Version_32 := 16#d9061d54#;
   pragma Export (C, u00062, "system__val_lluS");
   u00063 : constant Version_32 := 16#27b600b2#;
   pragma Export (C, u00063, "system__val_utilB");
   u00064 : constant Version_32 := 16#5e526e77#;
   pragma Export (C, u00064, "system__val_utilS");
   u00065 : constant Version_32 := 16#d1060688#;
   pragma Export (C, u00065, "system__case_utilB");
   u00066 : constant Version_32 := 16#d6fbb15e#;
   pragma Export (C, u00066, "system__case_utilS");
   u00067 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00067, "system__finalization_rootB");
   u00068 : constant Version_32 := 16#bd00ab19#;
   pragma Export (C, u00068, "system__finalization_rootS");
   u00069 : constant Version_32 := 16#84ad4a42#;
   pragma Export (C, u00069, "ada__numericsS");
   u00070 : constant Version_32 := 16#ac5daf3d#;
   pragma Export (C, u00070, "ada__numerics__float_randomB");
   u00071 : constant Version_32 := 16#ac27f55b#;
   pragma Export (C, u00071, "ada__numerics__float_randomS");
   u00072 : constant Version_32 := 16#fb675641#;
   pragma Export (C, u00072, "system__random_numbersB");
   u00073 : constant Version_32 := 16#c5ec563a#;
   pragma Export (C, u00073, "system__random_numbersS");
   u00074 : constant Version_32 := 16#22ab03a2#;
   pragma Export (C, u00074, "system__img_unsB");
   u00075 : constant Version_32 := 16#3c0076d1#;
   pragma Export (C, u00075, "system__img_unsS");
   u00076 : constant Version_32 := 16#7d397bc7#;
   pragma Export (C, u00076, "system__random_seedB");
   u00077 : constant Version_32 := 16#9afa1203#;
   pragma Export (C, u00077, "system__random_seedS");
   u00078 : constant Version_32 := 16#4266b2a8#;
   pragma Export (C, u00078, "system__val_unsB");
   u00079 : constant Version_32 := 16#b35ca71d#;
   pragma Export (C, u00079, "system__val_unsS");
   u00080 : constant Version_32 := 16#61dafdec#;
   pragma Export (C, u00080, "ada__task_identificationB");
   u00081 : constant Version_32 := 16#68bdacf5#;
   pragma Export (C, u00081, "ada__task_identificationS");
   u00082 : constant Version_32 := 16#57a37a42#;
   pragma Export (C, u00082, "system__address_imageB");
   u00083 : constant Version_32 := 16#531e45b3#;
   pragma Export (C, u00083, "system__address_imageS");
   u00084 : constant Version_32 := 16#41756927#;
   pragma Export (C, u00084, "system__task_primitivesS");
   u00085 : constant Version_32 := 16#bb68f74c#;
   pragma Export (C, u00085, "system__os_interfaceB");
   u00086 : constant Version_32 := 16#17a9c3dc#;
   pragma Export (C, u00086, "system__os_interfaceS");
   u00087 : constant Version_32 := 16#b1d865da#;
   pragma Export (C, u00087, "system__os_constantsS");
   u00088 : constant Version_32 := 16#181ef6b5#;
   pragma Export (C, u00088, "system__task_primitives__operationsB");
   u00089 : constant Version_32 := 16#970dd798#;
   pragma Export (C, u00089, "system__task_primitives__operationsS");
   u00090 : constant Version_32 := 16#89b55e64#;
   pragma Export (C, u00090, "system__interrupt_managementB");
   u00091 : constant Version_32 := 16#47187112#;
   pragma Export (C, u00091, "system__interrupt_managementS");
   u00092 : constant Version_32 := 16#f65595cf#;
   pragma Export (C, u00092, "system__multiprocessorsB");
   u00093 : constant Version_32 := 16#ca5e47fa#;
   pragma Export (C, u00093, "system__multiprocessorsS");
   u00094 : constant Version_32 := 16#e0fce7f8#;
   pragma Export (C, u00094, "system__task_infoB");
   u00095 : constant Version_32 := 16#72e86588#;
   pragma Export (C, u00095, "system__task_infoS");
   u00096 : constant Version_32 := 16#81b0c012#;
   pragma Export (C, u00096, "system__taskingB");
   u00097 : constant Version_32 := 16#77d8ab0e#;
   pragma Export (C, u00097, "system__taskingS");
   u00098 : constant Version_32 := 16#4bc4ed76#;
   pragma Export (C, u00098, "system__stack_usageB");
   u00099 : constant Version_32 := 16#09222097#;
   pragma Export (C, u00099, "system__stack_usageS");
   u00100 : constant Version_32 := 16#d82965ac#;
   pragma Export (C, u00100, "system__crtlS");
   u00101 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00101, "system__ioB");
   u00102 : constant Version_32 := 16#6cb02fc6#;
   pragma Export (C, u00102, "system__ioS");
   u00103 : constant Version_32 := 16#be29c4cf#;
   pragma Export (C, u00103, "system__tasking__debugB");
   u00104 : constant Version_32 := 16#b9ace83d#;
   pragma Export (C, u00104, "system__tasking__debugS");
   u00105 : constant Version_32 := 16#fd83e873#;
   pragma Export (C, u00105, "system__concat_2B");
   u00106 : constant Version_32 := 16#f0520f59#;
   pragma Export (C, u00106, "system__concat_2S");
   u00107 : constant Version_32 := 16#2b70b149#;
   pragma Export (C, u00107, "system__concat_3B");
   u00108 : constant Version_32 := 16#f982842c#;
   pragma Export (C, u00108, "system__concat_3S");
   u00109 : constant Version_32 := 16#a83b7c85#;
   pragma Export (C, u00109, "system__concat_6B");
   u00110 : constant Version_32 := 16#2035f53b#;
   pragma Export (C, u00110, "system__concat_6S");
   u00111 : constant Version_32 := 16#608e2cd1#;
   pragma Export (C, u00111, "system__concat_5B");
   u00112 : constant Version_32 := 16#75ac9ba7#;
   pragma Export (C, u00112, "system__concat_5S");
   u00113 : constant Version_32 := 16#932a4690#;
   pragma Export (C, u00113, "system__concat_4B");
   u00114 : constant Version_32 := 16#8c96f3a9#;
   pragma Export (C, u00114, "system__concat_4S");
   u00115 : constant Version_32 := 16#d0432c8d#;
   pragma Export (C, u00115, "system__img_enum_newB");
   u00116 : constant Version_32 := 16#93bede49#;
   pragma Export (C, u00116, "system__img_enum_newS");
   u00117 : constant Version_32 := 16#9777733a#;
   pragma Export (C, u00117, "system__img_lliB");
   u00118 : constant Version_32 := 16#e3bd8d58#;
   pragma Export (C, u00118, "system__img_lliS");
   u00119 : constant Version_32 := 16#0095d287#;
   pragma Export (C, u00119, "system__tasking__utilitiesB");
   u00120 : constant Version_32 := 16#39283e2c#;
   pragma Export (C, u00120, "system__tasking__utilitiesS");
   u00121 : constant Version_32 := 16#5d465a6e#;
   pragma Export (C, u00121, "system__tasking__initializationB");
   u00122 : constant Version_32 := 16#f20398cb#;
   pragma Export (C, u00122, "system__tasking__initializationS");
   u00123 : constant Version_32 := 16#bc850fc6#;
   pragma Export (C, u00123, "system__soft_links__taskingB");
   u00124 : constant Version_32 := 16#e47ef8be#;
   pragma Export (C, u00124, "system__soft_links__taskingS");
   u00125 : constant Version_32 := 16#17d21067#;
   pragma Export (C, u00125, "ada__exceptions__is_null_occurrenceB");
   u00126 : constant Version_32 := 16#8b1b3b36#;
   pragma Export (C, u00126, "ada__exceptions__is_null_occurrenceS");
   u00127 : constant Version_32 := 16#6abbd778#;
   pragma Export (C, u00127, "system__tasking__queuingB");
   u00128 : constant Version_32 := 16#3d02e133#;
   pragma Export (C, u00128, "system__tasking__queuingS");
   u00129 : constant Version_32 := 16#80c90528#;
   pragma Export (C, u00129, "system__tasking__protected_objectsB");
   u00130 : constant Version_32 := 16#6fa056d1#;
   pragma Export (C, u00130, "system__tasking__protected_objectsS");
   u00131 : constant Version_32 := 16#ee80728a#;
   pragma Export (C, u00131, "system__tracesB");
   u00132 : constant Version_32 := 16#00efb023#;
   pragma Export (C, u00132, "system__tracesS");
   u00133 : constant Version_32 := 16#c0d61d8c#;
   pragma Export (C, u00133, "system__tasking__protected_objects__entriesB");
   u00134 : constant Version_32 := 16#7671a6ef#;
   pragma Export (C, u00134, "system__tasking__protected_objects__entriesS");
   u00135 : constant Version_32 := 16#100eaf58#;
   pragma Export (C, u00135, "system__restrictionsB");
   u00136 : constant Version_32 := 16#be7ed557#;
   pragma Export (C, u00136, "system__restrictionsS");
   u00137 : constant Version_32 := 16#a4371844#;
   pragma Export (C, u00137, "system__finalization_mastersB");
   u00138 : constant Version_32 := 16#86e4f1c9#;
   pragma Export (C, u00138, "system__finalization_mastersS");
   u00139 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00139, "system__img_boolB");
   u00140 : constant Version_32 := 16#072ba962#;
   pragma Export (C, u00140, "system__img_boolS");
   u00141 : constant Version_32 := 16#6d4d969a#;
   pragma Export (C, u00141, "system__storage_poolsB");
   u00142 : constant Version_32 := 16#07a95f0d#;
   pragma Export (C, u00142, "system__storage_poolsS");
   u00143 : constant Version_32 := 16#e34550ca#;
   pragma Export (C, u00143, "system__pool_globalB");
   u00144 : constant Version_32 := 16#c88d2d16#;
   pragma Export (C, u00144, "system__pool_globalS");
   u00145 : constant Version_32 := 16#d6f619bb#;
   pragma Export (C, u00145, "system__memoryB");
   u00146 : constant Version_32 := 16#ab8fbebd#;
   pragma Export (C, u00146, "system__memoryS");
   u00147 : constant Version_32 := 16#bd6fc52e#;
   pragma Export (C, u00147, "system__traces__taskingB");
   u00148 : constant Version_32 := 16#33a47127#;
   pragma Export (C, u00148, "system__traces__taskingS");
   u00149 : constant Version_32 := 16#1ac8b3b4#;
   pragma Export (C, u00149, "ada__text_ioB");
   u00150 : constant Version_32 := 16#17a49c57#;
   pragma Export (C, u00150, "ada__text_ioS");
   u00151 : constant Version_32 := 16#9f23726e#;
   pragma Export (C, u00151, "interfaces__c_streamsB");
   u00152 : constant Version_32 := 16#bb1012c3#;
   pragma Export (C, u00152, "interfaces__c_streamsS");
   u00153 : constant Version_32 := 16#967994fc#;
   pragma Export (C, u00153, "system__file_ioB");
   u00154 : constant Version_32 := 16#4e02348f#;
   pragma Export (C, u00154, "system__file_ioS");
   u00155 : constant Version_32 := 16#0f6191e4#;
   pragma Export (C, u00155, "system__os_libB");
   u00156 : constant Version_32 := 16#94c13856#;
   pragma Export (C, u00156, "system__os_libS");
   u00157 : constant Version_32 := 16#1a817b8e#;
   pragma Export (C, u00157, "system__stringsB");
   u00158 : constant Version_32 := 16#8c4dc9ef#;
   pragma Export (C, u00158, "system__stringsS");
   u00159 : constant Version_32 := 16#3d557957#;
   pragma Export (C, u00159, "system__file_control_blockS");
   u00160 : constant Version_32 := 16#7b002481#;
   pragma Export (C, u00160, "system__storage_pools__subpoolsB");
   u00161 : constant Version_32 := 16#e3b008dc#;
   pragma Export (C, u00161, "system__storage_pools__subpoolsS");
   u00162 : constant Version_32 := 16#63f11652#;
   pragma Export (C, u00162, "system__storage_pools__subpools__finalizationB");
   u00163 : constant Version_32 := 16#fe2f4b3a#;
   pragma Export (C, u00163, "system__storage_pools__subpools__finalizationS");
   u00164 : constant Version_32 := 16#d5f9759f#;
   pragma Export (C, u00164, "ada__text_io__float_auxB");
   u00165 : constant Version_32 := 16#f854caf5#;
   pragma Export (C, u00165, "ada__text_io__float_auxS");
   u00166 : constant Version_32 := 16#e0da2b08#;
   pragma Export (C, u00166, "ada__text_io__generic_auxB");
   u00167 : constant Version_32 := 16#a6c327d3#;
   pragma Export (C, u00167, "ada__text_io__generic_auxS");
   u00168 : constant Version_32 := 16#56e74f1a#;
   pragma Export (C, u00168, "system__img_realB");
   u00169 : constant Version_32 := 16#355a896b#;
   pragma Export (C, u00169, "system__img_realS");
   u00170 : constant Version_32 := 16#2dc906b9#;
   pragma Export (C, u00170, "system__fat_llfS");
   u00171 : constant Version_32 := 16#1b28662b#;
   pragma Export (C, u00171, "system__float_controlB");
   u00172 : constant Version_32 := 16#120e9bb5#;
   pragma Export (C, u00172, "system__float_controlS");
   u00173 : constant Version_32 := 16#3da6be5a#;
   pragma Export (C, u00173, "system__img_lluB");
   u00174 : constant Version_32 := 16#ea3d4ae5#;
   pragma Export (C, u00174, "system__img_lluS");
   u00175 : constant Version_32 := 16#a282befe#;
   pragma Export (C, u00175, "system__powten_tableS");
   u00176 : constant Version_32 := 16#8ff77155#;
   pragma Export (C, u00176, "system__val_realB");
   u00177 : constant Version_32 := 16#0cdbaf98#;
   pragma Export (C, u00177, "system__val_realS");
   u00178 : constant Version_32 := 16#0be1b996#;
   pragma Export (C, u00178, "system__exn_llfB");
   u00179 : constant Version_32 := 16#7376c666#;
   pragma Export (C, u00179, "system__exn_llfS");
   u00180 : constant Version_32 := 16#6a5da479#;
   pragma Export (C, u00180, "gnatcollS");
   u00181 : constant Version_32 := 16#e3a92dd9#;
   pragma Export (C, u00181, "gnatcoll__gmpS");
   u00182 : constant Version_32 := 16#ce91b5f2#;
   pragma Export (C, u00182, "gnatcoll__gmp__integersB");
   u00183 : constant Version_32 := 16#925eb26f#;
   pragma Export (C, u00183, "gnatcoll__gmp__integersS");
   u00184 : constant Version_32 := 16#2a41728f#;
   pragma Export (C, u00184, "interfaces__c__stringsB");
   u00185 : constant Version_32 := 16#603c1c44#;
   pragma Export (C, u00185, "interfaces__c__stringsS");
   u00186 : constant Version_32 := 16#0d1713f3#;
   pragma Export (C, u00186, "gnatcoll__gmp__libS");
   u00187 : constant Version_32 := 16#3d8f0bf4#;
   pragma Export (C, u00187, "gnatcoll__gmp__integers__ioB");
   u00188 : constant Version_32 := 16#72e33b76#;
   pragma Export (C, u00188, "gnatcoll__gmp__integers__ioS");
   u00189 : constant Version_32 := 16#2259f15d#;
   pragma Export (C, u00189, "gnatcoll__gmp__integers__number_theoreticB");
   u00190 : constant Version_32 := 16#edf526bc#;
   pragma Export (C, u00190, "gnatcoll__gmp__integers__number_theoreticS");
   u00191 : constant Version_32 := 16#9a2c36f1#;
   pragma Export (C, u00191, "libquantumB");
   u00192 : constant Version_32 := 16#a54d9ffb#;
   pragma Export (C, u00192, "libquantumS");
   u00193 : constant Version_32 := 16#3e0cf54d#;
   pragma Export (C, u00193, "ada__numerics__auxB");
   u00194 : constant Version_32 := 16#9f6e24ed#;
   pragma Export (C, u00194, "ada__numerics__auxS");
   u00195 : constant Version_32 := 16#fd49a347#;
   pragma Export (C, u00195, "system__machine_codeS");
   u00196 : constant Version_32 := 16#712ba15e#;
   pragma Export (C, u00196, "system__fat_fltS");
   u00197 : constant Version_32 := 16#b8c59445#;
   pragma Export (C, u00197, "ada__numerics__complex_typesB");
   u00198 : constant Version_32 := 16#e4100fcf#;
   pragma Export (C, u00198, "ada__numerics__complex_typesS");
   u00199 : constant Version_32 := 16#ffe20862#;
   pragma Export (C, u00199, "system__stream_attributesB");
   u00200 : constant Version_32 := 16#e5402c91#;
   pragma Export (C, u00200, "system__stream_attributesS");
   u00201 : constant Version_32 := 16#1607bce4#;
   pragma Export (C, u00201, "system__arith_64B");
   u00202 : constant Version_32 := 16#db12ccc2#;
   pragma Export (C, u00202, "system__arith_64S");
   u00203 : constant Version_32 := 16#dd13bf65#;
   pragma Export (C, u00203, "system__exn_lliB");
   u00204 : constant Version_32 := 16#7365a326#;
   pragma Export (C, u00204, "system__exn_lliS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  interfaces%s
   --  system%s
   --  system.arith_64%s
   --  system.case_util%s
   --  system.case_util%b
   --  system.exn_llf%s
   --  system.exn_llf%b
   --  system.exn_lli%s
   --  system.exn_lli%b
   --  system.float_control%s
   --  system.float_control%b
   --  system.htable%s
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.img_real%s
   --  system.io%s
   --  system.io%b
   --  system.machine_code%s
   --  system.multiprocessors%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.powten_table%s
   --  system.restrictions%s
   --  system.restrictions%b
   --  system.standard_library%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.stack_usage%s
   --  system.stack_usage%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.os_lib%s
   --  system.task_info%s
   --  system.task_info%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  system.arith_64%b
   --  ada.exceptions.is_null_occurrence%s
   --  ada.exceptions.is_null_occurrence%b
   --  system.soft_links%s
   --  system.traces%s
   --  system.traces%b
   --  system.unsigned_types%s
   --  system.fat_flt%s
   --  system.fat_llf%s
   --  system.img_llu%s
   --  system.img_llu%b
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.img_real%b
   --  system.val_llu%s
   --  system.val_real%s
   --  system.val_uns%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_uns%b
   --  system.val_real%b
   --  system.val_llu%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  system.address_image%s
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.containers%s
   --  ada.io_exceptions%s
   --  ada.numerics%s
   --  ada.numerics.aux%s
   --  ada.numerics.aux%b
   --  ada.numerics.complex_types%s
   --  ada.numerics.complex_types%b
   --  ada.tags%s
   --  ada.streams%s
   --  ada.streams%b
   --  interfaces.c%s
   --  system.multiprocessors%b
   --  interfaces.c.strings%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.exceptions.machine%s
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  ada.finalization%b
   --  system.os_constants%s
   --  system.os_interface%s
   --  system.os_interface%b
   --  system.interrupt_management%s
   --  system.interrupt_management%b
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.storage_pools.subpools%s
   --  system.storage_pools.subpools.finalization%s
   --  system.storage_pools.subpools.finalization%b
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.task_primitives%s
   --  system.tasking%s
   --  ada.task_identification%s
   --  system.task_primitives.operations%s
   --  system.tasking%b
   --  system.tasking.debug%s
   --  system.task_primitives.operations%b
   --  system.traces.tasking%s
   --  system.traces.tasking%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.pool_global%s
   --  system.pool_global%b
   --  system.file_control_block%s
   --  system.file_io%s
   --  system.random_numbers%s
   --  ada.numerics.float_random%s
   --  ada.numerics.float_random%b
   --  system.random_seed%s
   --  system.random_seed%b
   --  system.secondary_stack%s
   --  system.file_io%b
   --  system.tasking.debug%b
   --  system.storage_pools.subpools%b
   --  system.finalization_masters%b
   --  interfaces.c.strings%b
   --  interfaces.c%b
   --  ada.tags%b
   --  system.soft_links%b
   --  system.os_lib%b
   --  system.secondary_stack%b
   --  system.random_numbers%b
   --  system.address_image%b
   --  system.soft_links.tasking%s
   --  system.soft_links.tasking%b
   --  system.tasking.initialization%s
   --  system.tasking.utilities%s
   --  ada.task_identification%b
   --  system.traceback%s
   --  ada.exceptions%b
   --  system.traceback%b
   --  system.tasking.initialization%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  ada.text_io.float_aux%s
   --  ada.text_io.generic_aux%s
   --  ada.text_io.generic_aux%b
   --  ada.text_io.float_aux%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  system.tasking.protected_objects.entries%s
   --  system.tasking.protected_objects.entries%b
   --  system.tasking.queuing%s
   --  system.tasking.queuing%b
   --  system.tasking.utilities%b
   --  gnatcoll%s
   --  gnatcoll.gmp%s
   --  gnatcoll.gmp.lib%s
   --  gnatcoll.gmp.integers%s
   --  gnatcoll.gmp.integers%b
   --  gnatcoll.gmp.integers.io%s
   --  gnatcoll.gmp.integers.io%b
   --  gnatcoll.gmp.integers.number_theoretic%s
   --  gnatcoll.gmp.integers.number_theoretic%b
   --  libquantum%s
   --  libquantum%b
   --  main%b
   --  END ELABORATION ORDER


end ada_main;
