open Prims
let mkForall_fuel' :
  'Auu____14 .
    Prims.string ->
      FStar_Range.range ->
        'Auu____14 ->
          (FStar_SMTEncoding_Term.pat Prims.list Prims.list *
            FStar_SMTEncoding_Term.fvs * FStar_SMTEncoding_Term.term) ->
            FStar_SMTEncoding_Term.term
  =
  fun mname  ->
    fun r  ->
      fun n1  ->
        fun uu____45  ->
          match uu____45 with
          | (pats,vars,body) ->
              let fallback uu____73 =
                FStar_SMTEncoding_Term.mkForall r (pats, vars, body)  in
              let uu____78 = FStar_Options.unthrottle_inductives ()  in
              if uu____78
              then fallback ()
              else
                (let uu____83 =
                   FStar_SMTEncoding_Env.fresh_fvar mname "f"
                     FStar_SMTEncoding_Term.Fuel_sort
                    in
                 match uu____83 with
                 | (fsym,fterm) ->
                     let add_fuel1 tms =
                       FStar_All.pipe_right tms
                         (FStar_List.map
                            (fun p  ->
                               match p.FStar_SMTEncoding_Term.tm with
                               | FStar_SMTEncoding_Term.App
                                   (FStar_SMTEncoding_Term.Var
                                    "HasType",args)
                                   ->
                                   FStar_SMTEncoding_Util.mkApp
                                     ("HasTypeFuel", (fterm :: args))
                               | uu____123 -> p))
                        in
                     let pats1 = FStar_List.map add_fuel1 pats  in
                     let body1 =
                       match body.FStar_SMTEncoding_Term.tm with
                       | FStar_SMTEncoding_Term.App
                           (FStar_SMTEncoding_Term.Imp ,guard::body'::[]) ->
                           let guard1 =
                             match guard.FStar_SMTEncoding_Term.tm with
                             | FStar_SMTEncoding_Term.App
                                 (FStar_SMTEncoding_Term.And ,guards) ->
                                 let uu____144 = add_fuel1 guards  in
                                 FStar_SMTEncoding_Util.mk_and_l uu____144
                             | uu____147 ->
                                 let uu____148 = add_fuel1 [guard]  in
                                 FStar_All.pipe_right uu____148 FStar_List.hd
                              in
                           FStar_SMTEncoding_Util.mkImp (guard1, body')
                       | uu____153 -> body  in
                     let vars1 =
                       let uu____165 =
                         FStar_SMTEncoding_Term.mk_fv
                           (fsym, FStar_SMTEncoding_Term.Fuel_sort)
                          in
                       uu____165 :: vars  in
                     FStar_SMTEncoding_Term.mkForall r (pats1, vars1, body1))
  
let (mkForall_fuel :
  Prims.string ->
    FStar_Range.range ->
      (FStar_SMTEncoding_Term.pat Prims.list Prims.list *
        FStar_SMTEncoding_Term.fvs * FStar_SMTEncoding_Term.term) ->
        FStar_SMTEncoding_Term.term)
  = fun mname  -> fun r  -> mkForall_fuel' mname r (Prims.parse_int "1") 
let (head_normal :
  FStar_SMTEncoding_Env.env_t -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun env  ->
    fun t  ->
      let t1 = FStar_Syntax_Util.unmeta t  in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_arrow uu____229 -> true
      | FStar_Syntax_Syntax.Tm_refine uu____245 -> true
      | FStar_Syntax_Syntax.Tm_bvar uu____253 -> true
      | FStar_Syntax_Syntax.Tm_uvar uu____255 -> true
      | FStar_Syntax_Syntax.Tm_abs uu____269 -> true
      | FStar_Syntax_Syntax.Tm_constant uu____289 -> true
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let uu____292 =
            FStar_TypeChecker_Env.lookup_definition
              [FStar_TypeChecker_Env.Eager_unfolding_only]
              env.FStar_SMTEncoding_Env.tcenv
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
             in
          FStar_All.pipe_right uu____292 FStar_Option.isNone
      | FStar_Syntax_Syntax.Tm_app
          ({ FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
             FStar_Syntax_Syntax.pos = uu____311;
             FStar_Syntax_Syntax.vars = uu____312;_},uu____313)
          ->
          let uu____338 =
            FStar_TypeChecker_Env.lookup_definition
              [FStar_TypeChecker_Env.Eager_unfolding_only]
              env.FStar_SMTEncoding_Env.tcenv
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
             in
          FStar_All.pipe_right uu____338 FStar_Option.isNone
      | uu____356 -> false
  
let (head_redex :
  FStar_SMTEncoding_Env.env_t -> FStar_Syntax_Syntax.term -> Prims.bool) =
  fun env  ->
    fun t  ->
      let uu____370 =
        let uu____371 = FStar_Syntax_Util.un_uinst t  in
        uu____371.FStar_Syntax_Syntax.n  in
      match uu____370 with
      | FStar_Syntax_Syntax.Tm_abs
          (uu____375,uu____376,FStar_Pervasives_Native.Some rc) ->
          ((FStar_Ident.lid_equals rc.FStar_Syntax_Syntax.residual_effect
              FStar_Parser_Const.effect_Tot_lid)
             ||
             (FStar_Ident.lid_equals rc.FStar_Syntax_Syntax.residual_effect
                FStar_Parser_Const.effect_GTot_lid))
            ||
            (FStar_List.existsb
               (fun uu___0_401  ->
                  match uu___0_401 with
                  | FStar_Syntax_Syntax.TOTAL  -> true
                  | uu____404 -> false) rc.FStar_Syntax_Syntax.residual_flags)
      | FStar_Syntax_Syntax.Tm_fvar fv ->
          let uu____407 =
            FStar_TypeChecker_Env.lookup_definition
              [FStar_TypeChecker_Env.Eager_unfolding_only]
              env.FStar_SMTEncoding_Env.tcenv
              (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
             in
          FStar_All.pipe_right uu____407 FStar_Option.isSome
      | uu____425 -> false
  
let (whnf :
  FStar_SMTEncoding_Env.env_t ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun t  ->
      let uu____438 = head_normal env t  in
      if uu____438
      then t
      else
        FStar_TypeChecker_Normalize.normalize
          [FStar_TypeChecker_Env.Beta;
          FStar_TypeChecker_Env.Weak;
          FStar_TypeChecker_Env.HNF;
          FStar_TypeChecker_Env.Exclude FStar_TypeChecker_Env.Zeta;
          FStar_TypeChecker_Env.Eager_unfolding;
          FStar_TypeChecker_Env.EraseUniverses]
          env.FStar_SMTEncoding_Env.tcenv t
  
let (norm :
  FStar_SMTEncoding_Env.env_t ->
    FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun t  ->
      FStar_TypeChecker_Normalize.normalize
        [FStar_TypeChecker_Env.Beta;
        FStar_TypeChecker_Env.Exclude FStar_TypeChecker_Env.Zeta;
        FStar_TypeChecker_Env.Eager_unfolding;
        FStar_TypeChecker_Env.EraseUniverses] env.FStar_SMTEncoding_Env.tcenv
        t
  
let (trivial_post : FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun t  ->
    let uu____460 =
      let uu____461 = FStar_Syntax_Syntax.null_binder t  in [uu____461]  in
    let uu____480 =
      FStar_Syntax_Syntax.fvar FStar_Parser_Const.true_lid
        FStar_Syntax_Syntax.delta_constant FStar_Pervasives_Native.None
       in
    FStar_Syntax_Util.abs uu____460 uu____480 FStar_Pervasives_Native.None
  
let (mk_Apply :
  FStar_SMTEncoding_Term.term ->
    FStar_SMTEncoding_Term.fvs -> FStar_SMTEncoding_Term.term)
  =
  fun e  ->
    fun vars  ->
      FStar_All.pipe_right vars
        (FStar_List.fold_left
           (fun out  ->
              fun var  ->
                let uu____502 = FStar_SMTEncoding_Term.fv_sort var  in
                match uu____502 with
                | FStar_SMTEncoding_Term.Fuel_sort  ->
                    let uu____503 = FStar_SMTEncoding_Util.mkFreeV var  in
                    FStar_SMTEncoding_Term.mk_ApplyTF out uu____503
                | s ->
                    let uu____506 = FStar_SMTEncoding_Util.mkFreeV var  in
                    FStar_SMTEncoding_Util.mk_ApplyTT out uu____506) e)
  
let (mk_Apply_args :
  FStar_SMTEncoding_Term.term ->
    FStar_SMTEncoding_Term.term Prims.list -> FStar_SMTEncoding_Term.term)
  =
  fun e  ->
    fun args  ->
      FStar_All.pipe_right args
        (FStar_List.fold_left FStar_SMTEncoding_Util.mk_ApplyTT e)
  
let raise_arity_mismatch :
  'a . Prims.string -> Prims.int -> Prims.int -> FStar_Range.range -> 'a =
  fun head1  ->
    fun arity  ->
      fun n_args  ->
        fun rng  ->
          let uu____562 =
            let uu____568 =
              let uu____570 = FStar_Util.string_of_int arity  in
              let uu____572 = FStar_Util.string_of_int n_args  in
              FStar_Util.format3
                "Head symbol %s expects at least %s arguments; got only %s"
                head1 uu____570 uu____572
               in
            (FStar_Errors.Fatal_SMTEncodingArityMismatch, uu____568)  in
          FStar_Errors.raise_error uu____562 rng
  
let (maybe_curry_app :
  FStar_Range.range ->
    (FStar_SMTEncoding_Term.op,FStar_SMTEncoding_Term.term) FStar_Util.either
      ->
      Prims.int ->
        FStar_SMTEncoding_Term.term Prims.list -> FStar_SMTEncoding_Term.term)
  =
  fun rng  ->
    fun head1  ->
      fun arity  ->
        fun args  ->
          let n_args = FStar_List.length args  in
          match head1 with
          | FStar_Util.Inr head2 -> mk_Apply_args head2 args
          | FStar_Util.Inl head2 ->
              if n_args = arity
              then FStar_SMTEncoding_Util.mkApp' (head2, args)
              else
                if n_args > arity
                then
                  (let uu____621 = FStar_Util.first_N arity args  in
                   match uu____621 with
                   | (args1,rest) ->
                       let head3 =
                         FStar_SMTEncoding_Util.mkApp' (head2, args1)  in
                       mk_Apply_args head3 rest)
                else
                  (let uu____645 = FStar_SMTEncoding_Term.op_to_string head2
                      in
                   raise_arity_mismatch uu____645 arity n_args rng)
  
let (maybe_curry_fvb :
  FStar_Range.range ->
    FStar_SMTEncoding_Env.fvar_binding ->
      FStar_SMTEncoding_Term.term Prims.list -> FStar_SMTEncoding_Term.term)
  =
  fun rng  ->
    fun fvb  ->
      fun args  ->
        if fvb.FStar_SMTEncoding_Env.fvb_thunked
        then
          let uu____668 = FStar_SMTEncoding_Env.force_thunk fvb  in
          mk_Apply_args uu____668 args
        else
          maybe_curry_app rng
            (FStar_Util.Inl
               (FStar_SMTEncoding_Term.Var (fvb.FStar_SMTEncoding_Env.smt_id)))
            fvb.FStar_SMTEncoding_Env.smt_arity args
  
let (is_app : FStar_SMTEncoding_Term.op -> Prims.bool) =
  fun uu___1_677  ->
    match uu___1_677 with
    | FStar_SMTEncoding_Term.Var "ApplyTT" -> true
    | FStar_SMTEncoding_Term.Var "ApplyTF" -> true
    | uu____683 -> false
  
let (is_an_eta_expansion :
  FStar_SMTEncoding_Env.env_t ->
    FStar_SMTEncoding_Term.fv Prims.list ->
      FStar_SMTEncoding_Term.term ->
        FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option)
  =
  fun env  ->
    fun vars  ->
      fun body  ->
        let rec check_partial_applications t xs =
          match ((t.FStar_SMTEncoding_Term.tm), xs) with
          | (FStar_SMTEncoding_Term.App
             (app,f::{
                       FStar_SMTEncoding_Term.tm =
                         FStar_SMTEncoding_Term.FreeV y;
                       FStar_SMTEncoding_Term.freevars = uu____731;
                       FStar_SMTEncoding_Term.rng = uu____732;_}::[]),x::xs1)
              when (is_app app) && (FStar_SMTEncoding_Term.fv_eq x y) ->
              check_partial_applications f xs1
          | (FStar_SMTEncoding_Term.App
             (FStar_SMTEncoding_Term.Var f,args),uu____763) ->
              let uu____773 =
                ((FStar_List.length args) = (FStar_List.length xs)) &&
                  (FStar_List.forall2
                     (fun a  ->
                        fun v1  ->
                          match a.FStar_SMTEncoding_Term.tm with
                          | FStar_SMTEncoding_Term.FreeV fv ->
                              FStar_SMTEncoding_Term.fv_eq fv v1
                          | uu____790 -> false) args (FStar_List.rev xs))
                 in
              if uu____773
              then FStar_SMTEncoding_Env.tok_of_name env f
              else FStar_Pervasives_Native.None
          | (uu____797,[]) ->
              let fvs = FStar_SMTEncoding_Term.free_variables t  in
              let uu____801 =
                FStar_All.pipe_right fvs
                  (FStar_List.for_all
                     (fun fv  ->
                        let uu____809 =
                          FStar_Util.for_some
                            (FStar_SMTEncoding_Term.fv_eq fv) vars
                           in
                        Prims.op_Negation uu____809))
                 in
              if uu____801
              then FStar_Pervasives_Native.Some t
              else FStar_Pervasives_Native.None
          | uu____816 -> FStar_Pervasives_Native.None  in
        check_partial_applications body (FStar_List.rev vars)
  
let check_pattern_vars :
  'Auu____834 'Auu____835 .
    FStar_SMTEncoding_Env.env_t ->
      (FStar_Syntax_Syntax.bv * 'Auu____834) Prims.list ->
        (FStar_Syntax_Syntax.term * 'Auu____835) Prims.list -> unit
  =
  fun env  ->
    fun vars  ->
      fun pats  ->
        let pats1 =
          FStar_All.pipe_right pats
            (FStar_List.map
               (fun uu____893  ->
                  match uu____893 with
                  | (x,uu____899) ->
                      FStar_TypeChecker_Normalize.normalize
                        [FStar_TypeChecker_Env.Beta;
                        FStar_TypeChecker_Env.AllowUnboundUniverses;
                        FStar_TypeChecker_Env.EraseUniverses]
                        env.FStar_SMTEncoding_Env.tcenv x))
           in
        match pats1 with
        | [] -> ()
        | hd1::tl1 ->
            let pat_vars =
              let uu____907 = FStar_Syntax_Free.names hd1  in
              FStar_List.fold_left
                (fun out  ->
                   fun x  ->
                     let uu____919 = FStar_Syntax_Free.names x  in
                     FStar_Util.set_union out uu____919) uu____907 tl1
               in
            let uu____922 =
              FStar_All.pipe_right vars
                (FStar_Util.find_opt
                   (fun uu____949  ->
                      match uu____949 with
                      | (b,uu____956) ->
                          let uu____957 = FStar_Util.set_mem b pat_vars  in
                          Prims.op_Negation uu____957))
               in
            (match uu____922 with
             | FStar_Pervasives_Native.None  -> ()
             | FStar_Pervasives_Native.Some (x,uu____964) ->
                 let pos =
                   FStar_List.fold_left
                     (fun out  ->
                        fun t  ->
                          FStar_Range.union_ranges out
                            t.FStar_Syntax_Syntax.pos)
                     hd1.FStar_Syntax_Syntax.pos tl1
                    in
                 let uu____978 =
                   let uu____984 =
                     let uu____986 = FStar_Syntax_Print.bv_to_string x  in
                     FStar_Util.format1
                       "SMT pattern misses at least one bound variable: %s"
                       uu____986
                      in
                   (FStar_Errors.Warning_SMTPatternIllFormed, uu____984)  in
                 FStar_Errors.log_issue pos uu____978)
  
type label = (FStar_SMTEncoding_Term.fv * Prims.string * FStar_Range.range)
type labels = label Prims.list
type pattern =
  {
  pat_vars: (FStar_Syntax_Syntax.bv * FStar_SMTEncoding_Term.fv) Prims.list ;
  pat_term:
    unit -> (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t) ;
  guard: FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term ;
  projections:
    FStar_SMTEncoding_Term.term ->
      (FStar_Syntax_Syntax.bv * FStar_SMTEncoding_Term.term) Prims.list
    }
let (__proj__Mkpattern__item__pat_vars :
  pattern -> (FStar_Syntax_Syntax.bv * FStar_SMTEncoding_Term.fv) Prims.list)
  =
  fun projectee  ->
    match projectee with
    | { pat_vars; pat_term; guard; projections;_} -> pat_vars
  
let (__proj__Mkpattern__item__pat_term :
  pattern ->
    unit -> (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun projectee  ->
    match projectee with
    | { pat_vars; pat_term; guard; projections;_} -> pat_term
  
let (__proj__Mkpattern__item__guard :
  pattern -> FStar_SMTEncoding_Term.term -> FStar_SMTEncoding_Term.term) =
  fun projectee  ->
    match projectee with
    | { pat_vars; pat_term; guard; projections;_} -> guard
  
let (__proj__Mkpattern__item__projections :
  pattern ->
    FStar_SMTEncoding_Term.term ->
      (FStar_Syntax_Syntax.bv * FStar_SMTEncoding_Term.term) Prims.list)
  =
  fun projectee  ->
    match projectee with
    | { pat_vars; pat_term; guard; projections;_} -> projections
  
let (as_function_typ :
  FStar_SMTEncoding_Env.env_t ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.term)
  =
  fun env  ->
    fun t0  ->
      let rec aux norm1 t =
        let t1 = FStar_Syntax_Subst.compress t  in
        match t1.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Tm_arrow uu____1272 -> t1
        | FStar_Syntax_Syntax.Tm_refine uu____1287 ->
            let uu____1294 = FStar_Syntax_Util.unrefine t1  in
            aux true uu____1294
        | uu____1296 ->
            if norm1
            then let uu____1298 = whnf env t1  in aux false uu____1298
            else
              (let uu____1302 =
                 let uu____1304 =
                   FStar_Range.string_of_range t0.FStar_Syntax_Syntax.pos  in
                 let uu____1306 = FStar_Syntax_Print.term_to_string t0  in
                 FStar_Util.format2 "(%s) Expected a function typ; got %s"
                   uu____1304 uu____1306
                  in
               failwith uu____1302)
         in
      aux true t0
  
let rec (curried_arrow_formals_comp :
  FStar_Syntax_Syntax.term ->
    (FStar_Syntax_Syntax.binders * FStar_Syntax_Syntax.comp))
  =
  fun k  ->
    let k1 = FStar_Syntax_Subst.compress k  in
    match k1.FStar_Syntax_Syntax.n with
    | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
        FStar_Syntax_Subst.open_comp bs c
    | FStar_Syntax_Syntax.Tm_refine (bv,uu____1348) ->
        let uu____1353 =
          curried_arrow_formals_comp bv.FStar_Syntax_Syntax.sort  in
        (match uu____1353 with
         | (args,res) ->
             (match args with
              | [] ->
                  let uu____1374 = FStar_Syntax_Syntax.mk_Total k1  in
                  ([], uu____1374)
              | uu____1381 -> (args, res)))
    | uu____1382 ->
        let uu____1383 = FStar_Syntax_Syntax.mk_Total k1  in ([], uu____1383)
  
let is_arithmetic_primitive :
  'Auu____1397 .
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      'Auu____1397 Prims.list -> Prims.bool
  =
  fun head1  ->
    fun args  ->
      match ((head1.FStar_Syntax_Syntax.n), args) with
      | (FStar_Syntax_Syntax.Tm_fvar fv,uu____1420::uu____1421::[]) ->
          ((((((((((((FStar_Syntax_Syntax.fv_eq_lid fv
                        FStar_Parser_Const.op_Addition)
                       ||
                       (FStar_Syntax_Syntax.fv_eq_lid fv
                          FStar_Parser_Const.op_Subtraction))
                      ||
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.op_Multiply))
                     ||
                     (FStar_Syntax_Syntax.fv_eq_lid fv
                        FStar_Parser_Const.op_Division))
                    ||
                    (FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.op_Modulus))
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.real_op_LT))
                  ||
                  (FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.real_op_LTE))
                 ||
                 (FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.real_op_GT))
                ||
                (FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.real_op_GTE))
               ||
               (FStar_Syntax_Syntax.fv_eq_lid fv
                  FStar_Parser_Const.real_op_Addition))
              ||
              (FStar_Syntax_Syntax.fv_eq_lid fv
                 FStar_Parser_Const.real_op_Subtraction))
             ||
             (FStar_Syntax_Syntax.fv_eq_lid fv
                FStar_Parser_Const.real_op_Multiply))
            ||
            (FStar_Syntax_Syntax.fv_eq_lid fv
               FStar_Parser_Const.real_op_Division)
      | (FStar_Syntax_Syntax.Tm_fvar fv,uu____1425::[]) ->
          FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.op_Minus
      | uu____1428 -> false
  
let (isInteger : FStar_Syntax_Syntax.term' -> Prims.bool) =
  fun tm  ->
    match tm with
    | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_int
        (n1,FStar_Pervasives_Native.None )) -> true
    | uu____1459 -> false
  
let (getInteger : FStar_Syntax_Syntax.term' -> Prims.int) =
  fun tm  ->
    match tm with
    | FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_int
        (n1,FStar_Pervasives_Native.None )) -> FStar_Util.int_of_string n1
    | uu____1482 -> failwith "Expected an Integer term"
  
let is_BitVector_primitive :
  'Auu____1492 .
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax * 'Auu____1492)
        Prims.list -> Prims.bool
  =
  fun head1  ->
    fun args  ->
      match ((head1.FStar_Syntax_Syntax.n), args) with
      | (FStar_Syntax_Syntax.Tm_fvar
         fv,(sz_arg,uu____1534)::uu____1535::uu____1536::[]) ->
          (((((((((((FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.bv_and_lid)
                      ||
                      (FStar_Syntax_Syntax.fv_eq_lid fv
                         FStar_Parser_Const.bv_xor_lid))
                     ||
                     (FStar_Syntax_Syntax.fv_eq_lid fv
                        FStar_Parser_Const.bv_or_lid))
                    ||
                    (FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.bv_add_lid))
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.bv_sub_lid))
                  ||
                  (FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.bv_shift_left_lid))
                 ||
                 (FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.bv_shift_right_lid))
                ||
                (FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.bv_udiv_lid))
               ||
               (FStar_Syntax_Syntax.fv_eq_lid fv
                  FStar_Parser_Const.bv_mod_lid))
              ||
              (FStar_Syntax_Syntax.fv_eq_lid fv
                 FStar_Parser_Const.bv_uext_lid))
             ||
             (FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.bv_mul_lid))
            && (isInteger sz_arg.FStar_Syntax_Syntax.n)
      | (FStar_Syntax_Syntax.Tm_fvar fv,(sz_arg,uu____1587)::uu____1588::[])
          ->
          ((FStar_Syntax_Syntax.fv_eq_lid fv FStar_Parser_Const.nat_to_bv_lid)
             ||
             (FStar_Syntax_Syntax.fv_eq_lid fv
                FStar_Parser_Const.bv_to_nat_lid))
            && (isInteger sz_arg.FStar_Syntax_Syntax.n)
      | uu____1625 -> false
  
let rec (encode_const :
  FStar_Const.sconst ->
    FStar_SMTEncoding_Env.env_t ->
      (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun c  ->
    fun env  ->
      match c with
      | FStar_Const.Const_unit  -> (FStar_SMTEncoding_Term.mk_Term_unit, [])
      | FStar_Const.Const_bool (true ) ->
          let uu____1949 =
            FStar_SMTEncoding_Term.boxBool FStar_SMTEncoding_Util.mkTrue  in
          (uu____1949, [])
      | FStar_Const.Const_bool (false ) ->
          let uu____1951 =
            FStar_SMTEncoding_Term.boxBool FStar_SMTEncoding_Util.mkFalse  in
          (uu____1951, [])
      | FStar_Const.Const_char c1 ->
          let uu____1954 =
            let uu____1955 =
              let uu____1963 =
                let uu____1966 =
                  let uu____1967 =
                    FStar_SMTEncoding_Util.mkInteger'
                      (FStar_Util.int_of_char c1)
                     in
                  FStar_SMTEncoding_Term.boxInt uu____1967  in
                [uu____1966]  in
              ("FStar.Char.__char_of_int", uu____1963)  in
            FStar_SMTEncoding_Util.mkApp uu____1955  in
          (uu____1954, [])
      | FStar_Const.Const_int (i,FStar_Pervasives_Native.None ) ->
          let uu____1985 =
            let uu____1986 = FStar_SMTEncoding_Util.mkInteger i  in
            FStar_SMTEncoding_Term.boxInt uu____1986  in
          (uu____1985, [])
      | FStar_Const.Const_int (repr,FStar_Pervasives_Native.Some sw) ->
          let syntax_term =
            FStar_ToSyntax_ToSyntax.desugar_machine_integer
              (env.FStar_SMTEncoding_Env.tcenv).FStar_TypeChecker_Env.dsenv
              repr sw FStar_Range.dummyRange
             in
          encode_term syntax_term env
      | FStar_Const.Const_string (s,uu____2007) ->
          let uu____2010 =
            FStar_SMTEncoding_Env.varops.FStar_SMTEncoding_Env.string_const s
             in
          (uu____2010, [])
      | FStar_Const.Const_range uu____2011 ->
          let uu____2012 = FStar_SMTEncoding_Term.mk_Range_const ()  in
          (uu____2012, [])
      | FStar_Const.Const_effect  ->
          (FStar_SMTEncoding_Term.mk_Term_type, [])
      | FStar_Const.Const_real r ->
          let uu____2015 =
            let uu____2016 = FStar_SMTEncoding_Util.mkReal r  in
            FStar_SMTEncoding_Term.boxReal uu____2016  in
          (uu____2015, [])
      | c1 ->
          let uu____2018 =
            let uu____2020 = FStar_Syntax_Print.const_to_string c1  in
            FStar_Util.format1 "Unhandled constant: %s" uu____2020  in
          failwith uu____2018

and (encode_binders :
  FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.binders ->
      FStar_SMTEncoding_Env.env_t ->
        (FStar_SMTEncoding_Term.fv Prims.list * FStar_SMTEncoding_Term.term
          Prims.list * FStar_SMTEncoding_Env.env_t *
          FStar_SMTEncoding_Term.decls_t * FStar_Syntax_Syntax.bv Prims.list))
  =
  fun fuel_opt  ->
    fun bs  ->
      fun env  ->
        (let uu____2049 =
           FStar_TypeChecker_Env.debug env.FStar_SMTEncoding_Env.tcenv
             FStar_Options.Medium
            in
         if uu____2049
         then
           let uu____2052 = FStar_Syntax_Print.binders_to_string ", " bs  in
           FStar_Util.print1 "Encoding binders %s\n" uu____2052
         else ());
        (let uu____2058 =
           FStar_All.pipe_right bs
             (FStar_List.fold_left
                (fun uu____2140  ->
                   fun b  ->
                     match uu____2140 with
                     | (vars,guards,env1,decls,names1) ->
                         let uu____2205 =
                           let x = FStar_Pervasives_Native.fst b  in
                           let uu____2221 =
                             FStar_SMTEncoding_Env.gen_term_var env1 x  in
                           match uu____2221 with
                           | (xxsym,xx,env') ->
                               let uu____2246 =
                                 let uu____2251 =
                                   norm env1 x.FStar_Syntax_Syntax.sort  in
                                 encode_term_pred fuel_opt uu____2251 env1 xx
                                  in
                               (match uu____2246 with
                                | (guard_x_t,decls') ->
                                    let uu____2266 =
                                      FStar_SMTEncoding_Term.mk_fv
                                        (xxsym,
                                          FStar_SMTEncoding_Term.Term_sort)
                                       in
                                    (uu____2266, guard_x_t, env', decls', x))
                            in
                         (match uu____2205 with
                          | (v1,g,env2,decls',n1) ->
                              ((v1 :: vars), (g :: guards), env2,
                                (FStar_List.append decls decls'), (n1 ::
                                names1)))) ([], [], env, [], []))
            in
         match uu____2058 with
         | (vars,guards,env1,decls,names1) ->
             ((FStar_List.rev vars), (FStar_List.rev guards), env1, decls,
               (FStar_List.rev names1)))

and (encode_term_pred :
  FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.typ ->
      FStar_SMTEncoding_Env.env_t ->
        FStar_SMTEncoding_Term.term ->
          (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun fuel_opt  ->
    fun t  ->
      fun env  ->
        fun e  ->
          let uu____2366 = encode_term t env  in
          match uu____2366 with
          | (t1,decls) ->
              let uu____2377 =
                FStar_SMTEncoding_Term.mk_HasTypeWithFuel fuel_opt e t1  in
              (uu____2377, decls)

and (encode_term_pred' :
  FStar_SMTEncoding_Term.term FStar_Pervasives_Native.option ->
    FStar_Syntax_Syntax.typ ->
      FStar_SMTEncoding_Env.env_t ->
        FStar_SMTEncoding_Term.term ->
          (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun fuel_opt  ->
    fun t  ->
      fun env  ->
        fun e  ->
          let uu____2388 = encode_term t env  in
          match uu____2388 with
          | (t1,decls) ->
              (match fuel_opt with
               | FStar_Pervasives_Native.None  ->
                   let uu____2403 = FStar_SMTEncoding_Term.mk_HasTypeZ e t1
                      in
                   (uu____2403, decls)
               | FStar_Pervasives_Native.Some f ->
                   let uu____2405 =
                     FStar_SMTEncoding_Term.mk_HasTypeFuel f e t1  in
                   (uu____2405, decls))

and (encode_arith_term :
  FStar_SMTEncoding_Env.env_t ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.args ->
        (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun env  ->
    fun head1  ->
      fun args_e  ->
        let uu____2411 = encode_args args_e env  in
        match uu____2411 with
        | (arg_tms,decls) ->
            let head_fv =
              match head1.FStar_Syntax_Syntax.n with
              | FStar_Syntax_Syntax.Tm_fvar fv -> fv
              | uu____2430 -> failwith "Impossible"  in
            let unary unbox arg_tms1 =
              let uu____2452 = FStar_List.hd arg_tms1  in unbox uu____2452
               in
            let binary unbox arg_tms1 =
              let uu____2477 =
                let uu____2478 = FStar_List.hd arg_tms1  in unbox uu____2478
                 in
              let uu____2479 =
                let uu____2480 =
                  let uu____2481 = FStar_List.tl arg_tms1  in
                  FStar_List.hd uu____2481  in
                unbox uu____2480  in
              (uu____2477, uu____2479)  in
            let mk_default uu____2489 =
              let uu____2490 =
                FStar_SMTEncoding_Env.lookup_free_var_sym env
                  head_fv.FStar_Syntax_Syntax.fv_name
                 in
              match uu____2490 with
              | (fname,fuel_args,arity) ->
                  let args = FStar_List.append fuel_args arg_tms  in
                  maybe_curry_app head1.FStar_Syntax_Syntax.pos fname arity
                    args
               in
            let mk_l box op mk_args ts =
              let uu____2579 = FStar_Options.smtencoding_l_arith_native ()
                 in
              if uu____2579
              then
                let uu____2582 =
                  let uu____2583 = mk_args ts  in op uu____2583  in
                FStar_All.pipe_right uu____2582 box
              else mk_default ()  in
            let mk_nl box unbox nm op ts =
              let uu____2641 = FStar_Options.smtencoding_nl_arith_wrapped ()
                 in
              if uu____2641
              then
                let uu____2644 = binary unbox ts  in
                match uu____2644 with
                | (t1,t2) ->
                    let uu____2651 =
                      FStar_SMTEncoding_Util.mkApp (nm, [t1; t2])  in
                    FStar_All.pipe_right uu____2651 box
              else
                (let uu____2657 =
                   FStar_Options.smtencoding_nl_arith_native ()  in
                 if uu____2657
                 then
                   let uu____2660 =
                     let uu____2661 = binary unbox ts  in op uu____2661  in
                   FStar_All.pipe_right uu____2660 box
                 else mk_default ())
               in
            let add1 box unbox =
              mk_l box FStar_SMTEncoding_Util.mkAdd (binary unbox)  in
            let sub1 box unbox =
              mk_l box FStar_SMTEncoding_Util.mkSub (binary unbox)  in
            let minus1 box unbox =
              mk_l box FStar_SMTEncoding_Util.mkMinus (unary unbox)  in
            let mul1 box unbox nm =
              mk_nl box unbox nm FStar_SMTEncoding_Util.mkMul  in
            let div1 box unbox nm =
              mk_nl box unbox nm FStar_SMTEncoding_Util.mkDiv  in
            let modulus box unbox =
              mk_nl box unbox "_mod" FStar_SMTEncoding_Util.mkMod  in
            let ops =
              [(FStar_Parser_Const.op_Addition,
                 (add1 FStar_SMTEncoding_Term.boxInt
                    FStar_SMTEncoding_Term.unboxInt));
              (FStar_Parser_Const.op_Subtraction,
                (sub1 FStar_SMTEncoding_Term.boxInt
                   FStar_SMTEncoding_Term.unboxInt));
              (FStar_Parser_Const.op_Multiply,
                (mul1 FStar_SMTEncoding_Term.boxInt
                   FStar_SMTEncoding_Term.unboxInt "_mul"));
              (FStar_Parser_Const.op_Division,
                (div1 FStar_SMTEncoding_Term.boxInt
                   FStar_SMTEncoding_Term.unboxInt "_div"));
              (FStar_Parser_Const.op_Modulus,
                (modulus FStar_SMTEncoding_Term.boxInt
                   FStar_SMTEncoding_Term.unboxInt));
              (FStar_Parser_Const.op_Minus,
                (minus1 FStar_SMTEncoding_Term.boxInt
                   FStar_SMTEncoding_Term.unboxInt));
              (FStar_Parser_Const.real_op_Addition,
                (add1 FStar_SMTEncoding_Term.boxReal
                   FStar_SMTEncoding_Term.unboxReal));
              (FStar_Parser_Const.real_op_Subtraction,
                (sub1 FStar_SMTEncoding_Term.boxReal
                   FStar_SMTEncoding_Term.unboxReal));
              (FStar_Parser_Const.real_op_Multiply,
                (mul1 FStar_SMTEncoding_Term.boxReal
                   FStar_SMTEncoding_Term.unboxReal "_rmul"));
              (FStar_Parser_Const.real_op_Division,
                (mk_nl FStar_SMTEncoding_Term.boxReal
                   FStar_SMTEncoding_Term.unboxReal "_rdiv"
                   FStar_SMTEncoding_Util.mkRealDiv));
              (FStar_Parser_Const.real_op_LT,
                (mk_l FStar_SMTEncoding_Term.boxBool
                   FStar_SMTEncoding_Util.mkLT
                   (binary FStar_SMTEncoding_Term.unboxReal)));
              (FStar_Parser_Const.real_op_LTE,
                (mk_l FStar_SMTEncoding_Term.boxBool
                   FStar_SMTEncoding_Util.mkLTE
                   (binary FStar_SMTEncoding_Term.unboxReal)));
              (FStar_Parser_Const.real_op_GT,
                (mk_l FStar_SMTEncoding_Term.boxBool
                   FStar_SMTEncoding_Util.mkGT
                   (binary FStar_SMTEncoding_Term.unboxReal)));
              (FStar_Parser_Const.real_op_GTE,
                (mk_l FStar_SMTEncoding_Term.boxBool
                   FStar_SMTEncoding_Util.mkGTE
                   (binary FStar_SMTEncoding_Term.unboxReal)))]
               in
            let uu____3096 =
              let uu____3106 =
                FStar_List.tryFind
                  (fun uu____3130  ->
                     match uu____3130 with
                     | (l,uu____3141) ->
                         FStar_Syntax_Syntax.fv_eq_lid head_fv l) ops
                 in
              FStar_All.pipe_right uu____3106 FStar_Util.must  in
            (match uu____3096 with
             | (uu____3185,op) ->
                 let uu____3197 = op arg_tms  in (uu____3197, decls))

and (encode_BitVector_term :
  FStar_SMTEncoding_Env.env_t ->
    FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
        FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
        Prims.list ->
        (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_elt
          Prims.list))
  =
  fun env  ->
    fun head1  ->
      fun args_e  ->
        let uu____3213 = FStar_List.hd args_e  in
        match uu____3213 with
        | (tm_sz,uu____3229) ->
            let uu____3238 = uu____3213  in
            let sz = getInteger tm_sz.FStar_Syntax_Syntax.n  in
            let sz_key =
              FStar_Util.format1 "BitVector_%s" (Prims.string_of_int sz)  in
            let sz_decls =
              let t_decls1 = FStar_SMTEncoding_Term.mkBvConstructor sz  in
              FStar_SMTEncoding_Term.mk_decls "" sz_key t_decls1 []  in
            let uu____3249 =
              match ((head1.FStar_Syntax_Syntax.n), args_e) with
              | (FStar_Syntax_Syntax.Tm_fvar
                 fv,uu____3275::(sz_arg,uu____3277)::uu____3278::[]) when
                  (FStar_Syntax_Syntax.fv_eq_lid fv
                     FStar_Parser_Const.bv_uext_lid)
                    && (isInteger sz_arg.FStar_Syntax_Syntax.n)
                  ->
                  let uu____3345 =
                    let uu____3346 = FStar_List.tail args_e  in
                    FStar_List.tail uu____3346  in
                  let uu____3373 =
                    let uu____3377 = getInteger sz_arg.FStar_Syntax_Syntax.n
                       in
                    FStar_Pervasives_Native.Some uu____3377  in
                  (uu____3345, uu____3373)
              | (FStar_Syntax_Syntax.Tm_fvar
                 fv,uu____3384::(sz_arg,uu____3386)::uu____3387::[]) when
                  FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.bv_uext_lid
                  ->
                  let uu____3454 =
                    let uu____3456 = FStar_Syntax_Print.term_to_string sz_arg
                       in
                    FStar_Util.format1
                      "Not a constant bitvector extend size: %s" uu____3456
                     in
                  failwith uu____3454
              | uu____3466 ->
                  let uu____3481 = FStar_List.tail args_e  in
                  (uu____3481, FStar_Pervasives_Native.None)
               in
            (match uu____3249 with
             | (arg_tms,ext_sz) ->
                 let uu____3508 = encode_args arg_tms env  in
                 (match uu____3508 with
                  | (arg_tms1,decls) ->
                      let head_fv =
                        match head1.FStar_Syntax_Syntax.n with
                        | FStar_Syntax_Syntax.Tm_fvar fv -> fv
                        | uu____3529 -> failwith "Impossible"  in
                      let unary arg_tms2 =
                        let uu____3541 = FStar_List.hd arg_tms2  in
                        FStar_SMTEncoding_Term.unboxBitVec sz uu____3541  in
                      let unary_arith arg_tms2 =
                        let uu____3552 = FStar_List.hd arg_tms2  in
                        FStar_SMTEncoding_Term.unboxInt uu____3552  in
                      let binary arg_tms2 =
                        let uu____3567 =
                          let uu____3568 = FStar_List.hd arg_tms2  in
                          FStar_SMTEncoding_Term.unboxBitVec sz uu____3568
                           in
                        let uu____3569 =
                          let uu____3570 =
                            let uu____3571 = FStar_List.tl arg_tms2  in
                            FStar_List.hd uu____3571  in
                          FStar_SMTEncoding_Term.unboxBitVec sz uu____3570
                           in
                        (uu____3567, uu____3569)  in
                      let binary_arith arg_tms2 =
                        let uu____3588 =
                          let uu____3589 = FStar_List.hd arg_tms2  in
                          FStar_SMTEncoding_Term.unboxBitVec sz uu____3589
                           in
                        let uu____3590 =
                          let uu____3591 =
                            let uu____3592 = FStar_List.tl arg_tms2  in
                            FStar_List.hd uu____3592  in
                          FStar_SMTEncoding_Term.unboxInt uu____3591  in
                        (uu____3588, uu____3590)  in
                      let mk_bv op mk_args resBox ts =
                        let uu____3650 =
                          let uu____3651 = mk_args ts  in op uu____3651  in
                        FStar_All.pipe_right uu____3650 resBox  in
                      let bv_and =
                        mk_bv FStar_SMTEncoding_Util.mkBvAnd binary
                          (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_xor =
                        mk_bv FStar_SMTEncoding_Util.mkBvXor binary
                          (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_or =
                        mk_bv FStar_SMTEncoding_Util.mkBvOr binary
                          (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_add =
                        mk_bv FStar_SMTEncoding_Util.mkBvAdd binary
                          (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_sub =
                        mk_bv FStar_SMTEncoding_Util.mkBvSub binary
                          (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_shl =
                        mk_bv (FStar_SMTEncoding_Util.mkBvShl sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_shr =
                        mk_bv (FStar_SMTEncoding_Util.mkBvShr sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_udiv =
                        mk_bv (FStar_SMTEncoding_Util.mkBvUdiv sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_mod =
                        mk_bv (FStar_SMTEncoding_Util.mkBvMod sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_mul =
                        mk_bv (FStar_SMTEncoding_Util.mkBvMul sz)
                          binary_arith (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let bv_ult =
                        mk_bv FStar_SMTEncoding_Util.mkBvUlt binary
                          FStar_SMTEncoding_Term.boxBool
                         in
                      let bv_uext arg_tms2 =
                        let uu____3783 =
                          let uu____3788 =
                            match ext_sz with
                            | FStar_Pervasives_Native.Some x -> x
                            | FStar_Pervasives_Native.None  ->
                                failwith "impossible"
                             in
                          FStar_SMTEncoding_Util.mkBvUext uu____3788  in
                        let uu____3797 =
                          let uu____3802 =
                            let uu____3804 =
                              match ext_sz with
                              | FStar_Pervasives_Native.Some x -> x
                              | FStar_Pervasives_Native.None  ->
                                  failwith "impossible"
                               in
                            sz + uu____3804  in
                          FStar_SMTEncoding_Term.boxBitVec uu____3802  in
                        mk_bv uu____3783 unary uu____3797 arg_tms2  in
                      let to_int1 =
                        mk_bv FStar_SMTEncoding_Util.mkBvToNat unary
                          FStar_SMTEncoding_Term.boxInt
                         in
                      let bv_to =
                        mk_bv (FStar_SMTEncoding_Util.mkNatToBv sz)
                          unary_arith (FStar_SMTEncoding_Term.boxBitVec sz)
                         in
                      let ops =
                        [(FStar_Parser_Const.bv_and_lid, bv_and);
                        (FStar_Parser_Const.bv_xor_lid, bv_xor);
                        (FStar_Parser_Const.bv_or_lid, bv_or);
                        (FStar_Parser_Const.bv_add_lid, bv_add);
                        (FStar_Parser_Const.bv_sub_lid, bv_sub);
                        (FStar_Parser_Const.bv_shift_left_lid, bv_shl);
                        (FStar_Parser_Const.bv_shift_right_lid, bv_shr);
                        (FStar_Parser_Const.bv_udiv_lid, bv_udiv);
                        (FStar_Parser_Const.bv_mod_lid, bv_mod);
                        (FStar_Parser_Const.bv_mul_lid, bv_mul);
                        (FStar_Parser_Const.bv_ult_lid, bv_ult);
                        (FStar_Parser_Const.bv_uext_lid, bv_uext);
                        (FStar_Parser_Const.bv_to_nat_lid, to_int1);
                        (FStar_Parser_Const.nat_to_bv_lid, bv_to)]  in
                      let uu____4044 =
                        let uu____4054 =
                          FStar_List.tryFind
                            (fun uu____4078  ->
                               match uu____4078 with
                               | (l,uu____4089) ->
                                   FStar_Syntax_Syntax.fv_eq_lid head_fv l)
                            ops
                           in
                        FStar_All.pipe_right uu____4054 FStar_Util.must  in
                      (match uu____4044 with
                       | (uu____4135,op) ->
                           let uu____4147 = op arg_tms1  in
                           (uu____4147, (FStar_List.append sz_decls decls)))))

and (encode_deeply_embedded_quantifier :
  FStar_Syntax_Syntax.term ->
    FStar_SMTEncoding_Env.env_t ->
      (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun t  ->
    fun env  ->
      let env1 =
        let uu___540_4157 = env  in
        {
          FStar_SMTEncoding_Env.bvar_bindings =
            (uu___540_4157.FStar_SMTEncoding_Env.bvar_bindings);
          FStar_SMTEncoding_Env.fvar_bindings =
            (uu___540_4157.FStar_SMTEncoding_Env.fvar_bindings);
          FStar_SMTEncoding_Env.depth =
            (uu___540_4157.FStar_SMTEncoding_Env.depth);
          FStar_SMTEncoding_Env.tcenv =
            (uu___540_4157.FStar_SMTEncoding_Env.tcenv);
          FStar_SMTEncoding_Env.warn =
            (uu___540_4157.FStar_SMTEncoding_Env.warn);
          FStar_SMTEncoding_Env.nolabels =
            (uu___540_4157.FStar_SMTEncoding_Env.nolabels);
          FStar_SMTEncoding_Env.use_zfuel_name =
            (uu___540_4157.FStar_SMTEncoding_Env.use_zfuel_name);
          FStar_SMTEncoding_Env.encode_non_total_function_typ =
            (uu___540_4157.FStar_SMTEncoding_Env.encode_non_total_function_typ);
          FStar_SMTEncoding_Env.current_module_name =
            (uu___540_4157.FStar_SMTEncoding_Env.current_module_name);
          FStar_SMTEncoding_Env.encoding_quantifier = true;
          FStar_SMTEncoding_Env.global_cache =
            (uu___540_4157.FStar_SMTEncoding_Env.global_cache)
        }  in
      let uu____4159 = encode_term t env1  in
      match uu____4159 with
      | (tm,decls) ->
          let vars = FStar_SMTEncoding_Term.free_variables tm  in
          let valid_tm = FStar_SMTEncoding_Term.mk_Valid tm  in
          let key =
            FStar_SMTEncoding_Term.mkForall t.FStar_Syntax_Syntax.pos
              ([], vars, valid_tm)
             in
          let tkey_hash = FStar_SMTEncoding_Term.hash_of_term key  in
          (match tm.FStar_SMTEncoding_Term.tm with
           | FStar_SMTEncoding_Term.App
               (uu____4185,{
                             FStar_SMTEncoding_Term.tm =
                               FStar_SMTEncoding_Term.FreeV uu____4186;
                             FStar_SMTEncoding_Term.freevars = uu____4187;
                             FStar_SMTEncoding_Term.rng = uu____4188;_}::
                {
                  FStar_SMTEncoding_Term.tm = FStar_SMTEncoding_Term.FreeV
                    uu____4189;
                  FStar_SMTEncoding_Term.freevars = uu____4190;
                  FStar_SMTEncoding_Term.rng = uu____4191;_}::[])
               ->
               (FStar_Errors.log_issue t.FStar_Syntax_Syntax.pos
                  (FStar_Errors.Warning_QuantifierWithoutPattern,
                    "Not encoding deeply embedded, unguarded quantifier to SMT");
                (tm, decls))
           | uu____4237 ->
               let uu____4238 = encode_formula t env1  in
               (match uu____4238 with
                | (phi,decls') ->
                    let interp =
                      match vars with
                      | [] ->
                          let uu____4258 =
                            let uu____4263 =
                              FStar_SMTEncoding_Term.mk_Valid tm  in
                            (uu____4263, phi)  in
                          FStar_SMTEncoding_Util.mkIff uu____4258
                      | uu____4264 ->
                          let uu____4265 =
                            let uu____4276 =
                              let uu____4277 =
                                let uu____4282 =
                                  FStar_SMTEncoding_Term.mk_Valid tm  in
                                (uu____4282, phi)  in
                              FStar_SMTEncoding_Util.mkIff uu____4277  in
                            ([[valid_tm]], vars, uu____4276)  in
                          FStar_SMTEncoding_Term.mkForall
                            t.FStar_Syntax_Syntax.pos uu____4265
                       in
                    let ax =
                      let uu____4292 =
                        let uu____4300 =
                          let uu____4302 =
                            FStar_Util.digest_of_string tkey_hash  in
                          Prims.op_Hat "l_quant_interp_" uu____4302  in
                        (interp,
                          (FStar_Pervasives_Native.Some
                             "Interpretation of deeply embedded quantifier"),
                          uu____4300)
                         in
                      FStar_SMTEncoding_Util.mkAssume uu____4292  in
                    let uu____4308 =
                      let uu____4309 =
                        let uu____4312 =
                          FStar_SMTEncoding_Term.mk_decls "" tkey_hash 
                            [ax] (FStar_List.append decls decls')
                           in
                        FStar_List.append decls' uu____4312  in
                      FStar_List.append decls uu____4309  in
                    (tm, uu____4308)))

and (encode_term :
  FStar_Syntax_Syntax.typ ->
    FStar_SMTEncoding_Env.env_t ->
      (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun t  ->
    fun env  ->
      let t0 = FStar_Syntax_Subst.compress t  in
      (let uu____4324 =
         FStar_All.pipe_left
           (FStar_TypeChecker_Env.debug env.FStar_SMTEncoding_Env.tcenv)
           (FStar_Options.Other "SMTEncoding")
          in
       if uu____4324
       then
         let uu____4329 = FStar_Syntax_Print.tag_of_term t  in
         let uu____4331 = FStar_Syntax_Print.tag_of_term t0  in
         let uu____4333 = FStar_Syntax_Print.term_to_string t0  in
         FStar_Util.print3 "(%s) (%s)   %s\n" uu____4329 uu____4331
           uu____4333
       else ());
      (match t0.FStar_Syntax_Syntax.n with
       | FStar_Syntax_Syntax.Tm_delayed uu____4342 ->
           let uu____4365 =
             let uu____4367 =
               FStar_All.pipe_left FStar_Range.string_of_range
                 t.FStar_Syntax_Syntax.pos
                in
             let uu____4370 = FStar_Syntax_Print.tag_of_term t0  in
             let uu____4372 = FStar_Syntax_Print.term_to_string t0  in
             let uu____4374 = FStar_Syntax_Print.term_to_string t  in
             FStar_Util.format4 "(%s) Impossible: %s\n%s\n%s\n" uu____4367
               uu____4370 uu____4372 uu____4374
              in
           failwith uu____4365
       | FStar_Syntax_Syntax.Tm_unknown  ->
           let uu____4381 =
             let uu____4383 =
               FStar_All.pipe_left FStar_Range.string_of_range
                 t.FStar_Syntax_Syntax.pos
                in
             let uu____4386 = FStar_Syntax_Print.tag_of_term t0  in
             let uu____4388 = FStar_Syntax_Print.term_to_string t0  in
             let uu____4390 = FStar_Syntax_Print.term_to_string t  in
             FStar_Util.format4 "(%s) Impossible: %s\n%s\n%s\n" uu____4383
               uu____4386 uu____4388 uu____4390
              in
           failwith uu____4381
       | FStar_Syntax_Syntax.Tm_lazy i ->
           let e = FStar_Syntax_Util.unfold_lazy i  in
           ((let uu____4400 =
               FStar_All.pipe_left
                 (FStar_TypeChecker_Env.debug env.FStar_SMTEncoding_Env.tcenv)
                 (FStar_Options.Other "SMTEncoding")
                in
             if uu____4400
             then
               let uu____4405 = FStar_Syntax_Print.term_to_string t0  in
               let uu____4407 = FStar_Syntax_Print.term_to_string e  in
               FStar_Util.print2 ">> Unfolded (%s) ~> (%s)\n" uu____4405
                 uu____4407
             else ());
            encode_term e env)
       | FStar_Syntax_Syntax.Tm_bvar x ->
           let uu____4413 =
             let uu____4415 = FStar_Syntax_Print.bv_to_string x  in
             FStar_Util.format1 "Impossible: locally nameless; got %s"
               uu____4415
              in
           failwith uu____4413
       | FStar_Syntax_Syntax.Tm_ascribed (t1,(k,uu____4424),uu____4425) ->
           let uu____4474 =
             match k with
             | FStar_Util.Inl t2 -> FStar_Syntax_Util.is_unit t2
             | uu____4484 -> false  in
           if uu____4474
           then (FStar_SMTEncoding_Term.mk_Term_unit, [])
           else encode_term t1 env
       | FStar_Syntax_Syntax.Tm_quoted (qt,uu____4502) ->
           let tv =
             let uu____4508 =
               let uu____4515 = FStar_Reflection_Basic.inspect_ln qt  in
               FStar_Syntax_Embeddings.embed
                 FStar_Reflection_Embeddings.e_term_view uu____4515
                in
             uu____4508 t.FStar_Syntax_Syntax.pos
               FStar_Pervasives_Native.None
               FStar_Syntax_Embeddings.id_norm_cb
              in
           ((let uu____4519 =
               FStar_All.pipe_left
                 (FStar_TypeChecker_Env.debug env.FStar_SMTEncoding_Env.tcenv)
                 (FStar_Options.Other "SMTEncoding")
                in
             if uu____4519
             then
               let uu____4524 = FStar_Syntax_Print.term_to_string t0  in
               let uu____4526 = FStar_Syntax_Print.term_to_string tv  in
               FStar_Util.print2 ">> Inspected (%s) ~> (%s)\n" uu____4524
                 uu____4526
             else ());
            (let t1 =
               let uu____4534 =
                 let uu____4545 = FStar_Syntax_Syntax.as_arg tv  in
                 [uu____4545]  in
               FStar_Syntax_Util.mk_app
                 (FStar_Reflection_Data.refl_constant_term
                    FStar_Reflection_Data.fstar_refl_pack_ln) uu____4534
                in
             encode_term t1 env))
       | FStar_Syntax_Syntax.Tm_meta
           (t1,FStar_Syntax_Syntax.Meta_pattern uu____4571) ->
           encode_term t1
             (let uu___612_4589 = env  in
              {
                FStar_SMTEncoding_Env.bvar_bindings =
                  (uu___612_4589.FStar_SMTEncoding_Env.bvar_bindings);
                FStar_SMTEncoding_Env.fvar_bindings =
                  (uu___612_4589.FStar_SMTEncoding_Env.fvar_bindings);
                FStar_SMTEncoding_Env.depth =
                  (uu___612_4589.FStar_SMTEncoding_Env.depth);
                FStar_SMTEncoding_Env.tcenv =
                  (uu___612_4589.FStar_SMTEncoding_Env.tcenv);
                FStar_SMTEncoding_Env.warn =
                  (uu___612_4589.FStar_SMTEncoding_Env.warn);
                FStar_SMTEncoding_Env.nolabels =
                  (uu___612_4589.FStar_SMTEncoding_Env.nolabels);
                FStar_SMTEncoding_Env.use_zfuel_name =
                  (uu___612_4589.FStar_SMTEncoding_Env.use_zfuel_name);
                FStar_SMTEncoding_Env.encode_non_total_function_typ =
                  (uu___612_4589.FStar_SMTEncoding_Env.encode_non_total_function_typ);
                FStar_SMTEncoding_Env.current_module_name =
                  (uu___612_4589.FStar_SMTEncoding_Env.current_module_name);
                FStar_SMTEncoding_Env.encoding_quantifier = false;
                FStar_SMTEncoding_Env.global_cache =
                  (uu___612_4589.FStar_SMTEncoding_Env.global_cache)
              })
       | FStar_Syntax_Syntax.Tm_meta (t1,uu____4592) -> encode_term t1 env
       | FStar_Syntax_Syntax.Tm_name x ->
           let t1 = FStar_SMTEncoding_Env.lookup_term_var env x  in (t1, [])
       | FStar_Syntax_Syntax.Tm_fvar v1 ->
           let uu____4600 = head_redex env t  in
           if uu____4600
           then let uu____4607 = whnf env t  in encode_term uu____4607 env
           else
             (let fvb =
                FStar_SMTEncoding_Env.lookup_free_var_name env
                  v1.FStar_Syntax_Syntax.fv_name
                 in
              let tok =
                FStar_SMTEncoding_Env.lookup_free_var env
                  v1.FStar_Syntax_Syntax.fv_name
                 in
              let tkey_hash = FStar_SMTEncoding_Term.hash_of_term tok  in
              let uu____4614 =
                if
                  fvb.FStar_SMTEncoding_Env.smt_arity > (Prims.parse_int "0")
                then
                  match tok.FStar_SMTEncoding_Term.tm with
                  | FStar_SMTEncoding_Term.FreeV uu____4638 ->
                      let sym_name =
                        let uu____4649 =
                          FStar_Util.digest_of_string tkey_hash  in
                        Prims.op_Hat "@kick_partial_app_" uu____4649  in
                      let uu____4652 =
                        let uu____4655 =
                          let uu____4656 =
                            let uu____4664 =
                              FStar_SMTEncoding_Term.kick_partial_app tok  in
                            (uu____4664,
                              (FStar_Pervasives_Native.Some
                                 "kick_partial_app"), sym_name)
                             in
                          FStar_SMTEncoding_Util.mkAssume uu____4656  in
                        [uu____4655]  in
                      (uu____4652, sym_name)
                  | FStar_SMTEncoding_Term.App (uu____4671,[]) ->
                      let sym_name =
                        let uu____4676 =
                          FStar_Util.digest_of_string tkey_hash  in
                        Prims.op_Hat "@kick_partial_app_" uu____4676  in
                      let uu____4679 =
                        let uu____4682 =
                          let uu____4683 =
                            let uu____4691 =
                              FStar_SMTEncoding_Term.kick_partial_app tok  in
                            (uu____4691,
                              (FStar_Pervasives_Native.Some
                                 "kick_partial_app"), sym_name)
                             in
                          FStar_SMTEncoding_Util.mkAssume uu____4683  in
                        [uu____4682]  in
                      (uu____4679, sym_name)
                  | uu____4698 -> ([], "")
                else ([], "")  in
              match uu____4614 with
              | (aux_decls,sym_name) ->
                  let uu____4721 =
                    if aux_decls = []
                    then
                      FStar_All.pipe_right []
                        FStar_SMTEncoding_Term.mk_decls_trivial
                    else
                      FStar_SMTEncoding_Term.mk_decls sym_name tkey_hash
                        aux_decls []
                     in
                  (tok, uu____4721))
       | FStar_Syntax_Syntax.Tm_type uu____4729 ->
           (FStar_SMTEncoding_Term.mk_Term_type, [])
       | FStar_Syntax_Syntax.Tm_uinst (t1,uu____4731) -> encode_term t1 env
       | FStar_Syntax_Syntax.Tm_constant c -> encode_const c env
       | FStar_Syntax_Syntax.Tm_arrow (binders,c) ->
           let module_name = env.FStar_SMTEncoding_Env.current_module_name
              in
           let uu____4761 = FStar_Syntax_Subst.open_comp binders c  in
           (match uu____4761 with
            | (binders1,res) ->
                let uu____4772 =
                  (env.FStar_SMTEncoding_Env.encode_non_total_function_typ &&
                     (FStar_Syntax_Util.is_pure_or_ghost_comp res))
                    || (FStar_Syntax_Util.is_tot_or_gtot_comp res)
                   in
                if uu____4772
                then
                  let uu____4779 =
                    encode_binders FStar_Pervasives_Native.None binders1 env
                     in
                  (match uu____4779 with
                   | (vars,guards,env',decls,uu____4804) ->
                       let fsym =
                         let uu____4818 =
                           let uu____4824 =
                             FStar_SMTEncoding_Env.varops.FStar_SMTEncoding_Env.fresh
                               module_name "f"
                              in
                           (uu____4824, FStar_SMTEncoding_Term.Term_sort)  in
                         FStar_SMTEncoding_Term.mk_fv uu____4818  in
                       let f = FStar_SMTEncoding_Util.mkFreeV fsym  in
                       let app = mk_Apply f vars  in
                       let uu____4830 =
                         FStar_TypeChecker_Util.pure_or_ghost_pre_and_post
                           (let uu___666_4839 =
                              env.FStar_SMTEncoding_Env.tcenv  in
                            {
                              FStar_TypeChecker_Env.solver =
                                (uu___666_4839.FStar_TypeChecker_Env.solver);
                              FStar_TypeChecker_Env.range =
                                (uu___666_4839.FStar_TypeChecker_Env.range);
                              FStar_TypeChecker_Env.curmodule =
                                (uu___666_4839.FStar_TypeChecker_Env.curmodule);
                              FStar_TypeChecker_Env.gamma =
                                (uu___666_4839.FStar_TypeChecker_Env.gamma);
                              FStar_TypeChecker_Env.gamma_sig =
                                (uu___666_4839.FStar_TypeChecker_Env.gamma_sig);
                              FStar_TypeChecker_Env.gamma_cache =
                                (uu___666_4839.FStar_TypeChecker_Env.gamma_cache);
                              FStar_TypeChecker_Env.modules =
                                (uu___666_4839.FStar_TypeChecker_Env.modules);
                              FStar_TypeChecker_Env.expected_typ =
                                (uu___666_4839.FStar_TypeChecker_Env.expected_typ);
                              FStar_TypeChecker_Env.sigtab =
                                (uu___666_4839.FStar_TypeChecker_Env.sigtab);
                              FStar_TypeChecker_Env.attrtab =
                                (uu___666_4839.FStar_TypeChecker_Env.attrtab);
                              FStar_TypeChecker_Env.is_pattern =
                                (uu___666_4839.FStar_TypeChecker_Env.is_pattern);
                              FStar_TypeChecker_Env.instantiate_imp =
                                (uu___666_4839.FStar_TypeChecker_Env.instantiate_imp);
                              FStar_TypeChecker_Env.effects =
                                (uu___666_4839.FStar_TypeChecker_Env.effects);
                              FStar_TypeChecker_Env.generalize =
                                (uu___666_4839.FStar_TypeChecker_Env.generalize);
                              FStar_TypeChecker_Env.letrecs =
                                (uu___666_4839.FStar_TypeChecker_Env.letrecs);
                              FStar_TypeChecker_Env.top_level =
                                (uu___666_4839.FStar_TypeChecker_Env.top_level);
                              FStar_TypeChecker_Env.check_uvars =
                                (uu___666_4839.FStar_TypeChecker_Env.check_uvars);
                              FStar_TypeChecker_Env.use_eq =
                                (uu___666_4839.FStar_TypeChecker_Env.use_eq);
                              FStar_TypeChecker_Env.is_iface =
                                (uu___666_4839.FStar_TypeChecker_Env.is_iface);
                              FStar_TypeChecker_Env.admit =
                                (uu___666_4839.FStar_TypeChecker_Env.admit);
                              FStar_TypeChecker_Env.lax = true;
                              FStar_TypeChecker_Env.lax_universes =
                                (uu___666_4839.FStar_TypeChecker_Env.lax_universes);
                              FStar_TypeChecker_Env.phase1 =
                                (uu___666_4839.FStar_TypeChecker_Env.phase1);
                              FStar_TypeChecker_Env.failhard =
                                (uu___666_4839.FStar_TypeChecker_Env.failhard);
                              FStar_TypeChecker_Env.nosynth =
                                (uu___666_4839.FStar_TypeChecker_Env.nosynth);
                              FStar_TypeChecker_Env.uvar_subtyping =
                                (uu___666_4839.FStar_TypeChecker_Env.uvar_subtyping);
                              FStar_TypeChecker_Env.tc_term =
                                (uu___666_4839.FStar_TypeChecker_Env.tc_term);
                              FStar_TypeChecker_Env.type_of =
                                (uu___666_4839.FStar_TypeChecker_Env.type_of);
                              FStar_TypeChecker_Env.universe_of =
                                (uu___666_4839.FStar_TypeChecker_Env.universe_of);
                              FStar_TypeChecker_Env.check_type_of =
                                (uu___666_4839.FStar_TypeChecker_Env.check_type_of);
                              FStar_TypeChecker_Env.use_bv_sorts =
                                (uu___666_4839.FStar_TypeChecker_Env.use_bv_sorts);
                              FStar_TypeChecker_Env.qtbl_name_and_index =
                                (uu___666_4839.FStar_TypeChecker_Env.qtbl_name_and_index);
                              FStar_TypeChecker_Env.normalized_eff_names =
                                (uu___666_4839.FStar_TypeChecker_Env.normalized_eff_names);
                              FStar_TypeChecker_Env.fv_delta_depths =
                                (uu___666_4839.FStar_TypeChecker_Env.fv_delta_depths);
                              FStar_TypeChecker_Env.proof_ns =
                                (uu___666_4839.FStar_TypeChecker_Env.proof_ns);
                              FStar_TypeChecker_Env.synth_hook =
                                (uu___666_4839.FStar_TypeChecker_Env.synth_hook);
                              FStar_TypeChecker_Env.splice =
                                (uu___666_4839.FStar_TypeChecker_Env.splice);
                              FStar_TypeChecker_Env.postprocess =
                                (uu___666_4839.FStar_TypeChecker_Env.postprocess);
                              FStar_TypeChecker_Env.is_native_tactic =
                                (uu___666_4839.FStar_TypeChecker_Env.is_native_tactic);
                              FStar_TypeChecker_Env.identifier_info =
                                (uu___666_4839.FStar_TypeChecker_Env.identifier_info);
                              FStar_TypeChecker_Env.tc_hooks =
                                (uu___666_4839.FStar_TypeChecker_Env.tc_hooks);
                              FStar_TypeChecker_Env.dsenv =
                                (uu___666_4839.FStar_TypeChecker_Env.dsenv);
                              FStar_TypeChecker_Env.nbe =
                                (uu___666_4839.FStar_TypeChecker_Env.nbe)
                            }) res
                          in
                       (match uu____4830 with
                        | (pre_opt,res_t) ->
                            let uu____4851 =
                              encode_term_pred FStar_Pervasives_Native.None
                                res_t env' app
                               in
                            (match uu____4851 with
                             | (res_pred,decls') ->
                                 let uu____4862 =
                                   match pre_opt with
                                   | FStar_Pervasives_Native.None  ->
                                       let uu____4875 =
                                         FStar_SMTEncoding_Util.mk_and_l
                                           guards
                                          in
                                       (uu____4875, [])
                                   | FStar_Pervasives_Native.Some pre ->
                                       let uu____4879 =
                                         encode_formula pre env'  in
                                       (match uu____4879 with
                                        | (guard,decls0) ->
                                            let uu____4892 =
                                              FStar_SMTEncoding_Util.mk_and_l
                                                (guard :: guards)
                                               in
                                            (uu____4892, decls0))
                                    in
                                 (match uu____4862 with
                                  | (guards1,guard_decls) ->
                                      let t_interp =
                                        let uu____4906 =
                                          let uu____4917 =
                                            FStar_SMTEncoding_Util.mkImp
                                              (guards1, res_pred)
                                             in
                                          ([[app]], vars, uu____4917)  in
                                        FStar_SMTEncoding_Term.mkForall
                                          t.FStar_Syntax_Syntax.pos
                                          uu____4906
                                         in
                                      let cvars =
                                        let uu____4937 =
                                          FStar_SMTEncoding_Term.free_variables
                                            t_interp
                                           in
                                        FStar_All.pipe_right uu____4937
                                          (FStar_List.filter
                                             (fun x  ->
                                                let uu____4956 =
                                                  FStar_SMTEncoding_Term.fv_name
                                                    x
                                                   in
                                                let uu____4958 =
                                                  FStar_SMTEncoding_Term.fv_name
                                                    fsym
                                                   in
                                                uu____4956 <> uu____4958))
                                         in
                                      let tkey =
                                        FStar_SMTEncoding_Term.mkForall
                                          t.FStar_Syntax_Syntax.pos
                                          ([], (fsym :: cvars), t_interp)
                                         in
                                      let tkey_hash =
                                        FStar_SMTEncoding_Term.hash_of_term
                                          tkey
                                         in
                                      let tsym =
                                        let uu____4980 =
                                          FStar_Util.digest_of_string
                                            tkey_hash
                                           in
                                        Prims.op_Hat "Tm_arrow_" uu____4980
                                         in
                                      let cvar_sorts =
                                        FStar_List.map
                                          FStar_SMTEncoding_Term.fv_sort
                                          cvars
                                         in
                                      let caption =
                                        let uu____4995 =
                                          FStar_Options.log_queries ()  in
                                        if uu____4995
                                        then
                                          let uu____4998 =
                                            let uu____5000 =
                                              FStar_TypeChecker_Normalize.term_to_string
                                                env.FStar_SMTEncoding_Env.tcenv
                                                t0
                                               in
                                            FStar_Util.replace_char
                                              uu____5000 10 32
                                             in
                                          FStar_Pervasives_Native.Some
                                            uu____4998
                                        else FStar_Pervasives_Native.None  in
                                      let tdecl =
                                        FStar_SMTEncoding_Term.DeclFun
                                          (tsym, cvar_sorts,
                                            FStar_SMTEncoding_Term.Term_sort,
                                            caption)
                                         in
                                      let t1 =
                                        let uu____5013 =
                                          let uu____5021 =
                                            FStar_List.map
                                              FStar_SMTEncoding_Util.mkFreeV
                                              cvars
                                             in
                                          (tsym, uu____5021)  in
                                        FStar_SMTEncoding_Util.mkApp
                                          uu____5013
                                         in
                                      let t_has_kind =
                                        FStar_SMTEncoding_Term.mk_HasType t1
                                          FStar_SMTEncoding_Term.mk_Term_type
                                         in
                                      let k_assumption =
                                        let a_name =
                                          Prims.op_Hat "kinding_" tsym  in
                                        let uu____5040 =
                                          let uu____5048 =
                                            FStar_SMTEncoding_Term.mkForall
                                              t0.FStar_Syntax_Syntax.pos
                                              ([[t_has_kind]], cvars,
                                                t_has_kind)
                                             in
                                          (uu____5048,
                                            (FStar_Pervasives_Native.Some
                                               a_name), a_name)
                                           in
                                        FStar_SMTEncoding_Util.mkAssume
                                          uu____5040
                                         in
                                      let f_has_t =
                                        FStar_SMTEncoding_Term.mk_HasType f
                                          t1
                                         in
                                      let f_has_t_z =
                                        FStar_SMTEncoding_Term.mk_HasTypeZ f
                                          t1
                                         in
                                      let pre_typing =
                                        let a_name =
                                          Prims.op_Hat "pre_typing_" tsym  in
                                        let uu____5065 =
                                          let uu____5073 =
                                            let uu____5074 =
                                              let uu____5085 =
                                                let uu____5086 =
                                                  let uu____5091 =
                                                    let uu____5092 =
                                                      FStar_SMTEncoding_Term.mk_PreType
                                                        f
                                                       in
                                                    FStar_SMTEncoding_Term.mk_tester
                                                      "Tm_arrow" uu____5092
                                                     in
                                                  (f_has_t, uu____5091)  in
                                                FStar_SMTEncoding_Util.mkImp
                                                  uu____5086
                                                 in
                                              ([[f_has_t]], (fsym :: cvars),
                                                uu____5085)
                                               in
                                            let uu____5110 =
                                              mkForall_fuel module_name
                                                t0.FStar_Syntax_Syntax.pos
                                               in
                                            uu____5110 uu____5074  in
                                          (uu____5073,
                                            (FStar_Pervasives_Native.Some
                                               "pre-typing for functions"),
                                            (Prims.op_Hat module_name
                                               (Prims.op_Hat "_" a_name)))
                                           in
                                        FStar_SMTEncoding_Util.mkAssume
                                          uu____5065
                                         in
                                      let t_interp1 =
                                        let a_name =
                                          Prims.op_Hat "interpretation_" tsym
                                           in
                                        let uu____5133 =
                                          let uu____5141 =
                                            let uu____5142 =
                                              let uu____5153 =
                                                FStar_SMTEncoding_Util.mkIff
                                                  (f_has_t_z, t_interp)
                                                 in
                                              ([[f_has_t_z]], (fsym ::
                                                cvars), uu____5153)
                                               in
                                            FStar_SMTEncoding_Term.mkForall
                                              t0.FStar_Syntax_Syntax.pos
                                              uu____5142
                                             in
                                          (uu____5141,
                                            (FStar_Pervasives_Native.Some
                                               a_name),
                                            (Prims.op_Hat module_name
                                               (Prims.op_Hat "_" a_name)))
                                           in
                                        FStar_SMTEncoding_Util.mkAssume
                                          uu____5133
                                         in
                                      let t_decls1 =
                                        [tdecl;
                                        k_assumption;
                                        pre_typing;
                                        t_interp1]  in
                                      let uu____5176 =
                                        let uu____5177 =
                                          let uu____5180 =
                                            let uu____5183 =
                                              FStar_SMTEncoding_Term.mk_decls
                                                tsym tkey_hash t_decls1
                                                (FStar_List.append decls
                                                   (FStar_List.append decls'
                                                      guard_decls))
                                               in
                                            FStar_List.append guard_decls
                                              uu____5183
                                             in
                                          FStar_List.append decls' uu____5180
                                           in
                                        FStar_List.append decls uu____5177
                                         in
                                      (t1, uu____5176)))))
                else
                  (let tsym =
                     FStar_SMTEncoding_Env.varops.FStar_SMTEncoding_Env.fresh
                       module_name "Non_total_Tm_arrow"
                      in
                   let tdecl =
                     FStar_SMTEncoding_Term.DeclFun
                       (tsym, [], FStar_SMTEncoding_Term.Term_sort,
                         FStar_Pervasives_Native.None)
                      in
                   let t1 = FStar_SMTEncoding_Util.mkApp (tsym, [])  in
                   let t_kinding =
                     let a_name =
                       Prims.op_Hat "non_total_function_typing_" tsym  in
                     let uu____5204 =
                       let uu____5212 =
                         FStar_SMTEncoding_Term.mk_HasType t1
                           FStar_SMTEncoding_Term.mk_Term_type
                          in
                       (uu____5212,
                         (FStar_Pervasives_Native.Some
                            "Typing for non-total arrows"), a_name)
                        in
                     FStar_SMTEncoding_Util.mkAssume uu____5204  in
                   let fsym =
                     FStar_SMTEncoding_Term.mk_fv
                       ("f", FStar_SMTEncoding_Term.Term_sort)
                      in
                   let f = FStar_SMTEncoding_Util.mkFreeV fsym  in
                   let f_has_t = FStar_SMTEncoding_Term.mk_HasType f t1  in
                   let t_interp =
                     let a_name = Prims.op_Hat "pre_typing_" tsym  in
                     let uu____5225 =
                       let uu____5233 =
                         let uu____5234 =
                           let uu____5245 =
                             let uu____5246 =
                               let uu____5251 =
                                 let uu____5252 =
                                   FStar_SMTEncoding_Term.mk_PreType f  in
                                 FStar_SMTEncoding_Term.mk_tester "Tm_arrow"
                                   uu____5252
                                  in
                               (f_has_t, uu____5251)  in
                             FStar_SMTEncoding_Util.mkImp uu____5246  in
                           ([[f_has_t]], [fsym], uu____5245)  in
                         let uu____5278 =
                           mkForall_fuel module_name
                             t0.FStar_Syntax_Syntax.pos
                            in
                         uu____5278 uu____5234  in
                       (uu____5233, (FStar_Pervasives_Native.Some a_name),
                         a_name)
                        in
                     FStar_SMTEncoding_Util.mkAssume uu____5225  in
                   let uu____5295 =
                     FStar_All.pipe_right [tdecl; t_kinding; t_interp]
                       FStar_SMTEncoding_Term.mk_decls_trivial
                      in
                   (t1, uu____5295)))
       | FStar_Syntax_Syntax.Tm_refine uu____5298 ->
           let uu____5305 =
             let uu____5310 =
               FStar_TypeChecker_Normalize.normalize_refinement
                 [FStar_TypeChecker_Env.Weak;
                 FStar_TypeChecker_Env.HNF;
                 FStar_TypeChecker_Env.EraseUniverses]
                 env.FStar_SMTEncoding_Env.tcenv t0
                in
             match uu____5310 with
             | { FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_refine (x,f);
                 FStar_Syntax_Syntax.pos = uu____5317;
                 FStar_Syntax_Syntax.vars = uu____5318;_} ->
                 let uu____5325 =
                   FStar_Syntax_Subst.open_term
                     [(x, FStar_Pervasives_Native.None)] f
                    in
                 (match uu____5325 with
                  | (b,f1) ->
                      let uu____5350 =
                        let uu____5351 = FStar_List.hd b  in
                        FStar_Pervasives_Native.fst uu____5351  in
                      (uu____5350, f1))
             | uu____5366 -> failwith "impossible"  in
           (match uu____5305 with
            | (x,f) ->
                let uu____5378 = encode_term x.FStar_Syntax_Syntax.sort env
                   in
                (match uu____5378 with
                 | (base_t,decls) ->
                     let uu____5389 =
                       FStar_SMTEncoding_Env.gen_term_var env x  in
                     (match uu____5389 with
                      | (x1,xtm,env') ->
                          let uu____5406 = encode_formula f env'  in
                          (match uu____5406 with
                           | (refinement,decls') ->
                               let uu____5417 =
                                 FStar_SMTEncoding_Env.fresh_fvar
                                   env.FStar_SMTEncoding_Env.current_module_name
                                   "f" FStar_SMTEncoding_Term.Fuel_sort
                                  in
                               (match uu____5417 with
                                | (fsym,fterm) ->
                                    let tm_has_type_with_fuel =
                                      FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                        (FStar_Pervasives_Native.Some fterm)
                                        xtm base_t
                                       in
                                    let encoding =
                                      FStar_SMTEncoding_Util.mkAnd
                                        (tm_has_type_with_fuel, refinement)
                                       in
                                    let cvars =
                                      let uu____5445 =
                                        let uu____5456 =
                                          FStar_SMTEncoding_Term.free_variables
                                            refinement
                                           in
                                        let uu____5467 =
                                          FStar_SMTEncoding_Term.free_variables
                                            tm_has_type_with_fuel
                                           in
                                        FStar_List.append uu____5456
                                          uu____5467
                                         in
                                      FStar_Util.remove_dups
                                        FStar_SMTEncoding_Term.fv_eq
                                        uu____5445
                                       in
                                    let cvars1 =
                                      FStar_All.pipe_right cvars
                                        (FStar_List.filter
                                           (fun y  ->
                                              (let uu____5521 =
                                                 FStar_SMTEncoding_Term.fv_name
                                                   y
                                                  in
                                               uu____5521 <> x1) &&
                                                (let uu____5525 =
                                                   FStar_SMTEncoding_Term.fv_name
                                                     y
                                                    in
                                                 uu____5525 <> fsym)))
                                       in
                                    let xfv =
                                      FStar_SMTEncoding_Term.mk_fv
                                        (x1,
                                          FStar_SMTEncoding_Term.Term_sort)
                                       in
                                    let ffv =
                                      FStar_SMTEncoding_Term.mk_fv
                                        (fsym,
                                          FStar_SMTEncoding_Term.Fuel_sort)
                                       in
                                    let tkey =
                                      FStar_SMTEncoding_Term.mkForall
                                        t0.FStar_Syntax_Syntax.pos
                                        ([], (ffv :: xfv :: cvars1),
                                          encoding)
                                       in
                                    let tkey_hash =
                                      FStar_SMTEncoding_Term.hash_of_term
                                        tkey
                                       in
                                    let module_name =
                                      env.FStar_SMTEncoding_Env.current_module_name
                                       in
                                    let tsym =
                                      let uu____5561 =
                                        FStar_Util.digest_of_string tkey_hash
                                         in
                                      Prims.op_Hat "Tm_refine_" uu____5561
                                       in
                                    let cvar_sorts =
                                      FStar_List.map
                                        FStar_SMTEncoding_Term.fv_sort cvars1
                                       in
                                    let tdecl =
                                      FStar_SMTEncoding_Term.DeclFun
                                        (tsym, cvar_sorts,
                                          FStar_SMTEncoding_Term.Term_sort,
                                          FStar_Pervasives_Native.None)
                                       in
                                    let t1 =
                                      let uu____5581 =
                                        let uu____5589 =
                                          FStar_List.map
                                            FStar_SMTEncoding_Util.mkFreeV
                                            cvars1
                                           in
                                        (tsym, uu____5589)  in
                                      FStar_SMTEncoding_Util.mkApp uu____5581
                                       in
                                    let x_has_base_t =
                                      FStar_SMTEncoding_Term.mk_HasType xtm
                                        base_t
                                       in
                                    let x_has_t =
                                      FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                        (FStar_Pervasives_Native.Some fterm)
                                        xtm t1
                                       in
                                    let t_has_kind =
                                      FStar_SMTEncoding_Term.mk_HasType t1
                                        FStar_SMTEncoding_Term.mk_Term_type
                                       in
                                    let t_haseq_base =
                                      FStar_SMTEncoding_Term.mk_haseq base_t
                                       in
                                    let t_haseq_ref =
                                      FStar_SMTEncoding_Term.mk_haseq t1  in
                                    let t_haseq1 =
                                      let uu____5609 =
                                        let uu____5617 =
                                          let uu____5618 =
                                            let uu____5629 =
                                              FStar_SMTEncoding_Util.mkIff
                                                (t_haseq_ref, t_haseq_base)
                                               in
                                            ([[t_haseq_ref]], cvars1,
                                              uu____5629)
                                             in
                                          FStar_SMTEncoding_Term.mkForall
                                            t0.FStar_Syntax_Syntax.pos
                                            uu____5618
                                           in
                                        (uu____5617,
                                          (FStar_Pervasives_Native.Some
                                             (Prims.op_Hat "haseq for " tsym)),
                                          (Prims.op_Hat "haseq" tsym))
                                         in
                                      FStar_SMTEncoding_Util.mkAssume
                                        uu____5609
                                       in
                                    let t_kinding =
                                      let uu____5643 =
                                        let uu____5651 =
                                          FStar_SMTEncoding_Term.mkForall
                                            t0.FStar_Syntax_Syntax.pos
                                            ([[t_has_kind]], cvars1,
                                              t_has_kind)
                                           in
                                        (uu____5651,
                                          (FStar_Pervasives_Native.Some
                                             "refinement kinding"),
                                          (Prims.op_Hat "refinement_kinding_"
                                             tsym))
                                         in
                                      FStar_SMTEncoding_Util.mkAssume
                                        uu____5643
                                       in
                                    let t_interp =
                                      let uu____5665 =
                                        let uu____5673 =
                                          let uu____5674 =
                                            let uu____5685 =
                                              FStar_SMTEncoding_Util.mkIff
                                                (x_has_t, encoding)
                                               in
                                            ([[x_has_t]], (ffv :: xfv ::
                                              cvars1), uu____5685)
                                             in
                                          FStar_SMTEncoding_Term.mkForall
                                            t0.FStar_Syntax_Syntax.pos
                                            uu____5674
                                           in
                                        (uu____5673,
                                          (FStar_Pervasives_Native.Some
                                             "refinement_interpretation"),
                                          (Prims.op_Hat
                                             "refinement_interpretation_"
                                             tsym))
                                         in
                                      FStar_SMTEncoding_Util.mkAssume
                                        uu____5665
                                       in
                                    let t_decls1 =
                                      [tdecl; t_kinding; t_interp; t_haseq1]
                                       in
                                    let uu____5717 =
                                      let uu____5718 =
                                        let uu____5721 =
                                          FStar_SMTEncoding_Term.mk_decls
                                            tsym tkey_hash t_decls1
                                            (FStar_List.append decls decls')
                                           in
                                        FStar_List.append decls' uu____5721
                                         in
                                      FStar_List.append decls uu____5718  in
                                    (t1, uu____5717))))))
       | FStar_Syntax_Syntax.Tm_uvar (uv,uu____5725) ->
           let ttm =
             let uu____5743 =
               FStar_Syntax_Unionfind.uvar_id
                 uv.FStar_Syntax_Syntax.ctx_uvar_head
                in
             FStar_SMTEncoding_Util.mk_Term_uvar uu____5743  in
           let uu____5745 =
             encode_term_pred FStar_Pervasives_Native.None
               uv.FStar_Syntax_Syntax.ctx_uvar_typ env ttm
              in
           (match uu____5745 with
            | (t_has_k,decls) ->
                let d =
                  let uu____5757 =
                    let uu____5765 =
                      let uu____5767 =
                        let uu____5769 =
                          let uu____5771 =
                            FStar_Syntax_Unionfind.uvar_id
                              uv.FStar_Syntax_Syntax.ctx_uvar_head
                             in
                          FStar_Util.string_of_int uu____5771  in
                        FStar_Util.format1 "uvar_typing_%s" uu____5769  in
                      FStar_SMTEncoding_Env.varops.FStar_SMTEncoding_Env.mk_unique
                        uu____5767
                       in
                    (t_has_k, (FStar_Pervasives_Native.Some "Uvar typing"),
                      uu____5765)
                     in
                  FStar_SMTEncoding_Util.mkAssume uu____5757  in
                let uu____5777 =
                  let uu____5778 =
                    FStar_All.pipe_right [d]
                      FStar_SMTEncoding_Term.mk_decls_trivial
                     in
                  FStar_List.append decls uu____5778  in
                (ttm, uu____5777))
       | FStar_Syntax_Syntax.Tm_app uu____5785 ->
           let uu____5802 = FStar_Syntax_Util.head_and_args t0  in
           (match uu____5802 with
            | (head1,args_e) ->
                let uu____5849 =
                  let uu____5864 =
                    let uu____5865 = FStar_Syntax_Subst.compress head1  in
                    uu____5865.FStar_Syntax_Syntax.n  in
                  (uu____5864, args_e)  in
                (match uu____5849 with
                 | uu____5882 when head_redex env head1 ->
                     let uu____5897 = whnf env t  in
                     encode_term uu____5897 env
                 | uu____5898 when is_arithmetic_primitive head1 args_e ->
                     encode_arith_term env head1 args_e
                 | uu____5921 when is_BitVector_primitive head1 args_e ->
                     encode_BitVector_term env head1 args_e
                 | (FStar_Syntax_Syntax.Tm_fvar fv,uu____5939) when
                     (Prims.op_Negation
                        env.FStar_SMTEncoding_Env.encoding_quantifier)
                       &&
                       ((FStar_Syntax_Syntax.fv_eq_lid fv
                           FStar_Parser_Const.forall_lid)
                          ||
                          (FStar_Syntax_Syntax.fv_eq_lid fv
                             FStar_Parser_Const.exists_lid))
                     -> encode_deeply_embedded_quantifier t0 env
                 | (FStar_Syntax_Syntax.Tm_uinst
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
                       FStar_Syntax_Syntax.pos = uu____5961;
                       FStar_Syntax_Syntax.vars = uu____5962;_},uu____5963),uu____5964)
                     when
                     (Prims.op_Negation
                        env.FStar_SMTEncoding_Env.encoding_quantifier)
                       &&
                       ((FStar_Syntax_Syntax.fv_eq_lid fv
                           FStar_Parser_Const.forall_lid)
                          ||
                          (FStar_Syntax_Syntax.fv_eq_lid fv
                             FStar_Parser_Const.exists_lid))
                     -> encode_deeply_embedded_quantifier t0 env
                 | (FStar_Syntax_Syntax.Tm_uinst
                    ({
                       FStar_Syntax_Syntax.n = FStar_Syntax_Syntax.Tm_fvar fv;
                       FStar_Syntax_Syntax.pos = uu____5990;
                       FStar_Syntax_Syntax.vars = uu____5991;_},uu____5992),
                    (v0,uu____5994)::(v1,uu____5996)::(v2,uu____5998)::[])
                     when
                     FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.lexcons_lid
                     ->
                     let uu____6069 = encode_term v0 env  in
                     (match uu____6069 with
                      | (v01,decls0) ->
                          let uu____6080 = encode_term v1 env  in
                          (match uu____6080 with
                           | (v11,decls1) ->
                               let uu____6091 = encode_term v2 env  in
                               (match uu____6091 with
                                | (v21,decls2) ->
                                    let uu____6102 =
                                      FStar_SMTEncoding_Util.mk_LexCons v01
                                        v11 v21
                                       in
                                    (uu____6102,
                                      (FStar_List.append decls0
                                         (FStar_List.append decls1 decls2))))))
                 | (FStar_Syntax_Syntax.Tm_fvar
                    fv,(v0,uu____6105)::(v1,uu____6107)::(v2,uu____6109)::[])
                     when
                     FStar_Syntax_Syntax.fv_eq_lid fv
                       FStar_Parser_Const.lexcons_lid
                     ->
                     let uu____6176 = encode_term v0 env  in
                     (match uu____6176 with
                      | (v01,decls0) ->
                          let uu____6187 = encode_term v1 env  in
                          (match uu____6187 with
                           | (v11,decls1) ->
                               let uu____6198 = encode_term v2 env  in
                               (match uu____6198 with
                                | (v21,decls2) ->
                                    let uu____6209 =
                                      FStar_SMTEncoding_Util.mk_LexCons v01
                                        v11 v21
                                       in
                                    (uu____6209,
                                      (FStar_List.append decls0
                                         (FStar_List.append decls1 decls2))))))
                 | (FStar_Syntax_Syntax.Tm_constant
                    (FStar_Const.Const_range_of ),(arg,uu____6211)::[]) ->
                     encode_const
                       (FStar_Const.Const_range (arg.FStar_Syntax_Syntax.pos))
                       env
                 | (FStar_Syntax_Syntax.Tm_constant
                    (FStar_Const.Const_set_range_of
                    ),(arg,uu____6247)::(rng,uu____6249)::[]) ->
                     encode_term arg env
                 | (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_reify
                    ),uu____6300) ->
                     let e0 =
                       let uu____6322 = FStar_List.hd args_e  in
                       FStar_TypeChecker_Util.reify_body_with_arg
                         env.FStar_SMTEncoding_Env.tcenv head1 uu____6322
                        in
                     ((let uu____6332 =
                         FStar_All.pipe_left
                           (FStar_TypeChecker_Env.debug
                              env.FStar_SMTEncoding_Env.tcenv)
                           (FStar_Options.Other "SMTEncodingReify")
                          in
                       if uu____6332
                       then
                         let uu____6337 =
                           FStar_Syntax_Print.term_to_string e0  in
                         FStar_Util.print1 "Result of normalization %s\n"
                           uu____6337
                       else ());
                      (let e =
                         let uu____6345 =
                           let uu____6350 =
                             FStar_TypeChecker_Util.remove_reify e0  in
                           let uu____6351 = FStar_List.tl args_e  in
                           FStar_Syntax_Syntax.mk_Tm_app uu____6350
                             uu____6351
                            in
                         uu____6345 FStar_Pervasives_Native.None
                           t0.FStar_Syntax_Syntax.pos
                          in
                       encode_term e env))
                 | (FStar_Syntax_Syntax.Tm_constant
                    (FStar_Const.Const_reflect
                    uu____6360),(arg,uu____6362)::[]) -> encode_term arg env
                 | uu____6397 ->
                     let uu____6412 = encode_args args_e env  in
                     (match uu____6412 with
                      | (args,decls) ->
                          let encode_partial_app ht_opt =
                            let uu____6473 = encode_term head1 env  in
                            match uu____6473 with
                            | (head2,decls') ->
                                let app_tm = mk_Apply_args head2 args  in
                                (match ht_opt with
                                 | FStar_Pervasives_Native.None  ->
                                     (app_tm,
                                       (FStar_List.append decls decls'))
                                 | FStar_Pervasives_Native.Some (formals,c)
                                     ->
                                     let uu____6545 =
                                       FStar_Util.first_N
                                         (FStar_List.length args_e) formals
                                        in
                                     (match uu____6545 with
                                      | (formals1,rest) ->
                                          let subst1 =
                                            FStar_List.map2
                                              (fun uu____6643  ->
                                                 fun uu____6644  ->
                                                   match (uu____6643,
                                                           uu____6644)
                                                   with
                                                   | ((bv,uu____6674),
                                                      (a,uu____6676)) ->
                                                       FStar_Syntax_Syntax.NT
                                                         (bv, a)) formals1
                                              args_e
                                             in
                                          let ty =
                                            let uu____6706 =
                                              FStar_Syntax_Util.arrow rest c
                                               in
                                            FStar_All.pipe_right uu____6706
                                              (FStar_Syntax_Subst.subst
                                                 subst1)
                                             in
                                          let uu____6707 =
                                            encode_term_pred
                                              FStar_Pervasives_Native.None ty
                                              env app_tm
                                             in
                                          (match uu____6707 with
                                           | (has_type,decls'') ->
                                               let cvars =
                                                 FStar_SMTEncoding_Term.free_variables
                                                   has_type
                                                  in
                                               let tkey_hash =
                                                 FStar_SMTEncoding_Term.hash_of_term
                                                   app_tm
                                                  in
                                               let e_typing =
                                                 let uu____6724 =
                                                   let uu____6732 =
                                                     FStar_SMTEncoding_Term.mkForall
                                                       t0.FStar_Syntax_Syntax.pos
                                                       ([[has_type]], cvars,
                                                         has_type)
                                                      in
                                                   let uu____6741 =
                                                     let uu____6743 =
                                                       let uu____6745 =
                                                         FStar_SMTEncoding_Term.hash_of_term
                                                           app_tm
                                                          in
                                                       FStar_Util.digest_of_string
                                                         uu____6745
                                                        in
                                                     Prims.op_Hat
                                                       "partial_app_typing_"
                                                       uu____6743
                                                      in
                                                   (uu____6732,
                                                     (FStar_Pervasives_Native.Some
                                                        "Partial app typing"),
                                                     uu____6741)
                                                    in
                                                 FStar_SMTEncoding_Util.mkAssume
                                                   uu____6724
                                                  in
                                               let uu____6751 =
                                                 let uu____6754 =
                                                   let uu____6757 =
                                                     let uu____6760 =
                                                       FStar_SMTEncoding_Term.mk_decls
                                                         "" tkey_hash
                                                         [e_typing]
                                                         (FStar_List.append
                                                            decls
                                                            (FStar_List.append
                                                               decls' decls''))
                                                        in
                                                     FStar_List.append
                                                       decls'' uu____6760
                                                      in
                                                   FStar_List.append decls'
                                                     uu____6757
                                                    in
                                                 FStar_List.append decls
                                                   uu____6754
                                                  in
                                               (app_tm, uu____6751))))
                             in
                          let encode_full_app fv =
                            let uu____6780 =
                              FStar_SMTEncoding_Env.lookup_free_var_sym env
                                fv
                               in
                            match uu____6780 with
                            | (fname,fuel_args,arity) ->
                                let tm =
                                  maybe_curry_app t0.FStar_Syntax_Syntax.pos
                                    fname arity
                                    (FStar_List.append fuel_args args)
                                   in
                                (tm, decls)
                             in
                          let head2 = FStar_Syntax_Subst.compress head1  in
                          let head_type =
                            match head2.FStar_Syntax_Syntax.n with
                            | FStar_Syntax_Syntax.Tm_uinst
                                ({
                                   FStar_Syntax_Syntax.n =
                                     FStar_Syntax_Syntax.Tm_name x;
                                   FStar_Syntax_Syntax.pos = uu____6823;
                                   FStar_Syntax_Syntax.vars = uu____6824;_},uu____6825)
                                ->
                                FStar_Pervasives_Native.Some
                                  (x.FStar_Syntax_Syntax.sort)
                            | FStar_Syntax_Syntax.Tm_name x ->
                                FStar_Pervasives_Native.Some
                                  (x.FStar_Syntax_Syntax.sort)
                            | FStar_Syntax_Syntax.Tm_uinst
                                ({
                                   FStar_Syntax_Syntax.n =
                                     FStar_Syntax_Syntax.Tm_fvar fv;
                                   FStar_Syntax_Syntax.pos = uu____6832;
                                   FStar_Syntax_Syntax.vars = uu____6833;_},uu____6834)
                                ->
                                let uu____6839 =
                                  let uu____6840 =
                                    let uu____6845 =
                                      FStar_TypeChecker_Env.lookup_lid
                                        env.FStar_SMTEncoding_Env.tcenv
                                        (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                       in
                                    FStar_All.pipe_right uu____6845
                                      FStar_Pervasives_Native.fst
                                     in
                                  FStar_All.pipe_right uu____6840
                                    FStar_Pervasives_Native.snd
                                   in
                                FStar_Pervasives_Native.Some uu____6839
                            | FStar_Syntax_Syntax.Tm_fvar fv ->
                                let uu____6875 =
                                  let uu____6876 =
                                    let uu____6881 =
                                      FStar_TypeChecker_Env.lookup_lid
                                        env.FStar_SMTEncoding_Env.tcenv
                                        (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                       in
                                    FStar_All.pipe_right uu____6881
                                      FStar_Pervasives_Native.fst
                                     in
                                  FStar_All.pipe_right uu____6876
                                    FStar_Pervasives_Native.snd
                                   in
                                FStar_Pervasives_Native.Some uu____6875
                            | FStar_Syntax_Syntax.Tm_ascribed
                                (uu____6910,(FStar_Util.Inl t1,uu____6912),uu____6913)
                                -> FStar_Pervasives_Native.Some t1
                            | FStar_Syntax_Syntax.Tm_ascribed
                                (uu____6960,(FStar_Util.Inr c,uu____6962),uu____6963)
                                ->
                                FStar_Pervasives_Native.Some
                                  (FStar_Syntax_Util.comp_result c)
                            | uu____7010 -> FStar_Pervasives_Native.None  in
                          (match head_type with
                           | FStar_Pervasives_Native.None  ->
                               encode_partial_app
                                 FStar_Pervasives_Native.None
                           | FStar_Pervasives_Native.Some head_type1 ->
                               let head_type2 =
                                 let uu____7031 =
                                   FStar_TypeChecker_Normalize.normalize_refinement
                                     [FStar_TypeChecker_Env.Weak;
                                     FStar_TypeChecker_Env.HNF;
                                     FStar_TypeChecker_Env.EraseUniverses]
                                     env.FStar_SMTEncoding_Env.tcenv
                                     head_type1
                                    in
                                 FStar_All.pipe_left
                                   FStar_Syntax_Util.unrefine uu____7031
                                  in
                               let uu____7032 =
                                 curried_arrow_formals_comp head_type2  in
                               (match uu____7032 with
                                | (formals,c) ->
                                    (match head2.FStar_Syntax_Syntax.n with
                                     | FStar_Syntax_Syntax.Tm_uinst
                                         ({
                                            FStar_Syntax_Syntax.n =
                                              FStar_Syntax_Syntax.Tm_fvar fv;
                                            FStar_Syntax_Syntax.pos =
                                              uu____7048;
                                            FStar_Syntax_Syntax.vars =
                                              uu____7049;_},uu____7050)
                                         when
                                         (FStar_List.length formals) =
                                           (FStar_List.length args)
                                         ->
                                         encode_full_app
                                           fv.FStar_Syntax_Syntax.fv_name
                                     | FStar_Syntax_Syntax.Tm_fvar fv when
                                         (FStar_List.length formals) =
                                           (FStar_List.length args)
                                         ->
                                         encode_full_app
                                           fv.FStar_Syntax_Syntax.fv_name
                                     | uu____7068 ->
                                         if
                                           (FStar_List.length formals) >
                                             (FStar_List.length args)
                                         then
                                           encode_partial_app
                                             (FStar_Pervasives_Native.Some
                                                (formals, c))
                                         else
                                           encode_partial_app
                                             FStar_Pervasives_Native.None))))))
       | FStar_Syntax_Syntax.Tm_abs (bs,body,lopt) ->
           let uu____7147 = FStar_Syntax_Subst.open_term' bs body  in
           (match uu____7147 with
            | (bs1,body1,opening) ->
                let fallback uu____7170 =
                  let f =
                    FStar_SMTEncoding_Env.varops.FStar_SMTEncoding_Env.fresh
                      env.FStar_SMTEncoding_Env.current_module_name "Tm_abs"
                     in
                  let decl =
                    FStar_SMTEncoding_Term.DeclFun
                      (f, [], FStar_SMTEncoding_Term.Term_sort,
                        (FStar_Pervasives_Native.Some
                           "Imprecise function encoding"))
                     in
                  let uu____7180 =
                    let uu____7181 =
                      FStar_SMTEncoding_Term.mk_fv
                        (f, FStar_SMTEncoding_Term.Term_sort)
                       in
                    FStar_All.pipe_left FStar_SMTEncoding_Util.mkFreeV
                      uu____7181
                     in
                  let uu____7183 =
                    FStar_All.pipe_right [decl]
                      FStar_SMTEncoding_Term.mk_decls_trivial
                     in
                  (uu____7180, uu____7183)  in
                let is_impure rc =
                  let uu____7193 =
                    FStar_TypeChecker_Util.is_pure_or_ghost_effect
                      env.FStar_SMTEncoding_Env.tcenv
                      rc.FStar_Syntax_Syntax.residual_effect
                     in
                  FStar_All.pipe_right uu____7193 Prims.op_Negation  in
                let codomain_eff rc =
                  let res_typ =
                    match rc.FStar_Syntax_Syntax.residual_typ with
                    | FStar_Pervasives_Native.None  ->
                        let uu____7208 =
                          let uu____7221 =
                            FStar_TypeChecker_Env.get_range
                              env.FStar_SMTEncoding_Env.tcenv
                             in
                          FStar_TypeChecker_Util.new_implicit_var
                            "SMTEncoding codomain" uu____7221
                            env.FStar_SMTEncoding_Env.tcenv
                            FStar_Syntax_Util.ktype0
                           in
                        (match uu____7208 with
                         | (t1,uu____7224,uu____7225) -> t1)
                    | FStar_Pervasives_Native.Some t1 -> t1  in
                  let uu____7243 =
                    FStar_Ident.lid_equals
                      rc.FStar_Syntax_Syntax.residual_effect
                      FStar_Parser_Const.effect_Tot_lid
                     in
                  if uu____7243
                  then
                    let uu____7248 = FStar_Syntax_Syntax.mk_Total res_typ  in
                    FStar_Pervasives_Native.Some uu____7248
                  else
                    (let uu____7251 =
                       FStar_Ident.lid_equals
                         rc.FStar_Syntax_Syntax.residual_effect
                         FStar_Parser_Const.effect_GTot_lid
                        in
                     if uu____7251
                     then
                       let uu____7256 = FStar_Syntax_Syntax.mk_GTotal res_typ
                          in
                       FStar_Pervasives_Native.Some uu____7256
                     else FStar_Pervasives_Native.None)
                   in
                (match lopt with
                 | FStar_Pervasives_Native.None  ->
                     ((let uu____7264 =
                         let uu____7270 =
                           let uu____7272 =
                             FStar_Syntax_Print.term_to_string t0  in
                           FStar_Util.format1
                             "Losing precision when encoding a function literal: %s\n(Unnannotated abstraction in the compiler ?)"
                             uu____7272
                            in
                         (FStar_Errors.Warning_FunctionLiteralPrecisionLoss,
                           uu____7270)
                          in
                       FStar_Errors.log_issue t0.FStar_Syntax_Syntax.pos
                         uu____7264);
                      fallback ())
                 | FStar_Pervasives_Native.Some rc ->
                     let uu____7277 =
                       (is_impure rc) &&
                         (let uu____7280 =
                            FStar_TypeChecker_Env.is_reifiable_rc
                              env.FStar_SMTEncoding_Env.tcenv rc
                             in
                          Prims.op_Negation uu____7280)
                        in
                     if uu____7277
                     then fallback ()
                     else
                       (let uu____7289 =
                          encode_binders FStar_Pervasives_Native.None bs1 env
                           in
                        match uu____7289 with
                        | (vars,guards,envbody,decls,uu____7314) ->
                            let body2 =
                              let uu____7328 =
                                FStar_TypeChecker_Env.is_reifiable_rc
                                  env.FStar_SMTEncoding_Env.tcenv rc
                                 in
                              if uu____7328
                              then
                                FStar_TypeChecker_Util.reify_body
                                  env.FStar_SMTEncoding_Env.tcenv body1
                              else body1  in
                            let uu____7333 = encode_term body2 envbody  in
                            (match uu____7333 with
                             | (body3,decls') ->
                                 let uu____7344 =
                                   let uu____7353 = codomain_eff rc  in
                                   match uu____7353 with
                                   | FStar_Pervasives_Native.None  ->
                                       (FStar_Pervasives_Native.None, [])
                                   | FStar_Pervasives_Native.Some c ->
                                       let tfun =
                                         FStar_Syntax_Util.arrow bs1 c  in
                                       let uu____7372 = encode_term tfun env
                                          in
                                       (match uu____7372 with
                                        | (t1,decls1) ->
                                            ((FStar_Pervasives_Native.Some t1),
                                              decls1))
                                    in
                                 (match uu____7344 with
                                  | (arrow_t_opt,decls'') ->
                                      let key_body =
                                        let uu____7406 =
                                          let uu____7417 =
                                            let uu____7418 =
                                              let uu____7423 =
                                                FStar_SMTEncoding_Util.mk_and_l
                                                  guards
                                                 in
                                              (uu____7423, body3)  in
                                            FStar_SMTEncoding_Util.mkImp
                                              uu____7418
                                             in
                                          ([], vars, uu____7417)  in
                                        FStar_SMTEncoding_Term.mkForall
                                          t0.FStar_Syntax_Syntax.pos
                                          uu____7406
                                         in
                                      let cvars =
                                        FStar_SMTEncoding_Term.free_variables
                                          key_body
                                         in
                                      let uu____7431 =
                                        match arrow_t_opt with
                                        | FStar_Pervasives_Native.None  ->
                                            (cvars, key_body)
                                        | FStar_Pervasives_Native.Some t1 ->
                                            let uu____7447 =
                                              let uu____7450 =
                                                let uu____7461 =
                                                  FStar_SMTEncoding_Term.free_variables
                                                    t1
                                                   in
                                                FStar_List.append uu____7461
                                                  cvars
                                                 in
                                              FStar_Util.remove_dups
                                                FStar_SMTEncoding_Term.fv_eq
                                                uu____7450
                                               in
                                            let uu____7488 =
                                              FStar_SMTEncoding_Util.mkAnd
                                                (key_body, t1)
                                               in
                                            (uu____7447, uu____7488)
                                         in
                                      (match uu____7431 with
                                       | (cvars1,key_body1) ->
                                           let tkey =
                                             FStar_SMTEncoding_Term.mkForall
                                               t0.FStar_Syntax_Syntax.pos
                                               ([], cvars1, key_body1)
                                              in
                                           let tkey_hash =
                                             FStar_SMTEncoding_Term.hash_of_term
                                               tkey
                                              in
                                           let uu____7510 =
                                             is_an_eta_expansion env vars
                                               body3
                                              in
                                           (match uu____7510 with
                                            | FStar_Pervasives_Native.Some t1
                                                ->
                                                let decls1 =
                                                  FStar_List.append decls
                                                    (FStar_List.append decls'
                                                       decls'')
                                                   in
                                                (t1, decls1)
                                            | FStar_Pervasives_Native.None 
                                                ->
                                                let cvar_sorts =
                                                  FStar_List.map
                                                    FStar_SMTEncoding_Term.fv_sort
                                                    cvars1
                                                   in
                                                let fsym =
                                                  let uu____7526 =
                                                    FStar_Util.digest_of_string
                                                      tkey_hash
                                                     in
                                                  Prims.op_Hat "Tm_abs_"
                                                    uu____7526
                                                   in
                                                let fdecl =
                                                  FStar_SMTEncoding_Term.DeclFun
                                                    (fsym, cvar_sorts,
                                                      FStar_SMTEncoding_Term.Term_sort,
                                                      FStar_Pervasives_Native.None)
                                                   in
                                                let f =
                                                  let uu____7535 =
                                                    let uu____7543 =
                                                      FStar_List.map
                                                        FStar_SMTEncoding_Util.mkFreeV
                                                        cvars1
                                                       in
                                                    (fsym, uu____7543)  in
                                                  FStar_SMTEncoding_Util.mkApp
                                                    uu____7535
                                                   in
                                                let app = mk_Apply f vars  in
                                                let typing_f =
                                                  match arrow_t_opt with
                                                  | FStar_Pervasives_Native.None
                                                       -> []
                                                  | FStar_Pervasives_Native.Some
                                                      t1 ->
                                                      let f_has_t =
                                                        FStar_SMTEncoding_Term.mk_HasTypeWithFuel
                                                          FStar_Pervasives_Native.None
                                                          f t1
                                                         in
                                                      let a_name =
                                                        Prims.op_Hat
                                                          "typing_" fsym
                                                         in
                                                      let uu____7560 =
                                                        let uu____7561 =
                                                          let uu____7569 =
                                                            FStar_SMTEncoding_Term.mkForall
                                                              t0.FStar_Syntax_Syntax.pos
                                                              ([[f]], cvars1,
                                                                f_has_t)
                                                             in
                                                          (uu____7569,
                                                            (FStar_Pervasives_Native.Some
                                                               a_name),
                                                            a_name)
                                                           in
                                                        FStar_SMTEncoding_Util.mkAssume
                                                          uu____7561
                                                         in
                                                      [uu____7560]
                                                   in
                                                let interp_f =
                                                  let a_name =
                                                    Prims.op_Hat
                                                      "interpretation_" fsym
                                                     in
                                                  let uu____7584 =
                                                    let uu____7592 =
                                                      let uu____7593 =
                                                        let uu____7604 =
                                                          FStar_SMTEncoding_Util.mkEq
                                                            (app, body3)
                                                           in
                                                        ([[app]],
                                                          (FStar_List.append
                                                             vars cvars1),
                                                          uu____7604)
                                                         in
                                                      FStar_SMTEncoding_Term.mkForall
                                                        t0.FStar_Syntax_Syntax.pos
                                                        uu____7593
                                                       in
                                                    (uu____7592,
                                                      (FStar_Pervasives_Native.Some
                                                         a_name), a_name)
                                                     in
                                                  FStar_SMTEncoding_Util.mkAssume
                                                    uu____7584
                                                   in
                                                let f_decls =
                                                  FStar_List.append (fdecl ::
                                                    typing_f) [interp_f]
                                                   in
                                                let uu____7618 =
                                                  let uu____7619 =
                                                    let uu____7622 =
                                                      let uu____7625 =
                                                        FStar_SMTEncoding_Term.mk_decls
                                                          fsym tkey_hash
                                                          f_decls
                                                          (FStar_List.append
                                                             decls
                                                             (FStar_List.append
                                                                decls'
                                                                decls''))
                                                         in
                                                      FStar_List.append
                                                        decls'' uu____7625
                                                       in
                                                    FStar_List.append decls'
                                                      uu____7622
                                                     in
                                                  FStar_List.append decls
                                                    uu____7619
                                                   in
                                                (f, uu____7618))))))))
       | FStar_Syntax_Syntax.Tm_let
           ((uu____7628,{
                          FStar_Syntax_Syntax.lbname = FStar_Util.Inr
                            uu____7629;
                          FStar_Syntax_Syntax.lbunivs = uu____7630;
                          FStar_Syntax_Syntax.lbtyp = uu____7631;
                          FStar_Syntax_Syntax.lbeff = uu____7632;
                          FStar_Syntax_Syntax.lbdef = uu____7633;
                          FStar_Syntax_Syntax.lbattrs = uu____7634;
                          FStar_Syntax_Syntax.lbpos = uu____7635;_}::uu____7636),uu____7637)
           -> failwith "Impossible: already handled by encoding of Sig_let"
       | FStar_Syntax_Syntax.Tm_let
           ((false
             ,{ FStar_Syntax_Syntax.lbname = FStar_Util.Inl x;
                FStar_Syntax_Syntax.lbunivs = uu____7671;
                FStar_Syntax_Syntax.lbtyp = t1;
                FStar_Syntax_Syntax.lbeff = uu____7673;
                FStar_Syntax_Syntax.lbdef = e1;
                FStar_Syntax_Syntax.lbattrs = uu____7675;
                FStar_Syntax_Syntax.lbpos = uu____7676;_}::[]),e2)
           -> encode_let x t1 e1 e2 env encode_term
       | FStar_Syntax_Syntax.Tm_let uu____7703 ->
           (FStar_Errors.diag t0.FStar_Syntax_Syntax.pos
              "Non-top-level recursive functions, and their enclosings let bindings (including the top-level let) are not yet fully encoded to the SMT solver; you may not be able to prove some facts";
            FStar_Exn.raise FStar_SMTEncoding_Env.Inner_let_rec)
       | FStar_Syntax_Syntax.Tm_match (e,pats) ->
           encode_match e pats FStar_SMTEncoding_Term.mk_Term_unit env
             encode_term)

and (encode_let :
  FStar_Syntax_Syntax.bv ->
    FStar_Syntax_Syntax.typ ->
      FStar_Syntax_Syntax.term ->
        FStar_Syntax_Syntax.term ->
          FStar_SMTEncoding_Env.env_t ->
            (FStar_Syntax_Syntax.term ->
               FStar_SMTEncoding_Env.env_t ->
                 (FStar_SMTEncoding_Term.term *
                   FStar_SMTEncoding_Term.decls_t))
              ->
              (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun x  ->
    fun t1  ->
      fun e1  ->
        fun e2  ->
          fun env  ->
            fun encode_body  ->
              let uu____7775 =
                let uu____7780 =
                  FStar_Syntax_Util.ascribe e1
                    ((FStar_Util.Inl t1), FStar_Pervasives_Native.None)
                   in
                encode_term uu____7780 env  in
              match uu____7775 with
              | (ee1,decls1) ->
                  let uu____7805 =
                    FStar_Syntax_Subst.open_term
                      [(x, FStar_Pervasives_Native.None)] e2
                     in
                  (match uu____7805 with
                   | (xs,e21) ->
                       let uu____7830 = FStar_List.hd xs  in
                       (match uu____7830 with
                        | (x1,uu____7848) ->
                            let env' =
                              FStar_SMTEncoding_Env.push_term_var env x1 ee1
                               in
                            let uu____7854 = encode_body e21 env'  in
                            (match uu____7854 with
                             | (ee2,decls2) ->
                                 (ee2, (FStar_List.append decls1 decls2)))))

and (encode_match :
  FStar_Syntax_Syntax.term ->
    FStar_Syntax_Syntax.branch Prims.list ->
      FStar_SMTEncoding_Term.term ->
        FStar_SMTEncoding_Env.env_t ->
          (FStar_Syntax_Syntax.term ->
             FStar_SMTEncoding_Env.env_t ->
               (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
            -> (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun e  ->
    fun pats  ->
      fun default_case  ->
        fun env  ->
          fun encode_br  ->
            let uu____7884 =
              let uu____7892 =
                let uu____7893 =
                  FStar_Syntax_Syntax.mk FStar_Syntax_Syntax.Tm_unknown
                    FStar_Pervasives_Native.None FStar_Range.dummyRange
                   in
                FStar_Syntax_Syntax.null_bv uu____7893  in
              FStar_SMTEncoding_Env.gen_term_var env uu____7892  in
            match uu____7884 with
            | (scrsym,scr',env1) ->
                let uu____7903 = encode_term e env1  in
                (match uu____7903 with
                 | (scr,decls) ->
                     let uu____7914 =
                       let encode_branch b uu____7943 =
                         match uu____7943 with
                         | (else_case,decls1) ->
                             let uu____7962 =
                               FStar_Syntax_Subst.open_branch b  in
                             (match uu____7962 with
                              | (p,w,br) ->
                                  let uu____7988 = encode_pat env1 p  in
                                  (match uu____7988 with
                                   | (env0,pattern) ->
                                       let guard = pattern.guard scr'  in
                                       let projections =
                                         pattern.projections scr'  in
                                       let env2 =
                                         FStar_All.pipe_right projections
                                           (FStar_List.fold_left
                                              (fun env2  ->
                                                 fun uu____8025  ->
                                                   match uu____8025 with
                                                   | (x,t) ->
                                                       FStar_SMTEncoding_Env.push_term_var
                                                         env2 x t) env1)
                                          in
                                       let uu____8032 =
                                         match w with
                                         | FStar_Pervasives_Native.None  ->
                                             (guard, [])
                                         | FStar_Pervasives_Native.Some w1 ->
                                             let uu____8054 =
                                               encode_term w1 env2  in
                                             (match uu____8054 with
                                              | (w2,decls2) ->
                                                  let uu____8067 =
                                                    let uu____8068 =
                                                      let uu____8073 =
                                                        let uu____8074 =
                                                          let uu____8079 =
                                                            FStar_SMTEncoding_Term.boxBool
                                                              FStar_SMTEncoding_Util.mkTrue
                                                             in
                                                          (w2, uu____8079)
                                                           in
                                                        FStar_SMTEncoding_Util.mkEq
                                                          uu____8074
                                                         in
                                                      (guard, uu____8073)  in
                                                    FStar_SMTEncoding_Util.mkAnd
                                                      uu____8068
                                                     in
                                                  (uu____8067, decls2))
                                          in
                                       (match uu____8032 with
                                        | (guard1,decls2) ->
                                            let uu____8094 =
                                              encode_br br env2  in
                                            (match uu____8094 with
                                             | (br1,decls3) ->
                                                 let uu____8107 =
                                                   FStar_SMTEncoding_Util.mkITE
                                                     (guard1, br1, else_case)
                                                    in
                                                 (uu____8107,
                                                   (FStar_List.append decls1
                                                      (FStar_List.append
                                                         decls2 decls3)))))))
                          in
                       FStar_List.fold_right encode_branch pats
                         (default_case, decls)
                        in
                     (match uu____7914 with
                      | (match_tm,decls1) ->
                          let uu____8128 =
                            let uu____8129 =
                              let uu____8140 =
                                let uu____8147 =
                                  let uu____8152 =
                                    FStar_SMTEncoding_Term.mk_fv
                                      (scrsym,
                                        FStar_SMTEncoding_Term.Term_sort)
                                     in
                                  (uu____8152, scr)  in
                                [uu____8147]  in
                              (uu____8140, match_tm)  in
                            FStar_SMTEncoding_Term.mkLet' uu____8129
                              FStar_Range.dummyRange
                             in
                          (uu____8128, decls1)))

and (encode_pat :
  FStar_SMTEncoding_Env.env_t ->
    FStar_Syntax_Syntax.pat -> (FStar_SMTEncoding_Env.env_t * pattern))
  =
  fun env  ->
    fun pat  ->
      (let uu____8175 =
         FStar_TypeChecker_Env.debug env.FStar_SMTEncoding_Env.tcenv
           FStar_Options.Medium
          in
       if uu____8175
       then
         let uu____8178 = FStar_Syntax_Print.pat_to_string pat  in
         FStar_Util.print1 "Encoding pattern %s\n" uu____8178
       else ());
      (let uu____8183 = FStar_TypeChecker_Util.decorated_pattern_as_term pat
          in
       match uu____8183 with
       | (vars,pat_term) ->
           let uu____8200 =
             FStar_All.pipe_right vars
               (FStar_List.fold_left
                  (fun uu____8242  ->
                     fun v1  ->
                       match uu____8242 with
                       | (env1,vars1) ->
                           let uu____8278 =
                             FStar_SMTEncoding_Env.gen_term_var env1 v1  in
                           (match uu____8278 with
                            | (xx,uu____8297,env2) ->
                                let uu____8301 =
                                  let uu____8308 =
                                    let uu____8313 =
                                      FStar_SMTEncoding_Term.mk_fv
                                        (xx,
                                          FStar_SMTEncoding_Term.Term_sort)
                                       in
                                    (v1, uu____8313)  in
                                  uu____8308 :: vars1  in
                                (env2, uu____8301))) (env, []))
              in
           (match uu____8200 with
            | (env1,vars1) ->
                let rec mk_guard pat1 scrutinee =
                  match pat1.FStar_Syntax_Syntax.v with
                  | FStar_Syntax_Syntax.Pat_var uu____8368 ->
                      FStar_SMTEncoding_Util.mkTrue
                  | FStar_Syntax_Syntax.Pat_wild uu____8369 ->
                      FStar_SMTEncoding_Util.mkTrue
                  | FStar_Syntax_Syntax.Pat_dot_term uu____8370 ->
                      FStar_SMTEncoding_Util.mkTrue
                  | FStar_Syntax_Syntax.Pat_constant c ->
                      let uu____8378 = encode_const c env1  in
                      (match uu____8378 with
                       | (tm,decls) ->
                           ((match decls with
                             | uu____8386::uu____8387 ->
                                 failwith
                                   "Unexpected encoding of constant pattern"
                             | uu____8391 -> ());
                            FStar_SMTEncoding_Util.mkEq (scrutinee, tm)))
                  | FStar_Syntax_Syntax.Pat_cons (f,args) ->
                      let is_f =
                        let tc_name =
                          FStar_TypeChecker_Env.typ_of_datacon
                            env1.FStar_SMTEncoding_Env.tcenv
                            (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                           in
                        let uu____8414 =
                          FStar_TypeChecker_Env.datacons_of_typ
                            env1.FStar_SMTEncoding_Env.tcenv tc_name
                           in
                        match uu____8414 with
                        | (uu____8422,uu____8423::[]) ->
                            FStar_SMTEncoding_Util.mkTrue
                        | uu____8428 ->
                            FStar_SMTEncoding_Env.mk_data_tester env1
                              (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                              scrutinee
                         in
                      let sub_term_guards =
                        FStar_All.pipe_right args
                          (FStar_List.mapi
                             (fun i  ->
                                fun uu____8464  ->
                                  match uu____8464 with
                                  | (arg,uu____8474) ->
                                      let proj =
                                        FStar_SMTEncoding_Env.primitive_projector_by_pos
                                          env1.FStar_SMTEncoding_Env.tcenv
                                          (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                          i
                                         in
                                      let uu____8483 =
                                        FStar_SMTEncoding_Util.mkApp
                                          (proj, [scrutinee])
                                         in
                                      mk_guard arg uu____8483))
                         in
                      FStar_SMTEncoding_Util.mk_and_l (is_f ::
                        sub_term_guards)
                   in
                let rec mk_projections pat1 scrutinee =
                  match pat1.FStar_Syntax_Syntax.v with
                  | FStar_Syntax_Syntax.Pat_dot_term (x,uu____8515) ->
                      [(x, scrutinee)]
                  | FStar_Syntax_Syntax.Pat_var x -> [(x, scrutinee)]
                  | FStar_Syntax_Syntax.Pat_wild x -> [(x, scrutinee)]
                  | FStar_Syntax_Syntax.Pat_constant uu____8546 -> []
                  | FStar_Syntax_Syntax.Pat_cons (f,args) ->
                      let uu____8571 =
                        FStar_All.pipe_right args
                          (FStar_List.mapi
                             (fun i  ->
                                fun uu____8617  ->
                                  match uu____8617 with
                                  | (arg,uu____8633) ->
                                      let proj =
                                        FStar_SMTEncoding_Env.primitive_projector_by_pos
                                          env1.FStar_SMTEncoding_Env.tcenv
                                          (f.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v
                                          i
                                         in
                                      let uu____8642 =
                                        FStar_SMTEncoding_Util.mkApp
                                          (proj, [scrutinee])
                                         in
                                      mk_projections arg uu____8642))
                         in
                      FStar_All.pipe_right uu____8571 FStar_List.flatten
                   in
                let pat_term1 uu____8673 = encode_term pat_term env1  in
                let pattern =
                  {
                    pat_vars = vars1;
                    pat_term = pat_term1;
                    guard = (mk_guard pat);
                    projections = (mk_projections pat)
                  }  in
                (env1, pattern)))

and (encode_args :
  FStar_Syntax_Syntax.args ->
    FStar_SMTEncoding_Env.env_t ->
      (FStar_SMTEncoding_Term.term Prims.list *
        FStar_SMTEncoding_Term.decls_t))
  =
  fun l  ->
    fun env  ->
      let uu____8683 =
        FStar_All.pipe_right l
          (FStar_List.fold_left
             (fun uu____8731  ->
                fun uu____8732  ->
                  match (uu____8731, uu____8732) with
                  | ((tms,decls),(t,uu____8772)) ->
                      let uu____8799 = encode_term t env  in
                      (match uu____8799 with
                       | (t1,decls') ->
                           ((t1 :: tms), (FStar_List.append decls decls'))))
             ([], []))
         in
      match uu____8683 with | (l1,decls) -> ((FStar_List.rev l1), decls)

and (encode_function_type_as_formula :
  FStar_Syntax_Syntax.typ ->
    FStar_SMTEncoding_Env.env_t ->
      (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun t  ->
    fun env  ->
      let universe_of_binders binders =
        FStar_List.map (fun uu____8877  -> FStar_Syntax_Syntax.U_zero)
          binders
         in
      let quant = FStar_Syntax_Util.smt_lemma_as_forall t universe_of_binders
         in
      let env1 =
        let uu___1241_8886 = env  in
        {
          FStar_SMTEncoding_Env.bvar_bindings =
            (uu___1241_8886.FStar_SMTEncoding_Env.bvar_bindings);
          FStar_SMTEncoding_Env.fvar_bindings =
            (uu___1241_8886.FStar_SMTEncoding_Env.fvar_bindings);
          FStar_SMTEncoding_Env.depth =
            (uu___1241_8886.FStar_SMTEncoding_Env.depth);
          FStar_SMTEncoding_Env.tcenv =
            (uu___1241_8886.FStar_SMTEncoding_Env.tcenv);
          FStar_SMTEncoding_Env.warn =
            (uu___1241_8886.FStar_SMTEncoding_Env.warn);
          FStar_SMTEncoding_Env.nolabels =
            (uu___1241_8886.FStar_SMTEncoding_Env.nolabels);
          FStar_SMTEncoding_Env.use_zfuel_name = true;
          FStar_SMTEncoding_Env.encode_non_total_function_typ =
            (uu___1241_8886.FStar_SMTEncoding_Env.encode_non_total_function_typ);
          FStar_SMTEncoding_Env.current_module_name =
            (uu___1241_8886.FStar_SMTEncoding_Env.current_module_name);
          FStar_SMTEncoding_Env.encoding_quantifier =
            (uu___1241_8886.FStar_SMTEncoding_Env.encoding_quantifier);
          FStar_SMTEncoding_Env.global_cache =
            (uu___1241_8886.FStar_SMTEncoding_Env.global_cache)
        }  in
      encode_formula quant env1

and (encode_smt_patterns :
  FStar_Syntax_Syntax.arg Prims.list Prims.list ->
    FStar_SMTEncoding_Env.env_t ->
      (FStar_SMTEncoding_Term.term Prims.list Prims.list *
        FStar_SMTEncoding_Term.decls_t))
  =
  fun pats_l  ->
    fun env  ->
      let env1 =
        let uu___1246_8903 = env  in
        {
          FStar_SMTEncoding_Env.bvar_bindings =
            (uu___1246_8903.FStar_SMTEncoding_Env.bvar_bindings);
          FStar_SMTEncoding_Env.fvar_bindings =
            (uu___1246_8903.FStar_SMTEncoding_Env.fvar_bindings);
          FStar_SMTEncoding_Env.depth =
            (uu___1246_8903.FStar_SMTEncoding_Env.depth);
          FStar_SMTEncoding_Env.tcenv =
            (uu___1246_8903.FStar_SMTEncoding_Env.tcenv);
          FStar_SMTEncoding_Env.warn =
            (uu___1246_8903.FStar_SMTEncoding_Env.warn);
          FStar_SMTEncoding_Env.nolabels =
            (uu___1246_8903.FStar_SMTEncoding_Env.nolabels);
          FStar_SMTEncoding_Env.use_zfuel_name = true;
          FStar_SMTEncoding_Env.encode_non_total_function_typ =
            (uu___1246_8903.FStar_SMTEncoding_Env.encode_non_total_function_typ);
          FStar_SMTEncoding_Env.current_module_name =
            (uu___1246_8903.FStar_SMTEncoding_Env.current_module_name);
          FStar_SMTEncoding_Env.encoding_quantifier =
            (uu___1246_8903.FStar_SMTEncoding_Env.encoding_quantifier);
          FStar_SMTEncoding_Env.global_cache =
            (uu___1246_8903.FStar_SMTEncoding_Env.global_cache)
        }  in
      let encode_smt_pattern t =
        let uu____8919 = FStar_Syntax_Util.head_and_args t  in
        match uu____8919 with
        | (head1,args) ->
            let head2 = FStar_Syntax_Util.un_uinst head1  in
            (match ((head2.FStar_Syntax_Syntax.n), args) with
             | (FStar_Syntax_Syntax.Tm_fvar
                fv,uu____8982::(x,uu____8984)::(t1,uu____8986)::[]) when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.has_type_lid
                 ->
                 let uu____9053 = encode_term x env1  in
                 (match uu____9053 with
                  | (x1,decls) ->
                      let uu____9064 = encode_term t1 env1  in
                      (match uu____9064 with
                       | (t2,decls') ->
                           let uu____9075 =
                             FStar_SMTEncoding_Term.mk_HasType x1 t2  in
                           (uu____9075, (FStar_List.append decls decls'))))
             | uu____9076 -> encode_term t env1)
         in
      FStar_List.fold_right
        (fun pats  ->
           fun uu____9119  ->
             match uu____9119 with
             | (pats_l1,decls) ->
                 let uu____9164 =
                   FStar_List.fold_right
                     (fun uu____9199  ->
                        fun uu____9200  ->
                          match (uu____9199, uu____9200) with
                          | ((p,uu____9242),(pats1,decls1)) ->
                              let uu____9277 = encode_smt_pattern p  in
                              (match uu____9277 with
                               | (t,d) ->
                                   let uu____9292 =
                                     FStar_SMTEncoding_Term.check_pattern_ok
                                       t
                                      in
                                   (match uu____9292 with
                                    | FStar_Pervasives_Native.None  ->
                                        ((t :: pats1),
                                          (FStar_List.append d decls1))
                                    | FStar_Pervasives_Native.Some
                                        illegal_subterm ->
                                        ((let uu____9309 =
                                            let uu____9315 =
                                              let uu____9317 =
                                                FStar_Syntax_Print.term_to_string
                                                  p
                                                 in
                                              let uu____9319 =
                                                FStar_SMTEncoding_Term.print_smt_term
                                                  illegal_subterm
                                                 in
                                              FStar_Util.format2
                                                "Pattern %s contains illegal sub-term (%s); dropping it"
                                                uu____9317 uu____9319
                                               in
                                            (FStar_Errors.Warning_SMTPatternIllFormed,
                                              uu____9315)
                                             in
                                          FStar_Errors.log_issue
                                            p.FStar_Syntax_Syntax.pos
                                            uu____9309);
                                         (pats1,
                                           (FStar_List.append d decls1))))))
                     pats ([], decls)
                    in
                 (match uu____9164 with
                  | (pats1,decls1) -> ((pats1 :: pats_l1), decls1))) pats_l
        ([], [])

and (encode_formula :
  FStar_Syntax_Syntax.typ ->
    FStar_SMTEncoding_Env.env_t ->
      (FStar_SMTEncoding_Term.term * FStar_SMTEncoding_Term.decls_t))
  =
  fun phi  ->
    fun env  ->
      let debug1 phi1 =
        let uu____9379 =
          FStar_All.pipe_left
            (FStar_TypeChecker_Env.debug env.FStar_SMTEncoding_Env.tcenv)
            (FStar_Options.Other "SMTEncoding")
           in
        if uu____9379
        then
          let uu____9384 = FStar_Syntax_Print.tag_of_term phi1  in
          let uu____9386 = FStar_Syntax_Print.term_to_string phi1  in
          FStar_Util.print2 "Formula (%s)  %s\n" uu____9384 uu____9386
        else ()  in
      let enc f r l =
        let uu____9428 =
          FStar_Util.fold_map
            (fun decls  ->
               fun x  ->
                 let uu____9460 =
                   encode_term (FStar_Pervasives_Native.fst x) env  in
                 match uu____9460 with
                 | (t,decls') -> ((FStar_List.append decls decls'), t)) [] l
           in
        match uu____9428 with
        | (decls,args) ->
            let uu____9491 =
              let uu___1310_9492 = f args  in
              {
                FStar_SMTEncoding_Term.tm =
                  (uu___1310_9492.FStar_SMTEncoding_Term.tm);
                FStar_SMTEncoding_Term.freevars =
                  (uu___1310_9492.FStar_SMTEncoding_Term.freevars);
                FStar_SMTEncoding_Term.rng = r
              }  in
            (uu____9491, decls)
         in
      let const_op f r uu____9527 = let uu____9540 = f r  in (uu____9540, [])
         in
      let un_op f l =
        let uu____9563 = FStar_List.hd l  in FStar_All.pipe_left f uu____9563
         in
      let bin_op f uu___2_9583 =
        match uu___2_9583 with
        | t1::t2::[] -> f (t1, t2)
        | uu____9594 -> failwith "Impossible"  in
      let enc_prop_c f r l =
        let uu____9635 =
          FStar_Util.fold_map
            (fun decls  ->
               fun uu____9660  ->
                 match uu____9660 with
                 | (t,uu____9676) ->
                     let uu____9681 = encode_formula t env  in
                     (match uu____9681 with
                      | (phi1,decls') ->
                          ((FStar_List.append decls decls'), phi1))) [] l
           in
        match uu____9635 with
        | (decls,phis) ->
            let uu____9710 =
              let uu___1340_9711 = f phis  in
              {
                FStar_SMTEncoding_Term.tm =
                  (uu___1340_9711.FStar_SMTEncoding_Term.tm);
                FStar_SMTEncoding_Term.freevars =
                  (uu___1340_9711.FStar_SMTEncoding_Term.freevars);
                FStar_SMTEncoding_Term.rng = r
              }  in
            (uu____9710, decls)
         in
      let eq_op r args =
        let rf =
          FStar_List.filter
            (fun uu____9774  ->
               match uu____9774 with
               | (a,q) ->
                   (match q with
                    | FStar_Pervasives_Native.Some
                        (FStar_Syntax_Syntax.Implicit uu____9795) -> false
                    | uu____9798 -> true)) args
           in
        if (FStar_List.length rf) <> (Prims.parse_int "2")
        then
          let uu____9817 =
            FStar_Util.format1
              "eq_op: got %s non-implicit arguments instead of 2?"
              (Prims.string_of_int (FStar_List.length rf))
             in
          failwith uu____9817
        else
          (let uu____9834 = enc (bin_op FStar_SMTEncoding_Util.mkEq)  in
           uu____9834 r rf)
         in
      let eq3_op r args =
        let n1 = FStar_List.length args  in
        if n1 = (Prims.parse_int "4")
        then
          let uu____9902 =
            enc
              (fun terms  ->
                 match terms with
                 | t0::t1::v0::v1::[] ->
                     let uu____9934 =
                       let uu____9939 = FStar_SMTEncoding_Util.mkEq (t0, t1)
                          in
                       let uu____9940 = FStar_SMTEncoding_Util.mkEq (v0, v1)
                          in
                       (uu____9939, uu____9940)  in
                     FStar_SMTEncoding_Util.mkAnd uu____9934
                 | uu____9941 -> failwith "Impossible")
             in
          uu____9902 r args
        else
          (let uu____9947 =
             FStar_Util.format1
               "eq3_op: got %s non-implicit arguments instead of 4?"
               (Prims.string_of_int n1)
              in
           failwith uu____9947)
         in
      let h_equals_op r args =
        let n1 = FStar_List.length args  in
        if n1 = (Prims.parse_int "4")
        then
          let uu____10009 =
            enc
              (fun terms  ->
                 match terms with
                 | t0::v0::t1::v1::[] ->
                     let uu____10041 =
                       let uu____10046 = FStar_SMTEncoding_Util.mkEq (t0, t1)
                          in
                       let uu____10047 = FStar_SMTEncoding_Util.mkEq (v0, v1)
                          in
                       (uu____10046, uu____10047)  in
                     FStar_SMTEncoding_Util.mkAnd uu____10041
                 | uu____10048 -> failwith "Impossible")
             in
          uu____10009 r args
        else
          (let uu____10054 =
             FStar_Util.format1
               "eq3_op: got %s non-implicit arguments instead of 4?"
               (Prims.string_of_int n1)
              in
           failwith uu____10054)
         in
      let mk_imp1 r uu___3_10083 =
        match uu___3_10083 with
        | (lhs,uu____10089)::(rhs,uu____10091)::[] ->
            let uu____10132 = encode_formula rhs env  in
            (match uu____10132 with
             | (l1,decls1) ->
                 (match l1.FStar_SMTEncoding_Term.tm with
                  | FStar_SMTEncoding_Term.App
                      (FStar_SMTEncoding_Term.TrueOp ,uu____10147) ->
                      (l1, decls1)
                  | uu____10152 ->
                      let uu____10153 = encode_formula lhs env  in
                      (match uu____10153 with
                       | (l2,decls2) ->
                           let uu____10164 =
                             FStar_SMTEncoding_Term.mkImp (l2, l1) r  in
                           (uu____10164, (FStar_List.append decls1 decls2)))))
        | uu____10165 -> failwith "impossible"  in
      let mk_ite r uu___4_10193 =
        match uu___4_10193 with
        | (guard,uu____10199)::(_then,uu____10201)::(_else,uu____10203)::[]
            ->
            let uu____10260 = encode_formula guard env  in
            (match uu____10260 with
             | (g,decls1) ->
                 let uu____10271 = encode_formula _then env  in
                 (match uu____10271 with
                  | (t,decls2) ->
                      let uu____10282 = encode_formula _else env  in
                      (match uu____10282 with
                       | (e,decls3) ->
                           let res = FStar_SMTEncoding_Term.mkITE (g, t, e) r
                              in
                           (res,
                             (FStar_List.append decls1
                                (FStar_List.append decls2 decls3))))))
        | uu____10294 -> failwith "impossible"  in
      let unboxInt_l f l =
        let uu____10324 = FStar_List.map FStar_SMTEncoding_Term.unboxInt l
           in
        f uu____10324  in
      let connectives =
        let uu____10354 =
          let uu____10379 = enc_prop_c (bin_op FStar_SMTEncoding_Util.mkAnd)
             in
          (FStar_Parser_Const.and_lid, uu____10379)  in
        let uu____10422 =
          let uu____10449 =
            let uu____10474 = enc_prop_c (bin_op FStar_SMTEncoding_Util.mkOr)
               in
            (FStar_Parser_Const.or_lid, uu____10474)  in
          let uu____10517 =
            let uu____10544 =
              let uu____10571 =
                let uu____10596 =
                  enc_prop_c (bin_op FStar_SMTEncoding_Util.mkIff)  in
                (FStar_Parser_Const.iff_lid, uu____10596)  in
              let uu____10639 =
                let uu____10666 =
                  let uu____10693 =
                    let uu____10718 =
                      enc_prop_c (un_op FStar_SMTEncoding_Util.mkNot)  in
                    (FStar_Parser_Const.not_lid, uu____10718)  in
                  [uu____10693;
                  (FStar_Parser_Const.eq2_lid, eq_op);
                  (FStar_Parser_Const.c_eq2_lid, eq_op);
                  (FStar_Parser_Const.eq3_lid, eq3_op);
                  (FStar_Parser_Const.c_eq3_lid, h_equals_op);
                  (FStar_Parser_Const.true_lid,
                    (const_op FStar_SMTEncoding_Term.mkTrue));
                  (FStar_Parser_Const.false_lid,
                    (const_op FStar_SMTEncoding_Term.mkFalse))]
                   in
                (FStar_Parser_Const.ite_lid, mk_ite) :: uu____10666  in
              uu____10571 :: uu____10639  in
            (FStar_Parser_Const.imp_lid, mk_imp1) :: uu____10544  in
          uu____10449 :: uu____10517  in
        uu____10354 :: uu____10422  in
      let rec fallback phi1 =
        match phi1.FStar_Syntax_Syntax.n with
        | FStar_Syntax_Syntax.Tm_meta
            (phi',FStar_Syntax_Syntax.Meta_labeled (msg,r,b)) ->
            let uu____11263 = encode_formula phi' env  in
            (match uu____11263 with
             | (phi2,decls) ->
                 let uu____11274 =
                   FStar_SMTEncoding_Term.mk
                     (FStar_SMTEncoding_Term.Labeled (phi2, msg, r)) r
                    in
                 (uu____11274, decls))
        | FStar_Syntax_Syntax.Tm_meta uu____11276 ->
            let uu____11283 = FStar_Syntax_Util.unmeta phi1  in
            encode_formula uu____11283 env
        | FStar_Syntax_Syntax.Tm_match (e,pats) ->
            let uu____11322 =
              encode_match e pats FStar_SMTEncoding_Util.mkFalse env
                encode_formula
               in
            (match uu____11322 with | (t,decls) -> (t, decls))
        | FStar_Syntax_Syntax.Tm_let
            ((false
              ,{ FStar_Syntax_Syntax.lbname = FStar_Util.Inl x;
                 FStar_Syntax_Syntax.lbunivs = uu____11334;
                 FStar_Syntax_Syntax.lbtyp = t1;
                 FStar_Syntax_Syntax.lbeff = uu____11336;
                 FStar_Syntax_Syntax.lbdef = e1;
                 FStar_Syntax_Syntax.lbattrs = uu____11338;
                 FStar_Syntax_Syntax.lbpos = uu____11339;_}::[]),e2)
            ->
            let uu____11366 = encode_let x t1 e1 e2 env encode_formula  in
            (match uu____11366 with | (t,decls) -> (t, decls))
        | FStar_Syntax_Syntax.Tm_app (head1,args) ->
            let head2 = FStar_Syntax_Util.un_uinst head1  in
            (match ((head2.FStar_Syntax_Syntax.n), args) with
             | (FStar_Syntax_Syntax.Tm_fvar
                fv,uu____11419::(x,uu____11421)::(t,uu____11423)::[]) when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.has_type_lid
                 ->
                 let uu____11490 = encode_term x env  in
                 (match uu____11490 with
                  | (x1,decls) ->
                      let uu____11501 = encode_term t env  in
                      (match uu____11501 with
                       | (t1,decls') ->
                           let uu____11512 =
                             FStar_SMTEncoding_Term.mk_HasType x1 t1  in
                           (uu____11512, (FStar_List.append decls decls'))))
             | (FStar_Syntax_Syntax.Tm_fvar
                fv,(r,uu____11515)::(msg,uu____11517)::(phi2,uu____11519)::[])
                 when
                 FStar_Syntax_Syntax.fv_eq_lid fv
                   FStar_Parser_Const.labeled_lid
                 ->
                 let uu____11586 =
                   let uu____11591 =
                     let uu____11592 = FStar_Syntax_Subst.compress r  in
                     uu____11592.FStar_Syntax_Syntax.n  in
                   let uu____11595 =
                     let uu____11596 = FStar_Syntax_Subst.compress msg  in
                     uu____11596.FStar_Syntax_Syntax.n  in
                   (uu____11591, uu____11595)  in
                 (match uu____11586 with
                  | (FStar_Syntax_Syntax.Tm_constant (FStar_Const.Const_range
                     r1),FStar_Syntax_Syntax.Tm_constant
                     (FStar_Const.Const_string (s,uu____11605))) ->
                      let phi3 =
                        FStar_Syntax_Syntax.mk
                          (FStar_Syntax_Syntax.Tm_meta
                             (phi2,
                               (FStar_Syntax_Syntax.Meta_labeled
                                  (s, r1, false))))
                          FStar_Pervasives_Native.None r1
                         in
                      fallback phi3
                  | uu____11616 -> fallback phi2)
             | (FStar_Syntax_Syntax.Tm_fvar fv,(t,uu____11623)::[]) when
                 (FStar_Syntax_Syntax.fv_eq_lid fv
                    FStar_Parser_Const.squash_lid)
                   ||
                   (FStar_Syntax_Syntax.fv_eq_lid fv
                      FStar_Parser_Const.auto_squash_lid)
                 -> encode_formula t env
             | uu____11658 when head_redex env head2 ->
                 let uu____11673 = whnf env phi1  in
                 encode_formula uu____11673 env
             | uu____11674 ->
                 let uu____11689 = encode_term phi1 env  in
                 (match uu____11689 with
                  | (tt,decls) ->
                      let tt1 =
                        let uu____11701 =
                          let uu____11703 =
                            FStar_Range.use_range
                              tt.FStar_SMTEncoding_Term.rng
                             in
                          let uu____11704 =
                            FStar_Range.use_range
                              phi1.FStar_Syntax_Syntax.pos
                             in
                          FStar_Range.rng_included uu____11703 uu____11704
                           in
                        if uu____11701
                        then tt
                        else
                          (let uu___1527_11708 = tt  in
                           {
                             FStar_SMTEncoding_Term.tm =
                               (uu___1527_11708.FStar_SMTEncoding_Term.tm);
                             FStar_SMTEncoding_Term.freevars =
                               (uu___1527_11708.FStar_SMTEncoding_Term.freevars);
                             FStar_SMTEncoding_Term.rng =
                               (phi1.FStar_Syntax_Syntax.pos)
                           })
                         in
                      let uu____11709 = FStar_SMTEncoding_Term.mk_Valid tt1
                         in
                      (uu____11709, decls)))
        | uu____11710 ->
            let uu____11711 = encode_term phi1 env  in
            (match uu____11711 with
             | (tt,decls) ->
                 let tt1 =
                   let uu____11723 =
                     let uu____11725 =
                       FStar_Range.use_range tt.FStar_SMTEncoding_Term.rng
                        in
                     let uu____11726 =
                       FStar_Range.use_range phi1.FStar_Syntax_Syntax.pos  in
                     FStar_Range.rng_included uu____11725 uu____11726  in
                   if uu____11723
                   then tt
                   else
                     (let uu___1535_11730 = tt  in
                      {
                        FStar_SMTEncoding_Term.tm =
                          (uu___1535_11730.FStar_SMTEncoding_Term.tm);
                        FStar_SMTEncoding_Term.freevars =
                          (uu___1535_11730.FStar_SMTEncoding_Term.freevars);
                        FStar_SMTEncoding_Term.rng =
                          (phi1.FStar_Syntax_Syntax.pos)
                      })
                    in
                 let uu____11731 = FStar_SMTEncoding_Term.mk_Valid tt1  in
                 (uu____11731, decls))
         in
      let encode_q_body env1 bs ps body =
        let uu____11775 = encode_binders FStar_Pervasives_Native.None bs env1
           in
        match uu____11775 with
        | (vars,guards,env2,decls,uu____11814) ->
            let uu____11827 = encode_smt_patterns ps env2  in
            (match uu____11827 with
             | (pats,decls') ->
                 let uu____11864 = encode_formula body env2  in
                 (match uu____11864 with
                  | (body1,decls'') ->
                      let guards1 =
                        match pats with
                        | ({
                             FStar_SMTEncoding_Term.tm =
                               FStar_SMTEncoding_Term.App
                               (FStar_SMTEncoding_Term.Var gf,p::[]);
                             FStar_SMTEncoding_Term.freevars = uu____11896;
                             FStar_SMTEncoding_Term.rng = uu____11897;_}::[])::[]
                            when
                            let uu____11917 =
                              FStar_Ident.text_of_lid
                                FStar_Parser_Const.guard_free
                               in
                            uu____11917 = gf -> []
                        | uu____11920 -> guards  in
                      let uu____11925 =
                        FStar_SMTEncoding_Util.mk_and_l guards1  in
                      (vars, pats, uu____11925, body1,
                        (FStar_List.append decls
                           (FStar_List.append decls' decls'')))))
         in
      debug1 phi;
      (let phi1 = FStar_Syntax_Util.unascribe phi  in
       let uu____11936 = FStar_Syntax_Util.destruct_typ_as_formula phi1  in
       match uu____11936 with
       | FStar_Pervasives_Native.None  -> fallback phi1
       | FStar_Pervasives_Native.Some (FStar_Syntax_Util.BaseConn (op,arms))
           ->
           let uu____11945 =
             FStar_All.pipe_right connectives
               (FStar_List.tryFind
                  (fun uu____12051  ->
                     match uu____12051 with
                     | (l,uu____12076) -> FStar_Ident.lid_equals op l))
              in
           (match uu____11945 with
            | FStar_Pervasives_Native.None  -> fallback phi1
            | FStar_Pervasives_Native.Some (uu____12145,f) ->
                f phi1.FStar_Syntax_Syntax.pos arms)
       | FStar_Pervasives_Native.Some (FStar_Syntax_Util.QAll
           (vars,pats,body)) ->
           (FStar_All.pipe_right pats
              (FStar_List.iter (check_pattern_vars env vars));
            (let uu____12237 = encode_q_body env vars pats body  in
             match uu____12237 with
             | (vars1,pats1,guard,body1,decls) ->
                 let tm =
                   let uu____12282 =
                     let uu____12293 =
                       FStar_SMTEncoding_Util.mkImp (guard, body1)  in
                     (pats1, vars1, uu____12293)  in
                   FStar_SMTEncoding_Term.mkForall
                     phi1.FStar_Syntax_Syntax.pos uu____12282
                    in
                 (tm, decls)))
       | FStar_Pervasives_Native.Some (FStar_Syntax_Util.QEx
           (vars,pats,body)) ->
           (FStar_All.pipe_right pats
              (FStar_List.iter (check_pattern_vars env vars));
            (let uu____12324 = encode_q_body env vars pats body  in
             match uu____12324 with
             | (vars1,pats1,guard,body1,decls) ->
                 let uu____12368 =
                   let uu____12369 =
                     let uu____12380 =
                       FStar_SMTEncoding_Util.mkAnd (guard, body1)  in
                     (pats1, vars1, uu____12380)  in
                   FStar_SMTEncoding_Term.mkExists
                     phi1.FStar_Syntax_Syntax.pos uu____12369
                    in
                 (uu____12368, decls))))
