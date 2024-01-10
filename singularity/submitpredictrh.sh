#!/bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --mem=30g
#SBATCH -p qTRDGPU
#SBATCH --gres=gpu:RTX:1
#SBATCH -t 1-00:00
#SBATCH -J ppredr
#SBATCH -e jobs/error%A.err
#SBATCH -o jobs/out%A.out
#SBATCH -A psy53c17
#SBATCH --mail-type=ALL
#SBATCH --mail-user=washbee1@student.gsu.edu
#SBATCH --oversubscribe


sleep 5s
echo "aa"
source /usr/share/lmod/lmod/init/bash
module use /application/ubuntumodules/localmodules
module load singularity/3.10.2
echo "bb"
singularity exec --nv --bind /data,/data/users2/washbee/speedrun/hcp-plis-subj-pialnn-rp:/data-pialnn/,/data/users2/washbee/speedrun/PialNN_fork:/pialnn /data/users2/washbee/containers/speedrun/pialnn_sr.sif /pialnn/singularity/predictrh.sh &
echo "CC"
wait

sleep 10s

