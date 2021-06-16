#--1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT *
FROM client
WHERE LENGTH(FirstName) < 6;
#2
.
+Вибрати львівські відділення банку.+
SELECT *
FROM department
WHERE DepartmentCity = 'Lviv';
#3
.
+Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT * FROM client WHERE Education='high' ORDER BY LastName;
#4.
+Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT * FROM application ORDER BY idApplication DESC LIMIT 5;
#5.
+Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT * FROM client WHERE (LastName LIKE '%OV' OR LastName LIKE '%OVA') ;
#6.
+Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT * FROM client  JOIN department  ON department.idDepartment = client.Department_idDepartment WHERE DepartmentCity='Kyiv';
#7.
+Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
SELECT FirstName,Passport FROM client GROUP BY FirstName;
#8.
+Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT * FROM client JOIN application ON application.Client_idClient=client.idClient WHERE Sum>5000 AND Currency='Gryvnia';
#9.
+Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT(SELECT COUNT(idClient) FROM client) AS AllClient,
      (SELECT COUNT(idClient) FROM client WHERE Department_idDepartment=2 OR Department_idDepartment=5) AS LvivClient;
#10. Знайти
кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT Client_idClient,MAX(sum) FROM application GROUP BY Client_idClient;
#11. Визначити
кількість заявок на крдеит для кожного клієнта.
SELECT FirstName,LastName,COUNT(idClient)
    AS TotalApplication FROM application JOIN client
                                              ON application.Client_idClient = client.idClient GROUP BY idClient;
#12. Визначити
найбільший та найменший кредити.
SELECT MAX(Sum) ,MIN(Sum) FROM application;
#13. Порахувати
кількість кредитів для клієнтів,які мають вищу освіту.
SELECT FirstName,LastName,COUNT(Client_idClient) AS COUNT
FROM application JOIN client ON application.Client_idClient=client.idClient
WHERE Education='high' GROUP BY idClient;
#14. Вивести
дані про клієнта, в якого середня сума кредитів найвища.
SELECT idClient,FirstName,LastName,MAX(x.avg)
FROM (SELECT *,AVG(Sum) as avg FROM client JOIN application ON application.Client_idClient=client.idClient
      GROUP BY idClient ORDER BY avg DESC) AS x;
#15. Вивести
відділення, яке видало в кредити найбільше грошей
SELECT DepartmentCity, MAX(x.maxC) AS MAX
FROM (SELECT *, SUM (Sum) as maxC FROM client
    JOIN application ON application.Client_idClient=client.idClient
    JOIN department ON client.Department_idDepartment=department.idDepartment
    GROUP BY idClient ORDER BY maxC DESC) AS x;
#16
.
Вивести
відділення, яке видало найбільший кредит.
SELECT DepartmentCity,MAX(x.maxC) AS MAX
FROM (SELECT *,MAX(Sum) as maxC FROM client
                                         JOIN application ON application.Client_idClient=client.idClient
                                         JOIN department ON client.Department_idDepartment=department.idDepartment
      GROUP BY idClient ORDER BY maxC DESC) AS x;
#17. Усім
клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application JOIN client ON application.Client_idClient=client.idClient
SET Sum=6000,Currency='Gryvnia'
WHERE Education='high';
#18. Усіх
клієнтів київських відділень пересилити до Києва.
UPDATE client JOIN department ON client.Department_idDepartment=department.idDepartment
SET City='Kyiv'
WHERE DepartmentCity='Kyiv';
#19. Видалити
усі кредити, які є повернені.
DELETE FROM application WHERE CreditState='Returned' LIMIT 10;
#20. Видалити
кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE application FROM application JOIN client ON application.Client_idClient=client.idClient WHERE LastName LIKE '_[a,e,i,o,u,y]%';
#Знайти
львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT idDepartment, DepartmentCity, CountOfWorkers
FROM department
         JOIN client ON department.idDepartment = client.Department_idDepartment
         JOIN application ON application.Client_idClient = client.idClient
WHERE Sum > 5000
  AND DepartmentCity = 'Lviv';
#Знайти
клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT FirstName, LastName
FROM client
         JOIN application ON client.Department_idDepartment = application.Client_idClient
WHERE CreditState = 'Returned'
  AND Sum > 5000;
/* Знайти максимальний неповернений кредит.*/
SELECT MAX(Sum)
FROM application
WHERE CreditState = 'Not returned';
/*Знайти клієнта, сума кредиту якого найменша*/
SELECT FirstName, LastName, MIN(x.sumX)
FROM (SELECT *, SUM(Sum) as sumX
      FROM application
               JOIN client ON client.idClient = application.Client_idClient
      GROUP BY Client_idClient) AS x;
/*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
SELECT *
FROM application
WHERE Sum > (
    SELECT AVG(x.avg)
    FROM (SELECT Sum(Sum) as avg FROM application GROUP BY Client_idClient) AS x);
/*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
SELECT *
FROM client
WHERE City = (SELECT x.City
              FROM (
                       SELECT City
                       FROM application
                                JOIN client ON client.idClient = application.Client_idClient
                       GROUP BY Client_idClient
                       ORDER BY MAX(SUM) DESC LIMIT 1) as x);
#місто
чувака який набрав найбільше кредитів
SELECT City
FROM application
         JOIN client ON client.idClient = application.Client_idClient
GROUP BY Client_idClient
ORDER BY MAX(SUM) DESC LIMIT 1;



