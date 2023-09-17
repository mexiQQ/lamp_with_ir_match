CUDA_VISIBLE_DEVICES=1 python3 attack4.py --dataset rotten_tomatoes \
     --split test --loss cos --n_inputs 100 -b 1 \
     --coeff_perplexity 0.2 --coeff_reg 1 --lr 0.01 \
     --lr_decay 0.89 --tag_factor 0.01 \
     --bert_path /home/jli265/projects/lamp_with_ir_match/models/bert-base-finetuned-rotten_tomatoes \
     --n_steps 2000 \
     --coeff_pooler_match 0.0 \
     --coeff_pooler_match_margin 0.0 \
     --pooler_match_for_init no \
     --pooler_match_for_optimization no \
     --pooler_match_for_swap no


