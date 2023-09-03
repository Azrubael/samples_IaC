Сборник справочных материалов для развертывания витруальных машин средствами Oracle VirtualBox & Vagrant. Составлен по итогам освоения дорожной карты ДевОпс 2022.

СОДЕРЖАНИЕ
----------
- multivm/                - Ubuntu18+Apache2 & Centos7+MariaDB;
- python_scripts/         - установщик pip3, добавление пользвателей, проверка файл/директория, установщик Apache2 `httpd` для CentOS7;
- vprofile_project/       - сценарии Vagrant для развертывания инфораструктуры из пяти виртуальных компьютеров. Это база для более сложных проектов IaC;
- website41/              - CentOS7+httpd + статический сайт фитнесс-клуба (для примера еще что-то).
- wordpress_ubuntu20/     - сценарий Vagrant для запуска витруального компьютера Ubuntu20+Apache2+Wordpress;
- Vagrantfile_CentOS7     - пример простого сценария Vagrant для CentOS7;
- Vagrantfile_centos7_uh  - пример простого сценария Vagrant для CentOS7+httpd;
- Vagrantfile_ubuntu18+go - CentOS7+go1.21+mc;
