#!/bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH --mem=2200m
#SBATCH -p qTRDGPU
#SBATCH --gres=gpu:RTX:1
#SBATCH -t 1-00:00
#SBATCH -J pialnnl
#SBATCH -e jobs/error%A.err
#SBATCH -o jobs/out%A.out
#SBATCH -A psy53c17
#SBATCH --mail-type=ALL
#SBATCH --mail-user=washbee1@student.gsu.edu
#SBATCH --oversubscribe
#SBATCH --nodelist=arctrdagn001

sleep 5s
echo "aa"
source /usr/share/lmod/lmod/init/bash
module use /application/ubuntumodules/localmodules
module load singularity/3.10.2


# Start the monitoring script in the background

echo "bb"

python monitor.py &
MONITOR_PID=$!

#singularity exec --nv --bind /data,/data/users2/washbee/speedrun/hcp-plis-subj-pialnn-201818:/data-pialnn/,/data/users2/washbee/speedrun/PialNN_fork:/pialnn,/data/users2/washbee/speedrun/hcp-plis-subj-pialnn-rp:/subj/ /data/users2/washbee/containers/speedrun/pialnn_sr_v2_sandbox/ /pialnn/singularity/benchmarks/bm.eval.sh &
singularity exec --nv --bind /data,/data/users2/washbee/speedrun/hcp-plis-subj-pialnn-201818:/data-pialnn/,/data/users2/washbee/speedrun/PialNN_fork:/pialnn /data/users2/washbee/containers/speedrun/pialnn_sr.sif /pialnn/singularity/benchmarks/bm.predict.sh &
# Start the PyTorch inference script in the background
PYTORCH_PID=$!


# Wait for the PyTorch script to finish
wait $PYTORCH_PID

# After the PyTorch script has finished, terminate the monitoring script
kill $MONITOR_PID

echo "PyTorch inference and monitoring have completed."
sleep 10s

