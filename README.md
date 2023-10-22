Сборник справочных материалов для развертывания витруальных машин средствами Oracle VirtualBox & Vagrant, а также Amazon AWS. Составлен по итогам освоения дорожной карты ДевОпс 2022.

СОДЕРЖАНИЕ
----------
- 43-multivm/             - Ubuntu18+Apache2 & Centos7+MariaDB;
- 60-containerintro/      - запуск гостевой Ubuntu18.04 при помощи Vagrant & Oracle Virtualbox, установка на ней Docker Community Edition и последующий запуск на виртуальном хосте двух вебсерверов: NGINX и Apache2;
- 63-EMart/               - запуск гостевой Ubuntu20.04 при помощи Vagrant & Oracle Virtualbox, установка на ней Docker Community Edition и последующий запуск на виртуальном хосте электронного магазина, имеющего микросервисную архитектуру;
- python_scripts/         - установщик pip3, добавление пользвателей, проверка файл/директория, установщик Apache2 `httpd` для CentOS7;
- vprofile_project/       - сценарии Vagrant для развертывания инфораструктуры из пяти виртуальных компьютеров. Это база для более сложных проектов IaC;
- website41/              - CentOS7+httpd + статический сайт фитнесс-клуба (для примера еще что-то);
- wordpress_ubuntu20/     - сценарий Vagrant для запуска витруального компьютера Ubuntu20+Apache2+Wordpress;
- Vagrantfile_CentOS7     - пример простого сценария Vagrant для CentOS7;
- Vagrantfile_centos7_uh  - пример простого сценария Vagrant для CentOS7+httpd;
- Vagrantfile_ubuntu18+go - CentOS7+go1.21+mc;

...а потом чем дальше, тем все глубже и глубже ;о)
