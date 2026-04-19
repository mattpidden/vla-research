# Week 1 – SO101 Setup + First VLA Experiments

## Setup + Initial Testing

This week was mainly about getting everything working end-to-end.

I set up the SO101 robot arm and followed the lerobot installation steps to create a Python environment. The install was mostly smooth. After that, I calibrated the arms (setting joint/motor limits) and spent some time teleoperating to get comfortable controlling the follower arm.

## Task + Dataset (v1)

The task was: pick up an apple and place it into a white ceramic bowl.

I collected an initial dataset of **20 episodes** using:

* a wrist-mounted camera on the follower arm
* a world camera on a tripod (top-down view)

Demonstrations were done left → right with some variation in positions.

## Training + First Results

I trained **SmolVLA** (lerobot’s small VLA model). Running this on Imperial’s GPU cluster (Slurm) took a while due to dependency issues and some OOM problems, but eventually I got it working via the lerobot CLI on an A40/A100.

Inference was run locally on a 4090 using the async server. Speed was good (~0.1s per step), but performance was very poor:

* robot consistently failed to grasp the apple
* often missed the object entirely
* if helped into a grasp, it sometimes moved toward the bowl and dropped it nearby

Overall success rate: **~0%**

It did seem like the model partially understood the task (move → bowl), but grasping was the clear failure point.

## Dataset (v2) + Improvement

I then collected **30 more episodes** (50 total), but reduced task variability:

* apple and bowl positions constrained to tighter regions
* still some variation, but more consistent setup

After fine-tuning again, performance improved:

* **~30% success rate (3/10 trials)**
* successful runs completed within ~60 seconds

Still inconsistent, but a clear step up from before.

## Takeaways

* 20 demos is not enough for this task
* ~50 demos starts to produce usable behaviour
* grasping is the main bottleneck
* dataset consistency matters a lot

## Next Steps

* improve quality of grasp demonstrations
* increase dataset size further
* experiment with other policies (pi0.5, ACT)
* potentially adjust camera setup / resolution
