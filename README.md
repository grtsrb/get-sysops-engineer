# get-sysops-engineer
Repository for second round of interview for Junior SysOps Engineer , GET Belgrade


Zadatak 1:
Napraviti EC2 instancu na AWS platformi koristeci sledece parametre:
AMI: Amazon Linux 2 (64-bit)
Type: t2.micro
VPC: custom (non-default) --> kreirati custom VPC
Subnet: custom (non-default) --> kreirati custom public subnet
- Instalirati PostgreSQL klijenta na Linuxu.
- Instalirati i konfigurisati Amazon RDS for PostgreSQL (db.t3.micro) u
Multi-AZ.
- Konfigurisati i omoguciti komunikaciju izmedju EC2 (Linux) i RDS
PostgreSQL.
- Kreirati jednu tabelu sa nekoliko proizvoljnih kolona i redova.
- Instalirati i startovati Apache Web Server na datoj instanci. Omoguciti
javni pristup default web stranici Apache web servera, i SSH pristup datom
serveru samo sa svoje IP adrese.
Koristeci AWS tagove, prilepiti sledece metapodatke za datu EC2 instancu:
Tag key: Name, Tag value: test-ec2;
Tag key: Description, Tag value: Test instance;
Tag key: CostCenter, Tag value: 123456;
Na prezentaciji demonstirati failover sa jedne RDS instance na drugu.
Napomena: Obavezno koristiti IaC (Infrastructure as Code) tool po izboru
(Terraform/CloudFormation), za podizanje prethodno opisane infrastrukture.

Zadatak 2 ⇒ Lambda + Dev
Napraviti u programskom jeziku po izboru (Python/PowerShell) program,
koji salje sledecu poruku na email: "Hello, world!".
Potrebno je da se data poruka salje jednom dnevno u 1h ujutru. Veci
deo logike programa treba da bude implementiran preko AWS servisa.
Hints: Prilikom realizacije koristiti sledece AWS tehnologije: AWS
Lambda, AWS CloudWatch/EventBridge, Simple Notification Service
(SNS). AWS Lambda koristiti za izvrsavanje koda,
EventBridge/CloudWatch koristiti za zakazivanje periodicnog
izvrsavanja datog programa, a SNS koristiti za objavljivanje date
poruke u okviru odredjenog topic-a.
Consumeri (sa odredjenim email-om) je potrebno da se rucno
subscribuju na dati topic - ovaj deo logike nije potrebno
implementirati u samom kodu.

Zadatak 3 ⇒ Linux, Bash

U prilogu se nalazi lista fajlova u formatu 'kABCDEFGH.kod' gde je
ABCDEFGH broj u heksadecimalnom formatu, npr. k000ccf3b.kod .
Potrebno je napraviti bash skript koji će u lokalnom direktorijumu:
1. Kreirati prazne fajlove sa nazivima iz liste
2. Proveriti za svaki fajl da li mu je naziv u zadatom formatu i
prikazati neispravne nazive fajlova
3. Napraviti potrebne poddirektorijume i u njih rasporediti fajlove
po sledećem šablonu:
- Fajl kABCDEFGH.kod treba prebaciti u direktorijum G0/E0 , ako je G
paran broj
- Fajl kABCDEFGH.kod treba prebaciti u direktorijum X0/E0 , gde je
X=G-1 , ako je G neparan broj
Na primer, fajl k000ccf3b.kod treba prebaciti u folder 20/c0, fajl
k000cde67.kod treba prebaciti u folder 60/d0 .
Fajlove čiji naziv nije u zadatom formatu treba ignorisati
