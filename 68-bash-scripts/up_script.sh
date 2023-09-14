#!/bin/bash

# Скрипт для автоматического сохранения ключей в рабочую папку ssh и создания для них ярлыков

INSTANCES="scriptbox web01 web02 web03"

for vm in $INSTANCES; do
  vagrant up $vm &>> $PWD/vagrant_up.log
  current_key_path="$PWD/.vagrant/machines/$vm/virtualbox/private_key"
  ssh_key_path="$HOME/vagrant_$vm"+"_private_key"
  mv -f $current_key_path $ssh_key_path &>> $PWD/vagrant_up.log
  ln -sr $ssh_key_path $current_key_path &>> $PWD/vagrant_up.log
  vagrant $vm reload --provision &>> $PWD/vagrant_up.log
done