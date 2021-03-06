open Prims
type inst_t = (FStar_Ident.lident * FStar_Syntax_Syntax.universes) Prims.list
let mk :
  'Auu____14 'Auu____15 .
    'Auu____14 FStar_Syntax_Syntax.syntax ->
      'Auu____15 -> 'Auu____15 FStar_Syntax_Syntax.syntax
  =
  fun t  ->
    fun s  ->
      FStar_Syntax_Syntax.mk s FStar_Pervasives_Native.None
        t.FStar_Syntax_Syntax.pos
  
let rec (inst :
  (FStar_Syntax_Syntax.term ->
     FStar_Syntax_Syntax.fv -> FStar_Syntax_Syntax.term)
    -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term)
  =
  fun s  ->
    fun t  ->
      let t1 = FStar_Syntax_Subst.compress t  in
      let mk1 = mk t1  in
      match t1.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Tm_delayed uu____145 -> failwith "Impossible"
      | FStar_Syntax_Syntax.Tm_name uu____169 -> t1
      | FStar_Syntax_Syntax.Tm_uvar uu____170 -> t1
      | FStar_Syntax_Syntax.Tm_uvar uu____183 -> t1
      | FStar_Syntax_Syntax.Tm_type uu____196 -> t1
      | FStar_Syntax_Syntax.Tm_bvar uu____197 -> t1
      | FStar_Syntax_Syntax.Tm_constant uu____198 -> t1
      | FStar_Syntax_Syntax.Tm_quoted uu____199 -> t1
      | FStar_Syntax_Syntax.Tm_unknown  -> t1
      | FStar_Syntax_Syntax.Tm_uinst uu____206 -> t1
      | FStar_Syntax_Syntax.Tm_lazy uu____213 -> t1
      | FStar_Syntax_Syntax.Tm_fvar fv -> s t1 fv
      | FStar_Syntax_Syntax.Tm_abs (bs,body,lopt) ->
          let bs1 = inst_binders s bs  in
          let body1 = inst s body  in
          let uu____244 =
            let uu____245 =
              let uu____264 = inst_lcomp_opt s lopt  in
              (bs1, body1, uu____264)  in
            FStar_Syntax_Syntax.Tm_abs uu____245  in
          mk1 uu____244
      | FStar_Syntax_Syntax.Tm_arrow (bs,c) ->
          let bs1 = inst_binders s bs  in
          let c1 = inst_comp s c  in
          mk1 (FStar_Syntax_Syntax.Tm_arrow (bs1, c1))
      | FStar_Syntax_Syntax.Tm_refine (bv,t2) ->
          let bv1 =
            let uu___47_322 = bv  in
            let uu____323 = inst s bv.FStar_Syntax_Syntax.sort  in
            {
              FStar_Syntax_Syntax.ppname =
                (uu___47_322.FStar_Syntax_Syntax.ppname);
              FStar_Syntax_Syntax.index =
                (uu___47_322.FStar_Syntax_Syntax.index);
              FStar_Syntax_Syntax.sort = uu____323
            }  in
          let t3 = inst s t2  in
          mk1 (FStar_Syntax_Syntax.Tm_refine (bv1, t3))
      | FStar_Syntax_Syntax.Tm_app (t2,args) ->
          let uu____355 =
            let uu____356 =
              let uu____373 = inst s t2  in
              let uu____376 = inst_args s args  in (uu____373, uu____376)  in
            FStar_Syntax_Syntax.Tm_app uu____356  in
          mk1 uu____355
      | FStar_Syntax_Syntax.Tm_match (t2,pats) ->
          let pats1 =
            FStar_All.pipe_right pats
              (FStar_List.map
                 (fun uu____508  ->
                    match uu____508 with
                    | (p,wopt,t3) ->
                        let wopt1 =
                          match wopt with
                          | FStar_Pervasives_Native.None  ->
                              FStar_Pervasives_Native.None
                          | FStar_Pervasives_Native.Some w ->
                              let uu____546 = inst s w  in
                              FStar_Pervasives_Native.Some uu____546
                           in
                        let t4 = inst s t3  in (p, wopt1, t4)))
             in
          let uu____552 =
            let uu____553 = let uu____576 = inst s t2  in (uu____576, pats1)
               in
            FStar_Syntax_Syntax.Tm_match uu____553  in
          mk1 uu____552
      | FStar_Syntax_Syntax.Tm_ascribed (t11,asc,f) ->
          let inst_asc uu____669 =
            match uu____669 with
            | (annot,topt) ->
                let topt1 = FStar_Util.map_opt topt (inst s)  in
                let annot1 =
                  match annot with
                  | FStar_Util.Inl t2 ->
                      let uu____731 = inst s t2  in FStar_Util.Inl uu____731
                  | FStar_Util.Inr c ->
                      let uu____739 = inst_comp s c  in
                      FStar_Util.Inr uu____739
                   in
                (annot1, topt1)
             in
          let uu____752 =
            let uu____753 =
              let uu____780 = inst s t11  in
              let uu____783 = inst_asc asc  in (uu____780, uu____783, f)  in
            FStar_Syntax_Syntax.Tm_ascribed uu____753  in
          mk1 uu____752
      | FStar_Syntax_Syntax.Tm_let (lbs,t2) ->
          let lbs1 =
            let uu____848 =
              FStar_All.pipe_right (FStar_Pervasives_Native.snd lbs)
                (FStar_List.map
                   (fun lb  ->
                      let uu___89_863 = lb  in
                      let uu____864 = inst s lb.FStar_Syntax_Syntax.lbtyp  in
                      let uu____867 = inst s lb.FStar_Syntax_Syntax.lbdef  in
                      {
                        FStar_Syntax_Syntax.lbname =
                          (uu___89_863.FStar_Syntax_Syntax.lbname);
                        FStar_Syntax_Syntax.lbunivs =
                          (uu___89_863.FStar_Syntax_Syntax.lbunivs);
                        FStar_Syntax_Syntax.lbtyp = uu____864;
                        FStar_Syntax_Syntax.lbeff =
                          (uu___89_863.FStar_Syntax_Syntax.lbeff);
                        FStar_Syntax_Syntax.lbdef = uu____867;
                        FStar_Syntax_Syntax.lbattrs =
                          (uu___89_863.FStar_Syntax_Syntax.lbattrs);
                        FStar_Syntax_Syntax.lbpos =
                          (uu___89_863.FStar_Syntax_Syntax.lbpos)
                      }))
               in
            ((FStar_Pervasives_Native.fst lbs), uu____848)  in
          let uu____876 =
            let uu____877 = let uu____891 = inst s t2  in (lbs1, uu____891)
               in
            FStar_Syntax_Syntax.Tm_let uu____877  in
          mk1 uu____876
      | FStar_Syntax_Syntax.Tm_meta
          (t2,FStar_Syntax_Syntax.Meta_pattern args) ->
          let uu____921 =
            let uu____922 =
              let uu____929 = inst s t2  in
              let uu____932 =
                let uu____933 =
                  FStar_All.pipe_right args (FStar_List.map (inst_args s))
                   in
                FStar_Syntax_Syntax.Meta_pattern uu____933  in
              (uu____929, uu____932)  in
            FStar_Syntax_Syntax.Tm_meta uu____922  in
          mk1 uu____921
      | FStar_Syntax_Syntax.Tm_meta
          (t2,FStar_Syntax_Syntax.Meta_monadic (m,t')) ->
          let uu____1003 =
            let uu____1004 =
              let uu____1011 = inst s t2  in
              let uu____1014 =
                let uu____1015 =
                  let uu____1022 = inst s t'  in (m, uu____1022)  in
                FStar_Syntax_Syntax.Meta_monadic uu____1015  in
              (uu____1011, uu____1014)  in
            FStar_Syntax_Syntax.Tm_meta uu____1004  in
          mk1 uu____1003
      | FStar_Syntax_Syntax.Tm_meta (t2,tag) ->
          let uu____1035 =
            let uu____1036 = let uu____1043 = inst s t2  in (uu____1043, tag)
               in
            FStar_Syntax_Syntax.Tm_meta uu____1036  in
          mk1 uu____1035

and (inst_binders :
  (FStar_Syntax_Syntax.term ->
     FStar_Syntax_Syntax.fv -> FStar_Syntax_Syntax.term)
    -> FStar_Syntax_Syntax.binders -> FStar_Syntax_Syntax.binders)
  =
  fun s  ->
    fun bs  ->
      FStar_All.pipe_right bs
        (FStar_List.map
           (fun uu____1078  ->
              match uu____1078 with
              | (x,imp) ->
                  let uu____1097 =
                    let uu___113_1098 = x  in
                    let uu____1099 = inst s x.FStar_Syntax_Syntax.sort  in
                    {
                      FStar_Syntax_Syntax.ppname =
                        (uu___113_1098.FStar_Syntax_Syntax.ppname);
                      FStar_Syntax_Syntax.index =
                        (uu___113_1098.FStar_Syntax_Syntax.index);
                      FStar_Syntax_Syntax.sort = uu____1099
                    }  in
                  (uu____1097, imp)))

and (inst_args :
  (FStar_Syntax_Syntax.term ->
     FStar_Syntax_Syntax.fv -> FStar_Syntax_Syntax.term)
    ->
    (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
      FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
      Prims.list ->
      (FStar_Syntax_Syntax.term' FStar_Syntax_Syntax.syntax *
        FStar_Syntax_Syntax.arg_qualifier FStar_Pervasives_Native.option)
        Prims.list)
  =
  fun s  ->
    fun args  ->
      FStar_All.pipe_right args
        (FStar_List.map
           (fun uu____1154  ->
              match uu____1154 with
              | (a,imp) -> let uu____1173 = inst s a  in (uu____1173, imp)))

and (inst_comp :
  (FStar_Syntax_Syntax.term ->
     FStar_Syntax_Syntax.fv -> FStar_Syntax_Syntax.term)
    ->
    FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax ->
      FStar_Syntax_Syntax.comp' FStar_Syntax_Syntax.syntax)
  =
  fun s  ->
    fun c  ->
      match c.FStar_Syntax_Syntax.n with
      | FStar_Syntax_Syntax.Total (t,uopt) ->
          let uu____1196 = inst s t  in
          FStar_Syntax_Syntax.mk_Total' uu____1196 uopt
      | FStar_Syntax_Syntax.GTotal (t,uopt) ->
          let uu____1207 = inst s t  in
          FStar_Syntax_Syntax.mk_GTotal' uu____1207 uopt
      | FStar_Syntax_Syntax.Comp ct ->
          let ct1 =
            let uu___132_1210 = ct  in
            let uu____1211 = inst s ct.FStar_Syntax_Syntax.result_typ  in
            let uu____1214 = inst_args s ct.FStar_Syntax_Syntax.effect_args
               in
            let uu____1225 =
              FStar_All.pipe_right ct.FStar_Syntax_Syntax.flags
                (FStar_List.map
                   (fun uu___0_1235  ->
                      match uu___0_1235 with
                      | FStar_Syntax_Syntax.DECREASES t ->
                          let uu____1239 = inst s t  in
                          FStar_Syntax_Syntax.DECREASES uu____1239
                      | f -> f))
               in
            {
              FStar_Syntax_Syntax.comp_univs =
                (uu___132_1210.FStar_Syntax_Syntax.comp_univs);
              FStar_Syntax_Syntax.effect_name =
                (uu___132_1210.FStar_Syntax_Syntax.effect_name);
              FStar_Syntax_Syntax.result_typ = uu____1211;
              FStar_Syntax_Syntax.effect_args = uu____1214;
              FStar_Syntax_Syntax.flags = uu____1225
            }  in
          FStar_Syntax_Syntax.mk_Comp ct1

and (inst_lcomp_opt :
  (FStar_Syntax_Syntax.term ->
     FStar_Syntax_Syntax.fv -> FStar_Syntax_Syntax.term)
    ->
    FStar_Syntax_Syntax.residual_comp FStar_Pervasives_Native.option ->
      FStar_Syntax_Syntax.residual_comp FStar_Pervasives_Native.option)
  =
  fun s  ->
    fun l  ->
      match l with
      | FStar_Pervasives_Native.None  -> FStar_Pervasives_Native.None
      | FStar_Pervasives_Native.Some rc ->
          let uu____1254 =
            let uu___144_1255 = rc  in
            let uu____1256 =
              FStar_Util.map_opt rc.FStar_Syntax_Syntax.residual_typ (inst s)
               in
            {
              FStar_Syntax_Syntax.residual_effect =
                (uu___144_1255.FStar_Syntax_Syntax.residual_effect);
              FStar_Syntax_Syntax.residual_typ = uu____1256;
              FStar_Syntax_Syntax.residual_flags =
                (uu___144_1255.FStar_Syntax_Syntax.residual_flags)
            }  in
          FStar_Pervasives_Native.Some uu____1254

let (instantiate :
  inst_t -> FStar_Syntax_Syntax.term -> FStar_Syntax_Syntax.term) =
  fun i  ->
    fun t  ->
      match i with
      | [] -> t
      | uu____1280 ->
          let inst_fv t1 fv =
            let uu____1292 =
              FStar_Util.find_opt
                (fun uu____1306  ->
                   match uu____1306 with
                   | (x,uu____1313) ->
                       FStar_Ident.lid_equals x
                         (fv.FStar_Syntax_Syntax.fv_name).FStar_Syntax_Syntax.v)
                i
               in
            match uu____1292 with
            | FStar_Pervasives_Native.None  -> t1
            | FStar_Pervasives_Native.Some (uu____1318,us) ->
                mk t1 (FStar_Syntax_Syntax.Tm_uinst (t1, us))
             in
          inst inst_fv t
  