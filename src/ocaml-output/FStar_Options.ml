open Prims
let (debug_embedding : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false 
let (eager_embedding : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false 
type debug_level_t =
  | Low 
  | Medium 
  | High 
  | Extreme 
  | Other of Prims.string 
let (uu___is_Low : debug_level_t -> Prims.bool) =
  fun projectee  -> match projectee with | Low  -> true | uu____71 -> false 
let (uu___is_Medium : debug_level_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Medium  -> true | uu____82 -> false
  
let (uu___is_High : debug_level_t -> Prims.bool) =
  fun projectee  -> match projectee with | High  -> true | uu____93 -> false 
let (uu___is_Extreme : debug_level_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Extreme  -> true | uu____104 -> false
  
let (uu___is_Other : debug_level_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Other _0 -> true | uu____117 -> false
  
let (__proj__Other__item___0 : debug_level_t -> Prims.string) =
  fun projectee  -> match projectee with | Other _0 -> _0 
type option_val =
  | Bool of Prims.bool 
  | String of Prims.string 
  | Path of Prims.string 
  | Int of Prims.int 
  | List of option_val Prims.list 
  | Unset 
let (uu___is_Bool : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Bool _0 -> true | uu____172 -> false
  
let (__proj__Bool__item___0 : option_val -> Prims.bool) =
  fun projectee  -> match projectee with | Bool _0 -> _0 
let (uu___is_String : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | String _0 -> true | uu____196 -> false
  
let (__proj__String__item___0 : option_val -> Prims.string) =
  fun projectee  -> match projectee with | String _0 -> _0 
let (uu___is_Path : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Path _0 -> true | uu____220 -> false
  
let (__proj__Path__item___0 : option_val -> Prims.string) =
  fun projectee  -> match projectee with | Path _0 -> _0 
let (uu___is_Int : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Int _0 -> true | uu____244 -> false
  
let (__proj__Int__item___0 : option_val -> Prims.int) =
  fun projectee  -> match projectee with | Int _0 -> _0 
let (uu___is_List : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | List _0 -> true | uu____269 -> false
  
let (__proj__List__item___0 : option_val -> option_val Prims.list) =
  fun projectee  -> match projectee with | List _0 -> _0 
let (uu___is_Unset : option_val -> Prims.bool) =
  fun projectee  ->
    match projectee with | Unset  -> true | uu____294 -> false
  
let (mk_bool : Prims.bool -> option_val) = fun _0_1  -> Bool _0_1 
let (mk_string : Prims.string -> option_val) = fun _0_2  -> String _0_2 
let (mk_path : Prims.string -> option_val) = fun _0_3  -> Path _0_3 
let (mk_int : Prims.int -> option_val) = fun _0_4  -> Int _0_4 
let (mk_list : option_val Prims.list -> option_val) = fun _0_5  -> List _0_5 
type options =
  | Set 
  | Reset 
  | Restore 
let (uu___is_Set : options -> Prims.bool) =
  fun projectee  -> match projectee with | Set  -> true | uu____336 -> false 
let (uu___is_Reset : options -> Prims.bool) =
  fun projectee  ->
    match projectee with | Reset  -> true | uu____347 -> false
  
let (uu___is_Restore : options -> Prims.bool) =
  fun projectee  ->
    match projectee with | Restore  -> true | uu____358 -> false
  
let (__unit_tests__ : Prims.bool FStar_ST.ref) = FStar_Util.mk_ref false 
let (__unit_tests : unit -> Prims.bool) =
  fun uu____383  -> FStar_ST.op_Bang __unit_tests__ 
let (__set_unit_tests : unit -> unit) =
  fun uu____410  -> FStar_ST.op_Colon_Equals __unit_tests__ true 
let (__clear_unit_tests : unit -> unit) =
  fun uu____438  -> FStar_ST.op_Colon_Equals __unit_tests__ false 
let (as_bool : option_val -> Prims.bool) =
  fun uu___80_467  ->
    match uu___80_467 with
    | Bool b -> b
    | uu____471 -> failwith "Impos: expected Bool"
  
let (as_int : option_val -> Prims.int) =
  fun uu___81_480  ->
    match uu___81_480 with
    | Int b -> b
    | uu____484 -> failwith "Impos: expected Int"
  
let (as_string : option_val -> Prims.string) =
  fun uu___82_493  ->
    match uu___82_493 with
    | String b -> b
    | Path b -> FStar_Common.try_convert_file_name_to_mixed b
    | uu____499 -> failwith "Impos: expected String"
  
let (as_list' : option_val -> option_val Prims.list) =
  fun uu___83_509  ->
    match uu___83_509 with
    | List ts -> ts
    | uu____515 -> failwith "Impos: expected List"
  
let as_list :
  'Auu____526 .
    (option_val -> 'Auu____526) -> option_val -> 'Auu____526 Prims.list
  =
  fun as_t  ->
    fun x  ->
      let uu____544 = as_list' x  in
      FStar_All.pipe_right uu____544 (FStar_List.map as_t)
  
let as_option :
  'Auu____558 .
    (option_val -> 'Auu____558) ->
      option_val -> 'Auu____558 FStar_Pervasives_Native.option
  =
  fun as_t  ->
    fun uu___84_573  ->
      match uu___84_573 with
      | Unset  -> FStar_Pervasives_Native.None
      | v1 ->
          let uu____577 = as_t v1  in FStar_Pervasives_Native.Some uu____577
  
let (as_comma_string_list : option_val -> Prims.string Prims.list) =
  fun uu___85_586  ->
    match uu___85_586 with
    | List ls ->
        let uu____593 =
          FStar_List.map
            (fun l  ->
               let uu____605 = as_string l  in FStar_Util.split uu____605 ",")
            ls
           in
        FStar_All.pipe_left FStar_List.flatten uu____593
    | uu____617 -> failwith "Impos: expected String (comma list)"
  
type optionstate = option_val FStar_Util.smap
let (fstar_options : optionstate Prims.list Prims.list FStar_ST.ref) =
  FStar_Util.mk_ref [] 
let (peek : unit -> optionstate) =
  fun uu____653  ->
    let uu____654 =
      let uu____657 = FStar_ST.op_Bang fstar_options  in
      FStar_List.hd uu____657  in
    FStar_List.hd uu____654
  
let (pop : unit -> unit) =
  fun uu____696  ->
    let uu____697 = FStar_ST.op_Bang fstar_options  in
    match uu____697 with
    | [] -> failwith "TOO MANY POPS!"
    | uu____732::[] -> failwith "TOO MANY POPS!"
    | uu____740::tl1 -> FStar_ST.op_Colon_Equals fstar_options tl1
  
let (push : unit -> unit) =
  fun uu____782  ->
    let uu____783 =
      let uu____788 =
        let uu____791 =
          let uu____794 = FStar_ST.op_Bang fstar_options  in
          FStar_List.hd uu____794  in
        FStar_List.map FStar_Util.smap_copy uu____791  in
      let uu____828 = FStar_ST.op_Bang fstar_options  in uu____788 ::
        uu____828
       in
    FStar_ST.op_Colon_Equals fstar_options uu____783
  
let (internal_pop : unit -> Prims.bool) =
  fun uu____895  ->
    let curstack =
      let uu____899 = FStar_ST.op_Bang fstar_options  in
      FStar_List.hd uu____899  in
    match curstack with
    | [] -> failwith "impossible: empty current option stack"
    | uu____936::[] -> false
    | uu____938::tl1 ->
        ((let uu____943 =
            let uu____948 =
              let uu____953 = FStar_ST.op_Bang fstar_options  in
              FStar_List.tl uu____953  in
            tl1 :: uu____948  in
          FStar_ST.op_Colon_Equals fstar_options uu____943);
         true)
  
let (internal_push : unit -> unit) =
  fun uu____1022  ->
    let curstack =
      let uu____1026 = FStar_ST.op_Bang fstar_options  in
      FStar_List.hd uu____1026  in
    let stack' =
      let uu____1063 =
        let uu____1064 = FStar_List.hd curstack  in
        FStar_Util.smap_copy uu____1064  in
      uu____1063 :: curstack  in
    let uu____1067 =
      let uu____1072 =
        let uu____1077 = FStar_ST.op_Bang fstar_options  in
        FStar_List.tl uu____1077  in
      stack' :: uu____1072  in
    FStar_ST.op_Colon_Equals fstar_options uu____1067
  
let (set : optionstate -> unit) =
  fun o  ->
    let uu____1146 = FStar_ST.op_Bang fstar_options  in
    match uu____1146 with
    | [] -> failwith "set on empty option stack"
    | []::uu____1181 -> failwith "set on empty current option stack"
    | (uu____1189::tl1)::os ->
        FStar_ST.op_Colon_Equals fstar_options ((o :: tl1) :: os)
  
let (snapshot : unit -> (Prims.int * unit)) =
  fun uu____1239  -> FStar_Common.snapshot push fstar_options () 
let (rollback : Prims.int FStar_Pervasives_Native.option -> unit) =
  fun depth  -> FStar_Common.rollback pop fstar_options depth 
let (set_option : Prims.string -> option_val -> unit) =
  fun k  ->
    fun v1  ->
      let uu____1269 = peek ()  in FStar_Util.smap_add uu____1269 k v1
  
let (set_option' : (Prims.string * option_val) -> unit) =
  fun uu____1282  -> match uu____1282 with | (k,v1) -> set_option k v1 
let (light_off_files : Prims.string Prims.list FStar_ST.ref) =
  FStar_Util.mk_ref [] 
let (add_light_off_file : Prims.string -> unit) =
  fun filename  ->
    let uu____1321 =
      let uu____1325 = FStar_ST.op_Bang light_off_files  in filename ::
        uu____1325
       in
    FStar_ST.op_Colon_Equals light_off_files uu____1321
  
let (defaults : (Prims.string * option_val) Prims.list) =
  [("__temp_no_proj", (List []));
  ("__temp_fast_implicits", (Bool false));
  ("abort_on", (Int (Prims.parse_int "0")));
  ("admit_smt_queries", (Bool false));
  ("admit_except", Unset);
  ("already_cached", Unset);
  ("cache_checked_modules", (Bool false));
  ("cache_dir", Unset);
  ("cache_off", (Bool false));
  ("cmi", (Bool false));
  ("codegen", Unset);
  ("codegen-lib", (List []));
  ("debug", (List []));
  ("debug_level", (List []));
  ("defensive", (String "no"));
  ("dep", Unset);
  ("detail_errors", (Bool false));
  ("detail_hint_replay", (Bool false));
  ("doc", (Bool false));
  ("dump_module", (List []));
  ("eager_inference", (Bool false));
  ("eager_subtyping", (Bool false));
  ("expose_interfaces", (Bool false));
  ("extract", Unset);
  ("extract_all", (Bool false));
  ("extract_module", (List []));
  ("extract_namespace", (List []));
  ("fs_typ_app", (Bool false));
  ("full_context_dependency", (Bool true));
  ("hide_uvar_nums", (Bool false));
  ("hint_info", (Bool false));
  ("hint_file", Unset);
  ("in", (Bool false));
  ("ide", (Bool false));
  ("include", (List []));
  ("print", (Bool false));
  ("print_in_place", (Bool false));
  ("initial_fuel", (Int (Prims.parse_int "2")));
  ("initial_ifuel", (Int (Prims.parse_int "1")));
  ("keep_query_captions", (Bool true));
  ("lax", (Bool false));
  ("load", (List []));
  ("log_queries", (Bool false));
  ("log_types", (Bool false));
  ("max_fuel", (Int (Prims.parse_int "8")));
  ("max_ifuel", (Int (Prims.parse_int "2")));
  ("min_fuel", (Int (Prims.parse_int "1")));
  ("MLish", (Bool false));
  ("n_cores", (Int (Prims.parse_int "1")));
  ("no_default_includes", (Bool false));
  ("no_extract", (List []));
  ("no_location_info", (Bool false));
  ("no_smt", (Bool false));
  ("no_plugins", (Bool false));
  ("no_tactics", (Bool false));
  ("normalize_pure_terms_for_extraction", (Bool false));
  ("odir", Unset);
  ("prims", Unset);
  ("pretype", (Bool true));
  ("prims_ref", Unset);
  ("print_bound_var_types", (Bool false));
  ("print_effect_args", (Bool false));
  ("print_full_names", (Bool false));
  ("print_implicits", (Bool false));
  ("print_universes", (Bool false));
  ("print_z3_statistics", (Bool false));
  ("prn", (Bool false));
  ("query_stats", (Bool false));
  ("record_hints", (Bool false));
  ("reuse_hint_for", Unset);
  ("silent", (Bool false));
  ("smt", Unset);
  ("smtencoding.elim_box", (Bool false));
  ("smtencoding.nl_arith_repr", (String "boxwrap"));
  ("smtencoding.l_arith_repr", (String "boxwrap"));
  ("tactics_failhard", (Bool false));
  ("tactics_info", (Bool false));
  ("tactic_raw_binders", (Bool false));
  ("tactic_trace", (Bool false));
  ("tactic_trace_d", (Int (Prims.parse_int "0")));
  ("tcnorm", (Bool true));
  ("timing", (Bool false));
  ("trace_error", (Bool false));
  ("ugly", (Bool false));
  ("unthrottle_inductives", (Bool false));
  ("unsafe_tactic_exec", (Bool false));
  ("use_native_tactics", Unset);
  ("use_eq_at_higher_order", (Bool false));
  ("use_hints", (Bool false));
  ("use_hint_hashes", (Bool false));
  ("using_facts_from", Unset);
  ("vcgen.optimize_bind_as_seq", Unset);
  ("verify_module", (List []));
  ("warn_default_effects", (Bool false));
  ("z3refresh", (Bool false));
  ("z3rlimit", (Int (Prims.parse_int "5")));
  ("z3rlimit_factor", (Int (Prims.parse_int "1")));
  ("z3seed", (Int (Prims.parse_int "0")));
  ("z3cliopt", (List []));
  ("use_two_phase_tc", (Bool true));
  ("__no_positivity", (Bool false));
  ("__ml_no_eta_expand_coertions", (Bool false));
  ("__tactics_nbe", (Bool false));
  ("warn_error", (String ""));
  ("use_extracted_interfaces", (Bool false));
  ("use_nbe", (Bool false));
  ("use_tc_cache", (Bool false))] 
let (init : unit -> unit) =
  fun uu____2227  ->
    let o = peek ()  in
    FStar_Util.smap_clear o;
    FStar_All.pipe_right defaults (FStar_List.iter set_option')
  
let (clear : unit -> unit) =
  fun uu____2247  ->
    let o = FStar_Util.smap_create (Prims.parse_int "50")  in
    FStar_ST.op_Colon_Equals fstar_options [[o]];
    FStar_ST.op_Colon_Equals light_off_files [];
    init ()
  
let (_run : unit) = clear () 
let (get_option : Prims.string -> option_val) =
  fun s  ->
    let uu____2320 =
      let uu____2323 = peek ()  in FStar_Util.smap_try_find uu____2323 s  in
    match uu____2320 with
    | FStar_Pervasives_Native.None  ->
        failwith
          (Prims.strcat "Impossible: option " (Prims.strcat s " not found"))
    | FStar_Pervasives_Native.Some s1 -> s1
  
let lookup_opt :
  'Auu____2336 . Prims.string -> (option_val -> 'Auu____2336) -> 'Auu____2336
  = fun s  -> fun c  -> let uu____2354 = get_option s  in c uu____2354 
let (get_abort_on : unit -> Prims.int) =
  fun uu____2361  -> lookup_opt "abort_on" as_int 
let (get_admit_smt_queries : unit -> Prims.bool) =
  fun uu____2370  -> lookup_opt "admit_smt_queries" as_bool 
let (get_admit_except : unit -> Prims.string FStar_Pervasives_Native.option)
  = fun uu____2381  -> lookup_opt "admit_except" (as_option as_string) 
let (get_already_cached :
  unit -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun uu____2397  ->
    lookup_opt "already_cached" (as_option (as_list as_string))
  
let (get_cache_checked_modules : unit -> Prims.bool) =
  fun uu____2414  -> lookup_opt "cache_checked_modules" as_bool 
let (get_cache_dir : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2425  -> lookup_opt "cache_dir" (as_option as_string) 
let (get_cache_off : unit -> Prims.bool) =
  fun uu____2437  -> lookup_opt "cache_off" as_bool 
let (get_cmi : unit -> Prims.bool) =
  fun uu____2446  -> lookup_opt "cmi" as_bool 
let (get_codegen : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2457  -> lookup_opt "codegen" (as_option as_string) 
let (get_codegen_lib : unit -> Prims.string Prims.list) =
  fun uu____2471  -> lookup_opt "codegen-lib" (as_list as_string) 
let (get_debug : unit -> Prims.string Prims.list) =
  fun uu____2485  -> lookup_opt "debug" (as_list as_string) 
let (get_debug_level : unit -> Prims.string Prims.list) =
  fun uu____2499  -> lookup_opt "debug_level" as_comma_string_list 
let (get_defensive : unit -> Prims.string) =
  fun uu____2510  -> lookup_opt "defensive" as_string 
let (get_dep : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2521  -> lookup_opt "dep" (as_option as_string) 
let (get_detail_errors : unit -> Prims.bool) =
  fun uu____2533  -> lookup_opt "detail_errors" as_bool 
let (get_detail_hint_replay : unit -> Prims.bool) =
  fun uu____2542  -> lookup_opt "detail_hint_replay" as_bool 
let (get_doc : unit -> Prims.bool) =
  fun uu____2551  -> lookup_opt "doc" as_bool 
let (get_dump_module : unit -> Prims.string Prims.list) =
  fun uu____2562  -> lookup_opt "dump_module" (as_list as_string) 
let (get_eager_subtyping : unit -> Prims.bool) =
  fun uu____2574  -> lookup_opt "eager_subtyping" as_bool 
let (get_expose_interfaces : unit -> Prims.bool) =
  fun uu____2583  -> lookup_opt "expose_interfaces" as_bool 
let (get_extract :
  unit -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun uu____2596  -> lookup_opt "extract" (as_option (as_list as_string)) 
let (get_extract_module : unit -> Prims.string Prims.list) =
  fun uu____2615  -> lookup_opt "extract_module" (as_list as_string) 
let (get_extract_namespace : unit -> Prims.string Prims.list) =
  fun uu____2629  -> lookup_opt "extract_namespace" (as_list as_string) 
let (get_fs_typ_app : unit -> Prims.bool) =
  fun uu____2641  -> lookup_opt "fs_typ_app" as_bool 
let (get_hide_uvar_nums : unit -> Prims.bool) =
  fun uu____2650  -> lookup_opt "hide_uvar_nums" as_bool 
let (get_hint_info : unit -> Prims.bool) =
  fun uu____2659  -> lookup_opt "hint_info" as_bool 
let (get_hint_file : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2670  -> lookup_opt "hint_file" (as_option as_string) 
let (get_in : unit -> Prims.bool) =
  fun uu____2682  -> lookup_opt "in" as_bool 
let (get_ide : unit -> Prims.bool) =
  fun uu____2691  -> lookup_opt "ide" as_bool 
let (get_include : unit -> Prims.string Prims.list) =
  fun uu____2702  -> lookup_opt "include" (as_list as_string) 
let (get_print : unit -> Prims.bool) =
  fun uu____2714  -> lookup_opt "print" as_bool 
let (get_print_in_place : unit -> Prims.bool) =
  fun uu____2723  -> lookup_opt "print_in_place" as_bool 
let (get_initial_fuel : unit -> Prims.int) =
  fun uu____2732  -> lookup_opt "initial_fuel" as_int 
let (get_initial_ifuel : unit -> Prims.int) =
  fun uu____2741  -> lookup_opt "initial_ifuel" as_int 
let (get_keep_query_captions : unit -> Prims.bool) =
  fun uu____2750  -> lookup_opt "keep_query_captions" as_bool 
let (get_lax : unit -> Prims.bool) =
  fun uu____2759  -> lookup_opt "lax" as_bool 
let (get_load : unit -> Prims.string Prims.list) =
  fun uu____2770  -> lookup_opt "load" (as_list as_string) 
let (get_log_queries : unit -> Prims.bool) =
  fun uu____2782  -> lookup_opt "log_queries" as_bool 
let (get_log_types : unit -> Prims.bool) =
  fun uu____2791  -> lookup_opt "log_types" as_bool 
let (get_max_fuel : unit -> Prims.int) =
  fun uu____2800  -> lookup_opt "max_fuel" as_int 
let (get_max_ifuel : unit -> Prims.int) =
  fun uu____2809  -> lookup_opt "max_ifuel" as_int 
let (get_min_fuel : unit -> Prims.int) =
  fun uu____2818  -> lookup_opt "min_fuel" as_int 
let (get_MLish : unit -> Prims.bool) =
  fun uu____2827  -> lookup_opt "MLish" as_bool 
let (get_n_cores : unit -> Prims.int) =
  fun uu____2836  -> lookup_opt "n_cores" as_int 
let (get_no_default_includes : unit -> Prims.bool) =
  fun uu____2845  -> lookup_opt "no_default_includes" as_bool 
let (get_no_extract : unit -> Prims.string Prims.list) =
  fun uu____2856  -> lookup_opt "no_extract" (as_list as_string) 
let (get_no_location_info : unit -> Prims.bool) =
  fun uu____2868  -> lookup_opt "no_location_info" as_bool 
let (get_no_plugins : unit -> Prims.bool) =
  fun uu____2877  -> lookup_opt "no_plugins" as_bool 
let (get_no_smt : unit -> Prims.bool) =
  fun uu____2886  -> lookup_opt "no_smt" as_bool 
let (get_normalize_pure_terms_for_extraction : unit -> Prims.bool) =
  fun uu____2895  -> lookup_opt "normalize_pure_terms_for_extraction" as_bool 
let (get_odir : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2906  -> lookup_opt "odir" (as_option as_string) 
let (get_ugly : unit -> Prims.bool) =
  fun uu____2918  -> lookup_opt "ugly" as_bool 
let (get_prims : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____2929  -> lookup_opt "prims" (as_option as_string) 
let (get_print_bound_var_types : unit -> Prims.bool) =
  fun uu____2941  -> lookup_opt "print_bound_var_types" as_bool 
let (get_print_effect_args : unit -> Prims.bool) =
  fun uu____2950  -> lookup_opt "print_effect_args" as_bool 
let (get_print_full_names : unit -> Prims.bool) =
  fun uu____2959  -> lookup_opt "print_full_names" as_bool 
let (get_print_implicits : unit -> Prims.bool) =
  fun uu____2968  -> lookup_opt "print_implicits" as_bool 
let (get_print_universes : unit -> Prims.bool) =
  fun uu____2977  -> lookup_opt "print_universes" as_bool 
let (get_print_z3_statistics : unit -> Prims.bool) =
  fun uu____2986  -> lookup_opt "print_z3_statistics" as_bool 
let (get_prn : unit -> Prims.bool) =
  fun uu____2995  -> lookup_opt "prn" as_bool 
let (get_query_stats : unit -> Prims.bool) =
  fun uu____3004  -> lookup_opt "query_stats" as_bool 
let (get_record_hints : unit -> Prims.bool) =
  fun uu____3013  -> lookup_opt "record_hints" as_bool 
let (get_reuse_hint_for :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3024  -> lookup_opt "reuse_hint_for" (as_option as_string) 
let (get_silent : unit -> Prims.bool) =
  fun uu____3036  -> lookup_opt "silent" as_bool 
let (get_smt : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3047  -> lookup_opt "smt" (as_option as_string) 
let (get_smtencoding_elim_box : unit -> Prims.bool) =
  fun uu____3059  -> lookup_opt "smtencoding.elim_box" as_bool 
let (get_smtencoding_nl_arith_repr : unit -> Prims.string) =
  fun uu____3068  -> lookup_opt "smtencoding.nl_arith_repr" as_string 
let (get_smtencoding_l_arith_repr : unit -> Prims.string) =
  fun uu____3077  -> lookup_opt "smtencoding.l_arith_repr" as_string 
let (get_tactic_raw_binders : unit -> Prims.bool) =
  fun uu____3086  -> lookup_opt "tactic_raw_binders" as_bool 
let (get_tactics_failhard : unit -> Prims.bool) =
  fun uu____3095  -> lookup_opt "tactics_failhard" as_bool 
let (get_tactics_info : unit -> Prims.bool) =
  fun uu____3104  -> lookup_opt "tactics_info" as_bool 
let (get_tactic_trace : unit -> Prims.bool) =
  fun uu____3113  -> lookup_opt "tactic_trace" as_bool 
let (get_tactic_trace_d : unit -> Prims.int) =
  fun uu____3122  -> lookup_opt "tactic_trace_d" as_int 
let (get_tactics_nbe : unit -> Prims.bool) =
  fun uu____3131  -> lookup_opt "__tactics_nbe" as_bool 
let (get_tcnorm : unit -> Prims.bool) =
  fun uu____3140  -> lookup_opt "tcnorm" as_bool 
let (get_timing : unit -> Prims.bool) =
  fun uu____3149  -> lookup_opt "timing" as_bool 
let (get_trace_error : unit -> Prims.bool) =
  fun uu____3158  -> lookup_opt "trace_error" as_bool 
let (get_unthrottle_inductives : unit -> Prims.bool) =
  fun uu____3167  -> lookup_opt "unthrottle_inductives" as_bool 
let (get_unsafe_tactic_exec : unit -> Prims.bool) =
  fun uu____3176  -> lookup_opt "unsafe_tactic_exec" as_bool 
let (get_use_eq_at_higher_order : unit -> Prims.bool) =
  fun uu____3185  -> lookup_opt "use_eq_at_higher_order" as_bool 
let (get_use_hints : unit -> Prims.bool) =
  fun uu____3194  -> lookup_opt "use_hints" as_bool 
let (get_use_hint_hashes : unit -> Prims.bool) =
  fun uu____3203  -> lookup_opt "use_hint_hashes" as_bool 
let (get_use_native_tactics :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3214  -> lookup_opt "use_native_tactics" (as_option as_string) 
let (get_use_tactics : unit -> Prims.bool) =
  fun uu____3226  ->
    let uu____3227 = lookup_opt "no_tactics" as_bool  in
    Prims.op_Negation uu____3227
  
let (get_using_facts_from :
  unit -> Prims.string Prims.list FStar_Pervasives_Native.option) =
  fun uu____3241  ->
    lookup_opt "using_facts_from" (as_option (as_list as_string))
  
let (get_vcgen_optimize_bind_as_seq :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____3260  ->
    lookup_opt "vcgen.optimize_bind_as_seq" (as_option as_string)
  
let (get_verify_module : unit -> Prims.string Prims.list) =
  fun uu____3274  -> lookup_opt "verify_module" (as_list as_string) 
let (get___temp_no_proj : unit -> Prims.string Prims.list) =
  fun uu____3288  -> lookup_opt "__temp_no_proj" (as_list as_string) 
let (get_version : unit -> Prims.bool) =
  fun uu____3300  -> lookup_opt "version" as_bool 
let (get_warn_default_effects : unit -> Prims.bool) =
  fun uu____3309  -> lookup_opt "warn_default_effects" as_bool 
let (get_z3cliopt : unit -> Prims.string Prims.list) =
  fun uu____3320  -> lookup_opt "z3cliopt" (as_list as_string) 
let (get_z3refresh : unit -> Prims.bool) =
  fun uu____3332  -> lookup_opt "z3refresh" as_bool 
let (get_z3rlimit : unit -> Prims.int) =
  fun uu____3341  -> lookup_opt "z3rlimit" as_int 
let (get_z3rlimit_factor : unit -> Prims.int) =
  fun uu____3350  -> lookup_opt "z3rlimit_factor" as_int 
let (get_z3seed : unit -> Prims.int) =
  fun uu____3359  -> lookup_opt "z3seed" as_int 
let (get_use_two_phase_tc : unit -> Prims.bool) =
  fun uu____3368  -> lookup_opt "use_two_phase_tc" as_bool 
let (get_no_positivity : unit -> Prims.bool) =
  fun uu____3377  -> lookup_opt "__no_positivity" as_bool 
let (get_ml_no_eta_expand_coertions : unit -> Prims.bool) =
  fun uu____3386  -> lookup_opt "__ml_no_eta_expand_coertions" as_bool 
let (get_warn_error : unit -> Prims.string) =
  fun uu____3395  -> lookup_opt "warn_error" as_string 
let (get_use_extracted_interfaces : unit -> Prims.bool) =
  fun uu____3404  -> lookup_opt "use_extracted_interfaces" as_bool 
let (get_use_nbe : unit -> Prims.bool) =
  fun uu____3413  -> lookup_opt "use_nbe" as_bool 
let (get_use_tc_cache : unit -> Prims.bool) =
  fun uu____3422  -> lookup_opt "use_tc_cache" as_bool 
let (dlevel : Prims.string -> debug_level_t) =
  fun uu___86_3431  ->
    match uu___86_3431 with
    | "Low" -> Low
    | "Medium" -> Medium
    | "High" -> High
    | "Extreme" -> Extreme
    | s -> Other s
  
let (one_debug_level_geq : debug_level_t -> debug_level_t -> Prims.bool) =
  fun l1  ->
    fun l2  ->
      match l1 with
      | Other uu____3452 -> l1 = l2
      | Low  -> l1 = l2
      | Medium  -> (l2 = Low) || (l2 = Medium)
      | High  -> ((l2 = Low) || (l2 = Medium)) || (l2 = High)
      | Extreme  ->
          (((l2 = Low) || (l2 = Medium)) || (l2 = High)) || (l2 = Extreme)
  
let (debug_level_geq : debug_level_t -> Prims.bool) =
  fun l2  ->
    let uu____3461 = get_debug_level ()  in
    FStar_All.pipe_right uu____3461
      (FStar_Util.for_some (fun l1  -> one_debug_level_geq (dlevel l1) l2))
  
let (universe_include_path_base_dirs : Prims.string Prims.list) =
  ["/ulib"; "/lib/fstar"] 
let (_version : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (_platform : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (_compiler : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (_date : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "<not set>" 
let (_commit : Prims.string FStar_ST.ref) = FStar_Util.mk_ref "" 
let (display_version : unit -> unit) =
  fun uu____3627  ->
    let uu____3628 =
      let uu____3630 = FStar_ST.op_Bang _version  in
      let uu____3653 = FStar_ST.op_Bang _platform  in
      let uu____3676 = FStar_ST.op_Bang _compiler  in
      let uu____3699 = FStar_ST.op_Bang _date  in
      let uu____3722 = FStar_ST.op_Bang _commit  in
      FStar_Util.format5
        "F* %s\nplatform=%s\ncompiler=%s\ndate=%s\ncommit=%s\n" uu____3630
        uu____3653 uu____3676 uu____3699 uu____3722
       in
    FStar_Util.print_string uu____3628
  
let display_usage_aux :
  'Auu____3753 'Auu____3754 .
    ('Auu____3753 * Prims.string * 'Auu____3754 FStar_Getopt.opt_variant *
      Prims.string) Prims.list -> unit
  =
  fun specs  ->
    FStar_Util.print_string "fstar.exe [options] file[s]\n";
    FStar_List.iter
      (fun uu____3809  ->
         match uu____3809 with
         | (uu____3822,flag,p,doc) ->
             (match p with
              | FStar_Getopt.ZeroArgs ig ->
                  if doc = ""
                  then
                    let uu____3841 =
                      let uu____3843 = FStar_Util.colorize_bold flag  in
                      FStar_Util.format1 "  --%s\n" uu____3843  in
                    FStar_Util.print_string uu____3841
                  else
                    (let uu____3848 =
                       let uu____3850 = FStar_Util.colorize_bold flag  in
                       FStar_Util.format2 "  --%s  %s\n" uu____3850 doc  in
                     FStar_Util.print_string uu____3848)
              | FStar_Getopt.OneArg (uu____3853,argname) ->
                  if doc = ""
                  then
                    let uu____3868 =
                      let uu____3870 = FStar_Util.colorize_bold flag  in
                      let uu____3872 = FStar_Util.colorize_bold argname  in
                      FStar_Util.format2 "  --%s %s\n" uu____3870 uu____3872
                       in
                    FStar_Util.print_string uu____3868
                  else
                    (let uu____3877 =
                       let uu____3879 = FStar_Util.colorize_bold flag  in
                       let uu____3881 = FStar_Util.colorize_bold argname  in
                       FStar_Util.format3 "  --%s %s  %s\n" uu____3879
                         uu____3881 doc
                        in
                     FStar_Util.print_string uu____3877))) specs
  
let (mk_spec :
  (FStar_BaseTypes.char * Prims.string * option_val FStar_Getopt.opt_variant
    * Prims.string) -> FStar_Getopt.opt)
  =
  fun o  ->
    let uu____3916 = o  in
    match uu____3916 with
    | (ns,name,arg,desc) ->
        let arg1 =
          match arg with
          | FStar_Getopt.ZeroArgs f ->
              let g uu____3958 =
                let uu____3959 = f ()  in set_option name uu____3959  in
              FStar_Getopt.ZeroArgs g
          | FStar_Getopt.OneArg (f,d) ->
              let g x = let uu____3980 = f x  in set_option name uu____3980
                 in
              FStar_Getopt.OneArg (g, d)
           in
        (ns, name, arg1, desc)
  
let (accumulated_option : Prims.string -> option_val -> option_val) =
  fun name  ->
    fun value  ->
      let prev_values =
        let uu____4007 = lookup_opt name (as_option as_list')  in
        FStar_Util.dflt [] uu____4007  in
      mk_list (value :: prev_values)
  
let (reverse_accumulated_option : Prims.string -> option_val -> option_val) =
  fun name  ->
    fun value  ->
      let uu____4033 =
        let uu____4036 = lookup_opt name as_list'  in
        FStar_List.append uu____4036 [value]  in
      mk_list uu____4033
  
let accumulate_string :
  'Auu____4050 .
    Prims.string -> ('Auu____4050 -> Prims.string) -> 'Auu____4050 -> unit
  =
  fun name  ->
    fun post_processor  ->
      fun value  ->
        let uu____4075 =
          let uu____4076 =
            let uu____4077 = post_processor value  in mk_string uu____4077
             in
          accumulated_option name uu____4076  in
        set_option name uu____4075
  
let (add_extract_module : Prims.string -> unit) =
  fun s  -> accumulate_string "extract_module" FStar_String.lowercase s 
let (add_extract_namespace : Prims.string -> unit) =
  fun s  -> accumulate_string "extract_namespace" FStar_String.lowercase s 
let (add_verify_module : Prims.string -> unit) =
  fun s  -> accumulate_string "verify_module" FStar_String.lowercase s 
type opt_type =
  | Const of option_val 
  | IntStr of Prims.string 
  | BoolStr 
  | PathStr of Prims.string 
  | SimpleStr of Prims.string 
  | EnumStr of Prims.string Prims.list 
  | OpenEnumStr of (Prims.string Prims.list * Prims.string) 
  | PostProcessed of ((option_val -> option_val) * opt_type) 
  | Accumulated of opt_type 
  | ReverseAccumulated of opt_type 
  | WithSideEffect of ((unit -> unit) * opt_type) 
let (uu___is_Const : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | Const _0 -> true | uu____4199 -> false
  
let (__proj__Const__item___0 : opt_type -> option_val) =
  fun projectee  -> match projectee with | Const _0 -> _0 
let (uu___is_IntStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | IntStr _0 -> true | uu____4220 -> false
  
let (__proj__IntStr__item___0 : opt_type -> Prims.string) =
  fun projectee  -> match projectee with | IntStr _0 -> _0 
let (uu___is_BoolStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | BoolStr  -> true | uu____4242 -> false
  
let (uu___is_PathStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | PathStr _0 -> true | uu____4255 -> false
  
let (__proj__PathStr__item___0 : opt_type -> Prims.string) =
  fun projectee  -> match projectee with | PathStr _0 -> _0 
let (uu___is_SimpleStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | SimpleStr _0 -> true | uu____4279 -> false
  
let (__proj__SimpleStr__item___0 : opt_type -> Prims.string) =
  fun projectee  -> match projectee with | SimpleStr _0 -> _0 
let (uu___is_EnumStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | EnumStr _0 -> true | uu____4305 -> false
  
let (__proj__EnumStr__item___0 : opt_type -> Prims.string Prims.list) =
  fun projectee  -> match projectee with | EnumStr _0 -> _0 
let (uu___is_OpenEnumStr : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | OpenEnumStr _0 -> true | uu____4342 -> false
  
let (__proj__OpenEnumStr__item___0 :
  opt_type -> (Prims.string Prims.list * Prims.string)) =
  fun projectee  -> match projectee with | OpenEnumStr _0 -> _0 
let (uu___is_PostProcessed : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | PostProcessed _0 -> true | uu____4393 -> false
  
let (__proj__PostProcessed__item___0 :
  opt_type -> ((option_val -> option_val) * opt_type)) =
  fun projectee  -> match projectee with | PostProcessed _0 -> _0 
let (uu___is_Accumulated : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | Accumulated _0 -> true | uu____4434 -> false
  
let (__proj__Accumulated__item___0 : opt_type -> opt_type) =
  fun projectee  -> match projectee with | Accumulated _0 -> _0 
let (uu___is_ReverseAccumulated : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | ReverseAccumulated _0 -> true
    | uu____4454 -> false
  
let (__proj__ReverseAccumulated__item___0 : opt_type -> opt_type) =
  fun projectee  -> match projectee with | ReverseAccumulated _0 -> _0 
let (uu___is_WithSideEffect : opt_type -> Prims.bool) =
  fun projectee  ->
    match projectee with | WithSideEffect _0 -> true | uu____4481 -> false
  
let (__proj__WithSideEffect__item___0 :
  opt_type -> ((unit -> unit) * opt_type)) =
  fun projectee  -> match projectee with | WithSideEffect _0 -> _0 
exception InvalidArgument of Prims.string 
let (uu___is_InvalidArgument : Prims.exn -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | InvalidArgument uu____4525 -> true
    | uu____4528 -> false
  
let (__proj__InvalidArgument__item__uu___ : Prims.exn -> Prims.string) =
  fun projectee  ->
    match projectee with | InvalidArgument uu____4539 -> uu____4539
  
let rec (parse_opt_val :
  Prims.string -> opt_type -> Prims.string -> option_val) =
  fun opt_name  ->
    fun typ  ->
      fun str_val  ->
        try
          (fun uu___91_4563  ->
             match () with
             | () ->
                 (match typ with
                  | Const c -> c
                  | IntStr uu____4565 ->
                      let uu____4567 = FStar_Util.safe_int_of_string str_val
                         in
                      (match uu____4567 with
                       | FStar_Pervasives_Native.Some v1 -> mk_int v1
                       | FStar_Pervasives_Native.None  ->
                           FStar_Exn.raise (InvalidArgument opt_name))
                  | BoolStr  ->
                      let uu____4575 =
                        if str_val = "true"
                        then true
                        else
                          if str_val = "false"
                          then false
                          else FStar_Exn.raise (InvalidArgument opt_name)
                         in
                      mk_bool uu____4575
                  | PathStr uu____4592 -> mk_path str_val
                  | SimpleStr uu____4594 -> mk_string str_val
                  | EnumStr strs ->
                      if FStar_List.mem str_val strs
                      then mk_string str_val
                      else FStar_Exn.raise (InvalidArgument opt_name)
                  | OpenEnumStr uu____4604 -> mk_string str_val
                  | PostProcessed (pp,elem_spec) ->
                      let uu____4621 =
                        parse_opt_val opt_name elem_spec str_val  in
                      pp uu____4621
                  | Accumulated elem_spec ->
                      let v1 = parse_opt_val opt_name elem_spec str_val  in
                      accumulated_option opt_name v1
                  | ReverseAccumulated elem_spec ->
                      let v1 = parse_opt_val opt_name elem_spec str_val  in
                      reverse_accumulated_option opt_name v1
                  | WithSideEffect (side_effect,elem_spec) ->
                      (side_effect ();
                       parse_opt_val opt_name elem_spec str_val))) ()
        with
        | InvalidArgument opt_name1 ->
            let uu____4641 =
              FStar_Util.format1 "Invalid argument to --%s" opt_name1  in
            failwith uu____4641
  
let rec (desc_of_opt_type :
  opt_type -> Prims.string FStar_Pervasives_Native.option) =
  fun typ  ->
    let desc_of_enum cases =
      FStar_Pervasives_Native.Some
        (Prims.strcat "[" (Prims.strcat (FStar_String.concat "|" cases) "]"))
       in
    match typ with
    | Const c -> FStar_Pervasives_Native.None
    | IntStr desc -> FStar_Pervasives_Native.Some desc
    | BoolStr  -> desc_of_enum ["true"; "false"]
    | PathStr desc -> FStar_Pervasives_Native.Some desc
    | SimpleStr desc -> FStar_Pervasives_Native.Some desc
    | EnumStr strs -> desc_of_enum strs
    | OpenEnumStr (strs,desc) -> desc_of_enum (FStar_List.append strs [desc])
    | PostProcessed (uu____4711,elem_spec) -> desc_of_opt_type elem_spec
    | Accumulated elem_spec -> desc_of_opt_type elem_spec
    | ReverseAccumulated elem_spec -> desc_of_opt_type elem_spec
    | WithSideEffect (uu____4721,elem_spec) -> desc_of_opt_type elem_spec
  
let rec (arg_spec_of_opt_type :
  Prims.string -> opt_type -> option_val FStar_Getopt.opt_variant) =
  fun opt_name  ->
    fun typ  ->
      let parser = parse_opt_val opt_name typ  in
      let uu____4752 = desc_of_opt_type typ  in
      match uu____4752 with
      | FStar_Pervasives_Native.None  ->
          FStar_Getopt.ZeroArgs ((fun uu____4760  -> parser ""))
      | FStar_Pervasives_Native.Some desc ->
          FStar_Getopt.OneArg (parser, desc)
  
let (pp_validate_dir : option_val -> option_val) =
  fun p  -> let pp = as_string p  in FStar_Util.mkdir false pp; p 
let (pp_lowercase : option_val -> option_val) =
  fun s  ->
    let uu____4786 =
      let uu____4788 = as_string s  in FStar_String.lowercase uu____4788  in
    mk_string uu____4786
  
let (abort_counter : Prims.int FStar_ST.ref) =
  FStar_Util.mk_ref (Prims.parse_int "0") 
let rec (specs_with_types :
  unit ->
    (FStar_BaseTypes.char * Prims.string * opt_type * Prims.string)
      Prims.list)
  =
  fun uu____4845  ->
    let uu____4859 =
      let uu____4873 =
        let uu____4887 =
          let uu____4901 =
            let uu____4915 =
              let uu____4927 =
                let uu____4928 = mk_bool true  in Const uu____4928  in
              (FStar_Getopt.noshort, "cache_checked_modules", uu____4927,
                "Write a '.checked' file for each module after verification and read from it if present, instead of re-verifying")
               in
            let uu____4935 =
              let uu____4949 =
                let uu____4963 =
                  let uu____4975 =
                    let uu____4976 = mk_bool true  in Const uu____4976  in
                  (FStar_Getopt.noshort, "cache_off", uu____4975,
                    "Do not read or write any .checked files")
                   in
                let uu____4983 =
                  let uu____4997 =
                    let uu____5009 =
                      let uu____5010 = mk_bool true  in Const uu____5010  in
                    (FStar_Getopt.noshort, "cmi", uu____5009,
                      "Inline across module interfaces during extraction (aka. cross-module inlining)")
                     in
                  let uu____5017 =
                    let uu____5031 =
                      let uu____5045 =
                        let uu____5059 =
                          let uu____5073 =
                            let uu____5087 =
                              let uu____5101 =
                                let uu____5115 =
                                  let uu____5127 =
                                    let uu____5128 = mk_bool true  in
                                    Const uu____5128  in
                                  (FStar_Getopt.noshort, "detail_errors",
                                    uu____5127,
                                    "Emit a detailed error report by asking the SMT solver many queries; will take longer;\n         implies n_cores=1")
                                   in
                                let uu____5135 =
                                  let uu____5149 =
                                    let uu____5161 =
                                      let uu____5162 = mk_bool true  in
                                      Const uu____5162  in
                                    (FStar_Getopt.noshort,
                                      "detail_hint_replay", uu____5161,
                                      "Emit a detailed report for proof whose unsat core fails to replay;\n         implies n_cores=1")
                                     in
                                  let uu____5169 =
                                    let uu____5183 =
                                      let uu____5195 =
                                        let uu____5196 = mk_bool true  in
                                        Const uu____5196  in
                                      (FStar_Getopt.noshort, "doc",
                                        uu____5195,
                                        "Extract Markdown documentation files for the input modules, as well as an index. Output is written to --odir directory.")
                                       in
                                    let uu____5203 =
                                      let uu____5217 =
                                        let uu____5231 =
                                          let uu____5243 =
                                            let uu____5244 = mk_bool true  in
                                            Const uu____5244  in
                                          (FStar_Getopt.noshort,
                                            "eager_inference", uu____5243,
                                            "Deprecated: Solve all type-inference constraints eagerly; more efficient but at the cost of generality")
                                           in
                                        let uu____5251 =
                                          let uu____5265 =
                                            let uu____5277 =
                                              let uu____5278 = mk_bool true
                                                 in
                                              Const uu____5278  in
                                            (FStar_Getopt.noshort,
                                              "eager_subtyping", uu____5277,
                                              "Try to solve subtyping constraints at each binder (loses precision but may be slightly more efficient)")
                                             in
                                          let uu____5285 =
                                            let uu____5299 =
                                              let uu____5313 =
                                                let uu____5327 =
                                                  let uu____5341 =
                                                    let uu____5353 =
                                                      let uu____5354 =
                                                        mk_bool true  in
                                                      Const uu____5354  in
                                                    (FStar_Getopt.noshort,
                                                      "expose_interfaces",
                                                      uu____5353,
                                                      "Explicitly break the abstraction imposed by the interface of any implementation file that appears on the command line (use with care!)")
                                                     in
                                                  let uu____5361 =
                                                    let uu____5375 =
                                                      let uu____5387 =
                                                        let uu____5388 =
                                                          mk_bool true  in
                                                        Const uu____5388  in
                                                      (FStar_Getopt.noshort,
                                                        "hide_uvar_nums",
                                                        uu____5387,
                                                        "Don't print unification variable numbers")
                                                       in
                                                    let uu____5395 =
                                                      let uu____5409 =
                                                        let uu____5423 =
                                                          let uu____5435 =
                                                            let uu____5436 =
                                                              mk_bool true
                                                               in
                                                            Const uu____5436
                                                             in
                                                          (FStar_Getopt.noshort,
                                                            "hint_info",
                                                            uu____5435,
                                                            "Print information regarding hints (deprecated; use --query_stats instead)")
                                                           in
                                                        let uu____5443 =
                                                          let uu____5457 =
                                                            let uu____5469 =
                                                              let uu____5470
                                                                =
                                                                mk_bool true
                                                                 in
                                                              Const
                                                                uu____5470
                                                               in
                                                            (FStar_Getopt.noshort,
                                                              "in",
                                                              uu____5469,
                                                              "Legacy interactive mode; reads input from stdin")
                                                             in
                                                          let uu____5477 =
                                                            let uu____5491 =
                                                              let uu____5503
                                                                =
                                                                let uu____5504
                                                                  =
                                                                  mk_bool
                                                                    true
                                                                   in
                                                                Const
                                                                  uu____5504
                                                                 in
                                                              (FStar_Getopt.noshort,
                                                                "ide",
                                                                uu____5503,
                                                                "JSON-based interactive mode for IDEs")
                                                               in
                                                            let uu____5511 =
                                                              let uu____5525
                                                                =
                                                                let uu____5539
                                                                  =
                                                                  let uu____5551
                                                                    =
                                                                    let uu____5552
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5552
                                                                     in
                                                                  (FStar_Getopt.noshort,
                                                                    "print",
                                                                    uu____5551,
                                                                    "Parses and prettyprints the files included on the command line")
                                                                   in
                                                                let uu____5559
                                                                  =
                                                                  let uu____5573
                                                                    =
                                                                    let uu____5585
                                                                    =
                                                                    let uu____5586
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5586
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_in_place",
                                                                    uu____5585,
                                                                    "Parses and prettyprints in place the files included on the command line")
                                                                     in
                                                                  let uu____5593
                                                                    =
                                                                    let uu____5607
                                                                    =
                                                                    let uu____5621
                                                                    =
                                                                    let uu____5635
                                                                    =
                                                                    let uu____5649
                                                                    =
                                                                    let uu____5661
                                                                    =
                                                                    let uu____5662
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5662
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "lax",
                                                                    uu____5661,
                                                                    "Run the lax-type checker only (admit all verification conditions)")
                                                                     in
                                                                    let uu____5669
                                                                    =
                                                                    let uu____5683
                                                                    =
                                                                    let uu____5697
                                                                    =
                                                                    let uu____5709
                                                                    =
                                                                    let uu____5710
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5710
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "log_types",
                                                                    uu____5709,
                                                                    "Print types computed for data/val/let-bindings")
                                                                     in
                                                                    let uu____5717
                                                                    =
                                                                    let uu____5731
                                                                    =
                                                                    let uu____5743
                                                                    =
                                                                    let uu____5744
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5744
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "log_queries",
                                                                    uu____5743,
                                                                    "Log the Z3 queries in several queries-*.smt2 files, as we go")
                                                                     in
                                                                    let uu____5751
                                                                    =
                                                                    let uu____5765
                                                                    =
                                                                    let uu____5779
                                                                    =
                                                                    let uu____5793
                                                                    =
                                                                    let uu____5807
                                                                    =
                                                                    let uu____5819
                                                                    =
                                                                    let uu____5820
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5820
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "MLish",
                                                                    uu____5819,
                                                                    "Trigger various specializations for compiling the F* compiler itself (not meant for user code)")
                                                                     in
                                                                    let uu____5827
                                                                    =
                                                                    let uu____5841
                                                                    =
                                                                    let uu____5855
                                                                    =
                                                                    let uu____5867
                                                                    =
                                                                    let uu____5868
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5868
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_default_includes",
                                                                    uu____5867,
                                                                    "Ignore the default module search paths")
                                                                     in
                                                                    let uu____5875
                                                                    =
                                                                    let uu____5889
                                                                    =
                                                                    let uu____5903
                                                                    =
                                                                    let uu____5915
                                                                    =
                                                                    let uu____5916
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5916
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_location_info",
                                                                    uu____5915,
                                                                    "Suppress location information in the generated OCaml output (only relevant with --codegen OCaml)")
                                                                     in
                                                                    let uu____5923
                                                                    =
                                                                    let uu____5937
                                                                    =
                                                                    let uu____5949
                                                                    =
                                                                    let uu____5950
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5950
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_smt",
                                                                    uu____5949,
                                                                    "Do not send any queries to the SMT solver, and fail on them instead")
                                                                     in
                                                                    let uu____5957
                                                                    =
                                                                    let uu____5971
                                                                    =
                                                                    let uu____5983
                                                                    =
                                                                    let uu____5984
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____5984
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "normalize_pure_terms_for_extraction",
                                                                    uu____5983,
                                                                    "Extract top-level pure terms after normalizing them. This can lead to very large code, but can result in more partial evaluation and compile-time specialization.")
                                                                     in
                                                                    let uu____5991
                                                                    =
                                                                    let uu____6005
                                                                    =
                                                                    let uu____6019
                                                                    =
                                                                    let uu____6033
                                                                    =
                                                                    let uu____6045
                                                                    =
                                                                    let uu____6046
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6046
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_bound_var_types",
                                                                    uu____6045,
                                                                    "Print the types of bound variables")
                                                                     in
                                                                    let uu____6053
                                                                    =
                                                                    let uu____6067
                                                                    =
                                                                    let uu____6079
                                                                    =
                                                                    let uu____6080
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6080
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_effect_args",
                                                                    uu____6079,
                                                                    "Print inferred predicate transformers for all computation types")
                                                                     in
                                                                    let uu____6087
                                                                    =
                                                                    let uu____6101
                                                                    =
                                                                    let uu____6113
                                                                    =
                                                                    let uu____6114
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6114
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_full_names",
                                                                    uu____6113,
                                                                    "Print full names of variables")
                                                                     in
                                                                    let uu____6121
                                                                    =
                                                                    let uu____6135
                                                                    =
                                                                    let uu____6147
                                                                    =
                                                                    let uu____6148
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6148
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_implicits",
                                                                    uu____6147,
                                                                    "Print implicit arguments")
                                                                     in
                                                                    let uu____6155
                                                                    =
                                                                    let uu____6169
                                                                    =
                                                                    let uu____6181
                                                                    =
                                                                    let uu____6182
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6182
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_universes",
                                                                    uu____6181,
                                                                    "Print universes")
                                                                     in
                                                                    let uu____6189
                                                                    =
                                                                    let uu____6203
                                                                    =
                                                                    let uu____6215
                                                                    =
                                                                    let uu____6216
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6216
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "print_z3_statistics",
                                                                    uu____6215,
                                                                    "Print Z3 statistics for each SMT query (deprecated; use --query_stats instead)")
                                                                     in
                                                                    let uu____6223
                                                                    =
                                                                    let uu____6237
                                                                    =
                                                                    let uu____6249
                                                                    =
                                                                    let uu____6250
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6250
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "prn",
                                                                    uu____6249,
                                                                    "Print full names (deprecated; use --print_full_names instead)")
                                                                     in
                                                                    let uu____6257
                                                                    =
                                                                    let uu____6271
                                                                    =
                                                                    let uu____6283
                                                                    =
                                                                    let uu____6284
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6284
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "query_stats",
                                                                    uu____6283,
                                                                    "Print SMT query statistics")
                                                                     in
                                                                    let uu____6291
                                                                    =
                                                                    let uu____6305
                                                                    =
                                                                    let uu____6317
                                                                    =
                                                                    let uu____6318
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6318
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "record_hints",
                                                                    uu____6317,
                                                                    "Record a database of hints for efficient proof replay")
                                                                     in
                                                                    let uu____6325
                                                                    =
                                                                    let uu____6339
                                                                    =
                                                                    let uu____6353
                                                                    =
                                                                    let uu____6365
                                                                    =
                                                                    let uu____6366
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6366
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "silent",
                                                                    uu____6365,
                                                                    "Disable all non-critical output")
                                                                     in
                                                                    let uu____6373
                                                                    =
                                                                    let uu____6387
                                                                    =
                                                                    let uu____6401
                                                                    =
                                                                    let uu____6415
                                                                    =
                                                                    let uu____6429
                                                                    =
                                                                    let uu____6443
                                                                    =
                                                                    let uu____6455
                                                                    =
                                                                    let uu____6456
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6456
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactic_raw_binders",
                                                                    uu____6455,
                                                                    "Do not use the lexical scope of tactics to improve binder names")
                                                                     in
                                                                    let uu____6463
                                                                    =
                                                                    let uu____6477
                                                                    =
                                                                    let uu____6489
                                                                    =
                                                                    let uu____6490
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6490
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactics_failhard",
                                                                    uu____6489,
                                                                    "Do not recover from metaprogramming errors, and abort if one occurs")
                                                                     in
                                                                    let uu____6497
                                                                    =
                                                                    let uu____6511
                                                                    =
                                                                    let uu____6523
                                                                    =
                                                                    let uu____6524
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6524
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactics_info",
                                                                    uu____6523,
                                                                    "Print some rough information on tactics, such as the time they take to run")
                                                                     in
                                                                    let uu____6531
                                                                    =
                                                                    let uu____6545
                                                                    =
                                                                    let uu____6557
                                                                    =
                                                                    let uu____6558
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6558
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactic_trace",
                                                                    uu____6557,
                                                                    "Print a depth-indexed trace of tactic execution (Warning: very verbose)")
                                                                     in
                                                                    let uu____6565
                                                                    =
                                                                    let uu____6579
                                                                    =
                                                                    let uu____6593
                                                                    =
                                                                    let uu____6605
                                                                    =
                                                                    let uu____6606
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6606
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__tactics_nbe",
                                                                    uu____6605,
                                                                    "Use NBE to evaluate metaprograms (experimental)")
                                                                     in
                                                                    let uu____6613
                                                                    =
                                                                    let uu____6627
                                                                    =
                                                                    let uu____6641
                                                                    =
                                                                    let uu____6653
                                                                    =
                                                                    let uu____6654
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6654
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "timing",
                                                                    uu____6653,
                                                                    "Print the time it takes to verify each top-level definition")
                                                                     in
                                                                    let uu____6661
                                                                    =
                                                                    let uu____6675
                                                                    =
                                                                    let uu____6687
                                                                    =
                                                                    let uu____6688
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6688
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "trace_error",
                                                                    uu____6687,
                                                                    "Don't print an error message; show an exception trace instead")
                                                                     in
                                                                    let uu____6695
                                                                    =
                                                                    let uu____6709
                                                                    =
                                                                    let uu____6721
                                                                    =
                                                                    let uu____6722
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6722
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "ugly",
                                                                    uu____6721,
                                                                    "Emit output formatted for debugging")
                                                                     in
                                                                    let uu____6729
                                                                    =
                                                                    let uu____6743
                                                                    =
                                                                    let uu____6755
                                                                    =
                                                                    let uu____6756
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6756
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "unthrottle_inductives",
                                                                    uu____6755,
                                                                    "Let the SMT solver unfold inductive types to arbitrary depths (may affect verifier performance)")
                                                                     in
                                                                    let uu____6763
                                                                    =
                                                                    let uu____6777
                                                                    =
                                                                    let uu____6789
                                                                    =
                                                                    let uu____6790
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6790
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "unsafe_tactic_exec",
                                                                    uu____6789,
                                                                    "Allow tactics to run external processes. WARNING: checking an untrusted F* file while using this option can have disastrous effects.")
                                                                     in
                                                                    let uu____6797
                                                                    =
                                                                    let uu____6811
                                                                    =
                                                                    let uu____6823
                                                                    =
                                                                    let uu____6824
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6824
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_eq_at_higher_order",
                                                                    uu____6823,
                                                                    "Use equality constraints when comparing higher-order types (Temporary)")
                                                                     in
                                                                    let uu____6831
                                                                    =
                                                                    let uu____6845
                                                                    =
                                                                    let uu____6857
                                                                    =
                                                                    let uu____6858
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6858
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_hints",
                                                                    uu____6857,
                                                                    "Use a previously recorded hints database for proof replay")
                                                                     in
                                                                    let uu____6865
                                                                    =
                                                                    let uu____6879
                                                                    =
                                                                    let uu____6891
                                                                    =
                                                                    let uu____6892
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6892
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_hint_hashes",
                                                                    uu____6891,
                                                                    "Admit queries if their hash matches the hash recorded in the hints database")
                                                                     in
                                                                    let uu____6899
                                                                    =
                                                                    let uu____6913
                                                                    =
                                                                    let uu____6927
                                                                    =
                                                                    let uu____6939
                                                                    =
                                                                    let uu____6940
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6940
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_plugins",
                                                                    uu____6939,
                                                                    "Do not run plugins natively and interpret them as usual instead")
                                                                     in
                                                                    let uu____6947
                                                                    =
                                                                    let uu____6961
                                                                    =
                                                                    let uu____6973
                                                                    =
                                                                    let uu____6974
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____6974
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_tactics",
                                                                    uu____6973,
                                                                    "Do not run the tactic engine before discharging a VC")
                                                                     in
                                                                    let uu____6981
                                                                    =
                                                                    let uu____6995
                                                                    =
                                                                    let uu____7009
                                                                    =
                                                                    let uu____7023
                                                                    =
                                                                    let uu____7037
                                                                    =
                                                                    let uu____7049
                                                                    =
                                                                    let uu____7050
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7050
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__temp_fast_implicits",
                                                                    uu____7049,
                                                                    "Don't use this option yet")
                                                                     in
                                                                    let uu____7057
                                                                    =
                                                                    let uu____7071
                                                                    =
                                                                    let uu____7083
                                                                    =
                                                                    let uu____7084
                                                                    =
                                                                    let uu____7092
                                                                    =
                                                                    let uu____7093
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7093
                                                                     in
                                                                    ((fun
                                                                    uu____7100
                                                                     ->
                                                                    display_version
                                                                    ();
                                                                    FStar_All.exit
                                                                    (Prims.parse_int "0")),
                                                                    uu____7092)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7084
                                                                     in
                                                                    (118,
                                                                    "version",
                                                                    uu____7083,
                                                                    "Display version number")
                                                                     in
                                                                    let uu____7109
                                                                    =
                                                                    let uu____7123
                                                                    =
                                                                    let uu____7135
                                                                    =
                                                                    let uu____7136
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7136
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "warn_default_effects",
                                                                    uu____7135,
                                                                    "Warn when (a -> b) is desugared to (a -> Tot b)")
                                                                     in
                                                                    let uu____7143
                                                                    =
                                                                    let uu____7157
                                                                    =
                                                                    let uu____7171
                                                                    =
                                                                    let uu____7183
                                                                    =
                                                                    let uu____7184
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7184
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3refresh",
                                                                    uu____7183,
                                                                    "Restart Z3 after each query; useful for ensuring proof robustness")
                                                                     in
                                                                    let uu____7191
                                                                    =
                                                                    let uu____7205
                                                                    =
                                                                    let uu____7219
                                                                    =
                                                                    let uu____7233
                                                                    =
                                                                    let uu____7247
                                                                    =
                                                                    let uu____7261
                                                                    =
                                                                    let uu____7273
                                                                    =
                                                                    let uu____7274
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7274
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__no_positivity",
                                                                    uu____7273,
                                                                    "Don't check positivity of inductive types")
                                                                     in
                                                                    let uu____7281
                                                                    =
                                                                    let uu____7295
                                                                    =
                                                                    let uu____7307
                                                                    =
                                                                    let uu____7308
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7308
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__ml_no_eta_expand_coertions",
                                                                    uu____7307,
                                                                    "Do not eta-expand coertions in generated OCaml")
                                                                     in
                                                                    let uu____7315
                                                                    =
                                                                    let uu____7329
                                                                    =
                                                                    let uu____7343
                                                                    =
                                                                    let uu____7357
                                                                    =
                                                                    let uu____7371
                                                                    =
                                                                    let uu____7385
                                                                    =
                                                                    let uu____7397
                                                                    =
                                                                    let uu____7398
                                                                    =
                                                                    let uu____7406
                                                                    =
                                                                    let uu____7407
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7407
                                                                     in
                                                                    ((fun
                                                                    uu____7413
                                                                     ->
                                                                    FStar_ST.op_Colon_Equals
                                                                    debug_embedding
                                                                    true),
                                                                    uu____7406)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7398
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__debug_embedding",
                                                                    uu____7397,
                                                                    "Debug messages for embeddings/unembeddings of natively compiled terms")
                                                                     in
                                                                    let uu____7441
                                                                    =
                                                                    let uu____7455
                                                                    =
                                                                    let uu____7467
                                                                    =
                                                                    let uu____7468
                                                                    =
                                                                    let uu____7476
                                                                    =
                                                                    let uu____7477
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7477
                                                                     in
                                                                    ((fun
                                                                    uu____7483
                                                                     ->
                                                                    FStar_ST.op_Colon_Equals
                                                                    eager_embedding
                                                                    true),
                                                                    uu____7476)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7468
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "eager_embedding",
                                                                    uu____7467,
                                                                    "Eagerly embed and unembed terms to primitive operations and plugins: not recommended except for benchmarking")
                                                                     in
                                                                    let uu____7511
                                                                    =
                                                                    let uu____7525
                                                                    =
                                                                    let uu____7537
                                                                    =
                                                                    let uu____7538
                                                                    =
                                                                    let uu____7546
                                                                    =
                                                                    let uu____7547
                                                                    =
                                                                    mk_bool
                                                                    true  in
                                                                    Const
                                                                    uu____7547
                                                                     in
                                                                    ((fun
                                                                    uu____7554
                                                                     ->
                                                                    (
                                                                    let uu____7556
                                                                    =
                                                                    specs ()
                                                                     in
                                                                    display_usage_aux
                                                                    uu____7556);
                                                                    FStar_All.exit
                                                                    (Prims.parse_int "0")),
                                                                    uu____7546)
                                                                     in
                                                                    WithSideEffect
                                                                    uu____7538
                                                                     in
                                                                    (104,
                                                                    "help",
                                                                    uu____7537,
                                                                    "Display this information")
                                                                     in
                                                                    [uu____7525]
                                                                     in
                                                                    uu____7455
                                                                    ::
                                                                    uu____7511
                                                                     in
                                                                    uu____7385
                                                                    ::
                                                                    uu____7441
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_tc_cache",
                                                                    BoolStr,
                                                                    "Use typechecker cache, EXPERIMENTAL (default 'false')")
                                                                    ::
                                                                    uu____7371
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_nbe",
                                                                    BoolStr,
                                                                    "Use normalization by evaluation as the default normalization srategy (default 'false')")
                                                                    ::
                                                                    uu____7357
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_extracted_interfaces",
                                                                    BoolStr,
                                                                    "Extract interfaces from the dependencies and use them for verification (default 'false')")
                                                                    ::
                                                                    uu____7343
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "warn_error",
                                                                    (SimpleStr
                                                                    ""),
                                                                    "The [-warn_error] option follows the OCaml syntax, namely:\n\t\t- [r] is a range of warnings (either a number [n], or a range [n..n])\n\t\t- [-r] silences range [r]\n\t\t- [+r] enables range [r]\n\t\t- [@r] makes range [r] fatal.")
                                                                    ::
                                                                    uu____7329
                                                                     in
                                                                    uu____7295
                                                                    ::
                                                                    uu____7315
                                                                     in
                                                                    uu____7261
                                                                    ::
                                                                    uu____7281
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_two_phase_tc",
                                                                    BoolStr,
                                                                    "Use the two phase typechecker (default 'true')")
                                                                    ::
                                                                    uu____7247
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3seed",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Set the Z3 random seed (default 0)")
                                                                    ::
                                                                    uu____7233
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3rlimit_factor",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Set the Z3 per-query resource limit multiplier. This is useful when, say, regenerating hints and you want to be more lax. (default 1)")
                                                                    ::
                                                                    uu____7219
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3rlimit",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Set the Z3 per-query resource limit (default 5 units, taking roughtly 5s)")
                                                                    ::
                                                                    uu____7205
                                                                     in
                                                                    uu____7171
                                                                    ::
                                                                    uu____7191
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "z3cliopt",
                                                                    (ReverseAccumulated
                                                                    (SimpleStr
                                                                    "option")),
                                                                    "Z3 command line options")
                                                                    ::
                                                                    uu____7157
                                                                     in
                                                                    uu____7123
                                                                    ::
                                                                    uu____7143
                                                                     in
                                                                    uu____7071
                                                                    ::
                                                                    uu____7109
                                                                     in
                                                                    uu____7037
                                                                    ::
                                                                    uu____7057
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "__temp_no_proj",
                                                                    (Accumulated
                                                                    (SimpleStr
                                                                    "module_name")),
                                                                    "Don't generate projectors for this module")
                                                                    ::
                                                                    uu____7023
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "vcgen.optimize_bind_as_seq",
                                                                    (EnumStr
                                                                    ["off";
                                                                    "without_type";
                                                                    "with_type"]),
                                                                    "\n\t\tOptimize the generation of verification conditions, \n\t\t\tspecifically the construction of monadic `bind`,\n\t\t\tgenerating `seq` instead of `bind` when the first computation as a trivial post-condition.\n\t\t\tBy default, this optimization does not apply.\n\t\t\tWhen the `without_type` option is chosen, this imposes a cost on the SMT solver\n\t\t\tto reconstruct type information.\n\t\t\tWhen `with_type` is chosen, type information is provided to the SMT solver,\n\t\t\tbut at the cost of VC bloat, which may often be redundant.")
                                                                    ::
                                                                    uu____7009
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "using_facts_from",
                                                                    (Accumulated
                                                                    (SimpleStr
                                                                    "One or more space-separated occurrences of '[+|-]( * | namespace | fact id)'")),
                                                                    "\n\t\tPrunes the context to include only the facts from the given namespace or fact id. \n\t\t\tFacts can be include or excluded using the [+|-] qualifier. \n\t\t\tFor example --using_facts_from '* -FStar.Reflection +FStar.List -FStar.List.Tot' will \n\t\t\t\tremove all facts from FStar.List.Tot.*, \n\t\t\t\tretain all remaining facts from FStar.List.*, \n\t\t\t\tremove all facts from FStar.Reflection.*, \n\t\t\t\tand retain all the rest.\n\t\tNote, the '+' is optional: --using_facts_from 'FStar.List' is equivalent to --using_facts_from '+FStar.List'. \n\t\tMultiple uses of this option accumulate, e.g., --using_facts_from A --using_facts_from B is interpreted as --using_facts_from A^B.")
                                                                    ::
                                                                    uu____6995
                                                                     in
                                                                    uu____6961
                                                                    ::
                                                                    uu____6981
                                                                     in
                                                                    uu____6927
                                                                    ::
                                                                    uu____6947
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "use_native_tactics",
                                                                    (PathStr
                                                                    "path"),
                                                                    "Use compiled tactics from <path>")
                                                                    ::
                                                                    uu____6913
                                                                     in
                                                                    uu____6879
                                                                    ::
                                                                    uu____6899
                                                                     in
                                                                    uu____6845
                                                                    ::
                                                                    uu____6865
                                                                     in
                                                                    uu____6811
                                                                    ::
                                                                    uu____6831
                                                                     in
                                                                    uu____6777
                                                                    ::
                                                                    uu____6797
                                                                     in
                                                                    uu____6743
                                                                    ::
                                                                    uu____6763
                                                                     in
                                                                    uu____6709
                                                                    ::
                                                                    uu____6729
                                                                     in
                                                                    uu____6675
                                                                    ::
                                                                    uu____6695
                                                                     in
                                                                    uu____6641
                                                                    ::
                                                                    uu____6661
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tcnorm",
                                                                    BoolStr,
                                                                    "Attempt to normalize definitions marked as tcnorm (default 'true')")
                                                                    ::
                                                                    uu____6627
                                                                     in
                                                                    uu____6593
                                                                    ::
                                                                    uu____6613
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "tactic_trace_d",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Trace tactics up to a certain binding depth")
                                                                    ::
                                                                    uu____6579
                                                                     in
                                                                    uu____6545
                                                                    ::
                                                                    uu____6565
                                                                     in
                                                                    uu____6511
                                                                    ::
                                                                    uu____6531
                                                                     in
                                                                    uu____6477
                                                                    ::
                                                                    uu____6497
                                                                     in
                                                                    uu____6443
                                                                    ::
                                                                    uu____6463
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smtencoding.l_arith_repr",
                                                                    (EnumStr
                                                                    ["native";
                                                                    "boxwrap"]),
                                                                    "Toggle the representation of linear arithmetic functions in the SMT encoding:\n\t\ti.e., if 'boxwrap', use 'Prims.op_Addition, Prims.op_Subtraction, Prims.op_Minus'; \n\t\tif 'native', use '+, -, -'; \n\t\t(default 'boxwrap')")
                                                                    ::
                                                                    uu____6429
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smtencoding.nl_arith_repr",
                                                                    (EnumStr
                                                                    ["native";
                                                                    "wrapped";
                                                                    "boxwrap"]),
                                                                    "Control the representation of non-linear arithmetic functions in the SMT encoding:\n\t\ti.e., if 'boxwrap' use 'Prims.op_Multiply, Prims.op_Division, Prims.op_Modulus'; \n\t\tif 'native' use '*, div, mod';\n\t\tif 'wrapped' use '_mul, _div, _mod : Int*Int -> Int'; \n\t\t(default 'boxwrap')")
                                                                    ::
                                                                    uu____6415
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smtencoding.elim_box",
                                                                    BoolStr,
                                                                    "Toggle a peephole optimization that eliminates redundant uses of boxing/unboxing in the SMT encoding (default 'false')")
                                                                    ::
                                                                    uu____6401
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "smt",
                                                                    (PathStr
                                                                    "path"),
                                                                    "Path to the Z3 SMT solver (we could eventually support other solvers)")
                                                                    ::
                                                                    uu____6387
                                                                     in
                                                                    uu____6353
                                                                    ::
                                                                    uu____6373
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "reuse_hint_for",
                                                                    (SimpleStr
                                                                    "toplevel_name"),
                                                                    "Optimistically, attempt using the recorded hint for <toplevel_name> (a top-level name in the current module) when trying to verify some other term 'g'")
                                                                    ::
                                                                    uu____6339
                                                                     in
                                                                    uu____6305
                                                                    ::
                                                                    uu____6325
                                                                     in
                                                                    uu____6271
                                                                    ::
                                                                    uu____6291
                                                                     in
                                                                    uu____6237
                                                                    ::
                                                                    uu____6257
                                                                     in
                                                                    uu____6203
                                                                    ::
                                                                    uu____6223
                                                                     in
                                                                    uu____6169
                                                                    ::
                                                                    uu____6189
                                                                     in
                                                                    uu____6135
                                                                    ::
                                                                    uu____6155
                                                                     in
                                                                    uu____6101
                                                                    ::
                                                                    uu____6121
                                                                     in
                                                                    uu____6067
                                                                    ::
                                                                    uu____6087
                                                                     in
                                                                    uu____6033
                                                                    ::
                                                                    uu____6053
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "prims",
                                                                    (PathStr
                                                                    "file"),
                                                                    "") ::
                                                                    uu____6019
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "odir",
                                                                    (PostProcessed
                                                                    (pp_validate_dir,
                                                                    (PathStr
                                                                    "dir"))),
                                                                    "Place output in directory <dir>")
                                                                    ::
                                                                    uu____6005
                                                                     in
                                                                    uu____5971
                                                                    ::
                                                                    uu____5991
                                                                     in
                                                                    uu____5937
                                                                    ::
                                                                    uu____5957
                                                                     in
                                                                    uu____5903
                                                                    ::
                                                                    uu____5923
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "no_extract",
                                                                    (Accumulated
                                                                    (PathStr
                                                                    "module name")),
                                                                    "Deprecated: use --extract instead; Do not extract code from this module")
                                                                    ::
                                                                    uu____5889
                                                                     in
                                                                    uu____5855
                                                                    ::
                                                                    uu____5875
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "n_cores",
                                                                    (IntStr
                                                                    "positive_integer"),
                                                                    "Maximum number of cores to use for the solver (implies detail_errors = false) (default 1)")
                                                                    ::
                                                                    uu____5841
                                                                     in
                                                                    uu____5807
                                                                    ::
                                                                    uu____5827
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "min_fuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Minimum number of unrolling of recursive functions to try (default 1)")
                                                                    ::
                                                                    uu____5793
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "max_ifuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of inductive datatypes to try at most (default 2)")
                                                                    ::
                                                                    uu____5779
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "max_fuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of recursive functions to try at most (default 8)")
                                                                    ::
                                                                    uu____5765
                                                                     in
                                                                    uu____5731
                                                                    ::
                                                                    uu____5751
                                                                     in
                                                                    uu____5697
                                                                    ::
                                                                    uu____5717
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "load",
                                                                    (ReverseAccumulated
                                                                    (PathStr
                                                                    "module")),
                                                                    "Load compiled module")
                                                                    ::
                                                                    uu____5683
                                                                     in
                                                                    uu____5649
                                                                    ::
                                                                    uu____5669
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "keep_query_captions",
                                                                    BoolStr,
                                                                    "Retain comments in the logged SMT queries (requires --log_queries; default true)")
                                                                    ::
                                                                    uu____5635
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "initial_ifuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of inductive datatypes to try at first (default 1)")
                                                                    ::
                                                                    uu____5621
                                                                     in
                                                                    (FStar_Getopt.noshort,
                                                                    "initial_fuel",
                                                                    (IntStr
                                                                    "non-negative integer"),
                                                                    "Number of unrolling of recursive functions to try initially (default 2)")
                                                                    ::
                                                                    uu____5607
                                                                     in
                                                                  uu____5573
                                                                    ::
                                                                    uu____5593
                                                                   in
                                                                uu____5539 ::
                                                                  uu____5559
                                                                 in
                                                              (FStar_Getopt.noshort,
                                                                "include",
                                                                (ReverseAccumulated
                                                                   (PathStr
                                                                    "path")),
                                                                "A directory in which to search for files included on the command line")
                                                                :: uu____5525
                                                               in
                                                            uu____5491 ::
                                                              uu____5511
                                                             in
                                                          uu____5457 ::
                                                            uu____5477
                                                           in
                                                        uu____5423 ::
                                                          uu____5443
                                                         in
                                                      (FStar_Getopt.noshort,
                                                        "hint_file",
                                                        (PathStr "path"),
                                                        "Read/write hints to <path> (instead of module-specific hints files)")
                                                        :: uu____5409
                                                       in
                                                    uu____5375 :: uu____5395
                                                     in
                                                  uu____5341 :: uu____5361
                                                   in
                                                (FStar_Getopt.noshort,
                                                  "extract_namespace",
                                                  (Accumulated
                                                     (PostProcessed
                                                        (pp_lowercase,
                                                          (SimpleStr
                                                             "namespace name")))),
                                                  "Deprecated: use --extract instead; Only extract modules in the specified namespace")
                                                  :: uu____5327
                                                 in
                                              (FStar_Getopt.noshort,
                                                "extract_module",
                                                (Accumulated
                                                   (PostProcessed
                                                      (pp_lowercase,
                                                        (SimpleStr
                                                           "module_name")))),
                                                "Deprecated: use --extract instead; Only extract the specified modules (instead of the possibly-partial dependency graph)")
                                                :: uu____5313
                                               in
                                            (FStar_Getopt.noshort, "extract",
                                              (Accumulated
                                                 (SimpleStr
                                                    "One or more space-separated occurrences of '[+|-]( * | namespace | module)'")),
                                              "\n\t\tExtract only those modules whose names or namespaces match the provided options.\n\t\t\tModules can be extracted or not using the [+|-] qualifier. \n\t\t\tFor example --extract '* -FStar.Reflection +FStar.List -FStar.List.Tot' will \n\t\t\t\tnot extract FStar.List.Tot.*, \n\t\t\t\textract remaining modules from FStar.List.*, \n\t\t\t\tnot extract FStar.Reflection.*, \n\t\t\t\tand extract all the rest.\n\t\tNote, the '+' is optional: --extract '+A' and --extract 'A' mean the same thing.\n\t\tMultiple uses of this option accumulate, e.g., --extract A --extract B is interpreted as --extract 'A B'.")
                                              :: uu____5299
                                             in
                                          uu____5265 :: uu____5285  in
                                        uu____5231 :: uu____5251  in
                                      (FStar_Getopt.noshort, "dump_module",
                                        (Accumulated
                                           (SimpleStr "module_name")), "")
                                        :: uu____5217
                                       in
                                    uu____5183 :: uu____5203  in
                                  uu____5149 :: uu____5169  in
                                uu____5115 :: uu____5135  in
                              (FStar_Getopt.noshort, "dep",
                                (EnumStr ["make"; "graph"; "full"; "raw"]),
                                "Output the transitive closure of the full dependency graph in three formats:\n\t 'graph': a format suitable the 'dot' tool from 'GraphViz'\n\t 'full': a format suitable for 'make', including dependences for producing .ml and .krml files\n\t 'make': (deprecated) a format suitable for 'make', including only dependences among source files")
                                :: uu____5101
                               in
                            (FStar_Getopt.noshort, "defensive",
                              (EnumStr ["no"; "warn"; "fail"]),
                              "Enable several internal sanity checks, useful to track bugs and report issues.\n\t\tif 'no', no checks are performed\n\t\tif 'warn', checks are performed and raise a warning when they fail\n\t\tif 'fail', like 'warn', but the compiler aborts instead of issuing a warning\n\t\t(default 'no')")
                              :: uu____5087
                             in
                          (FStar_Getopt.noshort, "debug_level",
                            (Accumulated
                               (OpenEnumStr
                                  (["Low"; "Medium"; "High"; "Extreme"],
                                    "..."))),
                            "Control the verbosity of debugging info") ::
                            uu____5073
                           in
                        (FStar_Getopt.noshort, "debug",
                          (Accumulated (SimpleStr "module_name")),
                          "Print lots of debugging information while checking module")
                          :: uu____5059
                         in
                      (FStar_Getopt.noshort, "codegen-lib",
                        (Accumulated (SimpleStr "namespace")),
                        "External runtime library (i.e. M.N.x extracts to M.N.X instead of M_N.x)")
                        :: uu____5045
                       in
                    (FStar_Getopt.noshort, "codegen",
                      (EnumStr ["OCaml"; "FSharp"; "Kremlin"; "Plugin"]),
                      "Generate code for further compilation to executable code, or build a compiler plugin")
                      :: uu____5031
                     in
                  uu____4997 :: uu____5017  in
                uu____4963 :: uu____4983  in
              (FStar_Getopt.noshort, "cache_dir",
                (PostProcessed (pp_validate_dir, (PathStr "dir"))),
                "Read and write .checked and .checked.lax in directory <dir>")
                :: uu____4949
               in
            uu____4915 :: uu____4935  in
          (FStar_Getopt.noshort, "already_cached",
            (Accumulated
               (SimpleStr
                  "One or more space-separated occurrences of '[+|-]( * | namespace | module)'")),
            "\n\t\tExpects all modules whose names or namespaces match the provided options \n\t\t\tto already have valid .checked files in the include path")
            :: uu____4901
           in
        (FStar_Getopt.noshort, "admit_except",
          (SimpleStr "[symbol|(symbol, id)]"),
          "Admit all queries, except those with label (<symbol>, <id>)) (e.g. --admit_except '(FStar.Fin.pigeonhole, 1)' or --admit_except FStar.Fin.pigeonhole)")
          :: uu____4887
         in
      (FStar_Getopt.noshort, "admit_smt_queries", BoolStr,
        "Admit SMT queries, unsafe! (default 'false')") :: uu____4873
       in
    (FStar_Getopt.noshort, "abort_on",
      (PostProcessed
         ((fun uu___87_9093  ->
             match uu___87_9093 with
             | Int x -> (FStar_ST.op_Colon_Equals abort_counter x; Int x)
             | x -> failwith "?"), (IntStr "non-negative integer"))),
      "Abort on the n-th error or warning raised. Useful in combination with --trace_error. Count starts at 1, use 0 to disable. (default 0)")
      :: uu____4859

and (specs : unit -> FStar_Getopt.opt Prims.list) =
  fun uu____9122  ->
    let uu____9125 = specs_with_types ()  in
    FStar_List.map
      (fun uu____9156  ->
         match uu____9156 with
         | (short,long,typ,doc) ->
             let uu____9178 =
               let uu____9192 = arg_spec_of_opt_type long typ  in
               (short, long, uu____9192, doc)  in
             mk_spec uu____9178) uu____9125

let (settable : Prims.string -> Prims.bool) =
  fun uu___88_9207  ->
    match uu___88_9207 with
    | "abort_on" -> true
    | "admit_smt_queries" -> true
    | "admit_except" -> true
    | "debug" -> true
    | "debug_level" -> true
    | "defensive" -> true
    | "detail_errors" -> true
    | "detail_hint_replay" -> true
    | "eager_inference" -> true
    | "eager_subtyping" -> true
    | "hide_uvar_nums" -> true
    | "hint_info" -> true
    | "hint_file" -> true
    | "initial_fuel" -> true
    | "initial_ifuel" -> true
    | "lax" -> true
    | "load" -> true
    | "log_types" -> true
    | "log_queries" -> true
    | "max_fuel" -> true
    | "max_ifuel" -> true
    | "min_fuel" -> true
    | "no_smt" -> true
    | "__no_positivity" -> true
    | "ugly" -> true
    | "print_bound_var_types" -> true
    | "print_effect_args" -> true
    | "print_full_names" -> true
    | "print_implicits" -> true
    | "print_universes" -> true
    | "print_z3_statistics" -> true
    | "prn" -> true
    | "query_stats" -> true
    | "silent" -> true
    | "smtencoding.elim_box" -> true
    | "smtencoding.nl_arith_repr" -> true
    | "smtencoding.l_arith_repr" -> true
    | "timing" -> true
    | "trace_error" -> true
    | "unthrottle_inductives" -> true
    | "use_eq_at_higher_order" -> true
    | "no_plugins" -> true
    | "no_tactics" -> true
    | "normalize_pure_terms_for_extraction" -> true
    | "tactic_raw_binders" -> true
    | "tactics_failhard" -> true
    | "tactics_info" -> true
    | "tactic_trace" -> true
    | "tactic_trace_d" -> true
    | "tcnorm" -> true
    | "__tactics_nbe" -> true
    | "__temp_fast_implicits" -> true
    | "__temp_no_proj" -> true
    | "reuse_hint_for" -> true
    | "warn_error" -> true
    | "z3rlimit_factor" -> true
    | "z3rlimit" -> true
    | "z3refresh" -> true
    | "use_two_phase_tc" -> true
    | "vcgen.optimize_bind_as_seq" -> true
    | uu____9330 -> false
  
let (resettable : Prims.string -> Prims.bool) =
  fun s  ->
    (((settable s) || (s = "z3seed")) || (s = "z3cliopt")) ||
      (s = "using_facts_from")
  
let (all_specs : FStar_Getopt.opt Prims.list) = specs () 
let (all_specs_with_types :
  (FStar_BaseTypes.char * Prims.string * opt_type * Prims.string) Prims.list)
  = specs_with_types () 
let (settable_specs :
  (FStar_BaseTypes.char * Prims.string * unit FStar_Getopt.opt_variant *
    Prims.string) Prims.list)
  =
  FStar_All.pipe_right all_specs
    (FStar_List.filter
       (fun uu____9429  ->
          match uu____9429 with
          | (uu____9444,x,uu____9446,uu____9447) -> settable x))
  
let (resettable_specs :
  (FStar_BaseTypes.char * Prims.string * unit FStar_Getopt.opt_variant *
    Prims.string) Prims.list)
  =
  FStar_All.pipe_right all_specs
    (FStar_List.filter
       (fun uu____9522  ->
          match uu____9522 with
          | (uu____9537,x,uu____9539,uu____9540) -> resettable x))
  
let (display_usage : unit -> unit) =
  fun uu____9556  ->
    let uu____9557 = specs ()  in display_usage_aux uu____9557
  
let (fstar_bin_directory : Prims.string) = FStar_Util.get_exec_dir () 
exception File_argument of Prims.string 
let (uu___is_File_argument : Prims.exn -> Prims.bool) =
  fun projectee  ->
    match projectee with
    | File_argument uu____9589 -> true
    | uu____9592 -> false
  
let (__proj__File_argument__item__uu___ : Prims.exn -> Prims.string) =
  fun projectee  ->
    match projectee with | File_argument uu____9603 -> uu____9603
  
let (set_options : options -> Prims.string -> FStar_Getopt.parse_cmdline_res)
  =
  fun o  ->
    fun s  ->
      let specs1 =
        match o with
        | Set  -> settable_specs
        | Reset  -> resettable_specs
        | Restore  -> all_specs  in
      try
        (fun uu___93_9624  ->
           match () with
           | () ->
               if s = ""
               then FStar_Getopt.Success
               else
                 FStar_Getopt.parse_string specs1
                   (fun s1  -> FStar_Exn.raise (File_argument s1)) s) ()
      with
      | File_argument s1 ->
          let uu____9641 =
            FStar_Util.format1 "File %s is not a valid option" s1  in
          FStar_Getopt.Error uu____9641
  
let (file_list_ : Prims.string Prims.list FStar_ST.ref) =
  FStar_Util.mk_ref [] 
let (parse_cmd_line :
  unit -> (FStar_Getopt.parse_cmdline_res * Prims.string Prims.list)) =
  fun uu____9677  ->
    let res =
      FStar_Getopt.parse_cmdline all_specs
        (fun i  ->
           let uu____9683 =
             let uu____9687 = FStar_ST.op_Bang file_list_  in
             FStar_List.append uu____9687 [i]  in
           FStar_ST.op_Colon_Equals file_list_ uu____9683)
       in
    let uu____9744 =
      let uu____9748 = FStar_ST.op_Bang file_list_  in
      FStar_List.map FStar_Common.try_convert_file_name_to_mixed uu____9748
       in
    (res, uu____9744)
  
let (file_list : unit -> Prims.string Prims.list) =
  fun uu____9790  -> FStar_ST.op_Bang file_list_ 
let (restore_cmd_line_options : Prims.bool -> FStar_Getopt.parse_cmdline_res)
  =
  fun should_clear  ->
    let old_verify_module = get_verify_module ()  in
    if should_clear then clear () else init ();
    (let r =
       let uu____9833 = specs ()  in
       FStar_Getopt.parse_cmdline uu____9833 (fun x  -> ())  in
     (let uu____9840 =
        let uu____9846 =
          let uu____9847 = FStar_List.map mk_string old_verify_module  in
          List uu____9847  in
        ("verify_module", uu____9846)  in
      set_option' uu____9840);
     r)
  
let (module_name_of_file_name : Prims.string -> Prims.string) =
  fun f  ->
    let f1 = FStar_Util.basename f  in
    let f2 =
      let uu____9866 =
        let uu____9868 =
          let uu____9870 =
            let uu____9872 = FStar_Util.get_file_extension f1  in
            FStar_String.length uu____9872  in
          (FStar_String.length f1) - uu____9870  in
        uu____9868 - (Prims.parse_int "1")  in
      FStar_String.substring f1 (Prims.parse_int "0") uu____9866  in
    FStar_String.lowercase f2
  
let (should_verify : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____9885 = get_lax ()  in
    if uu____9885
    then false
    else
      (let l = get_verify_module ()  in
       FStar_List.contains (FStar_String.lowercase m) l)
  
let (should_verify_file : Prims.string -> Prims.bool) =
  fun fn  ->
    let uu____9906 = module_name_of_file_name fn  in should_verify uu____9906
  
let (dont_gen_projectors : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____9917 = get___temp_no_proj ()  in
    FStar_List.contains m uu____9917
  
let (should_print_message : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____9931 = should_verify m  in
    if uu____9931 then m <> "Prims" else false
  
let (include_path : unit -> Prims.string Prims.list) =
  fun uu____9948  ->
    let cache_dir =
      let uu____9953 = get_cache_dir ()  in
      match uu____9953 with
      | FStar_Pervasives_Native.None  -> []
      | FStar_Pervasives_Native.Some c -> [c]  in
    let uu____9967 = get_no_default_includes ()  in
    if uu____9967
    then
      let uu____9973 = get_include ()  in
      FStar_List.append cache_dir uu____9973
    else
      (let lib_paths =
         let uu____9984 = FStar_Util.expand_environment_variable "FSTAR_LIB"
            in
         match uu____9984 with
         | FStar_Pervasives_Native.None  ->
             let fstar_home = Prims.strcat fstar_bin_directory "/.."  in
             let defs = universe_include_path_base_dirs  in
             let uu____10000 =
               FStar_All.pipe_right defs
                 (FStar_List.map (fun x  -> Prims.strcat fstar_home x))
                in
             FStar_All.pipe_right uu____10000
               (FStar_List.filter FStar_Util.file_exists)
         | FStar_Pervasives_Native.Some s -> [s]  in
       let uu____10027 =
         let uu____10031 =
           let uu____10035 = get_include ()  in
           FStar_List.append uu____10035 ["."]  in
         FStar_List.append lib_paths uu____10031  in
       FStar_List.append cache_dir uu____10027)
  
let (find_file : Prims.string -> Prims.string FStar_Pervasives_Native.option)
  =
  let file_map = FStar_Util.smap_create (Prims.parse_int "100")  in
  fun filename  ->
    let uu____10062 = FStar_Util.smap_try_find file_map filename  in
    match uu____10062 with
    | FStar_Pervasives_Native.Some f -> FStar_Pervasives_Native.Some f
    | FStar_Pervasives_Native.None  ->
        let result =
          try
            (fun uu___95_10084  ->
               match () with
               | () ->
                   let uu____10088 = FStar_Util.is_path_absolute filename  in
                   if uu____10088
                   then
                     (if FStar_Util.file_exists filename
                      then FStar_Pervasives_Native.Some filename
                      else FStar_Pervasives_Native.None)
                   else
                     (let uu____10104 =
                        let uu____10108 = include_path ()  in
                        FStar_List.rev uu____10108  in
                      FStar_Util.find_map uu____10104
                        (fun p  ->
                           let path =
                             if p = "."
                             then filename
                             else FStar_Util.join_paths p filename  in
                           if FStar_Util.file_exists path
                           then FStar_Pervasives_Native.Some path
                           else FStar_Pervasives_Native.None))) ()
          with | uu___94_10136 -> FStar_Pervasives_Native.None  in
        (match result with
         | FStar_Pervasives_Native.None  -> result
         | FStar_Pervasives_Native.Some f ->
             (FStar_Util.smap_add file_map filename f; result))
  
let (prims : unit -> Prims.string) =
  fun uu____10156  ->
    let uu____10157 = get_prims ()  in
    match uu____10157 with
    | FStar_Pervasives_Native.None  ->
        let filename = "prims.fst"  in
        let uu____10166 = find_file filename  in
        (match uu____10166 with
         | FStar_Pervasives_Native.Some result -> result
         | FStar_Pervasives_Native.None  ->
             let uu____10175 =
               FStar_Util.format1
                 "unable to find required file \"%s\" in the module search path.\n"
                 filename
                in
             failwith uu____10175)
    | FStar_Pervasives_Native.Some x -> x
  
let (prims_basename : unit -> Prims.string) =
  fun uu____10188  ->
    let uu____10189 = prims ()  in FStar_Util.basename uu____10189
  
let (pervasives : unit -> Prims.string) =
  fun uu____10197  ->
    let filename = "FStar.Pervasives.fst"  in
    let uu____10201 = find_file filename  in
    match uu____10201 with
    | FStar_Pervasives_Native.Some result -> result
    | FStar_Pervasives_Native.None  ->
        let uu____10210 =
          FStar_Util.format1
            "unable to find required file \"%s\" in the module search path.\n"
            filename
           in
        failwith uu____10210
  
let (pervasives_basename : unit -> Prims.string) =
  fun uu____10220  ->
    let uu____10221 = pervasives ()  in FStar_Util.basename uu____10221
  
let (pervasives_native_basename : unit -> Prims.string) =
  fun uu____10229  ->
    let filename = "FStar.Pervasives.Native.fst"  in
    let uu____10233 = find_file filename  in
    match uu____10233 with
    | FStar_Pervasives_Native.Some result -> FStar_Util.basename result
    | FStar_Pervasives_Native.None  ->
        let uu____10242 =
          FStar_Util.format1
            "unable to find required file \"%s\" in the module search path.\n"
            filename
           in
        failwith uu____10242
  
let (prepend_output_dir : Prims.string -> Prims.string) =
  fun fname  ->
    let uu____10255 = get_odir ()  in
    match uu____10255 with
    | FStar_Pervasives_Native.None  -> fname
    | FStar_Pervasives_Native.Some x -> FStar_Util.join_paths x fname
  
let (prepend_cache_dir : Prims.string -> Prims.string) =
  fun fpath  ->
    let uu____10273 = get_cache_dir ()  in
    match uu____10273 with
    | FStar_Pervasives_Native.None  -> fpath
    | FStar_Pervasives_Native.Some x ->
        let uu____10282 = FStar_Util.basename fpath  in
        FStar_Util.join_paths x uu____10282
  
let (path_of_text : Prims.string -> Prims.string Prims.list) =
  fun text  -> FStar_String.split [46] text 
let (parse_settings :
  Prims.string Prims.list ->
    (Prims.string Prims.list * Prims.bool) Prims.list)
  =
  fun ns  ->
    let cache = FStar_Util.smap_create (Prims.parse_int "31")  in
    let with_cache f s =
      let uu____10404 = FStar_Util.smap_try_find cache s  in
      match uu____10404 with
      | FStar_Pervasives_Native.Some s1 -> s1
      | FStar_Pervasives_Native.None  ->
          let res = f s  in (FStar_Util.smap_add cache s res; res)
       in
    let parse_one_setting s =
      if s = "*"
      then ([], true)
      else
        if FStar_Util.starts_with s "-"
        then
          (let path =
             let uu____10539 =
               FStar_Util.substring_from s (Prims.parse_int "1")  in
             path_of_text uu____10539  in
           (path, false))
        else
          (let s1 =
             if FStar_Util.starts_with s "+"
             then FStar_Util.substring_from s (Prims.parse_int "1")
             else s  in
           ((path_of_text s1), true))
       in
    let uu____10562 =
      FStar_All.pipe_right ns
        (FStar_List.collect
           (fun s  ->
              let s1 = FStar_Util.trim_string s  in
              if s1 = ""
              then []
              else
                with_cache
                  (fun s2  ->
                     FStar_All.pipe_right (FStar_Util.split s2 " ")
                       (FStar_List.map parse_one_setting)) s1))
       in
    FStar_All.pipe_right uu____10562 FStar_List.rev
  
let (__temp_no_proj : Prims.string -> Prims.bool) =
  fun s  ->
    let uu____10688 = get___temp_no_proj ()  in
    FStar_All.pipe_right uu____10688 (FStar_List.contains s)
  
let (__temp_fast_implicits : unit -> Prims.bool) =
  fun uu____10703  -> lookup_opt "__temp_fast_implicits" as_bool 
let (admit_smt_queries : unit -> Prims.bool) =
  fun uu____10712  -> get_admit_smt_queries () 
let (admit_except : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____10721  -> get_admit_except () 
let (cache_checked_modules : unit -> Prims.bool) =
  fun uu____10728  -> get_cache_checked_modules () 
let (cache_off : unit -> Prims.bool) = fun uu____10735  -> get_cache_off () 
let (cmi : unit -> Prims.bool) = fun uu____10742  -> get_cmi () 
type codegen_t =
  | OCaml 
  | FSharp 
  | Kremlin 
  | Plugin 
let (uu___is_OCaml : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | OCaml  -> true | uu____10752 -> false
  
let (uu___is_FSharp : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | FSharp  -> true | uu____10763 -> false
  
let (uu___is_Kremlin : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Kremlin  -> true | uu____10774 -> false
  
let (uu___is_Plugin : codegen_t -> Prims.bool) =
  fun projectee  ->
    match projectee with | Plugin  -> true | uu____10785 -> false
  
let (codegen : unit -> codegen_t FStar_Pervasives_Native.option) =
  fun uu____10794  ->
    let uu____10795 = get_codegen ()  in
    FStar_Util.map_opt uu____10795
      (fun uu___89_10801  ->
         match uu___89_10801 with
         | "OCaml" -> OCaml
         | "FSharp" -> FSharp
         | "Kremlin" -> Kremlin
         | "Plugin" -> Plugin
         | uu____10807 -> failwith "Impossible")
  
let (codegen_libs : unit -> Prims.string Prims.list Prims.list) =
  fun uu____10820  ->
    let uu____10821 = get_codegen_lib ()  in
    FStar_All.pipe_right uu____10821
      (FStar_List.map (fun x  -> FStar_Util.split x "."))
  
let (debug_any : unit -> Prims.bool) =
  fun uu____10847  -> let uu____10848 = get_debug ()  in uu____10848 <> [] 
let (debug_module : Prims.string -> Prims.bool) =
  fun modul  ->
    let uu____10865 = get_debug ()  in
    FStar_All.pipe_right uu____10865 (FStar_List.contains modul)
  
let (debug_at_level : Prims.string -> debug_level_t -> Prims.bool) =
  fun modul  ->
    fun level  ->
      (let uu____10890 = get_debug ()  in
       FStar_All.pipe_right uu____10890 (FStar_List.contains modul)) &&
        (debug_level_geq level)
  
let (defensive : unit -> Prims.bool) =
  fun uu____10905  ->
    let uu____10906 = get_defensive ()  in uu____10906 <> "no"
  
let (defensive_fail : unit -> Prims.bool) =
  fun uu____10916  ->
    let uu____10917 = get_defensive ()  in uu____10917 = "fail"
  
let (dep : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____10929  -> get_dep () 
let (detail_errors : unit -> Prims.bool) =
  fun uu____10936  -> get_detail_errors () 
let (detail_hint_replay : unit -> Prims.bool) =
  fun uu____10943  -> get_detail_hint_replay () 
let (doc : unit -> Prims.bool) = fun uu____10950  -> get_doc () 
let (dump_module : Prims.string -> Prims.bool) =
  fun s  ->
    let uu____10960 = get_dump_module ()  in
    FStar_All.pipe_right uu____10960 (FStar_List.contains s)
  
let (eager_subtyping : unit -> Prims.bool) =
  fun uu____10975  -> get_eager_subtyping () 
let (expose_interfaces : unit -> Prims.bool) =
  fun uu____10982  -> get_expose_interfaces () 
let (fs_typ_app : Prims.string -> Prims.bool) =
  fun filename  ->
    let uu____10992 = FStar_ST.op_Bang light_off_files  in
    FStar_List.contains filename uu____10992
  
let (full_context_dependency : unit -> Prims.bool) = fun uu____11028  -> true 
let (hide_uvar_nums : unit -> Prims.bool) =
  fun uu____11036  -> get_hide_uvar_nums () 
let (hint_info : unit -> Prims.bool) =
  fun uu____11043  -> (get_hint_info ()) || (get_query_stats ()) 
let (hint_file : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11052  -> get_hint_file () 
let (ide : unit -> Prims.bool) = fun uu____11059  -> get_ide () 
let (print : unit -> Prims.bool) = fun uu____11066  -> get_print () 
let (print_in_place : unit -> Prims.bool) =
  fun uu____11073  -> get_print_in_place () 
let (initial_fuel : unit -> Prims.int) =
  fun uu____11080  ->
    let uu____11081 = get_initial_fuel ()  in
    let uu____11083 = get_max_fuel ()  in Prims.min uu____11081 uu____11083
  
let (initial_ifuel : unit -> Prims.int) =
  fun uu____11091  ->
    let uu____11092 = get_initial_ifuel ()  in
    let uu____11094 = get_max_ifuel ()  in Prims.min uu____11092 uu____11094
  
let (interactive : unit -> Prims.bool) =
  fun uu____11102  -> (get_in ()) || (get_ide ()) 
let (lax : unit -> Prims.bool) = fun uu____11109  -> get_lax () 
let (load : unit -> Prims.string Prims.list) =
  fun uu____11118  -> get_load () 
let (legacy_interactive : unit -> Prims.bool) = fun uu____11125  -> get_in () 
let (log_queries : unit -> Prims.bool) =
  fun uu____11132  -> get_log_queries () 
let (keep_query_captions : unit -> Prims.bool) =
  fun uu____11139  -> (log_queries ()) && (get_keep_query_captions ()) 
let (log_types : unit -> Prims.bool) = fun uu____11146  -> get_log_types () 
let (max_fuel : unit -> Prims.int) = fun uu____11153  -> get_max_fuel () 
let (max_ifuel : unit -> Prims.int) = fun uu____11160  -> get_max_ifuel () 
let (min_fuel : unit -> Prims.int) = fun uu____11167  -> get_min_fuel () 
let (ml_ish : unit -> Prims.bool) = fun uu____11174  -> get_MLish () 
let (set_ml_ish : unit -> unit) =
  fun uu____11180  -> set_option "MLish" (Bool true) 
let (n_cores : unit -> Prims.int) = fun uu____11189  -> get_n_cores () 
let (no_default_includes : unit -> Prims.bool) =
  fun uu____11196  -> get_no_default_includes () 
let (no_extract : Prims.string -> Prims.bool) =
  fun s  ->
    let s1 = FStar_String.lowercase s  in
    let uu____11208 = get_no_extract ()  in
    FStar_All.pipe_right uu____11208
      (FStar_Util.for_some (fun f  -> (FStar_String.lowercase f) = s1))
  
let (normalize_pure_terms_for_extraction : unit -> Prims.bool) =
  fun uu____11227  -> get_normalize_pure_terms_for_extraction () 
let (no_location_info : unit -> Prims.bool) =
  fun uu____11234  -> get_no_location_info () 
let (no_plugins : unit -> Prims.bool) = fun uu____11241  -> get_no_plugins () 
let (no_smt : unit -> Prims.bool) = fun uu____11248  -> get_no_smt () 
let (output_dir : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11257  -> get_odir () 
let (ugly : unit -> Prims.bool) = fun uu____11264  -> get_ugly () 
let (print_bound_var_types : unit -> Prims.bool) =
  fun uu____11271  -> get_print_bound_var_types () 
let (print_effect_args : unit -> Prims.bool) =
  fun uu____11278  -> get_print_effect_args () 
let (print_implicits : unit -> Prims.bool) =
  fun uu____11285  -> get_print_implicits () 
let (print_real_names : unit -> Prims.bool) =
  fun uu____11292  -> (get_prn ()) || (get_print_full_names ()) 
let (print_universes : unit -> Prims.bool) =
  fun uu____11299  -> get_print_universes () 
let (print_z3_statistics : unit -> Prims.bool) =
  fun uu____11306  -> (get_print_z3_statistics ()) || (get_query_stats ()) 
let (query_stats : unit -> Prims.bool) =
  fun uu____11313  -> get_query_stats () 
let (record_hints : unit -> Prims.bool) =
  fun uu____11320  -> get_record_hints () 
let (reuse_hint_for : unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11329  -> get_reuse_hint_for () 
let (silent : unit -> Prims.bool) = fun uu____11336  -> get_silent () 
let (smtencoding_elim_box : unit -> Prims.bool) =
  fun uu____11343  -> get_smtencoding_elim_box () 
let (smtencoding_nl_arith_native : unit -> Prims.bool) =
  fun uu____11350  ->
    let uu____11351 = get_smtencoding_nl_arith_repr ()  in
    uu____11351 = "native"
  
let (smtencoding_nl_arith_wrapped : unit -> Prims.bool) =
  fun uu____11361  ->
    let uu____11362 = get_smtencoding_nl_arith_repr ()  in
    uu____11362 = "wrapped"
  
let (smtencoding_nl_arith_default : unit -> Prims.bool) =
  fun uu____11372  ->
    let uu____11373 = get_smtencoding_nl_arith_repr ()  in
    uu____11373 = "boxwrap"
  
let (smtencoding_l_arith_native : unit -> Prims.bool) =
  fun uu____11383  ->
    let uu____11384 = get_smtencoding_l_arith_repr ()  in
    uu____11384 = "native"
  
let (smtencoding_l_arith_default : unit -> Prims.bool) =
  fun uu____11394  ->
    let uu____11395 = get_smtencoding_l_arith_repr ()  in
    uu____11395 = "boxwrap"
  
let (tactic_raw_binders : unit -> Prims.bool) =
  fun uu____11405  -> get_tactic_raw_binders () 
let (tactics_failhard : unit -> Prims.bool) =
  fun uu____11412  -> get_tactics_failhard () 
let (tactics_info : unit -> Prims.bool) =
  fun uu____11419  -> get_tactics_info () 
let (tactic_trace : unit -> Prims.bool) =
  fun uu____11426  -> get_tactic_trace () 
let (tactic_trace_d : unit -> Prims.int) =
  fun uu____11433  -> get_tactic_trace_d () 
let (tactics_nbe : unit -> Prims.bool) =
  fun uu____11440  -> get_tactics_nbe () 
let (tcnorm : unit -> Prims.bool) = fun uu____11447  -> get_tcnorm () 
let (timing : unit -> Prims.bool) = fun uu____11454  -> get_timing () 
let (trace_error : unit -> Prims.bool) =
  fun uu____11461  -> get_trace_error () 
let (unthrottle_inductives : unit -> Prims.bool) =
  fun uu____11468  -> get_unthrottle_inductives () 
let (unsafe_tactic_exec : unit -> Prims.bool) =
  fun uu____11475  -> get_unsafe_tactic_exec () 
let (use_eq_at_higher_order : unit -> Prims.bool) =
  fun uu____11482  -> get_use_eq_at_higher_order () 
let (use_hints : unit -> Prims.bool) = fun uu____11489  -> get_use_hints () 
let (use_hint_hashes : unit -> Prims.bool) =
  fun uu____11496  -> get_use_hint_hashes () 
let (use_native_tactics :
  unit -> Prims.string FStar_Pervasives_Native.option) =
  fun uu____11505  -> get_use_native_tactics () 
let (use_tactics : unit -> Prims.bool) =
  fun uu____11512  -> get_use_tactics () 
let (using_facts_from :
  unit -> (Prims.string Prims.list * Prims.bool) Prims.list) =
  fun uu____11528  ->
    let uu____11529 = get_using_facts_from ()  in
    match uu____11529 with
    | FStar_Pervasives_Native.None  -> [([], true)]
    | FStar_Pervasives_Native.Some ns -> parse_settings ns
  
let (vcgen_optimize_bind_as_seq : unit -> Prims.bool) =
  fun uu____11583  ->
    let uu____11584 = get_vcgen_optimize_bind_as_seq ()  in
    FStar_Option.isSome uu____11584
  
let (vcgen_decorate_with_type : unit -> Prims.bool) =
  fun uu____11595  ->
    let uu____11596 = get_vcgen_optimize_bind_as_seq ()  in
    match uu____11596 with
    | FStar_Pervasives_Native.Some "with_type" -> true
    | uu____11604 -> false
  
let (warn_default_effects : unit -> Prims.bool) =
  fun uu____11615  -> get_warn_default_effects () 
let (z3_exe : unit -> Prims.string) =
  fun uu____11622  ->
    let uu____11623 = get_smt ()  in
    match uu____11623 with
    | FStar_Pervasives_Native.None  -> FStar_Platform.exe "z3"
    | FStar_Pervasives_Native.Some s -> s
  
let (z3_cliopt : unit -> Prims.string Prims.list) =
  fun uu____11641  -> get_z3cliopt () 
let (z3_refresh : unit -> Prims.bool) = fun uu____11648  -> get_z3refresh () 
let (z3_rlimit : unit -> Prims.int) = fun uu____11655  -> get_z3rlimit () 
let (z3_rlimit_factor : unit -> Prims.int) =
  fun uu____11662  -> get_z3rlimit_factor () 
let (z3_seed : unit -> Prims.int) = fun uu____11669  -> get_z3seed () 
let (use_two_phase_tc : unit -> Prims.bool) =
  fun uu____11676  ->
    (get_use_two_phase_tc ()) &&
      (let uu____11678 = lax ()  in Prims.op_Negation uu____11678)
  
let (no_positivity : unit -> Prims.bool) =
  fun uu____11686  -> get_no_positivity () 
let (ml_no_eta_expand_coertions : unit -> Prims.bool) =
  fun uu____11693  -> get_ml_no_eta_expand_coertions () 
let (warn_error : unit -> Prims.string) =
  fun uu____11700  -> get_warn_error () 
let (use_extracted_interfaces : unit -> Prims.bool) =
  fun uu____11707  -> get_use_extracted_interfaces () 
let (use_nbe : unit -> Prims.bool) = fun uu____11714  -> get_use_nbe () 
let (use_tc_cache : unit -> Prims.bool) =
  fun uu____11721  -> get_use_tc_cache () 
let with_saved_options : 'a . (unit -> 'a) -> 'a =
  fun f  ->
    let uu____11738 =
      let uu____11740 = trace_error ()  in Prims.op_Negation uu____11740  in
    if uu____11738
    then
      (push ();
       (let r =
          try
            (fun uu___97_11755  ->
               match () with
               | () -> let uu____11760 = f ()  in FStar_Util.Inr uu____11760)
              ()
          with | uu___96_11762 -> FStar_Util.Inl uu___96_11762  in
        pop ();
        (match r with
         | FStar_Util.Inr v1 -> v1
         | FStar_Util.Inl ex -> FStar_Exn.raise ex)))
    else (push (); (let retv = f ()  in pop (); retv))
  
let (module_matches_namespace_filter :
  Prims.string -> Prims.string Prims.list -> Prims.bool) =
  fun m  ->
    fun filter1  ->
      let m1 = FStar_String.lowercase m  in
      let setting = parse_settings filter1  in
      let m_components = path_of_text m1  in
      let rec matches_path m_components1 path =
        match (m_components1, path) with
        | (uu____11843,[]) -> true
        | (m2::ms,p::ps) ->
            (m2 = (FStar_String.lowercase p)) && (matches_path ms ps)
        | uu____11876 -> false  in
      let uu____11888 =
        FStar_All.pipe_right setting
          (FStar_Util.try_find
             (fun uu____11930  ->
                match uu____11930 with
                | (path,uu____11941) -> matches_path m_components path))
         in
      match uu____11888 with
      | FStar_Pervasives_Native.None  -> false
      | FStar_Pervasives_Native.Some (uu____11960,flag) -> flag
  
let (should_extract : Prims.string -> Prims.bool) =
  fun m  ->
    let m1 = FStar_String.lowercase m  in
    let uu____11989 = get_extract ()  in
    match uu____11989 with
    | FStar_Pervasives_Native.Some extract_setting ->
        ((let uu____12004 =
            let uu____12020 = get_no_extract ()  in
            let uu____12024 = get_extract_namespace ()  in
            let uu____12028 = get_extract_module ()  in
            (uu____12020, uu____12024, uu____12028)  in
          match uu____12004 with
          | ([],[],[]) -> ()
          | uu____12053 ->
              failwith
                "Incompatible options: --extract cannot be used with --no_extract, --extract_namespace or --extract_module");
         module_matches_namespace_filter m1 extract_setting)
    | FStar_Pervasives_Native.None  ->
        let should_extract_namespace m2 =
          let uu____12082 = get_extract_namespace ()  in
          match uu____12082 with
          | [] -> false
          | ns ->
              FStar_All.pipe_right ns
                (FStar_Util.for_some
                   (fun n1  ->
                      FStar_Util.starts_with m2 (FStar_String.lowercase n1)))
           in
        let should_extract_module m2 =
          let uu____12110 = get_extract_module ()  in
          match uu____12110 with
          | [] -> false
          | l ->
              FStar_All.pipe_right l
                (FStar_Util.for_some
                   (fun n1  -> (FStar_String.lowercase n1) = m2))
           in
        (let uu____12132 = no_extract m1  in Prims.op_Negation uu____12132)
          &&
          (let uu____12135 =
             let uu____12146 = get_extract_namespace ()  in
             let uu____12150 = get_extract_module ()  in
             (uu____12146, uu____12150)  in
           (match uu____12135 with
            | ([],[]) -> true
            | uu____12170 ->
                (should_extract_namespace m1) || (should_extract_module m1)))
  
let (should_be_already_cached : Prims.string -> Prims.bool) =
  fun m  ->
    let uu____12190 = get_already_cached ()  in
    match uu____12190 with
    | FStar_Pervasives_Native.None  -> false
    | FStar_Pervasives_Native.Some already_cached_setting ->
        module_matches_namespace_filter m already_cached_setting
  