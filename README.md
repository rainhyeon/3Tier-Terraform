# 3Tier-Terraform

Terraform을 사용하여 AWS에 3계층(3-Tier) 아키텍처를 구축하는 프로젝트입니다.
![test 구성도 drawio (2)](https://github.com/user-attachments/assets/46453d70-ed1b-4a97-9e12-ff30fc93d625)

## 📁 프로젝트 구조

이 저장소는 다음과 같은 주요 Terraform 구성 파일들로 구성되어 있습니다:

- **`provider.tf`**: AWS 공급자 설정과 지역(region)을 정의합니다.
- **`variables.tf`**: 프로젝트에서 사용하는 변수들을 선언합니다.
- **`vpc.tf`**: VPC, 인터넷 게이트웨이(IGW), 라우팅 테이블 등을 설정합니다.
- **`subnet.tf`**: 퍼블릭 및 프라이빗 서브넷을 구성합니다.
- **`nat.tf`**: NAT 게이트웨이와 관련된 리소스를 정의합니다.
- **`security_groups.tf`**: 웹, 애플리케이션, 데이터베이스 계층에 대한 보안 그룹을 설정합니다.
- **`ec2.tf`**: 웹 및 WAS 계층의 EC2 인스턴스를 생성합니다.
- **`alb.tf`**: 애플리케이션 로드 밸런서(ALB)와 관련된 리소스를 정의합니다.
- **`rds.tf`**: MySQL RDS 인스턴스를 설정합니다.
- **`outputs.tf`**: 생성된 리소스의 정보를 출력합니다.
- **`main.tf`**: 모든 모듈과 리소스를 통합하여 정의합니다.

## 🏗️ 아키텍처 개요

이 프로젝트는 다음과 같은 3계층 아키텍처를 AWS 상에 구축합니다:

1. **웹 계층 (Web Tier)**:
   - 퍼블릭 서브넷에 위치한 EC2 인스턴스에서 Nginx를 사용하여 리버스 프록시를 설정합니다.
   - HTTP(80) 및 HTTPS(443) 포트를 개방하여 외부 트래픽을 수신합니다.

2. **애플리케이션 계층 (Application Tier)**:
   - 프라이빗 서브넷에 위치한 EC2 인스턴스에서 Tomcat을 실행합니다.
   - 웹 계층의 Nginx를 통해 포트 8080으로 트래픽을 수신합니다.

3. **데이터베이스 계층 (Database Tier)**:
   - 프라이빗 서브넷에 위치한 MySQL RDS 인스턴스를 생성합니다.
   - 애플리케이션 계층의 EC2 인스턴스에서만 접근이 가능하도록 보안 그룹을 설정합니다.

## 🔐 보안 그룹 설정

보안 그룹은 각 계층의 접근 제어를 위해 다음과 같이 설정됩니다:

- **웹 보안 그룹 (`web_sg`)**:
  - 포트 22(SSH), 80(HTTP), 443(HTTPS)을 외부에 개방합니다.

- **애플리케이션 보안 그룹 (`was_sg`)**:
  - 포트 22(SSH), 8080을 웹 보안 그룹에서 접근 가능하도록 설정합니다.

- **데이터베이스 보안 그룹 (`db_sg`)**:
  - 포트 3306(MySQL)을 애플리케이션 보안 그룹에서만 접근 가능하도록 설정합니다.


## ✅ 배포 순서

| 단계 |
|------|
| 1️⃣ VPC, IGW, Public RT 생성 |  
`terraform apply -target=aws_vpc.main -auto-approve`  
`terraform apply -target=aws_internet_gateway.igw -auto-approve`  
`terraform apply -target=aws_route_table.public_rt -auto-approve` |
| 2️⃣ Subnet 3개 생성 + Public 연결 |  
`terraform apply -target=aws_subnet.public -auto-approve`  
`terraform apply -target=aws_subnet.private_was -auto-approve`  
`terraform apply -target=aws_subnet.private_db -auto-approve`  
`terraform apply -target=aws_route_table_association.public_assoc -auto-approve` |
| 3️⃣ NAT Gateway 생성 (WAS만 인터넷 접근) |  
`terraform apply -target=aws_eip.nat_eip -auto-approve`  
`terraform apply -target=aws_nat_gateway.nat_gw -auto-approve`  
`terraform apply -target=aws_route_table.private_rt_was -auto-approve`  
`terraform apply -target=aws_route_table_association.was_assoc -auto-approve` |
| 4️⃣ 보안 그룹 3개 생성 |  
`terraform apply -target=aws_security_group.web_sg -auto-approve`  
`terraform apply -target=aws_security_group.was_sg -auto-approve`  
`terraform apply -target=aws_security_group.db_sg -auto-approve` |
| 5️⃣ EC2 인스턴스 (Web + WAS) |  
`terraform apply -target=aws_instance.web_server -auto-approve`  
`terraform apply -target=aws_instance.was_server -auto-approve` |
| 6️⃣ RDS Subnet Group + RDS 인스턴스 생성 |  
`terraform apply -target=aws_db_subnet_group.rds_subnet_group -auto-approve`  
`terraform apply -target=aws_db_instance.mysql_rds -auto-approve` |
| 7️⃣ ALB + Target Group + Listener 설정 |  
`terraform apply -target=aws_lb.web_alb -auto-approve`  
`terraform apply -target=aws_lb_target_group.web_tg -auto-approve`  
`terraform apply -target=aws_lb_listener.http_listener -auto-approve`  
`terraform apply -target=aws_lb_target_group_attachment.web1 -auto-approve` |
| 8️⃣ 전체 상태 확인 |  
`terraform show`  
`terraform output` |


## 🧪 테스트 및 검증

- 웹 브라우저에서 웹 계층의 퍼블릭 IP 또는 도메인을 통해 Nginx 리버스 프록시가 정상적으로 동작하는지 확인합니다.
- 애플리케이션 계층의 EC2 인스턴스에서 MySQL RDS에 접속하여 데이터베이스 연결을 검증합니다.

## 🧹 인프라 제거

생성된 모든 리소스를 제거하려면 다음 명령어를 실행합니다:

```bash
terraform destroy
