#!/bin/bash
# Validation-only script
sf project deploy validate \
    --target-org PropertyHub-Dev \
    --test-level RunLocalTests \
    --wait 30