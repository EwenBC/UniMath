(** the coinductive analogue of [MultiSortedMonadConstruction_actegorical]

author: Ralph Matthes 2023
 *)

Require Import UniMath.Foundations.PartD.
Require Import UniMath.Foundations.Sets.

Require Import UniMath.MoreFoundations.All.

Require Import UniMath.Combinatorics.Lists.

Require Import UniMath.CategoryTheory.Core.Categories.
Require Import UniMath.CategoryTheory.Core.NaturalTransformations.
Require Import UniMath.CategoryTheory.Core.Functors.
Require Import UniMath.CategoryTheory.Core.Univalence.
Require Import UniMath.CategoryTheory.FunctorCategory.
Require Import UniMath.CategoryTheory.whiskering.
Require Import UniMath.CategoryTheory.limits.graphs.colimits.
Require Import UniMath.CategoryTheory.limits.binproducts.
Require Import UniMath.CategoryTheory.limits.products.
Require Import UniMath.CategoryTheory.limits.bincoproducts.
Require Import UniMath.CategoryTheory.limits.coproducts.
Require Import UniMath.CategoryTheory.limits.terminal.
Require Import UniMath.CategoryTheory.limits.initial.
Require Import UniMath.CategoryTheory.exponentials.
Require Import UniMath.CategoryTheory.Adjunctions.Core.
Require Import UniMath.CategoryTheory.Monads.Monads.
Require Import UniMath.CategoryTheory.categories.HSET.Core.
Require Import UniMath.CategoryTheory.categories.HSET.Colimits.
Require Import UniMath.CategoryTheory.categories.HSET.Limits.
Require Import UniMath.CategoryTheory.categories.HSET.Structures.
Require Import UniMath.CategoryTheory.categories.HSET.Univalence.
Require Import UniMath.CategoryTheory.categories.StandardCategories.
Require Import UniMath.CategoryTheory.Groupoids.

(** for the additions in 2023 *)
Require Import UniMath.CategoryTheory.Core.Isos.
Require Import UniMath.CategoryTheory.FunctorCoalgebras.
Require Import UniMath.CategoryTheory.limits.graphs.limits.
Require Import UniMath.CategoryTheory.Chains.Cochains.
Require Import UniMath.CategoryTheory.Chains.CoAdamek.
Require Import UniMath.CategoryTheory.Chains.OmegaContFunctors.
Require Import UniMath.CategoryTheory.Monoidal.WhiskeredBifunctors.
Require Import UniMath.CategoryTheory.Monoidal.Categories.
Require Import UniMath.CategoryTheory.Actegories.Actegories.
Require Import UniMath.CategoryTheory.Actegories.ConstructionOfActegories.
Require Import UniMath.CategoryTheory.Actegories.MorphismsOfActegories.
Require Import UniMath.CategoryTheory.Actegories.CoproductsInActegories.
Require Import UniMath.CategoryTheory.Actegories.ConstructionOfActegoryMorphisms.
Require Import UniMath.CategoryTheory.Monoidal.CategoriesOfMonoids.
Require Import UniMath.CategoryTheory.Monoidal.Examples.MonoidalPointedObjects.
Require Import UniMath.CategoryTheory.Monoidal.Examples.EndofunctorsMonoidalElementary.
Require Import UniMath.CategoryTheory.Monoidal.Examples.MonadsAsMonoidsElementary.
Require Import UniMath.SubstitutionSystems.EquivalenceLaxLineatorsHomogeneousCase.
Require UniMath.SubstitutionSystems.LiftingInitial_alt.
Require Import UniMath.SubstitutionSystems.MultiSorted_alt.
Require Import UniMath.SubstitutionSystems.MultiSorted_actegorical.
Require Import UniMath.SubstitutionSystems.MultiSortedMonadConstruction_alt.
Require Import UniMath.SubstitutionSystems.GeneralizedSubstitutionSystems.
Require Import UniMath.SubstitutionSystems.ConstructionOfGHSS.
Require UniMath.SubstitutionSystems.BindingSigToMonad_actegorical.
Require Import UniMath.SubstitutionSystems.SigmaMonoids.
Require Import UniMath.SubstitutionSystems.ContinuitySignature.ContinuityOfMultiSortedSigToFunctor.
Require Import UniMath.SubstitutionSystems.ContinuitySignature.MultiSortedSignatureFunctorEquivalence.
Require Import UniMath.SubstitutionSystems.ContinuitySignature.CommutingOfOmegaLimitsAndCoproducts.
Require Import UniMath.SubstitutionSystems.ContinuitySignature.InstantiateHSET.

Local Open Scope cat.

Import BifunctorNotations.
Import MonoidalNotations.

Section ToBeMoved.

  (* Definition limArrowOfInverses
             {C : category} {g : graph} {d : diagram g C}
             (CC : LimCone d)
             (c : C) (cc : cone d c)
    : (∏  v : vertex g, is_z_isomorphism (pr1 cc v)) -> is_z_isomorphism (limArrow CC c cc).
  Proof.
    intro iv.
    apply isLim_is_z_iso.
    intros x x_con.
    use tpair.
    - unfold LimCone in CC.
      use tpair.
      + refine (pr11 (pr2 CC x x_con) · _).
        Search lim.
        Search lim.


    use make_is_z_isomorphism.
    - unfold cone in cc.

      Check pr1 cc.
      Search lim. *)

  Lemma isaprop_isCoproduct
        {C : category} {I : UU}
        {i : I -> C} {x : C}
        (j : ∏ i0 : I, C ⟦ i i0, x ⟧)
    : isaprop (isCoproduct I C i x j).
  Proof.
    repeat (apply impred; intro).
    apply isapropiscontr.
  Qed.

  Definition z_iso_from_coproduct_to_coproduct
             {C : category} {I : UU}
             {ind : I -> C}
             (CC CC' : Coproduct I C ind) : z_iso (pr11 CC) (pr11 CC').
  Proof.
    use make_z_iso.
    - apply CoproductArrow, CoproductIn.
    - apply CoproductArrow, CoproductIn.
    - split.
      + etrans. 1: apply postcompWithCoproductArrow.
        apply pathsinv0, Coproduct_endo_is_identity.
        intro.
        etrans.
        1: apply CoproductInCommutes.
        apply CoproductInCommutes.
      + etrans. 1: apply postcompWithCoproductArrow.
        apply pathsinv0, Coproduct_endo_is_identity.
        intro.
        etrans.
        1: apply CoproductInCommutes.
        apply CoproductInCommutes.
  Defined.

  Definition eq_Coproduct
             {C : category}
             {I : UU}
             {ind : I -> C}
             (C1 C2 : Coproduct I C ind)
             (q : pr11 C1  = pr11 C2)
             (e : ∏ i : I, CoproductIn I C C2 i = CoproductIn I C C1 i · pr1 (Univalence.idtoiso q))
  : C1 = C2.
  Proof.
    use subtypePath.
    { intro ; apply isaprop_isCoproduct. }
    use total2_paths_f.
    - exact q.
    - rewrite transportf_sec_constant.
      apply funextsec ; intro i.
      rewrite <- Univalence.idtoiso_postcompose.
      exact (! e i).
  Defined.

  Lemma isaprop_Coproducts
        {C : category} (Cuniv : Univalence.is_univalent C) (I : UU)
    : isaprop (Coproducts I C).
  Proof.


    use invproofirrelevance.
    intros C1 C2.
    apply funextsec ; intro ind.
    use eq_Coproduct.
    - refine (Univalence.isotoid _ Cuniv _).
      apply z_iso_from_coproduct_to_coproduct.
    - intro.
      rewrite Univalence.idtoiso_isotoid ; cbn.
      apply pathsinv0, CoproductInCommutes.
  Qed.

  Lemma ω_limits_distribute_over_I_coproducts_independent_of_product
        {C : category} {I : SET}
        (Cuniv : Univalence.is_univalent C)
        {l : Lims_of_shape conat_graph C}
        (p q : Coproducts (pr1 I) C)
    : ω_limits_distribute_over_I_coproducts C I l p
      -> ω_limits_distribute_over_I_coproducts C I l q.
  Proof.
    intro distr.

    transparent assert (pq : (p = q)).
    {
      apply isaprop_Coproducts.
      exact Cuniv.
    }
    induction pq.
    exact distr.
  Qed.

  Definition BinProduct_of_functors_BinProducts_of_shape
             {C D : category}
             (BC :  Colims_of_shape two_graph D)
             (F G : functor C D)
    : nat_z_iso (BinCoproduct_of_functors C D (BinCoproducts_from_Colims _ BC) F G)
                (coproduct_of_functors bool C D (Coproducts_from_Colims _ _ BC) (λ x : bool, if x then F else G)).
  Proof.
    use make_nat_z_iso.
    - use make_nat_trans.
      + intro c.
        use colimOfArrows.
        * intro b.
          induction b ; apply identity.
        * intros b1 b2 e.
          apply fromempty.
          exact e.
      + intros c1 c2 f.
        cbn.
        etrans.
        2: apply pathsinv0, precompWithColimOfArrows.
        etrans.
        1: apply postcompWithColimArrow.
        apply colimArrowUnique.
        intro b.
        cbn.
        etrans.
        1: apply (colimArrowCommutes (BC (bincoproduct_diagram D (F c1) (G c1)))).
        cbn.
        induction b.
        * cbn.
          etrans.
          1: apply assoc'.
          etrans.
          1: { apply maponpaths.
               apply (colimArrowCommutes  (BC (bincoproduct_diagram D (F c2) (G c2))) _ _ true).
          }
          cbn.
          etrans.
          1: apply maponpaths, id_left.
          apply pathsinv0, id_left.
        * cbn.
          etrans.
          1: apply assoc'.
          etrans.
          1: { apply maponpaths.
               apply (colimArrowCommutes  (BC (bincoproduct_diagram D (F c2) (G c2))) _ _ false).
          }
          cbn.
          etrans.
          1: apply maponpaths, id_left.
          apply pathsinv0, id_left.
    - intro c.
      use tpair.
      + use colimOfArrows.
        * intro b.
          induction b ; apply identity.
        * intros b1 b2 e.
          apply fromempty.
          exact e.
      + split ; cbn.
        * etrans.
          1: apply postcompWithColimArrow.
          apply pathsinv0.
          use colimArrowUnique.
          intro b.
          etrans.
          1: apply id_right.
          cbn.
          etrans.
          2: apply assoc.
          etrans.
          2: { apply maponpaths, pathsinv0.
               apply (colimArrowCommutes (BC (coproducts_diagram bool D (λ i : bool, (if i then F else G) c))) ).
          }
          induction b ; refine (_ @ ! id_left _) ; apply pathsinv0, id_left.
        * etrans.
          1: apply postcompWithColimArrow.
          apply pathsinv0.
          use colimArrowUnique.
          intro b.
          etrans.
          1: apply id_right.
          cbn.
          etrans.
          2: apply assoc.
          etrans.
          2: { apply maponpaths, pathsinv0.
               apply (colimArrowCommutes (BC (bincoproduct_diagram D (F c) (G c))) ).
          }
          induction b ; refine (_ @ ! id_left _) ; apply pathsinv0, id_left.
  Defined.

  Definition Colims_from_BinCoproducts
             {C : category} (CC : BinCoproducts C)
    : Colims_of_shape two_graph C.
  Proof.
    unfold Colims_of_shape.
    intro d.
    unfold diagram in d.
    cbn in d.

    set (c := CC (pr1 d true) (pr1 d false)).
    unfold BinCoproduct in c.
    use make_ColimCocone.
    - exact (pr11 c).
    - use tpair.
      + intro b.
        induction b.
        * exact (pr121 c).
        * exact (pr221 c).
      + intros b1 b2 e.
        apply fromempty.
        exact e.
    - intros co cc.
      unfold cocone in cc.

      use tpair.
      + exists (pr11 (pr2 c co (pr1 cc true) (pr1 cc false))).
        intro b.
        induction b.
        * exact (pr121 (pr2 c co (pr1 cc true) (pr1 cc false))).
        * exact (pr221 (pr2 c co (pr1 cc true) (pr1 cc false))).
      + intro t.
        transparent assert (ϕ : (∑ fg : C ⟦ pr11 c, co ⟧, pr121 c · fg = pr1 cc true × pr221 c · fg = pr1 cc false)).
        {
          use tpair.
          - exact (pr1 t).
          - split ; apply (pr2 t).
        }

        set (p := pr2 (pr2 c co (pr1 cc true) (pr1 cc false)) ϕ).
        use total2_paths_f.
        * apply (base_paths _ _ p).
        * apply isaprop_is_cocone_mor.
  Defined.

End ToBeMoved.

Section Upstream.

  Context (C : category) (BC : BinCoproducts C).
  Local Definition Id_H := LiftingInitial_alt.Id_H C BC.

  Context (L : ∏ coch : cochain [C, C], LimCone coch).
  Context (distr :  ω_limits_distribute_over_I_coproducts [C, C] (bool,, isasetbool) L
    (Coproducts_from_Colims bool [C, C]
       (Colims_from_BinCoproducts (BinCoproducts_functor_precat C C BC)))).

  Definition is_omega_cont_Id_H (H: [C, C] ⟶ [C, C]) :
    is_omega_cont H -> is_omega_cont (Id_H H).
  Proof.
    intro Hc.
    use is_omega_cont_z_iso.
    2: {
      use z_iso_from_nat_z_iso.
      use nat_z_iso_inv.

      transparent assert (BC0 : (Colims_of_shape two_graph [C,C])).
      {
        use Colims_from_BinCoproducts.
        apply BinCoproducts_functor_precat.
        exact BC.
      }

      exact (BinProduct_of_functors_BinProducts_of_shape BC0 (constant_functor [C, C] [C, C] (functor_identity C)) H).
    }

    use (coproduct_of_functors_omega_cont [C,C] (bool,,isasetbool)).
    - exact L.
    - exact distr.
    - intro b.
      induction b.
      + apply is_omega_cont_constant_functor.
      + exact Hc.
  Defined.

End Upstream.

Section MBindingSig.

Context (sort : UU) (* (Hsort_set : isaset sort) *) (Hsort : isofhlevel 3 sort) (C : category).

(* Assumptions on [C] used to construct the functor *)
(* Note that there is some redundancy in the assumptions *)
Context (TC : Terminal C) (IC : Initial C)
          (BP : BinProducts C) (BC : BinCoproducts C)
          (PC : forall (I : UU), Products I C) (CC : forall (I : UU), isaset I → Coproducts I C).

Local Notation "'1'" := (TerminalObject TC).
Local Notation "a ⊕ b" := (BinCoproductObject (BC a b)).

(* Let Hsort := hlevelntosn 2 _ Hsort_set. *)

(** Define the category of sorts *)
Let sort_cat : category := path_pregroupoid sort Hsort.

(** This represents "sort → C" *)
Let sortToC : category := [sort_cat,C].
Let make_sortToC (f : sort → C) : sortToC := functor_path_pregroupoid Hsort f.

Let BCsortToC : BinCoproducts sortToC := BinCoproducts_functor_precat _ _ BC.

Let BPC : BinProducts [sortToC,C] := BinProducts_functor_precat sortToC C BP.

(* Assumptions needed to prove ω-continuity of the functor *)
Context (HcoC : Lims_of_shape conat_graph C)
 (* (HCcommuteBP : propcoproducts_commute_binproducts C BP (λ p : hProp, CC p (isasetaprop (pr2 p)))) *)
 (HCcommuteCC : ∏ I : SET, ω_limits_distribute_over_I_coproducts C I HcoC (CC (pr1 I) (pr2 I))).



(** * Construction of a monad from a multisorted signature *)
Section monad.

  Local Definition sortToC1 := [sortToC, sortToC].
  Local Definition sortToC2 := [sortToC1, sortToC1].

  Let BCsortToC1 : BinCoproducts sortToC1 := BinCoproducts_functor_precat _ _ BCsortToC.
  (* Let ICsortToC1 : Initial sortToC1 := Initial_functor_precat _ _ (Initial_functor_precat _ _ IC).*)
  Let TCsortToC1 : Terminal sortToC1 := Terminal_functor_precat _ _ (Terminal_functor_precat _ _ TC).

  Local Definition HcoCsortToC : Lims_of_shape conat_graph sortToC.
  Proof.
    apply LimsFunctorCategory_of_shape, HcoC.
  Defined.
  Local Definition HcoCsortToC1 : Lims_of_shape conat_graph sortToC1.
  Proof.
    apply LimsFunctorCategory_of_shape, HcoCsortToC.
  Defined.

  Local Definition MultiSortedSigToFunctor' : MultiSortedSig sort -> sortToC2 := MultiSortedSigToFunctor' sort Hsort C TC BP BC CC.

  Local Definition is_omega_cont_MultiSortedSigToFunctor' (M : MultiSortedSig sort) :
    is_omega_cont (MultiSortedSigToFunctor' M) :=
    is_omega_cont_MultiSortedSigToFunctor' sort Hsort C TC
                                          BP BC CC HcoC HCcommuteCC M.

  Context (sortToC_exp : Exponentials (BinProducts_functor_precat [path_pregroupoid sort Hsort, C] C BP)).

  Local Definition MultiSortedSigToStrength' : ∏ M : MultiSortedSig sort,
        MultiSorted_actegorical.pointedstrengthfromselfaction_CAT sort Hsort C (MultiSortedSigToFunctor' M)
    := MultiSortedSigToStrength' sort Hsort C TC BP BC CC.

  Let Id_H : sortToC2 → sortToC2 := Id_H sortToC BCsortToC.

  (** Construction of terminal coalgebra for the omega-continuous signature functor with lax lineator *)
  Definition coindCodatatypeOfMultisortedBindingSig_CAT (sig : MultiSortedSig sort) (Cuniv : is_univalent C) :
    Terminal (CoAlg_category (Id_H (MultiSortedSigToFunctor' sig))).
  Proof.
    use limCoAlgTerminal.
    - exact TCsortToC1.
    - use is_omega_cont_Id_H.
      + apply HcoCsortToC1.
      + set (CP' := CoproductsBool BCsortToC).

        transparent assert (CP'' : (Coproducts bool sortToC)).
        {
          use Coproducts_functor_precat.
          apply CC.
          apply isasetbool.
        }

        transparent assert (CP'_distr : (ω_limits_distribute_over_I_coproducts sortToC (bool,, isasetbool) HcoCsortToC CP'')).
        {
          use functor_category_ω_limits_distribute_over_I_coproducts.
          apply HCcommuteCC.
        }

        set (q := functor_category_ω_limits_distribute_over_I_coproducts sortToC  (bool,, isasetbool) HcoCsortToC CP'' CP'_distr sortToC).
        use (ω_limits_distribute_over_I_coproducts_independent_of_product _ _ _ q).
        do 2 apply is_univalent_functor_category.
        apply Cuniv.
      + exact (is_omega_cont_MultiSortedSigToFunctor' sig).
    - apply HcoCsortToC1.
  Defined.

  Definition coindGHSSOfMultiSortedSig_CAT (sig : MultiSortedSig sort) (Cuniv : is_univalent C) :
    ghss (monendocat_monoidal sortToC) (MultiSortedSigToFunctor' sig) (MultiSortedSigToStrength' sig).
  Proof.
    use (final_coalg_to_ghss (MultiSortedSigToStrength' sig) BCsortToC1).
    - apply BindingSigToMonad_actegorical.bincoprod_distributor_pointed_CAT.
    - exact (pr1 (coindCodatatypeOfMultisortedBindingSig_CAT sig Cuniv)).
    - exact (pr2 (coindCodatatypeOfMultisortedBindingSig_CAT sig Cuniv)).
  Defined.

  (** the associated Sigma-monoid *)
  Definition coindSigmaMonoidOfMultiSortedSig_CAT (sig : MultiSortedSig sort) (Cuniv : is_univalent C) : SigmaMonoid (MultiSortedSigToStrength' sig).
  Proof.
    apply ghss_to_sigma_monoid.
    exact (coindGHSSOfMultiSortedSig_CAT sig Cuniv).
  Defined.

  (** the associated monad *)
  Definition coindMonadOfMultiSortedSig_CAT (sig : MultiSortedSig sort) (Cuniv : is_univalent C) : Monad sortToC.
  Proof.
    use monoid_to_monad_CAT.
    use SigmaMonoid_to_monoid.
    - exact (MultiSortedSigToFunctor' sig).
    - exact (MultiSortedSigToStrength' sig).
    - exact (coindSigmaMonoidOfMultiSortedSig_CAT sig Cuniv).
  Defined.

End monad.

End MBindingSig.

Section InstanceHSET.

  Context (sort : UU)  (Hsort : isofhlevel 3 sort) (*(Hsort_set : isaset sort)*).

  (* Let Hsort := hlevelntosn 2 _ Hsort_set.*)

  Let sortToHSET : category := [path_pregroupoid sort Hsort, HSET].

  Definition coindMultiSortedSigToMonadHSET_viaCAT : MultiSortedSig sort → Monad (sortToHSET).
  Proof.
    intros sig; simple refine (coindMonadOfMultiSortedSig_CAT sort Hsort HSET _ _ _ _ _ _ sig _).
    - apply TerminalHSET.
    - apply BinProductsHSET.
    - apply BinCoproductsHSET.
    - apply CoproductsHSET.
    - apply LimsHSET_of_shape.
    - apply I_coproduct_distribute_over_omega_limits_HSET.
    - apply is_univalent_HSET.
  Defined.

End InstanceHSET.
