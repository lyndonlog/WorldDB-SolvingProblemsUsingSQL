/*Making and answering problems using SQL with "World" dataset by MYSQL*/
-- Familiarizing about the usage of Joins, simple queries, subqueries and OVER(PARTITION BY)

SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM countrylanguage;
/*City table*/
/*Exploring data for null, empty and approriate values*/
SELECT * FROM city WHERE ID IS NULL OR ID = "" OR ID = "–";
SELECT * FROM city WHERE Name IS NULL OR Name = "" OR Name = "–";
SELECT * FROM city WHERE CountryCode IS NULL OR CountryCode = "" OR CountryCode = "–";
SELECT * FROM city WHERE District IS NULL OR District = "" OR District = "–";
SELECT * FROM city WHERE Population IS NULL OR Population = "" OR Population = "–";
/*Country table*/
/*Exploring data for null, empty and approriate values*/
SELECT Name,HeadOfState FROM country WHERE headofstate IS NULL OR HeadOfState = '';
-- Andorra, Antartica & San Marino has null or empty value for HeadOfstate
SELECT Name,Code FROM country WHERE Code IS NULL OR Code = '';
SELECT Name,Code FROM country WHERE Name IS NULL OR Name = '';
SELECT Name,Continent FROM country WHERE Continent IS NULL OR Continent = '';
SELECT Name,Region FROM country WHERE Region IS NULL OR Region = '';
SELECT Name,SurfaceArea FROM country WHERE SurfaceArea IS NULL OR SurfaceArea = '';
SELECT Name,IndepYear FROM country WHERE IndepYear IS NULL OR IndepYear = '';
-- There are many countries without Indepyear
SELECT Name,Population FROM country WHERE Population IS NULL OR Population = '';
-- There are many countries with 0 population.
SELECT Name,LifeExpectancy FROM country WHERE LifeExpectancy IS NULL OR LifeExpectancy = '';
SELECT Name,GNP FROM country WHERE GNP IS NULL OR GNP = '';
SELECT Name,GNPOld FROM country WHERE GNPOld IS NULL OR GNPOld = '';
SELECT Name,LocalName FROM country WHERE LocalName IS NULL OR LocalName = '–' OR LocalName = '';
SELECT Name,GNPOld FROM country WHERE GNPOld IS NULL OR GNPOld = '';
SELECT Name,GovernmentForm FROM country WHERE GovernmentForm IS NULL OR GovernmentForm = '';

SELECT * FROM countrylanguage;
/*CountryLanguage table*/
/*Exploring data for null, empty and approriate values*/
SELECT * FROM countrylanguage WHERE CountryCode IS NULL OR CountryCode = "" OR CountryCode = "–";
SELECT * FROM countrylanguage WHERE Language IS NULL OR Language = "" OR Language = "–";
SELECT * FROM countrylanguage WHERE IsOfficial IS NULL OR IsOfficial = "" OR IsOfficial = "–";
SELECT * FROM countrylanguage WHERE Percentage IS NULL OR Percentage = "" OR Percentage = "–";
-- there are countries that has 0 percentage


-- Total population of English Speaker by country
SELECT cl.CountryCode,c.Name,cl.Language,cl.IsOfficial,c.Population AS TotalPopulation, ROUND(((cl.Percentage*0.01) * c.Population),2) AS PopEnglishLanguage
,cl.Percentage FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode AND Language = "English"
GROUP BY CountryCode ORDER BY Percentage DESC;

-- Count of languages per country
SELECT CountryCode, Name, COUNT(Language) AS LanguageCount FROM country c
JOIN countrylanguage cl ON c.code = cl.CountryCode 
GROUP BY CountryCode ORDER BY LanguageCount DESC;

-- List of Languages in this dataset
SELECT COUNT(distinct Language) AS CountOfLanguage FROM countrylanguage;

SELECT DISTINCT Language FROM countrylanguage;

-- Top Languages
SELECT cl.CountryCode,c.Name,cl.Language,cl.IsOfficial,c.Population AS TotalPopulation,
cl.Percentage FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode 
GROUP BY CountryCode;
-- -----------------------------------
-- CHECKING if all the population in the Philippines are have been surveyed.
SELECT cl.CountryCode, c.Name, cl.Language, cl.IsOfficial, c.Population AS TotalPopulation,
((cl.Percentage*0.01)*(c.population)) AS NewPopulation
,cl.Percentage FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode WHERE CountryCode = 'PHL'
GROUP BY Language
ORDER BY Percentage DESC;

SELECT SUM(q2.NewPopulation) FROM (SELECT cl.CountryCode, c.Name, cl.Language, cl.IsOfficial, c.Population AS TotalPopulation,
((cl.Percentage*0.01)*(c.population)) AS NewPopulation
,cl.Percentage FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode WHERE CountryCode = 'PHL'
GROUP BY Language
ORDER BY Percentage DESC)q2;
-- '66850960.000' population had been surveyed for language.

SELECT SUM(percentage) FROM (SELECT cl.CountryCode, c.Name, cl.Language, cl.IsOfficial, c.Population AS TotalPopulation,
((cl.Percentage*0.01)*(c.population)) AS NewPopulation
,cl.Percentage FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode WHERE CountryCode = 'PHL'
GROUP BY Language
ORDER BY Percentage DESC)q2;
-- 88% was surveyed

-- '75967000' from the philippines who have been surveyed for language data
-- 12% of 75967000 from the philippines who have not been surveyed for language data
-- so 12% of 75967000 = 9116040 have not been surveyed
-- 9116040 + 66850960 = 75967000
-- It concludes that the other countries as well that their population are also have not been surveyed completely.

-- Total Population VS Surveyed Population per country
SELECT q2.*,(q2.Population - q2.surveyedpopulation) AS 'Difference/NotSurveyed' FROM
(SELECT cl.CountryCode, c.Name, c.Population,SUM((cl.Percentage*0.01)*(c.population)) AS SurveyedPopulation
FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode 
GROUP BY Name
ORDER BY SurveyedPopulation DESC)q2;

-- ----------------------------------------------------------------

-- Languages in the world per country and percentage by population language
SELECT cl.CountryCode, c.Name, cl.Language, cl.IsOfficial AS 'IsItOfficalLang(True or False)', 
((cl.Percentage*0.01)*(c.population)) AS PopulationLanguage
,c.Population AS PopulationOfCountry,cl.Percentage AS PercentageOfLanguagebyPopCountry FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode 
GROUP BY Name,Language
ORDER BY PopulationLanguage DESC;

-- Top languages in the world
SELECT q2.Language, SUM(q2.PopulationLanguage) AS TotalSpeaker FROM
(SELECT cl.CountryCode, c.Name, cl.Language, cl.IsOfficial AS 'IsItOfficalLang(True or False)', 
((cl.Percentage*0.01)*(c.population)) AS PopulationLanguage
,c.Population AS PopulationOfCountry,cl.Percentage AS PercentageOfLanguagebyPopCountry FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode 
GROUP BY Name,Language
ORDER BY PopulationLanguage DESC)q2 GROUP BY Language;

-- TOP 10 Language
SELECT q2.Language, SUM(q2.PopulationLanguage) AS TotalSpeaker FROM
(SELECT cl.CountryCode, c.Name, cl.Language, cl.IsOfficial AS 'IsItOfficalLang(True or False)', 
((cl.Percentage*0.01)*(c.population)) AS PopulationLanguage
,c.Population AS PopulationOfCountry,cl.Percentage AS PercentageOfLanguagebyPopCountry FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode 
GROUP BY Name,Language
ORDER BY PopulationLanguage DESC)q2 GROUP BY Language LIMIT 10;

-- Total Population, Total Speaker/SurveyedPopulation and Difference/PopulationNotSurveyed
-- cross join makes 2 columns for 2 tables. When I use Union, it gives 1 column.
SELECT q4.TotalPopulation, q4.TotalSpeaker AS TotalSurveyedPopulation,(q4.TotalPopulation - TotalSpeaker) AS 'Difference/NotSurveyed' FROM
(SELECT * FROM
(SELECT SUM(Population) AS TotalPopulation FROM country)q2
CROSS JOIN
(SELECT SUM(q2.TotalSpeaker) AS TotalSpeaker FROM
(SELECT q2.Language, SUM(q2.PopulationLanguage) AS TotalSpeaker FROM
(SELECT cl.CountryCode, c.Name, cl.Language, cl.IsOfficial AS 'IsItOfficalLang(True or False)', 
((cl.Percentage*0.01)*(c.population)) AS PopulationLanguage
,c.Population AS PopulationOfCountry,cl.Percentage AS PercentageOfLanguagebyPopCountry FROM countrylanguage cl
JOIN country c ON c.code = cl.CountryCode 
GROUP BY Name,Language
ORDER BY PopulationLanguage DESC)q2 GROUP BY Language)q2)q3)q4;

-- List of official language of the countries
SELECT cl.CountryCode,Name,Language,IsOfficial,Percentage FROM countrylanguage cl
JOIN country c ON c.code = cl.countrycode 
WHERE IsOfficial = True;

SELECT cl.CountryCode,Name,Language,IsOfficial,Percentage FROM countrylanguage cl
JOIN country c ON c.code = cl.countrycode 
WHERE IsOfficial = True AND Percentage > 50 ORDER BY Percentage DESC;

-- List of cities per country
SELECT Code,c.Name,Continent,Region,ct.Name From Country c
JOIN City ct ON c.code = ct.countrycode;

-- Number of cities per country
SELECT Code,c.Name,Continent,Region, COUNT(ct.Name) AS NumberOfCities,ct.population AS PopulationFromCityTable,
c.Population AS PopulationFromCountryTable,
(c.population-ct.population) AS `Difference/NotSurveyedForCity` FROM country c
JOIN City ct ON c.code = ct.countrycode 
GROUP BY c.code ORDER BY NumberOfCities DESC;

-- List of states/districts per country
SELECT Code,c.Name,Continent,Region, ct.District AS District From Country c
JOIN City ct ON c.code = ct.countrycode WHERE District NOT LIKE('–')  GROUP BY ct.District;

-- Number of countries per continents
SELECT continent, COUNT(*) AS NumberOfCountries FROM country GROUP BY Continent ORDER BY NumberOfCountries DESC;

-- Number of states/districts per country
-- Use distinct because there are duplicate states 
-- like (District = California and CityName = Los Anegles) then (District = California and CityName = San Diego)
SELECT Code,c.Name,Continent,Region, COUNT(DISTINCT ct.District) AS NumberOfDistricts From Country c
JOIN City ct ON c.code = ct.countrycode WHERE District NOT LIKE('–') 
GROUP BY c.code ORDER BY NumberOfDistricts DESC;

-- Number of countries per continent
SELECT Continent, COUNT(DISTINCT CODE) AS NumberOfCountries FROM country 
GROUP BY Continent ORDER BY NumberOfCountries DESC;
-- Number of countries per region
SELECT Region,Continent, COUNT(DISTINCT CODE) AS NumberOfCountries FROM country 
GROUP BY Region ORDER BY NumberOfCountries DESC;
-- Number of Region per Continent
SELECT Continent,Count(DISTINCT Region) AS NumberOfRegions FROM country 
GROUP BY Continent ORDER BY NumberOfRegions DESC;

-- Number of Region per Continent
SELECT Code,Name,SurfaceArea FROM country 
ORDER BY SurfaceArea DESC;

-- Average surface area
SELECT AVG(SurfaceArea) AS AverageSurfaceArea FROM country;

-- Surface Area > Average surface area
SELECT * FROM
(SELECT Code,Name,SurfaceArea FROM country 
WHERE SurfaceArea > (SELECT AVG(SurfaceArea) AS AverageSurfaceArea FROM country))q2
JOIN
(SELECT ROUND(AVG(SurfaceArea),2) AS AverageSurfaceArea FROM country)q3 ORDER BY SurfaceArea DESC;

-- Surface Area < Average surface area
SELECT * FROM
(SELECT Code,Name,SurfaceArea FROM country 
WHERE SurfaceArea < (SELECT AVG(SurfaceArea) AS AverageSurfaceArea FROM country))q2
JOIN
(SELECT ROUND(AVG(SurfaceArea),2) AS AverageSurfaceArea FROM country)q3 ORDER BY SurfaceArea DESC;

-- UNION for both Surface Area < Average surface area & Surface Area > Average surface area
SELECT * FROM
(SELECT * FROM
(SELECT Code,Name,SurfaceArea FROM country 
WHERE SurfaceArea > (SELECT AVG(SurfaceArea) AS AverageSurfaceArea FROM country))q2
JOIN
(SELECT ROUND(AVG(SurfaceArea),2) AS AverageSurfaceArea FROM country)q3 ORDER BY SurfaceArea DESC)q4
UNION
(SELECT * FROM
(SELECT Code,Name,SurfaceArea FROM country 
WHERE SurfaceArea < (SELECT AVG(SurfaceArea) AS AverageSurfaceArea FROM country))q2
JOIN
(SELECT ROUND(AVG(SurfaceArea),2) AS AverageSurfaceArea FROM country)q3 ORDER BY SurfaceArea DESC)
ORDER BY SurfaceArea DESC;

-- Life Expectancy
SELECT Code,Name, LifeExpectancy FROM Country WHERE lifeexpectancy IS NOT NULL
ORDER BY lifeexpectancy DESC;
-- Average Life Expectancy
SELECT AVG(LifeExpectancy) FROM Country WHERE lifeexpectancy IS NOT NULL;

-- LifeExpectancy > Average LifeExpectancy
SELECT * FROM
(SELECT Code,Name,LifeExpectancy FROM country 
WHERE LifeExpectancy > (SELECT AVG(LifeExpectancy) AS AverageLifeExpectancy FROM country))q2
JOIN
(SELECT ROUND(AVG(LifeExpectancy),2) AS AverageLifeExpectancy FROM country)q3 ORDER BY LifeExpectancy DESC;

-- Life Expectancy < Average Life Expectancy
SELECT * FROM
(SELECT Code,Name, LifeExpectancy FROM country WHERE LifeExpectancy < (SELECT AVG(LifeExpectancy) FROM country))q2
JOIN
(SELECT ROUND(AVG(LifeExpectancy),2) FROM Country)q3 ORDER BY LifeExpectancy ASC;

-- UNION of LifeExpectancy > Average LifeExpectancy & -- LifeExpectancy < Average LifeExpectancy
SELECT * FROM
(SELECT * FROM
(SELECT Code,Name,LifeExpectancy FROM country 
WHERE LifeExpectancy > (SELECT AVG(LifeExpectancy) AS AverageLifeExpectancy FROM country))q2
JOIN
(SELECT ROUND(AVG(LifeExpectancy),2) AS AverageLifeExpectancy FROM country)q3 ORDER BY LifeExpectancy DESC)q3
UNION
SELECT*FROM
(SELECT * FROM
(SELECT Code,Name, LifeExpectancy FROM country WHERE LifeExpectancy < (SELECT AVG(LifeExpectancy) FROM country))q2
JOIN
(SELECT ROUND(AVG(LifeExpectancy),2) FROM Country)q3 ORDER BY LifeExpectancy ASC)q4 ORDER BY LifeExpectancy DESC;

-- GNP

-- Where old GNP is not null
SELECT * FROM country;
SELECT Code,Name, GNP,GNPOld FROM Country WHERE GNPOLD IS NOT NULL
ORDER BY GNP DESC; 

-- Where GNP is greater than GNPOld

SELECT Code,Name, GNP,GNPOld FROM Country WHERE GNPOLD IS NOT NULL AND GNP > GNPOld
ORDER BY GNP DESC; 

-- Where GNP is less than GnpOld
SELECT Code,Name, GNP,GNPOld FROM Country WHERE GNPOLD IS NOT NULL AND GNP < GNPOld
ORDER BY GNP DESC; 

-- Select country where gnp is not zero.
SELECT  Code, Name, GNP FROM Country WHERE NOT GNP = 0 ORDER BY GNP DESC;

-- AVerage GNP short code is just use over()
SELECT Code,Name,GNP,AVG(GNP) OVER() AS AverageGNP FROM Country WHERE NOT GNP = 0 ORDER BY GNP DESC;
-- GNP > AVG GNP
SELECT q2.* FROM
(SELECT Code,Name,GNP,AVG(GNP) OVER() AS AverageGNP FROM Country WHERE NOT GNP = 0 ORDER BY GNP DESC)q2
WHERE GNP > AverageGNP;

-- GNP < AVG GNP
SELECT q2.* FROM
(SELECT Code,Name,GNP,AVG(GNP) OVER() AS AverageGNP FROM Country WHERE NOT GNP = 0 ORDER BY GNP DESC)q2
WHERE GNP < AverageGNP;

SELECT code,Name,GNP, Continent,COUNT(*) OVER(PARTITION BY Continent) AS NumberofCountriesPerContinent 
, row_number() OVER(PARTITION BY Continent ORDER BY GNP DESC) AS RowNumber
FROM country;

-- 1st 2nd 3rd and 4th quartile of countries on each continent by GNP
SELECT * FROM(
SELECT Continent,code,Name,GNP, COUNT(*) OVER(PARTITION BY Continent) AS NumberofCountriesPerContinent 
, row_number() OVER(PARTITION BY Continent ORDER BY GNP ASC) AS RowNumber
FROM country) q2 
WHERE RowNumber IN (Round(0.25*NumberofCountriesPerContinent),ROUND(0.50*NumberofCountriesPerContinent),
ROUND(0.755*NumberofCountriesPerContinent),ROUND(1*NumberofCountriesPerContinent));

-- 1st 2nd and 3rd quartile of countries by GNP. 3rd Quartile should be x 0.755
-- Note: Round to make it non decimal integer
SELECT *FROM
(SELECT Continent,code,Name,GNP, COUNT(*) OVER() AS NumberofCountries
, row_number() OVER(ORDER  BY GNP ASC) AS RowNumber
FROM country WHERE GNP <> 0) q2 WHERE RowNumber IN(ROUND(0.25*NumberofCountries),ROUND(0.50*NumberofCountries),ROUND(0.755*NumberofCountries)
,ROUND(1*NumberofCountries));

-- Quartile 1,2,3,4 Using Ntile for all countries excluding GNP = 0
SELECT MAX(GNP) AS QuartileGNPValue,Gnp_quartile AS QuartileNumber FROM 
(SELECT name, gnp, 
NTILE(4) OVER (ORDER BY gnp) AS gnp_quartile
FROM country WHERE GNP <> 0)q2 GROUP BY gnp_quartile;

-- Government form
SELECT COUNT(DISTINCT GovernmentForm) AS CountOfGovernmentForm FROM country;

-- List of Government Forms
SELECT DISTINCT GovernmentForm FROM country;

-- Number of countries per Government Forms
SELECT DISTINCT GovernmentForm,Count(*) as NumberOfCountries 
FROM country
GROUP BY GovernmentForm ORDER BY NumberOfCountries DESC;

-- List and number of countries per Government Forms
SELECT GovernmentForm, Name, Count(*) OVER(Partition BY GovernmentForm ) as NumberOfCountries
FROM country ORDER BY NumberOfCountries DESC;

-- HeadOfState
SELECT HeadOfState FROM Country WHERE HeadOfState <> "" AND HeadOfState IS NOT NULL;

SELECT HeadOfState,COUNT(*) AS NumberOfHandledCountries 
FROM Country WHERE HeadOfState <> "" AND HeadOfState IS NOT NULL
GROUP BY HeadOfState ORDER BY NumberOfHandledCountries DESC;

SELECT HeadOfState,Name, COUNT(*) OVER(PARTITION BY HeadOfState) AS NumberOfHandledCountries
FROM Country WHERE HeadOfState <> "" AND HeadOfState IS NOT NULL ORDER BY NumberOfHandledCountries DESC;

-- -------------------------------------------------------------
-- Checking for outliers for life expectancy using zscore

/*
The 68-95-99 rule
2.576 1.960 1.645 Confidence level
The 68-95-99 rule is based on the mean and standard deviation. It says:

68% of the population is within 1 standard deviation of the mean. (1.65)

95% of the population is within 2 standard deviation of the mean. (1.96)

99.7% of the population is within 3 standard deviation of the mean. (2.576)

SOURCE AND REFERENCE ABOUT ABOVE DETAILS ON Z-SCORE:
https://www.freecodecamp.org/news/normal-distribution-explained/#:~:text=The%2068%2D95%2D99%20rule&text=It%20says%3A,standard%20deviation%20of%20the%20mean.
https://www.youtube.com/watch?v=PD7ZdXfKbq0
*/
SELECT Name,LifeExpectancy FROM country WHERE LifeExpectancy IS NOT NULL ORDER BY LifeExpectancy DESC;

SELECT AVG(LifeExpectancy) FROM country WHERE LifeExpectancy IS NOT NULL;
-- 66.49 is the average

SELECT stddev(LifeExpectancy) FROM COUNTRY WHERE LifeExpectancy IS NOT NULL;
-- 11.49 is the stdv


SELECT name, LifeExpectancy, (LifeExpectancy-AVG(LifeExpectancy) OVER()) /stddev(LifeExpectancy) OVER() as ZScore FROM country
WHERE LifeExpectancy IS NOT NULL ORDER BY Zscore;

-- outliers 3 Standard deviation above/below the mean. Outside the 99.7%
SELECT * FROM
(SELECT name, LifeExpectancy, (LifeExpectancy-AVG(LifeExpectancy) OVER()) /stddev(LifeExpectancy) OVER() as ZScore FROM country) t2
WHERE Zscore > 2.576  OR Zscore < -2.576 ORDER BY LifeExpectancy;

-- outliers 2 Standard deviation above/below the mean. Outside the 95%
SELECT * FROM
(SELECT name, LifeExpectancy, (LifeExpectancy-AVG(LifeExpectancy) OVER()) /stddev(LifeExpectancy) OVER() as ZScore FROM country) t2
WHERE Zscore > 1.96  OR Zscore < -1.96 ORDER BY LifeExpectancy;

-- -- outliers 1 Standard deviation above/below the mean. Outside the 68%
SELECT * FROM
(SELECT name, LifeExpectancy, (LifeExpectancy-AVG(LifeExpectancy) OVER()) /stddev(LifeExpectancy) OVER() as ZScore FROM country) t2
WHERE Zscore > 1.65  OR Zscore < -1.65 ORDER BY LifeExpectancy;

-- (95-68)/2  = 13% chance of life expectancy of the people are within 43.51 to 55.
SELECT name,LifeExpectancy FROM country WHERE LifeExpectancy > 43.51 AND LifeExpectancy < 55 ORDER by LifeExpectancy;
