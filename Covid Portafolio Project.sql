SELECT *
FROM PortafolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 3,4

-- I am going to select the Data that I am going to be using.

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortafolioProject..CovidDeaths
WHERE continent is not null and continent is not null
ORDER BY 1,2

-- Total Cases vs Total Deaths. This will help me to see the Death Percentage by country.
-- I decided to look for the cases of my country but I can look for anyone's.

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Death_Percentage
FROM PortafolioProject..CovidDeaths
WHERE location like '%mexico%' and continent is not null
ORDER BY 1,2 

-- Total cases vs Population
--This is going to show me the percentage of the population that got Covid-19 in Mexico.
SELECT location, date, total_cases, Population, (total_cases/Population)*100 as Percent_population_infected
FROM PortafolioProject..CovidDeaths
WHERE location like '%mexico%' and continent is not null
ORDER BY 1,2 

-- Countries with the highest infection rate.
SELECT location, Population, MAX(total_cases) as Highest_infection_country, MAX(total_cases/Population)*100 as Percent_population_infected
FROM PortafolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location, population
ORDER BY Percent_population_infected desc


-- Continents with the highest death count.
SELECT continent, MAX(cast(total_deaths as int)) as Total_deaths
FROM PortafolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY total_deaths desc

-- Mortality rate
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths,
SUM(cast(new_deaths as int))/SUM(new_cases)*100 as death_percentage
FROM PortafolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

-- Vaccinations vs Total Population
WITH vaccinations_population (continent, location, date, population, new_vaccionations, people_vaccinated)
as
(
	SELECT deaths.continent, deaths.location, deaths.date, deaths.population, vaccinations.new_vaccinations,
	SUM(convert(int, vaccinations.new_vaccinations)) OVER (partition by deaths.location, deaths.date) as people_vaccinated 
	FROM PortafolioProject..CovidDeaths deaths
	JOIN PortafolioProject..CovidVaccinations vaccinations
		on deaths.location = vaccinations.location
		and deaths.date = vaccinations.date
	WHERE deaths.continent is not null
)
SELECT *, (people_vaccinated/population)*100
FROM vaccinations_population

















