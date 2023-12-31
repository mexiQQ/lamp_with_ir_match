#!/bin/bash
#SBATCH --job-name=attack_job
#SBATCH --output=job_logs/logs_%j.out
#SBATCH --error=job_logs/logs_%j.err
#SBATCH --partition=a6000
#SBATCH --nodelist=c31
#SBATCH --exclusive

cd /home/jli265/projects/lamp_with_ir_match
source ~/.bashrc
conda activate lamp

run_on_gpu() {
    local gpu_id="$1"
    local output_file="$2"
    local coeff_pooler_match="$3"
    local coeff_pooler_match_margin="$4"
    local pooler_match_for_init="$5"
    local pooler_match_for_optimization="$6"
    local pooler_match_for_swap="$7"
    local batch_size="$8"
    local n_input="$9"

    CUDA_VISIBLE_DEVICES=$gpu_id python3 attack4.py \
        --dataset sst2 --split test --loss cos --n_inputs $n_input \
        -b $batch_size --coeff_perplexity 0.2 --coeff_reg 1 --lr 0.01 \
        --lr_decay 0.89 --tag_factor 0.01 \
        --bert_path /home/jli265/projects/lamp_with_ir_match/models/bert-base-finetuned-sst2 \
        --n_steps 2000 --coeff_pooler_match $coeff_pooler_match --coeff_pooler_match_margin $coeff_pooler_match_margin \
        --pooler_match_for_init $pooler_match_for_init --pooler_match_for_optimization $pooler_match_for_optimization \
        --pooler_match_for_swap $pooler_match_for_swap > $output_file 2>&1 &
}

# Create output directories
mkdir -p logs_c31-sst2 

# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output1.log" 0.1 0.0 "no" "yes" "no" 1 100

# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output2.log" 1 0.0 "no" "yes" "no" 1 100

# Run the command on GPU 2 
# run_on_gpu 2 "logs_c31-sst2/output3.log" 5 0.0 "no" "yes" "no" 1 100

# Run the command on GPU 3 
# run_on_gpu 3 "logs_c31-sst2/output4.log" 0.0 0.0 "no" "no" "no" 1 100


# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output5.log" 0.1 0.0 "no" "yes" "no" 2 50

# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output6.log" 0.1 0.0 "no" "yes" "no" 4 25

# Run the command on GPU 2 
# run_on_gpu 2 "logs_c31-sst2/output7.log" 0.1 0.0 "no" "yes" "no" 8 13

# Run the command on GPU 3 
# run_on_gpu 3 "logs_c31-sst2/output8.log" 0.0 0.0 "no" "no" "no" 2 50


# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output9.log" 0.0 0.0 "no" "no" "no" 4 25

# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output10.log" 0.0 0.0 "no" "no" "no" 8 13

# Run the command on GPU 2 
# run_on_gpu 2 "logs_c31-sst2/output11.log" 0.0 0.0 "yes" "no" "yes" 1 100

# Run the command on GPU 3 
# run_on_gpu 3 "logs_c31-sst2/output12.log" 0.1 0.1 "no" "yes" "no" 1 100


# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output13.log" 0.1 0.0 "no" "yes" "no" 1 100

# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output14.log" 0.1 0.0 "no" "yes" "no" 2 50

# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output15.log" 0.1 0.0 "no" "yes" "no" 4 25

# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output16.log" 0.1 0.0 "no" "yes" "no" 8 13


# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output17.log" 0.1 0.1 "no" "yes" "no" 1 100

# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output18.log" 0.1 0.1 "no" "yes" "no" 2 50

# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output19.log" 0.1 0.1 "no" "yes" "no" 4 25

# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output20.log" 0.1 0.1 "no" "yes" "no" 8 13


# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output21.log" 0.08 0.0 "no" "yes" "no" 2 50 

# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output22.log" 0.05 0.0 "no" "yes" "no" 2 50

# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output23.log" 0.03 0.0 "no" "yes" "no" 2 50 

# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output24.log" 0.01 0.0 "no" "yes" "no" 2 50 


# Activation relu
# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output25.log" 0.1 0.0 "no" "yes" "no" 1 100 


# Activation relu
# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output26.log" 0.5 0.0 "no" "yes" "no" 1 100


# Activation relu
# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output27.log" 1 0.0 "no" "yes" "no" 1 100 


# Activation relu
# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output28.log" 5 0.0 "no" "yes" "no" 1 100 


# Activation relu
# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output29.log" 0.08 0.0 "no" "yes" "no" 1 100 


# Activation relu
# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output30.log" 0.05 0.0 "no" "yes" "no" 1 100


# Activation relu
# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output31.log" 0.03 0.0 "no" "yes" "no" 1 100 


# Activation relu
# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output32.log" 0.01 0.0 "no" "yes" "no" 1 100 



# Activation selu
# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output33.log" 0.1 0.0 "no" "yes" "no" 1 100 

# Activation selu
# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output34.log" 0.5 0.0 "no" "yes" "no" 1 100

# Activation selu
# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output35.log" 1 0.0 "no" "yes" "no" 1 100 

# Activation selu
# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output36.log" 0.0 0.0 "no" "no" "no" 1 100 


# Activation selu
# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output37.log" 0.08 0.0 "no" "yes" "no" 1 100 

# Activation selu
# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output38.log" 0.05 0.0 "no" "yes" "no" 1 100

# Activation selu
# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output39.log" 0.03 0.0 "no" "yes" "no" 1 100 

# Activation selu
# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output40.log" 0.01 0.0 "no" "yes" "no" 1 100 


# Activation selu
# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output41.log" 0.1 0.0 "no" "yes" "no" 2 50

# Activation selu
# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output42.log" 0.05 0.0 "no" "yes" "no" 2 50

# Activation selu
# Run the command on GPU 2
# run_on_gpu 2 "logs_c31-sst2/output43.log" 0.1 0.0 "no" "yes" "no" 4 25 

# Activation selu
# Run the command on GPU 3
# run_on_gpu 3 "logs_c31-sst2/output44.log" 0.05 0.0 "no" "yes" "no" 4 25


# Activation selu
# Run the command on GPU 0
# run_on_gpu 0 "logs_c31-sst2/output45.log" 0.1 0.0 "no" "yes" "no" 8 13 

# Activation selu
# Run the command on GPU 1
# run_on_gpu 1 "logs_c31-sst2/output46.log" 0.05 0.0 "no" "yes" "no" 8 13

# Activation selu
# Run the command on GPU 0
# run_on_gpu 2 "logs_c31-sst2/output47.log" 0.08 0.0 "no" "yes" "no" 2 50

# Activation selu
# Run the command on GPU 1
# run_on_gpu 3 "logs_c31-sst2/output48.log" 0.03 0.0 "no" "yes" "no" 2 50

# Run the command on GPU 0 
run_on_gpu 0 "logs_c31-sst2/output49.log" 0.05 0.0 "yes" "yes" "yes" 4 25 

# Run the command on GPU 1 
run_on_gpu 1 "logs_c31-sst2/output50.log" 0.05 0.0 "yes" "yes" "yes" 2 50 

# Run the command on GPU 2 
run_on_gpu 2 "logs_c31-sst2/output51.log" 0.05 0.0 "yes" "yes" "yes" 1 100 

# Run the command on GPU 3 
run_on_gpu 3 "logs_c31-sst2/output52.log" 0.05 0.0 "yes" "yes" "yes" 8 13

# Wait for both commands to complete
wait

cd ~/GrabGPU
./gg 24 72 0,1,2,3


