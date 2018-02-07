#!/bin/sh
#
# This file calls train.py with all hyperparameters as for the TriNet
# experiment on market1501 in the original paper.

# Shift the arguments so that we can just forward the remainder.
CLS_LOSS_WEIGHT=1.0
METRIC='euclidean'
HEADS='fc1024_cls_projection'
BACKBONE='resnet_v2_50'
EXPR_NAME='_3'

IMAGE_ROOT=/data2/wangq/VD1/ ; shift
INIT_CHECKPT=./pretrained_models/resnet_v2_50.ckpt ; shift
EXP_ROOT=./experiments/pku-vd/expr_cls_${METRIC}_${CLS_LOSS_WEIGHT}_${HEADS}_${BACKBONE}${EXPR_NAME} ; shift

python train.py \
    --train_set data/pku-vd/VD1_train_cls.csv \
    --model_name ${BACKBONE} \
    --image_root $IMAGE_ROOT \
    --initial_checkpoint $INIT_CHECKPT \
    --experiment_root $EXP_ROOT \
    --flip_augment \
    --crop_augment \
    --detailed_logs \
    --embedding_dim 128 \
    --batch_p 18 \
    --batch_k 4 \
    --pre_crop_height 300 --pre_crop_width 300 \
    --net_input_height 224 --net_input_width 224 \
    --margin soft \
    --metric ${METRIC} \
    --loss batch_hard \
    --head_name ${HEADS} \
    --learning_rate 1e-5 \
    --train_iterations 400000 \
    --decay_start_iteration 0 \
    --cls_loss_weight ${CLS_LOSS_WEIGHT} \
    --lr_decay_factor 0.8 \
    --lr_decay_steps 20000 \
    --weight_decay_factor 0.0005 \
    "$@"
    # --resume \