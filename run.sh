#!/bin/bash

terraform apply

terraform output -json > ../llm_server/output.json