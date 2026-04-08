# vla-research

```bash
export HF_HOME=/vol/dissolve/matt/hf_cache
export TRANSFORMERS_CACHE=/vol/dissolve/matt/hf_cache
export HF_DATASETS_CACHE=/vol/dissolve/matt/hf_cache

conda activate /vol/dissolve/matt/envs/lerobot

python -m lerobot.async_inference.policy_server      --host=127.0.0.1      --port=8080
```

```bash
lerobot-teleoperate     --robot.type=so101_follower     --robot.port=/dev/ttyACM0  --robot.id=blue_follower_arm     --teleop.type=so101_leader     --teleop.port=/dev/ttyACM1 --teleop.id=orange_leader_arm   --robot.cameras="{ camera1: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, camera2: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 30}}" --display_data=true

python -m lerobot.async_inference.robot_client     --server_address=127.0.0.1:8080     --robot.type=so101_follower     --robot.port=/dev/ttyACM0     --robot.id=blue_follower_arm     --robot.cameras="{camera1: {type: opencv, index_or_path: 2, width: 640, height: 480, fps: 30}, camera2: {type: opencv, index_or_path: 4, width: 640, height: 480, fps: 30}}"     --task="Put the apple in the bowl"     --policy_type=smolvla     --pretrained_name_or_path=mattpidden/smolvla_apple_policy     --policy_device=cuda     --actions_per_chunk=2     --chunk_size_threshold=0     --aggregate_fn_name=weighted_average     --debug_visualize_queue_size=True


```
