#!/bin/bash
#SBATCH --partition=a100,a40
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00
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

export PATH="$HOME/miniconda3/bin:$PATH"
source $HOME/miniconda3/etc/profile.d/conda.sh
conda activate /vol/dissolve/matt/envs/lerobot

export HF_HOME=/vol/dissolve/matt/hf_cache
export HF_DATASETS_CACHE=/vol/dissolve/matt/hf_cache
hf auth login

lerobot-train \
  --dataset.repo_id=justintiensmith/red_block_precision-multicolour_block_pick_place \
  --policy.type=act \
  --output_dir=/vol/dissolve/matt/outputs/actblockpolicy18 \
  --job_name=acttraining \
  --steps=100000 \
  --batch_size=32 \
  --save_freq=10000 \
  --policy.device=cuda \
  --policy.repo_id=mattpidden/act_100k_precise-multicolour_block_pick_place
