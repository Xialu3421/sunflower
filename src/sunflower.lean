import algebra.big_operators.ring
import probability.density
import probability.independence
import probability.conditional_expectation
import probability.notation
import probability.cond_count

open finset set measure_theory probability_theory
open_locale big_operators measure_theory ennreal probability_theory

variables {α : Type*} [fintype α] [decidable_eq α]
variables {𝒮 : finset (finset α)} {G : finset (finset α)} {U : finset α} {t : ℕ}

def shadow (G : finset (finset α)) (U : finset α) : finset (finset α) := G.filter (λ Y, Y ⊆ U)

lemma shadow_subset : shadow G U ⊆ G :=
begin
  sorry
end

def spread (ε : ℝ) (U : finset (finset α)) : Prop :=
∀ (Z : finset α), (finset.card (U.filter (λ u, Z ⊆ u)) : ℝ) ≤ ε ^ Z.card * U.card

lemma spread_iff_ratio (ε : ℝ) (U : finset (finset α)) :
  spread ε U ↔ ∀ (Z : finset α), (finset.card (U.filter (λ u, Z ⊆ u)) : ℝ) / U.card ≤ ε ^ Z.card :=
begin
  sorry
end

def to_antichain (G : finset (finset α)) : finset (finset α) :=
G.filter (λ A, ∀ B ∈ G, B ⊆ A → B = A)

lemma to_antichain_subset : to_antichain G ⊆ G :=
begin
  sorry
end

lemma is_antichain_to_antichain : is_antichain (⊆) (to_antichain G : set (finset α)) :=
begin
  sorry
end

lemma contains_subset {A} (hA : A ∈ G) : ∃ B ∈ to_antichain G, B ⊆ A :=
begin
  sorry
end

variables {W : ℕ → finset α} {i : ℕ}

-- WARNING! : INDEXED DIFFERENTLY FROM THE PDF
-- we only care about this definition for 0 ≤ i < t
def the_partial_function (W : ℕ → finset α) (𝒮 : finset (finset α)) (t : ℕ) : ℕ → finset (finset α)
| i := to_antichain $
          (𝒮.filter $
            λ S, 2 ^ (t - i) ≤ (S \ (finset.range (i+1)).bUnion W).card ∧
            ∀ j < i, ∀ X ∈ the_partial_function j, ¬ X ⊆ S).image $
          λ S, S \ (finset.range (i+1)).bUnion W

@[derive decidable]
def good_set (W : ℕ → finset α) (𝒮 : finset (finset α)) (t : ℕ) (i : ℕ) (S : finset α) : Prop :=
2 ^ (t - i) ≤ (S \ (finset.range (i+1)).bUnion W).card ∧
  ∀ j < i, ∀ X ∈ the_partial_function W 𝒮 t j, ¬ X ⊆ S

lemma the_partial_function_eq (t : ℕ) : ∀ i,
  the_partial_function W 𝒮 t i =
    to_antichain ((𝒮.filter (good_set W 𝒮 t i)).image (λ S, S \ (finset.range (i+1)).bUnion W))
| i := by { rw [the_partial_function], refl }

def the_function (W : ℕ → finset α) (𝒮 : finset (finset α)) (t : ℕ) :=
(finset.range t).bUnion (the_partial_function W 𝒮 t)

lemma part_two_a_helper (ht : 1 ≤ t) (S) (h : ¬ S ⊆ (finset.range t).bUnion W) :
  ∃ i ∈ finset.range t, 2 ^ (t - i) ≤ (S \ (finset.range (i + 1)).bUnion W).card :=
begin
  sorry
end

lemma part_two_a_helper' (ht : 1 ≤ t) (S) (h : ¬ S ⊆ (finset.range t).bUnion W) :
  ((finset.range t).filter
    (λ i, 2 ^ (t - i) ≤ (S \ (finset.range (i + 1)).bUnion W).card)).nonempty :=
begin
  sorry
end

lemma part_two (t : ℕ) :
  (∃ S ∈ 𝒮, S ⊆ (finset.range t).bUnion W) ∨
    ∀ S ∈ 𝒮, ∃ X ∈ the_function W 𝒮 t, X ⊆ S :=
begin
  sorry
end

lemma part_one_one_easy_bit (R : finset α) (h : ¬ ∃ T ∈ the_partial_function W 𝒮 t i, T ⊆ R) :
  ((the_partial_function W 𝒮 t i).filter (λ T, R = T ∪ W i)).card ≤ 2 ^ (2 ^ (t - i)) :=
begin
  sorry
end

-- lemma part_one_one_hard_bit_first_step (R : finset α)
--   (h : ∃ T ∈ the_partial_function W 𝒮 t i, T ⊆ R) :
--   ((the_partial_function W 𝒮 t i).filter (λ T, R = T ∪ W i)).card ≤ 2 ^ (2 ^ (t - i)) :=
-- begin
--   sorry
-- end

lemma part_one_one (R : finset α) :
  ((the_partial_function W 𝒮 t i).filter (λ T, R = T ∪ W i)).card ≤ 2 ^ (2 ^ (t - i)) :=
begin
  sorry
end

variables {Ω : Type*} [measurable_space Ω] {μ : measure Ω}

instance {α : Type*} : measurable_space (finset α) := ⊤

def spread_distribution (μ : measure Ω) (ε : ℝ) (UU : Ω → finset α) : Prop :=
∀ Z : finset α, (μ {ω | Z ⊆ UU ω}).to_real ≤ ε ^ Z.card

lemma spread_iff_uniform (ε : ℝ) (U : finset (finset α)) (UU : Ω → finset α)
  (hUU : pdf.is_uniform UU (U : set (finset α)) μ measure.count) :
  spread ε U ↔ spread_distribution μ ε UU :=
by sorry -- TODO: Bhavik

lemma exists_uniform {E : Type*} [measurable_space E] (s : set E) (μ : measure E) [sigma_finite μ]
  (hs : measurable_set s) :
  pdf.is_uniform id s (μ[|s]) μ :=
begin
  haveI : has_pdf (id : E → E) (μ[|s]) μ,
  { refine ⟨⟨measurable_id, s.indicator ((μ s)⁻¹ • 1), _, _⟩⟩,
    { refine measurable.indicator _ hs,
      refine measurable_one.const_smul _ },
    rw [with_density_indicator hs, with_density_smul _ measurable_one, with_density_one,
      measure.map_id],
    refl },
  change _ =ᵐ[_] _,
  apply ae_eq_of_forall_set_lintegral_eq_of_sigma_finite,
  { apply measurable_pdf },
  { exact (measurable_one.const_smul _).indicator hs },
  intros A hA hA',
  rw [←map_eq_set_lintegral_pdf (id : E → E) (μ[|s]) μ hA],
  rw lintegral_indicator _ hs,
  rw measure.map_id,
  simp only [pi.smul_apply, pi.one_apply, algebra.id.smul_eq_mul, mul_one, lintegral_const,
    measure.restrict_apply, measurable_set.univ, set.univ_inter],
  rw [cond_apply _ hs, measure.restrict_apply hs],
end

lemma exists_uniform' (ε : ℝ) (U : finset (finset α)) : ∃ (μ : measure (finset α))
  (UU : finset α → finset α), pdf.is_uniform UU (U : set (finset α)) μ measure.count :=
⟨_, _, exists_uniform _ _ measurable_space.measurable_set_top⟩
