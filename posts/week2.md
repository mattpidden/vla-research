# Week 2 – Policy Comparisons + Dataset Scaling

## Pi0.5 on Apple Dataset

I started by training **pi0.5** on the same 50-episode apple dataset. Initially I tried pi0 / pi0-fast but ran into issues getting them to fine-tune, so moved to pi0.5 (also expected to generalise better).

Training was done with:

* `freeze_vision_encoder=false`
* `train_expert_only=true`
* `steps=40000`

In hindsight, these settings were probably not ideal (likely overfitting + wrong parts of the model being trained).

Inference ran at ~0.2s on the 4090. Performance was similar to SmolVLA (~30% success), but behaviour was noticeably different:

* pi0.5 moved **confidently and decisively**
* SmolVLA felt **slow, twitchy, and hesitant**

## ACT Model

I also trained an **ACT policy** (10k steps) on the same dataset.

* smoother motion than both pi0.5 and SmolVLA
* slightly better performance (~40% success)
* generally more stable execution

## Key Failure Mode (All Policies)

Across all models, the same issue showed up:

* **grasping is the bottleneck**
* models often miss the apple by a small margin
* then enter a loop: re-approach → miss → jitter → repeat
* rarely recover once the first grasp fails

If the object *was* picked up:

* placing into the bowl was usually successful
* high success once grasp achieved

So effectively:

> first grasp attempt ≈ determines the whole trajectory

## Hypotheses

A few possible reasons for poor grasping:

* apple is quite large → gripper needs to fully open
* shiny surface → reflections / visual ambiguity
* top-down camera → mostly 2D (x, y), limited depth information

Better setup might be:

* smaller object
* less reflective surface
* angled camera (adds depth cues)

## New Dataset (Lego Duplo Blocks)

Based on this, I created a new dataset:

* **200 episodes total**
* 4 block colours (red, green, blue, yellow), same shape/size
* 50 episodes per colour
* task: pick up block → place in black desktop bin
* data collection time: ~2 hours

## Training Experiments

Trained multiple variants of:

* pi0.5
* SmolVLA
* ACT

Varying:

* number of steps
* training flags
* which parts of model were frozen

## Results

Overall, results were disappointing.

* all models still struggled with grasping
* success rates remained low (~30–40%)
* same failure mode persisted (miss → retry loop)

One notable result:

* **pi0.5 successfully conditioned on task language**

  * correctly selected the specified colour block
  * e.g. “pick up the red block…” → goes to red block
* but still failed frequently due to grasping

## Takeaways

* scaling dataset (50 → 200) did not solve grasping
* failure is consistent across architectures
* grasping ≠ solved by more data alone (at this scale)
* pi0.5 shows better semantic understanding (task conditioning)

## Overall Reflection

End of week feeling: fairly dissatisfied.

The models are not performing as expected compared to demos online (which show much harder tasks with high success rates ~80–90%). There is clearly something missing — either in:

* data quality
* setup (camera / object / embodiment)
* training configuration
* or overall system design

## Next Steps

* improve camera setup (add angled view / depth cues)
* simplify grasping further
* investigate training configs more carefully
* understand what differs from successful VLA demos
