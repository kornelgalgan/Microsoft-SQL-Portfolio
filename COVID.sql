select * 
From Portfolio_Project..CovidDeaths
order by 3,4

--Select *
--From Portfolio_Project..CovidVaccinations
--order by 3,4

-- Select Data that we are going to be using

Select Location, date, total_cases, new_cases, total_deaths, population
From Portfolio_Project..CovidDeaths
order by 1,2

-- Looking at Total CAses Vs Total Deaths
-- Shows likelihood of dying if you contact covid in your country  
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
Where location like '%states%'
order by 1,2

-- Looking at Total Cases vs Population
-- Shows what percentage of population got Covid
Select Location, date, Population, total_cases, (total_cases/population)*100 as DeathPercentPopulationInfected
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
order by 1,2

-- 3.
-- Looking  at Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From Portfolio_Project..CovidDeaths
-- Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- Showing Contries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
-- Where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Showing Contries with Highest Death Count per Population
Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
-- Where location like '%states%'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Let's break things down by continet 
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
-- Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Showing continents with the highest death count per population
Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
-- Where location like '%states%'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Global numbers
SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
where continent is not null
-- Group By date
order by 1,2

-- Looking at total population Vs Vaccinations
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 1,2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100
From PopvsVac 

-- TEMP TABLE
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
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
-- where dea.continent is not null
-- order by 1,2,3

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated

-- Create View to store data for later visualizations
Create View PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, 
dea.Date) as RollingPeopleVaccinated
From Portfolio_Project..CovidDeaths dea
Join Portfolio_Project..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
-- order by 1,2,3

select *
From PercentPopulationVaccinated

-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From Portfolio_Project..CovidDeaths
--Where location like '%states%'
Where continent is null
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3.
-- Looking  at Countries with Highest Infection Rate compared to Population
Select Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From Portfolio_Project..CovidDeaths
-- Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc

-- 4.

Select Location, Population, date, MAX(total_cases) as HighestInfectionCount, Max((total_cases/population))*100 as PercentPopulationInfected
From Portfolio_Project..CovidDeaths
Where location = ('Andorra' , 'Montenegro')
Group by Location, Population, date
order by PercentPopulationInfected desc