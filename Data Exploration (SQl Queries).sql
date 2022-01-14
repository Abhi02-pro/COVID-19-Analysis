
-- In this project we we will explore the COVID data of different countries.
-- The dataset consist of two tables containing data about :
-- 1. Death Status ; 2. Vaccination Status


-- Looking at the data available in the tables

SELECT * FROM covid_deaths ORDER BY location, date;

SELECT * FROM covid_vaccinations ORDER BY location, date;



-- Exploring data from the "covid_deaths" table


-- Selecting some useful data from the table

SELECT location, date, population, new_cases, total_cases, total_deaths
FROM covid_deaths
ORDER BY location, date;


-- Looking at Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract COVID in your country

SELECT location, date, total_cases, total_deaths, ROUND((total_deaths/total_cases)*100,5) AS death_percentage
FROM covid_deaths
ORDER BY location, date;


-- Looking at Total Cases vs Population
-- Shows what percentage of population got COVID

SELECT location, date, total_cases, population, ROUND((total_cases/population)*100,5) AS infection_percentage
FROM covid_deaths
ORDER BY location, date;


-- Looking at countries with highest infection rate compared to population

SELECT location, population, MAX(total_cases) AS infection_count, MAX(ROUND((total_cases/population)*100,5)) AS infection_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY infection_percentage DESC;


-- Looking at countries with highest death count compared to population

SELECT location, population, MAX(CAST(total_deaths AS int)) AS death_count, MAX(ROUND((CAST(total_deaths AS int)/population)*100,5)) AS death_percentage
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location,population
ORDER BY death_count DESC;


-- Let's break things down by Continent

-- Looking at continents with highest COVID infection

SELECT continent, MAX(population) AS popluation, MAX(total_cases) AS infection_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY infection_count DESC;


-- Looking at continents with highest death count

SELECT continent, MAX(population) AS popluation, MAX(CAST(total_deaths AS int)) AS death_count
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY death_count DESC;


-- GLOBAL NUMBERS

-- Everyday analysis

SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_death, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date;


-- Overall Count

SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS int)) AS total_death, (SUM(CAST(new_deaths AS int))/SUM(new_cases))*100
FROM covid_deaths
WHERE continent IS NOT NULL;



-- Exploring data from the "covid_vaccinations" table


-- Looking at the daily vaccination status for each country

SELECT death.date, death.location, 
	SUM(CAST(vaccine.new_vaccinations AS float)) 
	OVER (Partition by death.location ORDER BY death.location, death.date) 
	AS rolling_vaccinations
FROM covid_deaths AS death
JOIN covid_vaccinations AS vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent IS NOT NULL
ORDER BY death.location, death.date;


-- Looking at the country wise vaccination status

SELECT death.location, 
	MAX(CAST(vaccine.total_vaccinations AS float)) AS total_vaccination,
	MAX(CAST(vaccine.people_fully_vaccinated AS float)) AS fully_vaccinated
FROM covid_deaths AS death
JOIN covid_vaccinations AS vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent IS NOT NULL
GROUP BY death.location
ORDER BY death.location;


-- Looking at the continent wise vaccination status

SELECT death.continent,
	MAX(CAST(vaccine.total_vaccinations AS float)) AS total_vaccination,
	MAX(CAST(vaccine.people_fully_vaccinated AS float)) AS fully_vaccinated
FROM covid_deaths AS death
JOIN covid_vaccinations AS vaccine
	ON death.location = vaccine.location
	AND death.date = vaccine.date
WHERE death.continent IS NOT NULL
GROUP BY death.continent;

