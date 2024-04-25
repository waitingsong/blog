#!/bin/bash

# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/


curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

kubectl version --client

kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
sudo chmod a+r /etc/bash_completion.d/kubectl

echo 'complete -o default -F __start_kubectl k' >>~/.bashrc





