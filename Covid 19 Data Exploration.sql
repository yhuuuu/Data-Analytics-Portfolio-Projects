-- SELECT location, MAX(CAST(total_deaths AS SIGNED)) AS TotalDeathCount
-- FROM PortfolioProject.coviddeaths
-- WHERE continent IS NULL OR continent = ''
-- GROUP BY location
-- ORDER BY TotalDeathCount DESC;

-- select *
-- from PortfolioProject.coviddeaths
-- order by 3,4

-- SELECT COUNT(*) 
-- FROM PortfolioProject.CovidDeaths;

-- SELECT COUNT(*) 
-- FROM PortfolioProject.CovidVaccinations;

-- SELECT count(distinct (iso_code))
-- FROM PortfolioProject.CovidDeaths;

#continent is null
-- SELECT location ,MAX(total_deaths) as TotalDeathCount
-- FROM PortfolioProject.CovidDeaths
-- WHERE continent is null OR continent = ''
-- Group by location
-- order by TotalDeathCount desc;


-- #Looking at Total Cases vs population
-- Select Location, STR_TO_DATE(date, '%m/%d/%y'), total_cases, population, (total_cases/population)*100 as DeathPercentage
-- From PortfolioProject.CovidDeaths
-- Where location like'%states%'
-- order by 1,2



# continent with highest deathcount 
-- SELECT continent ,MAX(total_deaths) as TotalDeathCount
-- FROM PortfolioProject.CovidDeaths
-- WHERE continent is not null and continent <> ''
-- Group by continent
-- order by TotalDeathCount desc;


# Calculate the daily death rate globally
-- SELECT STR_TO_DATE(date, '%m/%d/%y'), sum(new_cases)as total_case,sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercntage
-- FROM PortfolioProject.CovidDeaths
-- WHERE continent is not null and continent <> ''
-- Group by date
-- Order by 1,2

# Calculate global death rate
-- SELECT sum(new_cases)as total_case,sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercntage
-- FROM PortfolioProject.CovidDeaths
-- WHERE continent is not null and continent <> ''
-- Order by 1,2

# Calculate death rate for each country
-- SELECT location , sum(new_cases)as total_case,sum(new_deaths) as total_deaths, (sum(new_deaths)/sum(new_cases))*100 as DeathPercntage
-- FROM PortfolioProject.CovidDeaths
-- WHERE continent is not null and continent <> ''
-- group by location
-- Order by DeathPercntage desc


# Looking at Total Population vs Vaccinations
# The PARTITION BY clause in the query is used within a window function (SUM() OVER (...)) 
# to divide the result set into partitions, or subsets, based on the column cd.location.
-- Select cd.continent, cd.location, STR_TO_DATE(cd.date, '%m/%d/%y'), cd.population, cv.new_vaccinations,
-- SUM(cv.new_vaccinations) OVER (Partition by cd.location Order by cd.location,
-- cd.date) as RollingPropleVaccinated

-- from PortfolioProject.CovidDeaths cd
-- join PortfolioProject.CovidVaccinations cv
-- 	on cd.location = cv.location
--     and cd.date = cv.date
-- where cd.continent is not null and cd.continent <> ''
-- order by 2,3;

# use CTE 
-- With PopvsVac (Continent, Location, Date, Population, New_Vacinations, RollingPeopleVaccinated)
-- as(
-- Select cd.continent, cd.location, STR_TO_DATE(cd.date, '%m/%d/%y'), cd.population, cv.new_vaccinations,
-- SUM(cv.new_vaccinations) OVER (Partition by cd.location Order by cd.location,
-- cd.date) as RollingPropleVaccinated

-- from PortfolioProject.CovidDeaths cd
-- join PortfolioProject.CovidVaccinations cv
-- 	on cd.location = cv.location
--     and cd.date = cv.date
-- where cd.continent is not null and cd.continent <> ''
-- -- order by 2,3   
-- )

-- SELECT *, (RollingPeopleVaccinated / Population)* 100
-- FROM PopvsVac
-- order by 2,3


# TEMP Table

-- DROP TEMPORARY TABLE IF EXISTS PercentPopulationVaccinated;
-- CREATE TEMPORARY TABLE PercentPopulationVaccinated (
--   Continent VARCHAR(255),
--   Location VARCHAR(255),
--   Date DATE,
--   Population BIGINT,
--   New_vaccinations BIGINT,
--   RollingPeopleVaccinated BIGINT
-- );

-- INSERT INTO PercentPopulationVaccinated
-- SELECT cd.continent, cd.location, STR_TO_DATE(cd.date, '%m/%d/%y'), cd.population, cv.new_vaccinations,
--   SUM(cv.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
-- FROM PortfolioProject.CovidDeaths cd
-- JOIN PortfolioProject.CovidVaccinations cv
--   ON cd.location = cv.location
--   AND cd.date = cv.date
-- WHERE cd.continent IS NOT NULL AND cd.continent <> '';

-- SELECT *, (RollingPeopleVaccinated / Population) * 100 AS PercentVaccinated
-- FROM PercentPopulationVaccinated
-- ORDER BY Location, Date;





/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From PortfolioProject.CovidDeaths
Where continent is not null and continent <> ''
order by 3,4


-- Select Data that we are going to be starting with

Select Location, STR_TO_DATE(date, '%m/%d/%y'), total_cases, new_cases, total_deaths, population
From PortfolioProject.CovidDeaths
Where continent is not null and continent <> ''
order by 1,2


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, STR_TO_DATE(date, '%m/%d/%y'), total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject.CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, STR_TO_DATE(date, '%m/%d/%y'), Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject.CovidDeaths
-- WHERE location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject.CovidDeaths
-- Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject.CovidDeaths
-- Where location like '%states%'
Where continent is not null and continent <> ''
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(Total_deaths) as TotalDeathCount
From PortfolioProject.CovidDeaths
-- Where location like '%states%'
Where continent is not null OR continent = ''
Group by continent
order by TotalDeathCount desc



-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject.CovidDeaths
-- Where location like '%states%'
where continent is not null OR continent = ''
-- Group By date
order by 1,2



-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.CovidDeaths dea
Join PortfolioProject.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3


-- Using CTE to perform Calculation on Partition By in previous query

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject.CovidDeaths dea
Join PortfolioProject.CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac



-- Using Temp Table to perform Calculation on Partition By in previous query

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated




-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

