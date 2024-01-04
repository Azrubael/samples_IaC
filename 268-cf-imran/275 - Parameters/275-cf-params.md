# 2024-01-04  17:12
===================

* 275 - Parameters
------------------

# Parameters
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/parameters-section-structure.html

Используйте дополнительный раздел «Параметры», чтобы настроить шаблоны. Параметры позволяют вводить пользовательские значения в шаблон каждый раз, когда вы создаете или обновляете стек.

Example:
---
Parameters:
  InstanceTypeParameter:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - m1.small
      - m1.large
    Description: Enter t2.micro, m1.small, or m1.large. Default is t2.micro.

