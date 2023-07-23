# CUDA_VISIBLE_DEVICES=2 ./lamp_cos3.sh /hdd1/jianwei/workspace/lamp/models/bert-base-finetuned-sst2 sst2 2
# CUDA_VISIBLE_DEVICES=3 ./lamp_cos3.sh /hdd1/jianwei/workspace/lamp/models/bert-base-uncased sst2 2
CUDA_VISIBLE_DEVICES=2 ./lamp_cos3.sh /hdd1/jianwei/workspace/lamp/outputs/finetune_glue-sst2_lr2e-05_epochs1_seed302_time1690088507223 sst2 2

