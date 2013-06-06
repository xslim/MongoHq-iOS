#!/bin/sh -x

MODEL_NAME="MongoHq"
MODEL_DIR="Models"
mogenerator --template-var arc=true \
  -m ${MODEL_DIR}/${MODEL_NAME}.xcdatamodeld/*.xcdatamodel \
  -M ${MODEL_DIR}/Machine -H ${MODEL_DIR}/Human \
  --includeh=${MODEL_DIR}/models.h
