#!/bin/bash
#SBATCH --partition=a100,a40
#SBATCH --gres=gpu:1
#SBATCH --mem=64G
#SBATCH --cpus-per-task=4
#SBATCH --time=24:00:00
#SBATCH --output=train_%j_vla0.out

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
conda activate /vol/dissolve/matt/envs/vla0

export HF_HOME=/vol/dissolve/matt/hf_cache
export TRANSFORMERS_CACHE=/vol/dissolve/matt/hf_cache
export HF_DATASETS_CACHE=/vol/dissolve/matt/hf_cache
#hf auth login
hf auth whoami

cd /vol/dissolve/matt/models/vla0
#cd libs/RoboVerse
#PIP_REQ_EXTRAS=lerobot pip install --no-build-isolation -e ".[lerobot]"
#cd ../..

python -m rv_train.train --exp-config configs/vla_so101.yaml
