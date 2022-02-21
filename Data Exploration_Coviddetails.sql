--Select * from CovidDeaths
--order by 3,4

Select location,date,total_cases,new_cases,total_deaths,population
from CovidDeaths
order by 1,2

-- Looking at total cases vs total deaths

Select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
Where location='Belgium'
order by 1,2

-- Looking at total cases vs popultaion

Select location,date,population,total_cases,(total_cases/population)*100 as CovidPopulationPercentage
from CovidDeaths
Where location='India'
order by 1,2

-- Looking at highest infection rates as compared to population

Select location,population,max(cast(total_cases as int)) as HighestInfectioncount,max(total_cases/population)*100 as CovidPopulationPercentage
from CovidDeaths
--Where location='India'
Group by location,population
order by CovidPopulationPercentage Desc

-- Looking at highest death count

Select location,population,max(cast(total_deaths as int)) as HighestDeathCount,max(total_deaths/population)*100 as CovidDeathPercentage
from CovidDeaths
Where continent is not null
Group by location,population
order by HighestDeathCount Desc

-- Showing continents with highest death counts

Select continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
Where continent is not null
Group by continent
order by TotalDeathCount Desc

--Global Numbers

Select date,sum(new_cases) as Newcases,sum(cast(new_deaths as int))as Newdeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
Where continent is not null
group by date
order by 1,2

Select date,sum(total_cases) as Totalcases,sum(cast(total_deaths as int))as Totaldeaths,
sum(cast(total_deaths as int))/sum(total_cases)*100 as DeathPercentage
from CovidDeaths
Where continent is not null
group by date
order by 1,2

Select sum(new_cases) as Newcases,sum(cast(new_deaths as int))as Newdeaths,
sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from CovidDeaths
Where continent is not null
order by 1,2

-- Looking at total population vs vaccinations

Select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER(partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
from CovidDeaths as dea join
CovidVaccinations as vac On
dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
order by 1,3

-- Using CTE

With popvsvac (Location,continent,date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
Select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER(partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
from CovidDeaths as dea join
CovidVaccinations as vac On
dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
)

select *,(RollingPeopleVaccinated/population)*100 as Percentagevaccinated
from popvsvac
order by 1,2,3

-- Creating Views

Create View Highestdeathcount as 
Select location,population,max(cast(total_deaths as int)) as HighestDeathCount,max(total_deaths/population)*100 as CovidDeathPercentage
from CovidDeaths
Where continent is not null
Group by location,population
--order by HighestDeathCount Desc

Create view PercentagePopulationVaccinated as

Select dea.location,dea.continent,dea.date,dea.population,vac.new_vaccinations,
sum(cast(vac.new_vaccinations as float)) OVER(partition by dea.Location order by dea.location,
dea.date) as RollingPeopleVaccinated
from CovidDeaths as dea join
CovidVaccinations as vac On
dea.location=vac.location and
dea.date=vac.date
where dea.continent is not null
--order by 1,3

Create view Totaldeathcount as 
Select continent,max(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
Where continent is not null
Group by continent
--order by TotalDeathCount Desc
