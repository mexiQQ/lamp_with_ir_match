CUDA_VISIBLE_DEVICES=0 python3 attack5.py --dataset sst2 \
     --split test --loss cos --n_inputs 25 -b 4 \
     --coeff_perplexity 0.2 --coeff_reg 1 --lr 0.01 \
     --lr_decay 0.89 --tag_factor 0.01 \
     --bert_path /home/jli265/projects/lamp_with_ir_match/models/bert-base-finetuned-sst2 \
     --n_steps 2000 \
     --coeff_pooler_match 1 \
     --coeff_pooler_match_margin 0.0 \
     --pooler_match_for_init no \
     --pooler_match_for_optimization yes \
     --pooler_match_for_swap no 


