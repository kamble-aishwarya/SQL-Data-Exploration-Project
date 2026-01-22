/*
Covid 19 Data Exploration 

Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

Select *
From PortfolioProject..CovidDeaths
-- Where continent is not null 
order by 3,4

Select *
From PortfolioProject..CovidVaccinations
-- Where continent is not null 
order by 3,4

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Where continent is not null 
order by 1,2


-- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2


-- Total Cases vs Population

Select Location, date, Population, total_cases,  (total_cases/population)*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location like '%states%'
Where continent is not null 
Group by continent
order by TotalDeathCount desc

-- GLOBAL NUMBERS

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition By dea. Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Use CTE

With PopvsVac (Continent, Location, Date, Population,New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition By dea. Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac


-- Temp Table

DROP TABLE IF EXISTS #PercentPopulationVaccinated
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
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition By dea. Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View 
--View: Percent of Population Vaccinated

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations, 
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition By dea. Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
On dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
From PercentPopulationVaccinated


--View: Daily New Cases vs Deaths
CREATE VIEW Daily_Cases_And_Deaths AS
SELECT
    continent,
    location,
    date,
    new_cases,
    new_deaths,
    CASE 
        WHEN new_cases = 0 THEN 0
        ELSE CAST(new_deaths as float) / CAST(new_cases as float) * 100
    END AS DailyDeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
go
SELECT * 
FROM Daily_Cases_And_Deaths

--View: Total Cases, Deaths & Death Rate by Country

Create View Country_Wise_Totals as 
Select 
location,
Population,
Max(total_deaths) as TotalDeaths,
Max(total_cases) as TotalCases,
(Max (Convert(float,total_deaths)) /Max (Convert(float,total_cases))) as DeathRate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
group by location, population
go
SELECT * 
FROM Country_Wise_Totals

--View: Continent-Level Death

Create or Alter View ContinentDeathSummary as 
Select 
continent,
Population,
Max(total_deaths) as TotalDeaths,
Max(total_cases) as TotalCases,
(Max (Convert(float,total_deaths)) /Max (Convert(float,total_cases))) as DeathRate
FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
group by continent, population
go
SELECT * 
From ContinentDeathSummary

--View: Vaccination Progress by Country 

Create or Alter View LatestVaccinationStatus as
select
dea.location,
dea.population,
max(vac.people_vaccinated) as PeopleVaccinated,
max(vac.people_fully_vaccinated) as FullyVaccinated,
(max(Convert(Float,vac.people_fully_vaccinated))/ Convert(Float, dea.population))*100 as FullyVaccinatedPercent
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
    ON dea.location = vac.location
WHERE dea.continent IS NOT NULL
GROUP BY dea.location, dea.population;
GO
SELECT * 
From LatestVaccinationStatus