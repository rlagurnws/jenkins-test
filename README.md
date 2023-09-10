---
layout: post
title: <우리FISA 클라우드 엔지니어링>Jenkins 적용
subtitle: Freestyle Projct
author: 김혁준
categories: 블로그
tags: blog MSA Project Architect
---

## Jenkins 사용 흐름
AWS EC2에 Jenkins, Docker 설치<br>
참고 : <br>
https://sothoughtful.dev/posts/Jenkins/ <br>
https://velog.io/@msung99/CICD-Jenkins-Docker-%EB%A5%BC-%ED%99%9C%EC%9A%A9%ED%95%9C-SpringBoot-%EB%B0%B0%ED%8F%AC-%EC%9E%90%EB%8F%99%ED%99%94-%EA%B5%AC%EC%B6%95#ci-%EA%B5%AC%EC%B6%95--github-%EC%99%80-jenkins-%EC%97%B0%EB%8F%99

jenkins, docker 설치 된 ec2 커뮤니티 AMI에 게시했으니 직접 설치하기 귀찮으신 분들은 저거 쓰셔요
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-3.png)

<br>
GitHub Web Hook을 통해 Repository push 발생 시<br>
Jenkins에서 DockerFile 이용하여 container 이미지로 만들어 Docker Hub에 업로드

SSH 통신으로 컨테이너 생성 할 EC2에 접속 후 docker-compose.yml 사용하여 컨테이너 생성
<br><br><br>

## Jenkins 설정

### SSH설정

Jenkins 관리 -> Plugins -> Available plugins에서 Publish Over SSH 플러그인 설치<br>
저는 이미 받아서 Installed plugins에 나와용
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-8.png)

<br><br>

플러그인 설치 후 Jenkins 관리 -> System으로 들어가면 제일 하단에 Publish over SSH 설정 생김<br>
Key에 접속할 EC2 pem key 값 삽입<br>
SSH server 추가 후 name은 마음대로, hostname은 접속할 ec2의 ip 작성<br>
Test configuration까지 야무지게 실행
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-9.png)

![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-10.png)

<br><br>

## Freestyle Project 설정

Freestyle project 생성
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image.png)

<br><br>

General탭의 GitHub project체크박스 선택 후 url 입력
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-1.png)

<br><br>

소스코드 관리 탭에서 Git url과 Credential, 소스 가져올 Branch 설정<br>
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-2.png)

<br><br>

빌드 유발은 GitHub Hook trigger 선택<br>
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-4.png)

<br><br>

빌드 스텝은 두 개로 나눔<br>
첫 번째는 gradlew clean 후 build<br>
두 번째는 docker에 로그인 후 (docker login -u [dockerHub id] -p [dockerHub password] docker.io)<br>
빌드 후 푸시 (docker build -t [dockerHub userName]/[dockerHub repository]:[version])

![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-5.png)

<br><br>

빌드 환경은 docker hub에 이미지 푸시 후 받아야 하므로<br>
Send files or execute commands over SSH after the build runs 선택<br>
SSH server 선택 후<br>
기존에 있던 컨테이너 종료 후 삭제 (이미지도 삭제) -> docker compose 사용하여 컨테이너 생성

![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-7.png)

<h3>FreeStyle project 설정 끝</h3>

<br><br>

## WebHook 설정
github repo -> settings -> webhook<br>
Payload URL에 Jenkins Ec2 IP/github-webhook/<br>
뒤에 <b>/github-webhook/</b> 꼭 붙여줘야함
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-11.png)


## Jenkins server 설정
DockerHub에 접속하기 위해<br>
/var/run/docker.sock의 권한 변경<br>
<b>sudo chmod 666 /var/run/docker.sock</b><br>
야무지게 확인해주기<br>
![image](https://github.com/rlagurnws/jenkins-test/blob/main/images/image-12.png)



















