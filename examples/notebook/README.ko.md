[[English](README.md)] [[한국어](README.ko.md)]

# 세이지 메이커 노트북 (SageMaker Notebook)
[세이지 메이커 노트북 인스턴스](https://docs.aws.amazon.com/sagemaker/latest/dg/nbi.html)는 기계학습 (ML)을 위한 쥬피터 노트북을 실행하는 컴퓨팅 자원입니다. 세이지 메이커 노트북 인스턴스는 자료 전처리, 학습을 위한 코드를 작성, 모델 배포를 위한 호스팅, 그리고 모델을 확인하고 검증하는 것을 지원합니다.

## 세이지 메이커 스튜디오와 노트북 인스턴스의 차이점
처음 노트북을 생성하려고 한다면, 세이지 메이커 노트북보다는 세이지 메이커 스튜디오를 사용하시길 권장합니다. 세이지 메이커 스튜디오는 아래와 같은 많은 장점이 있기 때문입니다:
- 세이지 메이커 스튜디오 노트북은 인스턴스 기반의 노트북보다 빨리 생성됩니다. 일반적으로 인스턴스 기반의 노트북보다 5-10 배 정도 빠릅니다.
- 세이지 메이커 스튜디오에서는 노트북 공유 기능이 제공됩니다. 사용자는 단 몇 번의 클릭만으로, 노트북 코드를 재생성할 수 있는 공유 가능한 링크를 만들수 있습니다. 또한 이 링크는 세이지 메이커 이미지가 실행할 때 사용할 수 있습니다.
- 세이지 메이커 스튜디오에는 가장 최신의 세이지 메이커 파이썬 SDK가 미리 설치 되어 있습니다.
- 세이지 메이커 스튜디오 노트북들은 스튜디오안에서 접근 가능합니다. 이 기능은 여러 분이 스튜디오를 벗어나지 않고 그 안에서 모델 빌드, 기계학습, 디버그, 모니터를 할 수 있도록 합니다.

보다 자세한 정보는, [여기](https://docs.aws.amazon.com/sagemaker/latest/dg/notebooks-comparison.html) 개발자 안내서를 참고하시기 바랍니다.

## 예제 내려받기
여러 분의 실습환경에 예제를 저장합니다.
```sh
git clone https://github.com/Young-ook/terraform-aws-sagemaker
cd terraform-aws-sagemaker/examples/notebook
```

## Setup
[예제](https://github.com/Young-ook/terraform-aws-sagemaker/blob/main/examples/notebook/main.tf)는 세이지 메이커 노트북 인스턴스를 생성하기 위한 테라폼 설정 예제 입니다. 내용을 확인한 다음 아래 안내를 따라 테라폼 명령을 수행합니다.

만약, 테라폼이 실습 환경에 없다면 메인 [페이지](https://github.com/Young-ook/terraform-aws-sagemaker#terraform)로 이동해서 설치 안내를 따라합니다.

테라폼 실행:
```
terraform init
```

시작하기 전에, 이 예제에서 사용자 정의 VPC를 생성할 지 아니면 기본 VPC를 정해야 합니다. 이 예제에서 사용자는 `use_default_vpc` 변수를 이용하여 세이지 메이커 노트북을 새로운 VPC에 생성할 지, 아니면 기본 VPC에 생성할 지 결정할 수 있습니다.

```
terraform plan -target module.vpc
terraform apply -target module.vpc
```

다른 변수를 사용해서 테라폼을 실행하려면 `-var-file` 옵션을 사용할 수 있습니다. 다음과 같이 테라폼 명령을 수행할 때 추가해 주면 됩니다.
```
terraform plan -var-file tc1.tfvars -target module.vpc
terraform apply -var-file tc1.tfvars -target module.vpc
```

신규 VPC 생성 또는 기본 VPC 조회를 완료한 다음에는 테라폼 명령을 한 번더 수행해서 세이지 메이커 노트북을 생성합니다. 이전 단계에서는 VPC만 다뤘습니다. VPC 가 생성 되었거나 기본 VPC를 조회 했기 때문에 이제 나머지 자원을 생성할 수 있습니다.
```
terraform plan
terraform apply
```

이전 단계에서 추가 변수를 구성한 경우 다른 리소스를 생성하기 위해 테라폼 명령을 다시 실행할 때는 `-var-file` 옵션을 사용해야 합니다.
```
terraform plan -var-file tc1.tfvars
terraform apply -var-file tc1.tfvars
```

## 정리
테라폼 실행:
```
terraform destroy
```

만약 `-var-file` 옵션을 사용해서 자원을 생성했다면, 삭제할 때도 같은 변수를 **반드시** 사용해야 합니다. 꼭 잊지말고 생성할 때 사용한 변수를 지정해서 자원을 삭제합니다.
```
terraform destroy -var-file tc1.tfvars
```

## SageMaker notebook examples
### Clone GitHub repository
After terraform successfully creates a sagemaker notebook instance in your aws environment, open the sagemaker notebook in your web browser. And click `git` icon on the left navigation bar, and select clone repository button to get the example codes from github repository. Or you can open a terminal in the jupyter notebook and directly clone the repository in the sagemaker workspace as below.

```
cd SageMaker
pwd
```

```
/home/ec2-user/SageMaker
```

```
git clone https://github.com/aws-samples/aws-ai-ml-workshop-kr
```

### Bring Your Own Containers (BYOC)
You can run your owne container in the sagemaker. There are some examples to explain how to use custom containers for machine leaning workloads.

#### Hello Docker
Find `sagemaker/byoc` directory and move in. Click `hello_docker.ipynb` file to open the interactive (notebook) interface for machine learning jobs and follow the instructions. Note this example written in korean. For english example, please refer to [this](TBD)

#### Scikit learn

#### Tensorflow

### Model Monitor
