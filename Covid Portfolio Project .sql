--Covid data clean and Preparation for Tableau


Select *
From PortfolioProject..CovidDeaths
where continent is not null 
Order by 3,4

--Select *
--From PortfolioProject..CovidVaccinations
--Order by 3,4

-- Select data thaht we are going to using 

Select Location , date, total_cases,new_cases, total_deaths,population
FROM PortfolioProject..CovidDeaths
where continent is not null 
Order by 1,2



--Looking at Total Cases vs Total Deaths
--Show the likelihood of dying if you contract covid in your country

Select Location , date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPorcentage
FROM PortfolioProject..CovidDeaths
Where location like '%kingdom%'
and continent is not null 
Order by 1,2



--Looking at Total Cases VS Population 
-- Show what Percentage of population got Covid 

Select Location , date,  population, total_cases,(total_cases/population)*100 as PorcenPopulationInnfected
FROM PortfolioProject..CovidDeaths
Where location like '%kingdom%'
and continent is not null 
Order by 1,2



--Looking at countries  with Highest Infation Rate Compare to Population 

Select Location ,  population, MAX(total_cases) as HighestInfactionCount , MAX((total_cases/population))*100 as PorcenPopulationInnfected
FROM PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
where continent is not null 
Group by location,population
Order by PorcenPopulationInnfected desc


-- Showing Contries with Highest Death count per Population

Select Location ,  MAX(cast(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
where continent is not null 
Group by location
Order by HighestDeathCount desc


--- Let's Break things down by continent 

Select continent ,  MAX(cast(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
where continent is not null 
Group by continent
Order by HighestDeathCount desc



--Showing the continents highest death per population

Select continent ,  MAX(cast(total_deaths as int)) as HighestDeathCount
FROM PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
WHERE continent is not null 
Group by continent
Order by HighestDeathCount desc


--Global Numbers 


Select  SUM(new_cases)as NewCases, SUM(cast(new_deaths as int )) as NewDeaths , SUM(cast(new_deaths as int ))/ SUM(new_cases)*100  as DeathPorcentage
FROM PortfolioProject..CovidDeaths
--Where location like '%kingdom%'
where continent is not null

Order by 1,2


-- Looking at Total Population vs Vaccinations

Select dea.continent , dea.location, dea.date, dea.population, cast(vac.new_vaccinations as int), SUM(convert(int , vac.new_vaccinations )) over (Partition by  dea.location order by dea.location, dea.date) as RollingPeapleVaccinated
--, (RollingPeapleVaccinated/population)*100
fROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
 ON dea.location =vac.location
 and dea.date = vac.date

where dea.continent is not null
and dea.location like '%Kingdom%'
order by 2,3


-- use CTE

WITH PopvsVac(continent, location, date , population, new_vaccination , RollingPeapleVaccinated) as
(

Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations , SUM(convert(int , vac.new_vaccinations )) over (Partition by  dea.location order by dea.location, dea.date) as RollingPeapleVaccinated
--, (RollingPeapleVaccinated/population)*100
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
 ON dea.location =vac.location
 and dea.date = vac.date

a dea.continent is not null
--and dea.location like '%Kingdom%'
--order by 2,3
)
Select *, (RollingPeapleVaccinated/population)*100
FROM PopvsVac


--Temp TABLE 

DROP TABLE IF exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeapleVaccinated numeric
)
INSERT INTO #PercentPopulationVaccinated
Select dea.continent , dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM(convert(int , vac.new_vaccinations )) over (Partition by  dea.location order by dea.location,
dea.date) as RollingPeapleVaccinated


--, (RollingPeapleVaccinated/population)*100

FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
 ON dea.location =vac.location
 and dea.date = vac.date

where dea.continent is not null
and dea.location like '%Kingdom%'
order by 2,3

 Select *, (RollingPeapleVaccinated/population)*100
from #PercentPopulationVaccinated