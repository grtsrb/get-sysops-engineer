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
