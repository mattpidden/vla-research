# vla-research

Training Cluster
```bash
ssh mdp25@gpucluster3.doc.ic.ac.uk

export HF_HOME=/vol/dissolve/matt/hf_cache
export TRANSFORMERS_CACHE=/vol/dissolve/matt/hf_cache
export HF_DATASETS_CACHE=/vol/dissolve/matt/hf_cache

nano train.sbatch
sbatch train.sbatch
tail -f outputfile
watch -n 10 squeue --me
```

Inference Server
```bash
ssh mdp25@devi.doc.ic.ac.uk
ssh -L 8080:localhost:8080 mdp25@devi.doc.ic.ac.uk

export HF_HOME=/vol/dissolve/matt/hf_cache
export TRANSFORMERS_CACHE=/vol/dissolve/matt/hf_cache
export HF_DATASETS_CACHE=/vol/dissolve/matt/hf_cache
export PIP_CACHE_DIR=/vol/dissolve/matt/pip_cache

export TORCHINDUCTOR_DISABLE=1
export TORCH_COMPILE_DISABLE=1
export CUDA_LAUNCH_BLOCKING=1

export PATH="$HOME/miniconda3/bin:$PATH"
source ~/.bashrc
conda activate /vol/dissolve/matt/envs/lerobot
conda config --add pkgs_dirs /vol/dissolve/matt/conda_pkgs
conda config --add envs_dirs /vol/dissolve/matt/envs

python -m lerobot.async_inference.policy_server      --host=127.0.0.1      --port=8080
```

Local Client
```bash
lerobot-port-find

lerobot-teleoperate     --robot.type=so101_follower     --robot.port=/dev/ttyACM0  --robot.id=blue_follower_arm     --teleop.type=so101_leader     --teleop.port=/dev/ttyACM1 --teleop.id=orange_leader_arm   --robot.cameras="{ camera1: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, camera2: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 30}}" --display_data=true

lerobot-record --robot.type=so101_follower --robot.port=/dev/ttyACM0 --robot.id=blue_follower_arm --robot.cameras="{wrist: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, world: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 30}}" --teleop.type=so101_leader --teleop.port=/dev/ttyACM1 --teleop.id=orange_leader_arm --display_data=true --dataset.repo_id=mattpidden/multicolour_block_pick_place --dataset.num_episodes=50 --dataset.single_task="Pick up the red block and carefully place it in the black bin" --dataset.streaming_encoding=false --dataset.encoder_threads=4 --dataset.fps=15

# use these flags if adding more episodes to a dataset that already exists:
--resume=true --dataset.root=./data/smol-vla-test-dataset


python -m lerobot.async_inference.robot_client     --server_address=127.0.0.1:8080     --robot.type=so101_follower     --robot.port=/dev/ttyACM0     --robot.id=blue_follower_arm     --robot.cameras="{camera1: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, camera2: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 30}}"     --task="Put the apple in the bowl"     --policy_type=smolvla     --pretrained_name_or_path=mattpidden/smolvla_apple_policy     --policy_device=cuda     --actions_per_chunk=2     --chunk_size_threshold=0     --aggregate_fn_name=weighted_average     --debug_visualize_queue_size=True



```
