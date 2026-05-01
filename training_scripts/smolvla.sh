#!/bin/bash
#SBATCH --partition=a40
#SBATCH --gres=gpu:1
#SBATCH --mem=24G
#SBATCH --cpus-per-task=4
#SBATCH --time=16:00:00
#SBATCH --output=train_%j.out

echo "Job ID: $SLURM_JOB_ID"
echo "Running on node: $(hostname)"
echo "Allocated CPUs: $SLURM_CPUS_ON_NODE"
echo "Allocated Memory: $SLURM_MEM_PER_NODE"
echo "Allocated GPU(s):"
nvidia-smi
echo "Free RAM:"
free -h
echo "Disk space in /tmp:"
df -h /tmp
echo "-------------------------"
export PYTHONUNBUFFERED=1
export CUDA_VISIBLE_DEVICES=0

# activate virtual environment
source /vol/bitbucket/mdp25/lerobot310/bin/activate

export HF_HOME=/vol/dissolve/matt/hf_cache
export TRANSFORMERS_CACHE=/vol/dissolve/matt/hf_cache
export HF_DATASETS_CACHE=/vol/dissolve/matt/hf_cache
hf auth login

lerobot-train    --dataset.repo_id=justintiensmith/red_block_precision-multicolour_block_pick_place   --policy.path=lerobot/smolvla_base   --output_dir=/vol/bitbucket/mdp25/outputs/smolvlablockpolicy68   --job_name=smolvla_training   --batch_size=32   --steps 30000   --save_freq 5000   --policy.device=cuda   --policy.repo_id=mattpidden/smolvla_30k_precision-multicolour_block_pick_place   --rename_map='{"observation.images.wrist": "observation.images.camera1", "observation.images.world": "observation.images.camera2"}'
