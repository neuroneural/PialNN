#!/bin/bash
#SBATCH -n 1
#SBATCH -c 4
#SBATCH -p qTRDGPU
#SBATCH --gres=gpu:RTX:1
#SBATCH -t 1-00:00
#SBATCH -J bmpialnn  # Optionally include task ID in job name if provided
#SBATCH -e jobs/error%A.err
#SBATCH -o jobs/out%A.out
#SBATCH -A psy53c17
#SBATCH --mail-type=ALL
#SBATCH --mail-user=washbee1@student.gsu.edu
#SBATCH --oversubscribe

# Define CSV files paths
success_csv_file="memory_usage_success.csv"
failure_csv_file="memory_usage_failure.csv"

sleep 5s
echo "aa"
source /usr/share/lmod/lmod/init/bash
module use /application/ubuntumodules/localmodules
module load singularity/3.10.2

echo "bb"

python monitor.py &
MONITOR_PID=$!

# Reset SECONDS to 0 to start timing
SECONDS=0

# Run the command and capture its PID
singularity exec --nv --bind /data,/data/users2/washbee/speedrun/hcp-plis-subj-pialnn-201818:/data-pialnn/,/data/users2/washbee/speedrun/PialNN_fork:/pialnn /data/users2/washbee/containers/speedrun/pialnn_sr.sif /pialnn/singularity/benchmarks/bm.predict.sh &
PYTORCH_PID=$!

# Wait for the singularity command to finish
wait $PYTORCH_PID
exit_status=$?

# Capture the duration
duration=$SECONDS

# After the command has finished, terminate the monitoring script
kill $MONITOR_PID

# Check if the command was successful
if [ $exit_status -eq 0 ]; then
    # Log success to CSV, using memory value passed to script
    echo "$(date),${1},${duration}" >> "${success_csv_file}"
    echo "Command executed successfully, memory usage and execution time logged to ${success_csv_file}."
else
    # Log failure to CSV, with exit status
    echo "$(date),Failed with exit status ${exit_status}, Memory Allocated: ${1}MB, Execution Time: ${duration} seconds" >> "${failure_csv_file}"
    echo "Command failed, error and execution time logged to ${failure_csv_file}."
fi

echo "PyTorch inference and monitoring have completed."
sleep 5s
