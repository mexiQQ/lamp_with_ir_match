CUDA_VISIBLE_DEVICES=0 ./lamp_l1l2_2.sh /home/jli265/projects/lamp_with_ir_match/models/bert-base-uncased sst2 1 --coeff_pooler_match 1.0 --coeff_pooler_match_margin 0.0 --pooler_match_for_init no --pooler_match_for_optimization no --pooler_match_for_swap no --pretraining-weights yes 

