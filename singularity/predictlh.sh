#!/bin/bash
. /opt/miniconda3/bin/activate pialnn
cd /pialnn
python predict.py --data_path=/data-pialnn/ --hemisphere=lh --save_mesh_eval=True --model_path='./ckpts/model/pialnn_model_lh_200epochs.pt'

