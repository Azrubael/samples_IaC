# 2024-01-03  16:40
===================

* 270 - Intrinsic Function
--------------------------

# Intrinsic function reference
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference.html

# Fn::Join
https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/intrinsic-function-reference-join.html
# The intrinsic function Fn::Join appends a set of values into a single value, separated by the specified delimiter. If a delimiter is the empty string, the set of values are concatenated with no delimiter.
# Встроенная функция Fn::Join присоединяет список значений в одну строку, используя для об`единения указанньій разделитель. Если разделитель представляет собой пустую строку, набор значений объединяется без разделителя.

Fn::Join: [ delimiter, [ comma-delimited list of values ] ]
# OR
!Join [ delimiter, [ comma-delimited list of values ] ]

  $ mkdir '270 - Intrinsic Function'
  $ cd '270 - Intrinsic Function'
  $ vim 270-functions.yaml
---
Resources:
  MyInstance:
    Type: AWS::EC2::Instance
    Properties:
      InstanceType: t2.micro
      ImageId:  ami-00b8917ae86a424c9  # Amazon Linux 2  us-east-1
      Tags:
        - Key: "Name"
          Value: !Join [ "-", [my,inst,from,AWS,CloudFormation] ]

> AWS > CloudFormation > *Create stack* > 'Template is ready' >
  'Upload a template file' > 'Choose file' > 270-functions.yaml >
  Next > *Create stack* > Submit